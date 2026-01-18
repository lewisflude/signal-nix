{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: services.swaync (via xdg.configFile)
# UPSTREAM SCHEMA: https://github.com/ErikReider/SwayNotificationCenter
# SCHEMA VERSION: 0.10.1
# LAST VALIDATED: 2026-01-17
# NOTES: SwayNC uses CSS for styling. Home Manager doesn't have a structured module,
#        so we use xdg.configFile for the style.css file. Signal ONLY sets colors.
#        Users configure fonts, spacing, animations, etc. in their own config.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-raised = signalColors.tonal."surface-hover";
    surface-emphasis = signalColors.tonal."surface-Lc15";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-tertiary = signalColors.tonal."text-tertiary";
    divider-primary = signalColors.tonal."divider-primary";
    divider-secondary = signalColors.tonal."divider-strong";
  };

  inherit (signalColors) accent;

  # Generate SwayNC CSS - COLORS ONLY
  swayNcCss = ''
    /**
     * Signal theme for Sway Notification Center
     * This file ONLY contains color overrides.
     * Configure fonts, spacing, animations, etc. in your own style.css
     */

    /* =============================================================================
       COLOR DEFINITIONS
       ============================================================================= */

    @define-color text-primary ${colors.text-primary.hex};
    @define-color text-secondary ${colors.text-secondary.hex};
    @define-color text-tertiary ${colors.text-tertiary.hex};

    @define-color surface-base ${colors.surface-base.hex};
    @define-color surface-raised ${colors.surface-raised.hex};
    @define-color surface-emphasis ${colors.surface-emphasis.hex};

    @define-color divider-primary ${colors.divider-primary.hex};
    @define-color divider-secondary ${colors.divider-secondary.hex};

    @define-color accent-focus ${accent.secondary.Lc75.hex};
    @define-color accent-success ${accent.primary.Lc75.hex};
    @define-color accent-warning ${accent.warning.Lc75.hex};
    @define-color accent-danger ${accent.danger.Lc75.hex};
    @define-color accent-info ${accent.secondary.Lc75.hex};

    /* =============================================================================
       NOTIFICATION CENTER WINDOW
       ============================================================================= */

    .notification-center {
      background-color: @surface-base;
      color: @text-primary;
    }

    .notification-center-header {
      background-color: @surface-emphasis;
      color: @text-primary;
      border-bottom: 2px solid @divider-primary;
    }

    .notification-center-header button {
      background-color: transparent;
      color: @text-primary;
    }

    .notification-center-header button:hover {
      background-color: @surface-raised;
    }

    .notification-center-body {
      background-color: @surface-base;
    }

    /* =============================================================================
       NOTIFICATIONS
       ============================================================================= */

    .notification {
      background-color: @surface-raised;
      color: @text-primary;
      border: 1px solid @divider-primary;
    }

    .notification:hover {
      background-color: @surface-emphasis;
    }

    /* Notification close button */
    .notification .close-button {
      background-color: transparent;
      color: @text-secondary;
    }

    .notification .close-button:hover {
      background-color: @accent-danger;
      color: @surface-base;
    }

    /* Notification title and body */
    .notification .title {
      color: @text-primary;
    }

    .notification .body {
      color: @text-secondary;
    }

    .notification .time {
      color: @text-tertiary;
    }

    /* Notification actions */
    .notification .action-button {
      background-color: @surface-base;
      color: @accent-focus;
      border: 1px solid @accent-focus;
    }

    .notification .action-button:hover {
      background-color: @accent-focus;
      color: @surface-base;
    }

    /* =============================================================================
       URGENCY LEVELS
       ============================================================================= */

    /* Low urgency */
    .notification.low {
      border-left: 4px solid @accent-info;
    }

    /* Normal urgency */
    .notification.normal {
      border-left: 4px solid @accent-focus;
    }

    /* Critical urgency */
    .notification.critical {
      background-color: @accent-danger;
      color: @surface-base;
      border-left: 4px solid @accent-danger;
    }

    .notification.critical .title,
    .notification.critical .body,
    .notification.critical .time {
      color: @surface-base;
    }

    .notification.critical .close-button {
      color: @surface-base;
    }

    .notification.critical .close-button:hover {
      background-color: rgba(0, 0, 0, 0.2);
    }

    /* =============================================================================
       WIDGETS
       ============================================================================= */

    /* Control center widgets */
    .widget {
      background-color: @surface-raised;
      color: @text-primary;
      border: 1px solid @divider-primary;
    }

    .widget button {
      background-color: @surface-base;
      color: @text-primary;
    }

    .widget button:hover {
      background-color: @surface-emphasis;
    }

    .widget button.active {
      background-color: @accent-focus;
      color: @surface-base;
    }

    /* Volume/brightness sliders */
    .widget scale trough {
      background-color: @surface-base;
    }

    .widget scale highlight {
      background-color: @accent-focus;
    }

    /* Do Not Disturb button */
    .widget-dnd button.active {
      background-color: @accent-warning;
      color: @surface-base;
    }

    /* Clear all button */
    .control-center-clear-all {
      background-color: transparent;
      color: @accent-danger;
      border: 1px solid @accent-danger;
    }

    .control-center-clear-all:hover {
      background-color: @accent-danger;
      color: @surface-base;
    }

    /* =============================================================================
       MISC ELEMENTS
       ============================================================================= */

    /* Progress bars */
    progressbar {
      background-color: @surface-base;
    }

    progressbar progress {
      background-color: @accent-focus;
    }

    /* Images in notifications */
    .notification image {
      border: 1px solid @divider-primary;
    }

    /* Inline replies */
    .notification entry {
      background-color: @surface-base;
      color: @text-primary;
      border: 1px solid @divider-primary;
    }

    .notification entry:focus {
      border-color: @accent-focus;
    }
  '';

  # Check if swaync should be themed
  shouldTheme = signalLib.shouldThemeApp "swaync" [
    "desktop"
    "notifications"
    "swaync"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    # SwayNC styling via CSS
    xdg.configFile."swaync/style.css".text = swayNcCss;
  };
}
