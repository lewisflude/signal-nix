{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: programs.fuzzel.settings
# UPSTREAM SCHEMA: https://codeberg.org/dnkl/fuzzel/src/branch/master/doc/fuzzel.ini.5.scd
# SCHEMA VERSION: 1.9.2
# LAST VALIDATED: 2026-01-17
# NOTES: Home-Manager provides freeform settings that serialize to INI format.
#        Fuzzel requires RRGGBBAA format (no # prefix) for colors with alpha.
#        This module ONLY sets colors - layout/fonts/sizing are user's responsibility.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    background = signalColors.tonal."surface-subtle";
    text = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    match = signalColors.accent.secondary.Lc75;
    selection-background = signalColors.tonal."divider-primary";
    selection-text = signalColors.tonal."text-primary";
    border = signalColors.accent.secondary.Lc75;
  };

  # Use high-fidelity alpha channel handling from signalLib
  # Converts hex to RRGGBBAA format (no # prefix) for Fuzzel
  withAlpha = color: alpha: signalLib.hexWithAlpha color alpha;

  # Check if fuzzel should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "fuzzel" [ "fuzzel" ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.fuzzel = {
      settings = {
        colors = {
          # High-fidelity color conversion with proper alpha channel handling
          background = withAlpha colors.background 0.949; # ~95% opacity (f2 in hex)
          text = withAlpha colors.text 1.0;
          match = withAlpha colors.match 1.0;
          selection-background = withAlpha colors.selection-background 1.0;
          selection-text = withAlpha colors.selection-text 1.0;
          selection-match = withAlpha colors.match 1.0;
          border = withAlpha colors.border 1.0;
        };
      };
    };
  };
}
