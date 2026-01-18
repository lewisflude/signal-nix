{
  description = "Signal Design System - NixOS and Home Manager integration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    signal-palette = {
      url = "github:lewisflude/signal-palette";
    };

    nix-colorizer = {
      url = "github:nutsalhan87/nix-colorizer";
    };

    # NMT - Nix Module Test framework (used by home-manager for testing)
    nmt = {
      url = "sourcehut:~rycee/nmt";
      flake = false;
    };

    # Home Manager for proper module testing
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      signal-palette,
      nix-colorizer,
      nmt,
      home-manager,
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
      homeManagerModules =
        let
          # Create signalLib once to avoid recursion
          signalLib = import ./lib {
            inherit (nixpkgs) lib;
            inherit (signal-palette) palette;
            inherit nix-colorizer;
          };
        in
        {
          default = self.homeManagerModules.signal;

          signal = import ./modules/common {
            inherit (signal-palette) palette;
            inherit nix-colorizer signalLib;
          };

          # Per-app modules for advanced users
          ironbar = import ./modules/ironbar;
          gtk = import ./modules/gtk;
          helix = import ./modules/editors/helix.nix;
          fuzzel = import ./modules/desktop/fuzzel.nix;
          ghostty = import ./modules/terminals/ghostty.nix;
        };

      # NixOS modules (system-level theming)
      nixosModules = {
        default = self.nixosModules.signal;

        signal = import ./modules/nixos/common {
          inherit (signal-palette) palette;
          inherit nix-colorizer;
        };

        # Granular module exports for advanced users
        boot = import ./modules/nixos/boot/console.nix;
        grub = import ./modules/nixos/boot/grub.nix;
        plymouth = import ./modules/nixos/boot/plymouth.nix;
        sddm = import ./modules/nixos/login/sddm.nix;
        gdm = import ./modules/nixos/login/gdm.nix;
        lightdm = import ./modules/nixos/login/lightdm.nix;
      };

      # Theme packages
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          signalLib = self.lib;
        in
        {
          # GRUB themes
          signal-grub-theme-dark = pkgs.callPackage ./pkgs/grub-theme {
            inherit signalLib;
            mode = "dark";
          };
          signal-grub-theme-light = pkgs.callPackage ./pkgs/grub-theme {
            inherit signalLib;
            mode = "light";
          };

          # SDDM themes
          signal-sddm-theme-dark = pkgs.callPackage ./pkgs/sddm-theme {
            inherit signalLib;
            mode = "dark";
          };
          signal-sddm-theme-light = pkgs.callPackage ./pkgs/sddm-theme {
            inherit signalLib;
            mode = "light";
          };

          # Plymouth themes
          signal-plymouth-theme-dark = pkgs.callPackage ./pkgs/plymouth-theme {
            inherit signalLib;
            mode = "dark";
          };
          signal-plymouth-theme-light = pkgs.callPackage ./pkgs/plymouth-theme {
            inherit signalLib;
            mode = "light";
          };

          # GTK themes (system-wide)
          signal-gtk-theme-dark = pkgs.callPackage ./pkgs/gtk-theme {
            inherit signalLib;
            mode = "dark";
          };
          signal-gtk-theme-light = pkgs.callPackage ./pkgs/gtk-theme {
            inherit signalLib;
            mode = "light";
          };
        }
      );

      # Library functions
      lib = import ./lib {
        inherit (nixpkgs) lib;
        inherit (signal-palette) palette;
        inherit nix-colorizer;
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
              pkgs.nix-unit
            ];

            shellHook = ''
              echo "Signal Design System Development Environment"
              echo ""
              echo "Available commands:"
              echo "  nix flake check              - Run all tests"
              echo "  nix build .#checks.x86_64-linux.<test-name>  - Run specific test"
              echo "  nix-unit tests/nmt/           - Run NMT tests"
              echo "  nixfmt .                     - Format Nix files"
              echo ""
            '';
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
            inherit (nixpkgs.legacyPackages.${system}) home-manager;
          };

          # Import NixOS-specific tests
          nixosTests = import ./tests/nixos.nix {
            inherit
              pkgs
              self
              system
              ;
            inherit (nixpkgs) lib;
          };

          # Import activation package tests (Home Manager integration)
          activationTests = import ./tests/activation {
            inherit
              pkgs
              self
              signal-palette
              system
              nix-colorizer
              ;
            inherit (nixpkgs) lib;
            home-manager = home-manager;
          };

          # Import module structure tests (validation)
          structureTests = import ./tests/module-structure-test.nix {
            inherit
              pkgs
              self
              system
              ;
            inherit (nixpkgs) lib;
          };

          # Import NixOS VM tests (integration testing in actual VMs)
          nixosVmTests = nixpkgs.lib.optionalAttrs pkgs.stdenv.isLinux (
            import ./tests/nixos-vm {
              inherit
                pkgs
                self
                system
                ;
              inherit (nixpkgs) lib;
            }
          );
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
            test -d ${./modules/nixos} || { echo "Missing nixos modules directory"; exit 1; }
            test -f ${./modules/nixos/common/default.nix} || { echo "Missing nixos common module"; exit 1; }
            test -f ${./modules/nixos/boot/console.nix} || { echo "Missing nixos console module"; exit 1; }
            test -f ${./modules/nixos/boot/grub.nix} || { echo "Missing nixos grub module"; exit 1; }
            test -f ${./modules/nixos/boot/plymouth.nix} || { echo "Missing nixos plymouth module"; exit 1; }
            test -f ${./modules/nixos/login/sddm.nix} || { echo "Missing nixos sddm module"; exit 1; }
            test -f ${./modules/nixos/login/gdm.nix} || { echo "Missing nixos gdm module"; exit 1; }
            test -f ${./modules/nixos/login/lightdm.nix} || { echo "Missing nixos lightdm module"; exit 1; }
            test -f ${./pkgs/grub-theme/default.nix} || { echo "Missing grub theme package"; exit 1; }
            test -f ${./pkgs/sddm-theme/default.nix} || { echo "Missing sddm theme package"; exit 1; }
            test -f ${./pkgs/plymouth-theme/default.nix} || { echo "Missing plymouth theme package"; exit 1; }
            test -f ${./pkgs/gtk-theme/default.nix} || { echo "Missing gtk theme package"; exit 1; }
            echo "✓ Flake structure is valid"
            echo "✓ Home Manager exports: default, signal, ironbar, gtk, helix, fuzzel, ghostty"
            echo "✓ NixOS exports: default, signal, boot, grub, plymouth, sddm, gdm, lightdm"
            echo "✓ Packages: grub-theme, sddm-theme, plymouth-theme, gtk-theme (all dark/light)"
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
            test -f ${./modules/monitors/mangohud.nix} || { echo "Missing mangohud module"; exit 1; }

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

          # Verify _module.args is not inside config blocks (prevents infinite recursion)
          module-args-placement = pkgs.runCommand "check-module-args-placement" { } ''
            echo "Checking _module.args placement..."

            # Find any _module.args declarations
            # They should NOT be inside "config = lib.mkIf cfg.enable" blocks as this causes infinite recursion
            # They should be in unconditional config sections

            # Check common module - make sure _module.args is NOT inside the mkIf block
            if ${pkgs.gnugrep}/bin/grep -A 10 "(lib.mkIf cfg.enable" ${./modules/common/default.nix} | ${pkgs.gnugrep}/bin/grep -q "_module.args"; then
              echo "ERROR: modules/common/default.nix has _module.args inside conditional config block"
              echo "This causes infinite recursion when modules reference these arguments"
              echo "See docs/MODULE_ARGS_INFINITE_RECURSION.md for details"
              exit 1
            fi

            # Check nixos common module - make sure _module.args is NOT inside the mkIf block
            if ${pkgs.gnugrep}/bin/grep -A 10 "(lib.mkIf cfg.enable" ${./modules/nixos/common/default.nix} | ${pkgs.gnugrep}/bin/grep -q "_module.args"; then
              echo "ERROR: modules/nixos/common/default.nix has _module.args inside conditional config block"
              echo "This causes infinite recursion when modules reference these arguments"
              echo "See docs/MODULE_ARGS_INFINITE_RECURSION.md for details"
              exit 1
            fi

            # Verify _module.args exists in both modules
            ${pkgs.gnugrep}/bin/grep -q "_module.args = {" ${./modules/common/default.nix} || {
              echo "ERROR: modules/common/default.nix should have _module.args defined"
              exit 1
            }

            ${pkgs.gnugrep}/bin/grep -q "_module.args = {" ${./modules/nixos/common/default.nix} || {
              echo "ERROR: modules/nixos/common/default.nix should have _module.args defined"
              exit 1
            }

            echo "✓ _module.args is correctly placed outside conditional blocks"
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
            module-mpv-structure
            module-mpv-colors
            module-gtk-evaluates
            module-ironbar-evaluates
            module-procs-evaluates
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

          # ============================================================================
          # Comprehensive Test Suite - Happy Path
          # ============================================================================

          inherit (allTests)
            happy-basic-dark-mode
            happy-basic-light-mode
            happy-auto-mode-defaults-dark
            happy-color-structure
            happy-syntax-colors-complete
            happy-brand-governance-functional-override
            ;

          # ============================================================================
          # Comprehensive Test Suite - Edge Cases
          # ============================================================================

          inherit (allTests)
            edge-empty-brand-colors
            edge-lightness-boundaries
            edge-chroma-boundaries
            edge-contrast-extreme-values
            edge-all-modules-disabled
            edge-ironbar-profiles
            ;

          # ============================================================================
          # Comprehensive Test Suite - Error Handling
          # ============================================================================

          inherit (allTests)
            error-invalid-theme-mode
            error-brand-governance-invalid-policy
            error-color-manipulation-throws
            ;

          # ============================================================================
          # Comprehensive Test Suite - Integration
          # ============================================================================

          inherit (allTests)
            integration-module-lib-interaction
            integration-colors-and-syntax
            integration-brand-with-colors
            integration-theme-resolution-consistency
            integration-auto-enable-logic
            integration-helix-builds
            integration-ghostty-builds
            ;

          # ============================================================================
          # Comprehensive Test Suite - Performance
          # ============================================================================

          inherit (allTests)
            performance-color-lookups
            performance-theme-resolution-cached
            performance-large-brand-colors
            performance-module-evaluation
            ;

          # ============================================================================
          # Comprehensive Test Suite - Security
          # ============================================================================

          inherit (allTests)
            security-color-hex-validation
            security-no-code-injection
            security-mode-enum-validation
            security-brand-policy-enum-validation
            security-no-path-traversal
            ;

          # ============================================================================
          # Comprehensive Test Suite - Documentation
          # ============================================================================

          inherit (allTests)
            documentation-examples-valid-nix
            documentation-readme-references
            ;

          # ============================================================================
          # Comprehensive Test Suite - Color Conversion (nix-colorizer)
          # ============================================================================

          inherit (allTests)
            color-conversion-hex-to-rgb
            color-conversion-hex-with-alpha
            color-conversion-validation
            ;

          # ============================================================================
          # Activation Package Tests - Home Manager Integration
          # ============================================================================
          # These tests build actual Home Manager configurations and verify
          # that generated files have correct content (not just that evaluation succeeds)

          inherit (activationTests)
            activation-helix-dark
            activation-helix-light
            activation-alacritty-dark
            activation-ghostty-dark
            activation-multi-module
            activation-auto-enable
            ;

          # ============================================================================
          # Module Structure Tests - Validation
          # ============================================================================
          # These tests verify that module structure is correct and that common
          # pitfalls (like incorrect _module.args placement) are caught

          inherit (structureTests)
            structure-hm-basic
            structure-hm-gtk
            structure-hm-multiple
            structure-nixos-basic
            structure-nixos-login
            structure-module-args
            structure-config-merge
            ;

          # ============================================================================
          # NixOS Module Tests
          # ============================================================================

          # Re-enabled with proper VM testing framework
          # These tests use pkgs.nixosTest to verify system-level configuration
        }
        // nixpkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
          # NixOS VM tests (Linux only)
          inherit (nixosVmTests)
            nixos-vm-console-colors
            nixos-vm-sddm
            nixos-vm-plymouth
            nixos-vm-grub
            nixos-vm-integration
            nixos-vm-light-mode
            ;
        }
      );
    };
}
