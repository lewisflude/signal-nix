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

            # First, enable the programs you want to use
            programs = {
              helix.enable = true;
              # neovim.enable = true;  # Optional
              ghostty.enable = true;
              bat.enable = true;
              # delta.enable = true;  # Optional
              # eza.enable = true;  # Optional
              fzf.enable = true;
              yazi.enable = true;
              starship.enable = true;
            };

            # Then apply Signal theme to enabled programs
            theming.signal = {
              enable = true;
              mode = "dark"; # "light", "dark", or "auto"

              # Apply theme to editors
              editors = {
                helix.enable = true;
                # neovim.enable = true;  # Only if programs.neovim.enable = true
              };

              # Apply theme to terminal
              terminals.ghostty.enable = true;

              # Apply theme to CLI tools
              cli = {
                bat.enable = true;
                # delta.enable = true;  # Only if programs.delta.enable = true
                # eza.enable = true;  # Only if programs.eza.enable = true
                fzf.enable = true;
                yazi.enable = true;
              };

              # Apply theme to shell prompt
              prompts.starship.enable = true;
            };
          }
        ];
      };
    };
}
