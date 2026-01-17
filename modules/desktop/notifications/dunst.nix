{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: services.dunst.settings
# UPSTREAM SCHEMA: https://dunst-project.org/documentation/
# SCHEMA VERSION: 1.11.0
# LAST VALIDATED: 2026-01-17
# NOTES: Dunst uses an INI-style config format. Home Manager provides a settings
#        attrset that gets serialized to dunstrc. We theme the global settings
#        and urgency-specific colors.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-raised = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    divider-primary = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # Check if dunst should be themed
  shouldTheme = signalLib.shouldThemeApp "dunst" [
    "desktop"
    "notifications"
    "dunst"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    services.dunst.settings = {
      global = {
        # Frame (border)
        frame_color = accent.focus.Lc75.hex;
        frame_width = 2;
        
        # Separator between notifications
        separator_color = "frame";
        
        # Font
        font = "Inter 11";
      };

      # Low urgency notifications (informational)
      urgency_low = {
        background = colors.surface-base.hex;
        foreground = colors.text-secondary.hex;
        frame_color = accent.info.Lc75.hex;
        timeout = 5;
      };

      # Normal urgency notifications (default)
      urgency_normal = {
        background = colors.surface-raised.hex;
        foreground = colors.text-primary.hex;
        frame_color = accent.focus.Lc75.hex;
        timeout = 10;
      };

      # Critical urgency notifications (important)
      urgency_critical = {
        background = accent.danger.Lc75.hex;
        foreground = colors.surface-base.hex;
        frame_color = accent.danger.Lc75.hex;
        timeout = 0; # Don't auto-dismiss
      };
    };
  };
}
