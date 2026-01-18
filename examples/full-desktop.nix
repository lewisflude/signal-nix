# Signal Design System - Full Desktop Example
# Complete configuration with all applications enabled

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

            # First, enable all programs
            programs = {
              helix.enable = true;
              neovim.enable = true;
              ghostty.enable = true;
              alacritty.enable = true;
              kitty.enable = true;
              wezterm.enable = true;
              tmux.enable = true;
              zellij.enable = true;
              bat.enable = true;
              delta.enable = true;
              eza.enable = true;
              fzf.enable = true;
              lazygit.enable = true;
              yazi.enable = true;
              btop.enable = true;
              mangohud.enable = true;
              starship.enable = true;
              zsh.enable = true;
            };

            # Then apply Signal theme to all enabled programs
            theming.signal = {
              enable = true;
              mode = "dark"; # "light", "dark", or "auto"

              # Desktop Environment
              ironbar = {
                enable = true;
                profile = "relaxed"; # "compact" (1080p), "relaxed" (1440p+), "spacious" (4K)
              };
              gtk.enable = true;
              fuzzel.enable = true;

              # Editors
              editors = {
                helix.enable = true;
                neovim.enable = true;
              };

              # Terminals (choose your favorite)
              terminals = {
                ghostty.enable = true;
                alacritty.enable = true;
                kitty.enable = true;
                wezterm.enable = true;
              };

              # Terminal Multiplexers
              multiplexers = {
                tmux.enable = true;
                zellij.enable = true;
              };

              # CLI Tools
              cli = {
                bat.enable = true;
                delta.enable = true;
                eza.enable = true;
                fzf.enable = true;
                lazygit.enable = true;
                yazi.enable = true;
              };

              # System Monitors
              monitors = {
                btop.enable = true;
                mangohud.enable = true; # Gaming overlay
              };

              # Shell Prompts
              prompts = {
                starship.enable = true;
              };

              # Shells
              shells = {
                zsh.enable = true;
              };
            };
          }
        ];
      };
    };
}
