{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: xsession.windowManager.bspwm.settings
# UPSTREAM SCHEMA: https://github.com/baskerville/bspwm
# SCHEMA VERSION: 0.9.10
# LAST VALIDATED: 2026-01-17
# NOTES: bspwm uses shell commands for config. Home-Manager provides settings
#        attrset that gets serialized to bspwmrc. We set color options.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    divider-primary = signalColors.tonal."divider-Lc15";
    divider-secondary = signalColors.tonal."divider-Lc20";
  };

  inherit (signalColors) accent;

  # bspwm uses hex colors with #
  # Check if bspwm should be themed
  shouldTheme = signalLib.shouldThemeApp "bspwm" [
    "desktop"
    "wm"
    "bspwm"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    xsession.windowManager.bspwm.settings = {
      # Border colors
      normal_border_color = colors.divider-primary.hex;
      active_border_color = colors.divider-secondary.hex;
      focused_border_color = accent.focus.Lc75.hex;
      presel_feedback_color = accent.info.Lc75.hex;
      
      # Border width (user can override)
      border_width = lib.mkDefault 2;
      
      # Gap size (user can override)
      window_gap = lib.mkDefault 8;
    };
  };
}
