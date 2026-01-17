{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: programs.ghostty.settings
# UPSTREAM SCHEMA: https://ghostty.org/docs/config
# SCHEMA VERSION: 1.0.0
# LAST VALIDATED: 2026-01-17
# NOTES: Ghostty is a newer terminal. Home-Manager provides freeform settings
#        that serialize to Ghostty's config format. Keys must match schema exactly.
#        The window-theme option accepts "auto", "light", "dark", or "ghostty".
let
  inherit (lib) mkIf removePrefix;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-elevated = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    divider-primary = signalColors.tonal."divider-primary";
  };

  inherit (signalColors) accent;

  # Helper to get hex without # prefix
  hexRaw = color: removePrefix "#" color.hex;

  # ANSI color mapping using Signal palette
  ansiColors = {
    # Normal colors
    black = signalColors.tonal."black";
    red = accent.danger.Lc75;
    green = accent.primary.Lc75;
    yellow = accent.warning.Lc75;
    blue = accent.secondary.Lc75;
    magenta = accent.tertiary.Lc75;
    cyan = accent.secondary.Lc75;
    white = signalColors.tonal."text-secondary";

    # Bright colors
    bright-black = signalColors.tonal."text-tertiary";
    bright-red = accent.danger.Lc75;
    bright-green = accent.primary.Lc75;
    bright-yellow = accent.warning.Lc75;
    bright-blue = accent.secondary.Lc75;
    bright-magenta = accent.tertiary.Lc75;
    bright-cyan = accent.secondary.Lc75;
    bright-white = signalColors.tonal."text-primary";
  };

  # Check if ghostty should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "ghostty" [
    "terminals"
    "ghostty"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.ghostty = {
      settings = {
        # Window theme (GTK) - uses system theme for titlebar
        "window-theme" = "ghostty";

        # Background and foreground
        background = hexRaw colors.surface-base;
        foreground = hexRaw colors.text-primary;

        # Cursor colors
        "cursor-color" = hexRaw accent.secondary.Lc75;
        "cursor-text" = hexRaw colors.surface-base;

        # Selection colors
        "selection-background" = hexRaw colors.divider-primary;
        "selection-foreground" = hexRaw colors.text-primary;

        # Split divider color
        "split-divider-color" = hexRaw colors.divider-primary;

        # ANSI color palette
        palette = [
          "0=${ansiColors.black.hex}"
          "1=${ansiColors.red.hex}"
          "2=${ansiColors.green.hex}"
          "3=${ansiColors.yellow.hex}"
          "4=${ansiColors.blue.hex}"
          "5=${ansiColors.magenta.hex}"
          "6=${ansiColors.cyan.hex}"
          "7=${ansiColors.white.hex}"
          # Bright colors (8-15)
          "8=${ansiColors.bright-black.hex}"
          "9=${ansiColors.bright-red.hex}"
          "10=${ansiColors.bright-green.hex}"
          "11=${ansiColors.bright-yellow.hex}"
          "12=${ansiColors.bright-blue.hex}"
          "13=${ansiColors.bright-magenta.hex}"
          "14=${ansiColors.bright-cyan.hex}"
          "15=${ansiColors.bright-white.hex}"
        ];
      };
    };
  };
}
