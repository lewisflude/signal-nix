# Signal Design System - Auto-Enable Example
# Automatic theming for all enabled programs

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

            # Enable the programs you want to use
            programs = {
              # Editors
              helix.enable = true;
              neovim.enable = true;

              # Terminals
              ghostty.enable = true;
              alacritty.enable = true;
              kitty.enable = true;

              # Multiplexers
              tmux.enable = true;
              zellij.enable = true;

              # CLI Tools
              bat.enable = true;
              delta.enable = true;
              eza.enable = true;
              fzf.enable = true;
              lazygit.enable = true;
              yazi.enable = true;

              # Monitors
              btop.enable = true;

              # Prompts
              starship.enable = true;

              # Shells
              zsh.enable = true;
            };

            # GTK
            gtk.enable = true;

            # Signal will automatically theme ALL enabled programs above
            theming.signal = {
              enable = true;
              autoEnable = true; # This is the key option!
              mode = "dark"; # "light", "dark", or "auto"

              # Optional: Explicitly disable theming for specific programs
              # cli.bat.enable = false;  # Don't theme bat, even though it's enabled

              # Optional: Explicitly enable (redundant with autoEnable, but clearer)
              # editors.helix.enable = true;
            };
          }
        ];
      };
    };
}
