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
#        attrset that gets serialized to dunstrc. We theme ONLY colors.
#        Users configure fonts, frame_width, timeouts, etc. in their own config.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-raised = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    divider-primary = signalColors.tonal."divider-primary";
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
        # Frame (border) color - ONLY COLOR
        frame_color = accent.secondary.Lc75.hex;

        # Separator between notifications color
        separator_color = "frame";
      };

      # Low urgency notifications (informational) - ONLY COLORS
      urgency_low = {
        background = colors.surface-base.hex;
        foreground = colors.text-secondary.hex;
        frame_color = accent.secondary.Lc75.hex;
      };

      # Normal urgency notifications (default) - ONLY COLORS
      urgency_normal = {
        background = colors.surface-raised.hex;
        foreground = colors.text-primary.hex;
        frame_color = accent.secondary.Lc75.hex;
      };

      # Critical urgency notifications (important) - ONLY COLORS
      urgency_critical = {
        background = accent.danger.Lc75.hex;
        foreground = colors.surface-base.hex;
        frame_color = accent.danger.Lc75.hex;
      };
    };
  };
}
