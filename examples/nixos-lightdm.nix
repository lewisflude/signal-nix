# Signal Design System - NixOS LightDM Example
#
# This example shows how to enable LightDM theming with Signal colors.
# LightDM is a lightweight, fast display manager with GTK greeter support.

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      signal,
    }:
    {
      nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          signal.nixosModules.default

          {
            # =================================================================
            # Signal LightDM Configuration
            # =================================================================

            theming.signal.nixos = {
              enable = true;
              mode = "dark"; # or "light"

              # Enable LightDM display manager theming
              login.lightdm = {
                enable = true;

                # Optional: Custom background image for login screen
                # backgroundImage = ./path/to/background.png;
              };
            };

            # =================================================================
            # System Configuration (you must enable LightDM separately)
            # =================================================================

            # Enable LightDM display manager
            services.xserver = {
              enable = true;
              displayManager.lightdm = {
                enable = true;

                # Enable GTK greeter (required for Signal theming)
                greeters.gtk.enable = true;
              };

              # Example: Enable a desktop environment
              # desktopManager.xfce.enable = true;
              # Or use a window manager
              # windowManager.i3.enable = true;
            };

            # =================================================================
            # Example: Complete system theming with LightDM
            # =================================================================

            theming.signal.nixos = {
              enable = true;
              mode = "dark";

              # Boot experience
              boot = {
                console.enable = true; # TTY colors
                grub.enable = true; # GRUB boot menu
                plymouth.enable = true; # Boot splash
              };

              # Login screen
              login.lightdm = {
                enable = true;
                # Optional: Use solid color background
                # (if not set, uses Signal surface color)
                # backgroundImage = null;
              };
            };

            # Boot configuration
            boot.loader = {
              grub = {
                enable = true;
                device = "/dev/sda"; # or "nodev" for UEFI
              };
            };

            # =================================================================
            # Example: Multi-display manager support
            # =================================================================

            # You can theme multiple display managers
            # (though only one should be enabled at a time)
            theming.signal.nixos.login = {
              lightdm.enable = true; # Active
              # sddm.enable = true;  # Alternative for KDE
              # gdm.enable = true;   # Alternative for GNOME
            };

            # System version
            system.stateVersion = "24.11";
          }
        ];
      };
    };
}
