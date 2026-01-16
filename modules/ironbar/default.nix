# Ironbar Signal Theme Configuration Module
# Configures ironbar with Signal theme design system
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

  # Import configuration generator
  configModule = import ./config.nix { inherit pkgs lib signalColors; };

  # Import tokens
  tokens = import ./tokens.nix { inherit signalColors pkgs; };

  # Generate dynamic style.css with Signal colors
  styleFile =
    pkgs.writeText "ironbar-signal-style.css"
      ''
        /**
         * IRONBAR STYLESHEET - SIGNAL THEME
         * Simplified color-focused theme
         * Colors are dynamically generated from Signal design system
         */

        /* =============================================================================
           COLOR TOKENS
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
        @define-color accent_warning ${tokens.colors.accent.warning};
        @define-color accent_danger ${tokens.colors.accent.danger};

        /* =============================================================================
           BASE STYLES
           ============================================================================= */

        * {
          font-family: monospace;
          font-size: 14px;
        }

        .background {
          background-color: transparent;
        }

        #bar {
          background-color: transparent;
          margin: 12px;
        }

        /* =============================================================================
           WIDGETS & COMPONENTS
           ============================================================================= */

        /* Text Styling */
        label {
          color: @text_primary;
        }

        /* Workspaces */
        .workspaces button {
          color: @text_tertiary;
          background-color: transparent;
          border: none;
          padding: 4px 8px;
          margin: 0 4px;
          border-radius: 12px;
        }

        .workspaces button.focused {
          color: @text_primary;
          border-left: 3px solid @accent_focus;
          border-top-left-radius: 0;
          border-bottom-left-radius: 0;
        }

        .workspaces button:hover {
          color: @text_primary;
        }

        /* Window Title */
        .focused {
          padding: 4px 20px;
        }

        .focused label {
          color: @text_secondary;
        }

        .focused.active {
          border-left: 3px solid @accent_focus;
          border-top-left-radius: 0;
          border-bottom-left-radius: 0;
        }

        .focused.active label {
          color: @text_primary;
        }

        /* Control Buttons */
        button {
          background-color: transparent;
          border: none;
          color: @text_primary;
        }

        button:hover {
          opacity: 1.0;
        }

        /* System Tray */
        .tray .item {
          padding: 4px;
          margin: 0 3px;
          border-radius: 10px;
        }

        /* Battery */
        .battery {
          font-family: monospace;
        }

        .battery.warning {
          color: @accent_warning;
          border-left: 3px solid @accent_warning;
        }

        .battery.critical {
          color: @accent_danger;
          border-left: 3px solid @accent_danger;
        }

        /* Clock */
        .clock {
          font-family: monospace;
          color: @text_primary;
          padding: 0 16px;
        }

        /* Power Button */
        .power {
          color: @accent_danger;
        }

        /* Notifications */
        .notifications {
          padding: 0 8px;
        }

        /* =============================================================================
           LAYOUT (Islands)
           ============================================================================= */

        #bar #start,
        #bar #center,
        #bar #end {
          background-color: @surface_base;
          border: 2px solid @surface_emphasis;
          border-radius: 16px;
          padding: 4px 16px;
        }

        #bar #start {
          margin-right: 16px;
        }

        #bar #center {
          margin: 0 8px;
        }

        #bar #end {
          margin-left: 16px;
        }
      '';
in
{
  config = mkIf (cfg.enable && cfg.ironbar.enable) {
    programs.ironbar = {
      enable = true;

      # Systemd Integration
      systemd = true;

      # Styling - dynamically generated
      style = styleFile;

      # Configuration
      inherit (configModule) config;
    };
  };
}
