{
  config,
  lib,

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
  inherit (lib) mkIf mkDefault;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    divider = signalColors.tonal."divider-primary";
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
        color = mkDefault "${toFootColor colors.surface-base} ${toFootColor accent.secondary.Lc75}";
      };

      colors = {
        # Basic colors
        background = mkDefault (toFootColor colors.surface-base);
        foreground = mkDefault (toFootColor colors.text-primary);

        # Selection
        selection-foreground = mkDefault (toFootColor colors.text-primary);
        selection-background = mkDefault (toFootColor colors.divider);

        # URLs
        urls = mkDefault (toFootColor accent.secondary.Lc75);

        # Regular colors (0-7)
        regular0 = mkDefault (toFootColor signalColors.tonal."black"); # black
        regular1 = mkDefault (toFootColor accent.danger.Lc75); # red
        regular2 = mkDefault (toFootColor accent.primary.Lc75); # green
        regular3 = mkDefault (toFootColor accent.warning.Lc75); # yellow
        regular4 = mkDefault (toFootColor accent.secondary.Lc75); # blue
        regular5 = mkDefault (toFootColor accent.tertiary.Lc75); # magenta
        regular6 = mkDefault (toFootColor accent.secondary.Lc75); # cyan
        regular7 = mkDefault (toFootColor signalColors.tonal."text-secondary"); # white

        # Bright colors (8-15)
        bright0 = mkDefault (toFootColor signalColors.tonal."text-tertiary"); # bright black
        bright1 = mkDefault (toFootColor accent.danger.Lc75); # bright red
        bright2 = mkDefault (toFootColor accent.primary.Lc75); # bright green
        bright3 = mkDefault (toFootColor accent.warning.Lc75); # bright yellow
        bright4 = mkDefault (toFootColor accent.secondary.Lc75); # bright blue
        bright5 = mkDefault (toFootColor accent.tertiary.Lc75); # bright magenta
        bright6 = mkDefault (toFootColor accent.secondary.Lc75); # bright cyan
        bright7 = mkDefault (toFootColor signalColors.tonal."text-primary"); # bright white
      };
    };
  };
}
