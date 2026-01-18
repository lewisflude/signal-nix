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
#
# REFACTORED: Now uses mkTier3Module helper to reduce boilerplate
let
  inherit (signalColors) accent;

  # Use the standard ANSI color helper
  ansiColors = signalLib.makeAnsiColors signalColors;

  # Use the standard UI colors helper
  uiColors = signalLib.makeUIColors signalColors;
in
signalLib.mkTier3Module {
  appName = "kitty";
  category = [ "terminals" ];

  settingsGenerator = _: {
    # Basic colors
    foreground = uiColors.text-primary.hex;
    background = uiColors.surface-base.hex;

    # Cursor colors
    cursor = uiColors.accent-secondary.hex;
    cursor_text_color = uiColors.surface-base.hex;

    # Selection colors
    selection_foreground = uiColors.text-primary.hex;
    selection_background = uiColors.divider-primary.hex;

    # URL underline color
    url_color = uiColors.accent-secondary.hex;

    # Tab bar colors
    active_tab_foreground = uiColors.text-primary.hex;
    active_tab_background = uiColors.surface-base.hex;
    inactive_tab_foreground = uiColors.text-secondary.hex;
    inactive_tab_background = uiColors.divider-primary.hex;

    # Marks
    mark1_foreground = uiColors.surface-base.hex;
    mark1_background = uiColors.accent-secondary.hex;
    mark2_foreground = uiColors.surface-base.hex;
    mark2_background = uiColors.accent-tertiary.hex;
    mark3_foreground = uiColors.surface-base.hex;
    mark3_background = uiColors.warning.hex;

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
}
