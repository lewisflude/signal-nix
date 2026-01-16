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
        in
        {
          format = pkgs.runCommand "check-format" { } ''
            ${pkgs.nixfmt}/bin/nixfmt --check ${./.}
            touch $out
          '';
        }
      );
    };
}
