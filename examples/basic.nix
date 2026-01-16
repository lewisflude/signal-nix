# Signal Design System - Basic Example
# Minimal configuration with essential applications

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      signal,
      ...
    }:
    {
      homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          signal.homeManagerModules.default
          {
            home = {
              username = "user";
              homeDirectory = "/home/user";
              stateVersion = "24.11";
            };

            # Enable Signal theme with basic apps
            theming.signal = {
              enable = true;
              mode = "dark"; # "light", "dark", or "auto"

              # Editor
              helix.enable = true;

              # Terminal (choose one or more)
              terminals.ghostty.enable = true;

              # CLI tools
              cli = {
                bat.enable = true;
                fzf.enable = true;
                yazi.enable = true;
              };

              # Shell prompt (recommended)
              prompts.starship.enable = true;
            };
          }
        ];
      };
    };
}
