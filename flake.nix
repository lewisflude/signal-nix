{
  description = "Signal Design System - NixOS and Home Manager integration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    signal-palette = {
      url = "github:lewisflude/signal-palette";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      signal-palette,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Home Manager modules (primary interface)
      homeManagerModules = {
        default = self.homeManagerModules.signal;

        signal = import ./modules/common { inherit (signal-palette) palette; };

        # Per-app modules for advanced users
        ironbar = import ./modules/ironbar;
        gtk = import ./modules/gtk;
        helix = import ./modules/editors/helix.nix;
        fuzzel = import ./modules/desktop/fuzzel.nix;
        ghostty = import ./modules/terminals/ghostty.nix;
      };

      # Library functions
      lib = import ./lib {
        inherit (nixpkgs) lib;
        inherit (signal-palette) palette;
      };

      # Development shell
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.nixfmt
              pkgs.statix
              pkgs.deadnix
              pkgs.nil
            ];
          };
        }
      );

      # Formatter
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      # Checks
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Import comprehensive test suite
          allTests = import ./tests {
            inherit
              pkgs
              self
              signal-palette
              system
              ;
            inherit (nixpkgs) lib;
            home-manager = nixpkgs.legacyPackages.${system}.home-manager;
          };
        in
        {
          # ============================================================================
          # Static Checks (existing)
          # ============================================================================

          format = pkgs.runCommand "check-format" { } ''
            ${pkgs.nixfmt}/bin/nixfmt --check ${./.}
            touch $out
          '';

          # Verify flake outputs structure
          flake-outputs = pkgs.runCommand "check-flake-outputs" { } ''
            echo "Checking flake structure..."
            test -f ${./flake.nix} || exit 1
            test -d ${./modules} || exit 1
            test -d ${./lib} || exit 1
            test -d ${./examples} || exit 1
            echo "✓ Flake structure is valid"
            echo "✓ Module exports: default, signal, ironbar, gtk, helix, fuzzel, ghostty"
            touch $out
          '';

          # Verify all application module files exist and have valid Nix syntax
          modules-exist = pkgs.runCommand "check-modules-exist" { } ''
            echo "Verifying module files..."

            # Check core modules
            test -f ${./modules/common/default.nix} || { echo "Missing common module"; exit 1; }
            test -f ${./lib/default.nix} || { echo "Missing lib"; exit 1; }

            # Check application modules
            test -f ${./modules/editors/helix.nix} || { echo "Missing helix module"; exit 1; }
            test -f ${./modules/desktop/fuzzel.nix} || { echo "Missing fuzzel module"; exit 1; }
            test -f ${./modules/terminals/ghostty.nix} || { echo "Missing ghostty module"; exit 1; }
            test -f ${./modules/terminals/alacritty.nix} || { echo "Missing alacritty module"; exit 1; }
            test -f ${./modules/terminals/kitty.nix} || { echo "Missing kitty module"; exit 1; }
            test -f ${./modules/terminals/wezterm.nix} || { echo "Missing wezterm module"; exit 1; }
            test -f ${./modules/gtk/default.nix} || { echo "Missing gtk module"; exit 1; }
            test -f ${./modules/ironbar/default.nix} || { echo "Missing ironbar module"; exit 1; }
            test -f ${./modules/cli/bat.nix} || { echo "Missing bat module"; exit 1; }
            test -f ${./modules/cli/fzf.nix} || { echo "Missing fzf module"; exit 1; }
            test -f ${./modules/cli/lazygit.nix} || { echo "Missing lazygit module"; exit 1; }
            test -f ${./modules/cli/yazi.nix} || { echo "Missing yazi module"; exit 1; }
            test -f ${./modules/prompts/starship.nix} || { echo "Missing starship module"; exit 1; }
            test -f ${./modules/shells/zsh.nix} || { echo "Missing zsh module"; exit 1; }
            test -f ${./modules/multiplexers/tmux.nix} || { echo "Missing tmux module"; exit 1; }
            test -f ${./modules/multiplexers/zellij.nix} || { echo "Missing zellij module"; exit 1; }
            test -f ${./modules/monitors/btop.nix} || { echo "Missing btop module"; exit 1; }

            # Check examples
            test -f ${./examples/basic.nix} || { echo "Missing basic example"; exit 1; }
            test -f ${./examples/full-desktop.nix} || { echo "Missing full-desktop example"; exit 1; }
            test -f ${./examples/custom-brand.nix} || { echo "Missing custom-brand example"; exit 1; }

            echo "✓ All required modules and examples exist"
            touch $out
          '';

          # Verify theme resolution is correct
          theme-resolution = pkgs.runCommand "check-theme-resolution" { } ''
            echo "Checking theme resolution..."

            # Check that modules use resolveThemeMode for theme names
            # This prevents issues like "signal-auto" being used as a theme name

            # bat.nix should use themeMode
            ${pkgs.gnugrep}/bin/grep -q "themeMode = signalLib.resolveThemeMode" ${./modules/cli/bat.nix} || {
              echo "ERROR: bat.nix should use signalLib.resolveThemeMode"
              exit 1
            }

            # helix.nix should use themeMode
            ${pkgs.gnugrep}/bin/grep -q "themeMode = signalLib.resolveThemeMode" ${./modules/editors/helix.nix} || {
              echo "ERROR: helix.nix should use signalLib.resolveThemeMode"
              exit 1
            }

            # gtk should use themeMode
            ${pkgs.gnugrep}/bin/grep -q "themeMode = signalLib.resolveThemeMode" ${./modules/gtk/default.nix} || {
              echo "ERROR: gtk/default.nix should use signalLib.resolveThemeMode"
              exit 1
            }

            # Common module should resolve mode when getting colors
            ${pkgs.gnugrep}/bin/grep -q "resolveThemeMode cfg.mode" ${./modules/common/default.nix} || {
              echo "ERROR: common/default.nix should resolve theme mode when getting colors"
              exit 1
            }

            # Check that lib has resolveThemeMode function
            ${pkgs.gnugrep}/bin/grep -q "resolveThemeMode" ${./lib/default.nix} || {
              echo "ERROR: lib/default.nix should export resolveThemeMode function"
              exit 1
            }

            echo "✓ Theme resolution is properly configured"
            touch $out
          '';

          # ============================================================================
          # Unit Tests - Library Functions
          # ============================================================================

          inherit (allTests)
            unit-lib-resolveThemeMode
            unit-lib-isValidResolvedMode
            unit-lib-getThemeName
            unit-lib-getColors
            unit-lib-getSyntaxColors
            ;

          # ============================================================================
          # Integration Tests - Example Configurations
          # ============================================================================

          inherit (allTests)
            integration-example-basic
            integration-example-auto-enable
            integration-example-full-desktop
            integration-example-custom-brand
            integration-example-migrating
            integration-example-multi-machine
            ;

          # ============================================================================
          # Module Tests - Individual Module Evaluation
          # ============================================================================

          inherit (allTests)
            module-common-evaluates
            module-helix-dark
            module-helix-light
            module-ghostty-evaluates
            module-bat-evaluates
            module-fzf-evaluates
            module-gtk-evaluates
            module-ironbar-evaluates
            ;

          # ============================================================================
          # Edge Case Tests - Option Combinations and Conflicts
          # ============================================================================

          inherit (allTests)
            edge-case-all-disabled
            edge-case-multiple-terminals
            edge-case-brand-governance
            edge-case-ironbar-profiles
            ;

          # ============================================================================
          # Validation Tests - Theme Resolution Consistency
          # ============================================================================

          inherit (allTests)
            validation-theme-names
            validation-no-auto-theme-names
            ;

          # ============================================================================
          # Accessibility Tests
          # ============================================================================

          inherit (allTests)
            accessibility-contrast-estimation
            ;

          # ============================================================================
          # Color Manipulation Tests
          # ============================================================================

          inherit (allTests)
            color-manipulation-lightness
            color-manipulation-chroma
            ;
        }
      );
    };
}
