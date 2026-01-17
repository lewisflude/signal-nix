# Signal Complete System Theming Example
#
# This example shows how to use Signal's NixOS modules AND Home Manager modules
# together for complete system-to-user theming consistency.

{
  description = "NixOS configuration with complete Signal theming";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          # Import Signal NixOS module
          signal.nixosModules.default

          # Import Home Manager NixOS module
          home-manager.nixosModules.home-manager

          # Your hardware configuration
          # ./hardware-configuration.nix

          # Main configuration
          (
            { config, pkgs, ... }:
            {
              # ====================================================================
              # System-Level Signal Theming (NixOS)
              # ====================================================================

              theming.signal.nixos = {
                enable = true;
                mode = "dark";

                # Theme boot components
                boot = {
                  console.enable = true; # TTY colors
                  grub.enable = true; # GRUB bootloader theme
                  # plymouth.enable = true;  # Coming soon: boot splash
                };

                # Theme display manager (coming soon)
                # login = {
                #   sddm.enable = true;  # or gdm, lightdm
                # };
              };

              # ====================================================================
              # Home Manager Configuration
              # ====================================================================

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                users.alice = {
                  imports = [ signal.homeManagerModules.default ];

                  # User-Level Signal Theming (Home Manager)
                  theming.signal = {
                    enable = true;
                    mode = "dark"; # Can differ from system mode if desired
                    autoEnable = true; # Automatically theme all enabled programs

                    # Optional: Override specific programs
                    # cli.bat.enable = false;  # Don't theme bat
                  };

                  # Enable programs - Signal will theme them automatically
                  programs = {
                    # Editors
                    helix.enable = true;
                    neovim.enable = true;

                    # Terminals
                    ghostty.enable = true;
                    kitty.enable = true;

                    # CLI tools
                    bat.enable = true;
                    fzf.enable = true;
                    lazygit.enable = true;
                    yazi.enable = true;

                    # Multiplexers
                    tmux.enable = true;
                    zellij.enable = true;

                    # Shell
                    zsh = {
                      enable = true;
                      enableCompletion = true;
                    };

                    # Prompt
                    starship.enable = true;

                    # System monitor
                    btop.enable = true;
                  };

                  # GTK theming
                  gtk.enable = true;

                  home = {
                    username = "alice";
                    homeDirectory = "/home/alice";
                    stateVersion = "24.11";
                  };
                };
              };

              # ====================================================================
              # Standard NixOS Configuration
              # ====================================================================

              # Bootloader
              boot.loader.grub = {
                enable = true;
                device = "/dev/sda";
              };

              # Networking
              networking = {
                hostName = "desktop";
                networkmanager.enable = true;
              };

              # User accounts
              users.users.alice = {
                isNormalUser = true;
                home = "/home/alice";
                extraGroups = [
                  "wheel"
                  "networkmanager"
                ];
              };

              # System packages
              environment.systemPackages = with pkgs; [
                vim
                wget
                git
                firefox
              ];

              # Time and locale
              time.timeZone = "America/New_York";
              i18n.defaultLocale = "en_US.UTF-8";

              # Audio
              sound.enable = true;
              hardware.pulseaudio.enable = true;

              # Display server
              services.xserver = {
                enable = true;
                displayManager.sddm.enable = true;
                desktopManager.plasma5.enable = true;
              };

              system.stateVersion = "24.11";
            }
          )
        ];
      };
    };
}
