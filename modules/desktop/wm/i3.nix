{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: structured-config (Tier 2)
# HOME-MANAGER MODULE: xsession.windowManager.i3.config.colors
# UPSTREAM SCHEMA: https://i3wm.org/docs/userguide.html#_changing_colors
# SCHEMA VERSION: 4.23
# LAST VALIDATED: 2026-01-17
# NOTES: i3 uses the same color scheme format as Sway (Sway is i3-compatible).
#        Colors are defined with border, background, text, indicator, and childBorder.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-raised = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    divider-primary = signalColors.tonal."divider-Lc15";
    divider-secondary = signalColors.tonal."divider-Lc20";
  };

  inherit (signalColors) accent;

  # Check if i3 should be themed
  shouldTheme = signalLib.shouldThemeApp "i3" [
    "desktop"
    "wm"
    "i3"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    xsession.windowManager.i3.config.colors = {
      # Focused window (active)
      focused = {
        border = accent.focus.Lc75.hex;
        background = colors.surface-raised.hex;
        text = colors.text-primary.hex;
        indicator = accent.focus.Lc75.hex;
        childBorder = accent.focus.Lc75.hex;
      };

      # Focused window (inactive - in multi-monitor setup)
      focusedInactive = {
        border = colors.divider-secondary.hex;
        background = colors.surface-base.hex;
        text = colors.text-secondary.hex;
        indicator = colors.divider-secondary.hex;
        childBorder = colors.divider-secondary.hex;
      };

      # Unfocused window
      unfocused = {
        border = colors.divider-primary.hex;
        background = colors.surface-base.hex;
        text = colors.text-secondary.hex;
        indicator = colors.divider-primary.hex;
        childBorder = colors.divider-primary.hex;
      };

      # Urgent window (demands attention)
      urgent = {
        border = accent.danger.Lc75.hex;
        background = accent.danger.Lc75.hex;
        text = colors.surface-base.hex;
        indicator = accent.danger.Lc75.hex;
        childBorder = accent.danger.Lc75.hex;
      };

      # Placeholder (rare)
      placeholder = {
        border = colors.divider-primary.hex;
        background = colors.surface-base.hex;
        text = colors.text-secondary.hex;
        indicator = colors.divider-primary.hex;
        childBorder = colors.divider-primary.hex;
      };

      # Status bar colors
      background = colors.surface-base.hex;
    };
  };
}
