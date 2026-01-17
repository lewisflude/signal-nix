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
  inherit (lib) mkIf;
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

    /* ==========================================================================
       SIGNAL SEMANTIC COLORS
       ========================================================================== */

    /* Text Colors */
    @define-color text_primary ${tokens.colors.text.primary};
    @define-color text_secondary ${tokens.colors.text.secondary};
    @define-color text_tertiary ${tokens.colors.text.tertiary};

    /* Surface Colors */
    @define-color surface_base ${tokens.colors.surface.base};
    @define-color surface_emphasis ${tokens.colors.surface.emphasis};

    /* Accent Colors */
    @define-color accent_focus ${tokens.colors.accent.secondary};
    @define-color accent_success ${tokens.colors.accent.primary};
    @define-color accent_warning ${tokens.colors.accent.warning};
    @define-color accent_danger ${tokens.colors.accent.danger};

    /* ==========================================================================
       GTK NAMED COLORS (Complete Set)
       Required for GTK apps to prevent fallback to default theme colors
       ========================================================================== */

    /* Widget text/foreground color */
    @define-color theme_fg_color ${tokens.colors.text.primary};

    /* Text color for entries, views and content in general */
    @define-color theme_text_color ${tokens.colors.text.primary};

    /* Widget base background color */
    @define-color theme_bg_color ${tokens.colors.surface.base};

    /* Text widgets and the like base background color */
    @define-color theme_base_color ${tokens.colors.surface.base};

    /* Base background color of selections */
    @define-color theme_selected_bg_color ${tokens.colors.accent.secondary};

    /* Text/foreground color of selections */
    @define-color theme_selected_fg_color ${tokens.colors.surface.base};

    /* Base background color of insensitive widgets */
    @define-color insensitive_bg_color ${tokens.colors.surface.emphasis};

    /* Text foreground color of insensitive widgets */
    @define-color insensitive_fg_color ${tokens.colors.text.tertiary};

    /* Insensitive text widgets and the like base background color */
    @define-color insensitive_base_color ${tokens.colors.surface.base};

    /* Widget text/foreground color on backdrop windows */
    @define-color theme_unfocused_fg_color ${tokens.colors.text.secondary};

    /* Text color for entries, views and content in general on backdrop windows */
    @define-color theme_unfocused_text_color ${tokens.colors.text.secondary};

    /* Widget base background color on backdrop windows */
    @define-color theme_unfocused_bg_color ${tokens.colors.surface.base};

    /* Text widgets and the like base background color on backdrop windows */
    @define-color theme_unfocused_base_color ${tokens.colors.surface.base};

    /* Base background color of selections on backdrop windows */
    @define-color theme_unfocused_selected_bg_color ${tokens.colors.accent.secondary};

    /* Text/foreground color of selections on backdrop windows */
    @define-color theme_unfocused_selected_fg_color ${tokens.colors.surface.base};

    /* Insensitive color on backdrop windows */
    @define-color unfocused_insensitive_color ${tokens.colors.text.tertiary};

    /* Widgets main borders color */
    @define-color borders ${tokens.colors.surface.emphasis};

    /* Widgets main borders color on backdrop windows */
    @define-color unfocused_borders ${tokens.colors.surface.emphasis};

    /* State colors */
    @define-color warning_color ${tokens.colors.accent.warning};
    @define-color error_color ${tokens.colors.accent.danger};
    @define-color success_color ${tokens.colors.accent.primary};
    @define-color destructive_color ${tokens.colors.accent.danger};

    /* Window Manager colors */
    @define-color wm_title ${tokens.colors.text.primary};
    @define-color wm_unfocused_title ${tokens.colors.text.secondary};
    @define-color wm_highlight ${tokens.colors.surface.emphasis};
    @define-color wm_borders_edge ${tokens.colors.surface.emphasis};
    @define-color wm_bg_a ${tokens.colors.surface.base};
    @define-color wm_bg_b ${tokens.colors.surface.base};
    @define-color wm_shadow alpha(black, 0.35);
    @define-color wm_border alpha(black, 0.18);
    @define-color wm_button_hover_color_a ${tokens.colors.surface.emphasis};
    @define-color wm_button_hover_color_b ${tokens.colors.surface.base};
    @define-color wm_button_active_color_a ${tokens.colors.accent.secondary};
    @define-color wm_button_active_color_b ${tokens.colors.accent.secondary};
    @define-color wm_button_active_color_c ${tokens.colors.accent.secondary};

    /* Content view background */
    @define-color content_view_bg ${tokens.colors.surface.base};
  '';
in
{
  # Don't define options here - they're defined in common/default.nix
  # This module only provides the implementation

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
