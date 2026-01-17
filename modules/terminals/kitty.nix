{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: programs.kitty.settings
# UPSTREAM SCHEMA: https://sw.kovidgoyal.net/kitty/conf/
# SCHEMA VERSION: 0.32.0
# LAST VALIDATED: 2026-01-17
# NOTES: No native theme option available. Home-Manager serializes the settings
#        attrset to kitty.conf format. All keys must match kitty schema exactly.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    divider-primary = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # ANSI color mapping using Signal palette
  ansiColors = {
    # Normal colors
    black = signalColors.tonal."base-L015";
    red = accent.danger.Lc75;
    green = accent.success.Lc75;
    yellow = accent.warning.Lc75;
    blue = accent.focus.Lc75;
    magenta = accent.special.Lc75;
    cyan = accent.info.Lc75;
    white = signalColors.tonal."text-Lc60";

    # Bright colors
    bright-black = signalColors.tonal."text-Lc45";
    bright-red = accent.danger.Lc75;
    bright-green = accent.success.Lc75;
    bright-yellow = accent.warning.Lc75;
    bright-blue = accent.focus.Lc75;
    bright-magenta = accent.special.Lc75;
    bright-cyan = accent.info.Lc75;
    bright-white = signalColors.tonal."text-Lc75";
  };

  # Check if kitty should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "kitty" [
    "terminals"
    "kitty"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.kitty = {
      settings = {
        # Basic colors
        foreground = colors.text-primary.hex;
        background = colors.surface-base.hex;

        # Cursor colors
        cursor = accent.focus.Lc75.hex;
        cursor_text_color = colors.surface-base.hex;

        # Selection colors
        selection_foreground = colors.text-primary.hex;
        selection_background = colors.divider-primary.hex;

        # URL underline color
        url_color = accent.focus.Lc75.hex;

        # Tab bar colors
        active_tab_foreground = colors.text-primary.hex;
        active_tab_background = colors.surface-base.hex;
        inactive_tab_foreground = colors.text-secondary.hex;
        inactive_tab_background = colors.divider-primary.hex;

        # Marks
        mark1_foreground = colors.surface-base.hex;
        mark1_background = accent.info.Lc75.hex;
        mark2_foreground = colors.surface-base.hex;
        mark2_background = accent.special.Lc75.hex;
        mark3_foreground = colors.surface-base.hex;
        mark3_background = accent.warning.Lc75.hex;

        # The 16 terminal colors

        # Black
        color0 = ansiColors.black.hex;
        color8 = ansiColors.bright-black.hex;

        # Red
        color1 = ansiColors.red.hex;
        color9 = ansiColors.bright-red.hex;

        # Green
        color2 = ansiColors.green.hex;
        color10 = ansiColors.bright-green.hex;

        # Yellow
        color3 = ansiColors.yellow.hex;
        color11 = ansiColors.bright-yellow.hex;

        # Blue
        color4 = ansiColors.blue.hex;
        color12 = ansiColors.bright-blue.hex;

        # Magenta
        color5 = ansiColors.magenta.hex;
        color13 = ansiColors.bright-magenta.hex;

        # Cyan
        color6 = ansiColors.cyan.hex;
        color14 = ansiColors.bright-cyan.hex;

        # White
        color7 = ansiColors.white.hex;
        color15 = ansiColors.bright-white.hex;
      };
    };
  };
}
