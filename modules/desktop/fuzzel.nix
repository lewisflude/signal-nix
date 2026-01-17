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
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    background = signalColors.tonal."surface-Lc05";
    text = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    match = signalColors.accent.focus.Lc75;
    selection-background = signalColors.tonal."divider-Lc15";
    selection-text = signalColors.tonal."text-Lc75";
    border = signalColors.accent.focus.Lc75;
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
        main = {
          font = "monospace:size=14";
          dpi-aware = true;
          icon-theme = "Adwaita";
          layer = "overlay";
          width = 50;
          horizontal-pad = 40;
          vertical-pad = 20;
          inner-pad = 10;
        };

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

        border = {
          width = 2;
          radius = 12;
        };
      };
    };
  };
}
