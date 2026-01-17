{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: ini-config (Tier 2)
# HOME-MANAGER MODULE: programs.tofi.settings
# UPSTREAM SCHEMA: https://github.com/philj56/tofi
# SCHEMA VERSION: 0.9.1
# LAST VALIDATED: 2026-01-17
# NOTES: tofi uses INI config. Home-Manager provides settings attrset.
#        Minimalist launcher with excellent performance.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-raised = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    divider = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # tofi uses hex colors without #
  toTofiColor = color: lib.removePrefix "#" color.hex;

  # Check if tofi should be themed
  shouldTheme = signalLib.shouldThemeApp "tofi" [
    "desktop"
    "launchers"
    "tofi"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.tofi.settings = {
      # Background
      background-color = toTofiColor colors.surface-base;
      
      # Text colors
      text-color = toTofiColor colors.text-primary;
      prompt-color = toTofiColor accent.focus.Lc75;
      placeholder-color = toTofiColor colors.text-secondary;
      
      # Input
      input-color = toTofiColor colors.text-primary;
      default-result-color = toTofiColor colors.text-secondary;
      
      # Selection
      selection-color = toTofiColor accent.focus.Lc75;
      selection-background = toTofiColor colors.surface-raised;
      selection-background-padding = 4;
      
      # Border
      border-width = 2;
      border-color = toTofiColor colors.divider;
      
      # Outline (for selected item)
      outline-width = 0;
      
      # Corner radius
      corner-radius = 8;
      
      # Padding
      padding-left = 12;
      padding-right = 12;
      padding-top = 12;
      padding-bottom = 12;
      
      # Font (user can override)
      font = lib.mkDefault "Inter";
      font-size = lib.mkDefault 14;
    };
  };
}
