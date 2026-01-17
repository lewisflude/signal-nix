# Ironbar Signal Theme - Color Palette Provider
# Provides Signal color palette for ironbar without configuring the program
# Users import the colors in their own ironbar configuration
{
  config,
  lib,
  pkgs,
  signalColors,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.theming.signal;

  # Import color tokens
  tokens = import ./tokens.nix { inherit signalColors; };

  # Generate CSS file with ONLY color definitions
  # No styling, just @define-color statements
  colorsOnlyCss = pkgs.writeText "ironbar-signal-colors.css" ''
    /**
     * SIGNAL COLOR PALETTE FOR IRONBAR
     * Generated from Signal Design System
     * 
     * This file ONLY contains @define-color definitions.
     * Import this in your ironbar style.css to use Signal colors.
     * 
     * Usage:
     *   @import url("''${config.theming.signal.colors.ironbar.cssFile}");
     * 
     * Then use colors like:
     *   color: @text_primary;
     *   background-color: @surface_base;
     *   border-color: @accent_focus;
     */

    /* Text Colors */
    @define-color text_primary ${tokens.colors.text.primary};
    @define-color text_secondary ${tokens.colors.text.secondary};
    @define-color text_tertiary ${tokens.colors.text.tertiary};

    /* Surface Colors */
    @define-color surface_base ${tokens.colors.surface.base};
    @define-color surface_emphasis ${tokens.colors.surface.emphasis};

    /* Accent Colors */
    @define-color accent_focus ${tokens.colors.accent.focus};
    @define-color accent_success ${tokens.colors.accent.success};
    @define-color accent_warning ${tokens.colors.accent.warning};
    @define-color accent_danger ${tokens.colors.accent.danger};
  '';
in
{
  options.theming.signal.ironbar = {
    enable = mkEnableOption "Signal color palette for ironbar";
  };

  config = mkIf (cfg.enable && cfg.ironbar.enable) {
    # Expose colors for consumers to use
    theming.signal.colors.ironbar = {
      # Pre-generated CSS file with color definitions
      # Users can @import this in their own style.css
      cssFile = colorsOnlyCss;

      # Raw color tokens for Nix-based configuration
      # Useful for programmatic color access
      tokens = tokens.colors;
    };
  };
}
