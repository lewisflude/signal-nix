# Ironbar Signal Theme Configuration Module
# Configures ironbar with Signal theme design system
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  # Import configuration generator
  configModule = import ./config.nix { inherit pkgs lib; };

  # Style file path
  styleFile = ./style.css;
in
{
  config = mkIf (cfg.enable && cfg.ironbar.enable) {
    programs.ironbar = {
      enable = true;

      # Systemd Integration
      systemd = true;

      # Styling
      style = styleFile;

      # Configuration
      inherit (configModule) config;
    };
  };
}
