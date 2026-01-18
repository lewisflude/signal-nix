{
  config,
  lib,

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
  inherit (lib) mkIf mkDefault;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-raised = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    divider = signalColors.tonal."divider-primary";
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
      background-color = mkDefault (toTofiColor colors.surface-base);

      # Text colors
      text-color = mkDefault (toTofiColor colors.text-primary);
      prompt-color = mkDefault (toTofiColor accent.secondary.Lc75);
      placeholder-color = mkDefault (toTofiColor colors.text-secondary);

      # Input
      input-color = mkDefault (toTofiColor colors.text-primary);
      default-result-color = mkDefault (toTofiColor colors.text-secondary);

      # Selection
      selection-color = mkDefault (toTofiColor accent.secondary.Lc75);
      selection-background = mkDefault (toTofiColor colors.surface-raised);

      # Border
      border-color = mkDefault (toTofiColor colors.divider);

      # Outline (for selected item)

      # Corner radius

      # Padding

      # Font (user can override)
    };
  };
}
