# Signal Design System - Full Desktop Example
# Complete configuration with all applications enabled

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    signal,
    ...
  }: {
    homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        signal.homeManagerModules.default
        {
          home.username = "user";
          home.homeDirectory = "/home/user";
          home.stateVersion = "24.11";

          # Enable Signal theme for full desktop
          theming.signal = {
            enable = true;
            mode = "dark";

            # Desktop
            ironbar = {
              enable = true;
              profile = "relaxed"; # 1440p+ optimized
            };
            gtk.enable = true;
            fuzzel.enable = true;

            # Editors
            helix.enable = true;

            # Terminals
            terminals = {
              ghostty.enable = true;
              zellij.enable = true;
            };

            # CLI Tools
            cli = {
              bat.enable = true;
              fzf.enable = true;
              lazygit.enable = true;
              yazi.enable = true;
            };
          };
        }
      ];
    };
  };
}
