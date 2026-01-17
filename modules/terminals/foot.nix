{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: ini-config (Tier 2)
# HOME-MANAGER MODULE: programs.foot.settings
# UPSTREAM SCHEMA: https://codeberg.org/dnkl/foot
# SCHEMA VERSION: 1.17.2
# LAST VALIDATED: 2026-01-17
# NOTES: Foot uses INI-style config. Home-Manager provides settings attrset
#        that gets serialized to foot.ini format.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    divider = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # Foot uses hex colors without #
  toFootColor = color: lib.removePrefix "#" color.hex;

  # Check if foot should be themed
  shouldTheme = signalLib.shouldThemeApp "foot" [
    "terminals"
    "foot"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.foot.settings = {
      main = {
        # Font and general settings (user can override)
        # We only set colors
      };

      cursor = {
        color = "${toFootColor colors.surface-base} ${toFootColor accent.focus.Lc75}";
      };

      colors = {
        # Basic colors
        background = toFootColor colors.surface-base;
        foreground = toFootColor colors.text-primary;

        # Selection
        selection-foreground = toFootColor colors.text-primary;
        selection-background = toFootColor colors.divider;

        # URLs
        urls = toFootColor accent.focus.Lc75;

        # Regular colors (0-7)
        regular0 = toFootColor signalColors.tonal."base-L015"; # black
        regular1 = toFootColor accent.danger.Lc75; # red
        regular2 = toFootColor accent.success.Lc75; # green
        regular3 = toFootColor accent.warning.Lc75; # yellow
        regular4 = toFootColor accent.focus.Lc75; # blue
        regular5 = toFootColor accent.special.Lc75; # magenta
        regular6 = toFootColor accent.info.Lc75; # cyan
        regular7 = toFootColor signalColors.tonal."text-Lc60"; # white

        # Bright colors (8-15)
        bright0 = toFootColor signalColors.tonal."text-Lc45"; # bright black
        bright1 = toFootColor accent.danger.Lc75; # bright red
        bright2 = toFootColor accent.success.Lc75; # bright green
        bright3 = toFootColor accent.warning.Lc75; # bright yellow
        bright4 = toFootColor accent.focus.Lc75; # bright blue
        bright5 = toFootColor accent.special.Lc75; # bright magenta
        bright6 = toFootColor accent.info.Lc75; # bright cyan
        bright7 = toFootColor signalColors.tonal."text-Lc75"; # bright white
      };
    };
  };
}
