# Ironbar Signal Theme - Colors Only
# Provides Signal color palette for ironbar via CSS
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

  # Generate minimal color-only style.css with Signal colors
  styleFile = pkgs.writeText "ironbar-signal-style.css" ''
    /**
     * IRONBAR SIGNAL THEME - COLORS ONLY
     * Generated from Signal Design System
     * 
     * This file ONLY contains color definitions.
     * Configure ironbar widgets in your own configuration.
     * See: https://github.com/JakeStanger/ironbar/wiki
     */

    /* =============================================================================
       SIGNAL COLOR TOKENS
       ============================================================================= */

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

    /* =============================================================================
       APPLY COLORS TO ELEMENTS
       Apply Signal colors while respecting your layout
       ============================================================================= */

    .background {
      background-color: transparent;
    }

    #bar {
      background-color: transparent;
    }

    /* Text */
    label {
      color: @text_primary;
    }

    /* Workspaces */
    .workspaces button {
      color: @text_tertiary;
      background-color: transparent;
    }

    .workspaces button.focused {
      color: @text_primary;
      border-left-color: @accent_focus;
    }

    .workspaces button:hover {
      color: @text_secondary;
    }
  '';

  shouldTheme =
    if cfg.autoEnable then config.programs.ironbar.enable or false else cfg.ironbar.enable or false;
in
{
  options.theming.signal.ironbar = {
    enable = lib.mkEnableOption "Signal colors for ironbar (requires programs.ironbar.enable)";
  };

  config = mkIf (cfg.enable && shouldTheme) {
    programs.ironbar = {
      # Signal only provides colors via CSS
      # Configure widgets, layout, and behavior in your own programs.ironbar config
      style = lib.mkDefault styleFile;
    };
  };
}
