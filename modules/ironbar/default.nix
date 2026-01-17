# Ironbar Signal Theme Configuration Module
# Configures ironbar with Signal theme design system
{
  config,
  lib,
  pkgs,
  signalColors,
  signalLib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  # Import configuration generator
  configModule = import ./config.nix { inherit pkgs lib signalColors; };

  # Import tokens
  tokens = import ./tokens.nix { inherit signalColors; };

  # Generate minimal color-only style.css with Signal colors
  styleFile = pkgs.writeText "ironbar-signal-style.css" ''
    /**
     * IRONBAR SIGNAL THEME - COLORS ONLY
     * Generated from Signal Design System
     * 
     * This file ONLY contains color definitions.
     * For layout, spacing, and typography, create your own CSS file.
     * See: examples/ironbar-complete.css for a complete example
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
      color: @text_primary;
    }

    /* Window Title */
    .focused label {
      color: @text_secondary;
    }

    .focused.active {
      border-left-color: @accent_focus;
    }

    .focused.active label {
      color: @text_primary;
    }

    /* Control Buttons */
    button {
      background-color: transparent;
      color: @text_primary;
    }

    /* Battery States */
    .battery.warning {
      color: @accent_warning;
      border-left-color: @accent_warning;
    }

    .battery.critical {
      color: @accent_danger;
      border-left-color: @accent_danger;
    }

    /* Clock */
    .clock {
      color: @text_primary;
    }

    /* Power Button */
    .power {
      color: @accent_danger;
    }

    /* Layout Islands */
    #bar #start,
    #bar #center,
    #bar #end {
      background-color: @surface_base;
      border-color: @surface_emphasis;
    }
  '';

  # Check if ironbar should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "ironbar" [ "ironbar" ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.ironbar = {
      # Note: Signal only provides colors via CSS. Enable ironbar and configure
      # systemd integration in your own programs.ironbar configuration.

      # Styling - dynamically generated with Signal colors
      style = styleFile;

      # Configuration
      inherit (configModule) config;
    };
  };
}
