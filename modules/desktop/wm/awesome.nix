{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: lua-config (Tier 4)
# HOME-MANAGER MODULE: xsession.windowManager.awesome (via xdg.configFile)
# UPSTREAM SCHEMA: https://awesomewm.org/
# SCHEMA VERSION: 4.3
# LAST VALIDATED: 2026-01-17
# NOTES: awesome uses Lua for config. We provide a theme file that users
#        can import in their rc.lua. No direct HM module integration yet.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-raised = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-dim = signalColors.tonal."text-Lc45";
    divider = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # Generate awesome theme file in Lua
  awesomeTheme = ''
    -- Signal theme for awesome WM
    -- To use: require("signal-theme") in your rc.lua

    local theme = {}

    -- Colors
    theme.bg_normal     = "${colors.surface-base.hex}"
    theme.bg_focus      = "${colors.surface-raised.hex}"
    theme.bg_urgent     = "${accent.danger.Lc75.hex}"
    theme.bg_minimize   = "${colors.divider.hex}"
    theme.bg_systray    = theme.bg_normal

    theme.fg_normal     = "${colors.text-secondary.hex}"
    theme.fg_focus      = "${colors.text-primary.hex}"
    theme.fg_urgent     = "${colors.surface-base.hex}"
    theme.fg_minimize   = "${colors.text-dim.hex}"

    -- Borders
    theme.border_width  = 2
    theme.border_normal = "${colors.divider.hex}"
    theme.border_focus  = "${accent.focus.Lc75.hex}"
    theme.border_marked = "${accent.warning.Lc75.hex}"

    -- Gaps (if using useless gaps)
    theme.useless_gap   = 8

    -- Titlebar
    theme.titlebar_bg_normal = theme.bg_normal
    theme.titlebar_bg_focus  = theme.bg_focus
    theme.titlebar_fg_normal = theme.fg_normal
    theme.titlebar_fg_focus  = theme.fg_focus

    -- Taglist
    theme.taglist_bg_focus    = "${accent.focus.Lc75.hex}"
    theme.taglist_fg_focus    = "${colors.surface-base.hex}"
    theme.taglist_bg_occupied = theme.bg_focus
    theme.taglist_fg_occupied = theme.fg_normal
    theme.taglist_bg_empty    = theme.bg_normal
    theme.taglist_fg_empty    = theme.fg_minimize
    theme.taglist_bg_urgent   = theme.bg_urgent
    theme.taglist_fg_urgent   = theme.fg_urgent

    -- Tasklist
    theme.tasklist_bg_normal = theme.bg_normal
    theme.tasklist_fg_normal = theme.fg_normal
    theme.tasklist_bg_focus  = theme.bg_focus
    theme.tasklist_fg_focus  = theme.fg_focus
    theme.tasklist_bg_urgent = theme.bg_urgent
    theme.tasklist_fg_urgent = theme.fg_urgent

    -- Menu
    theme.menu_height = 24
    theme.menu_width  = 200
    theme.menu_bg_normal = theme.bg_normal
    theme.menu_bg_focus  = theme.bg_focus
    theme.menu_fg_normal = theme.fg_normal
    theme.menu_fg_focus  = theme.fg_focus
    theme.menu_border_width = 1
    theme.menu_border_color = "${colors.divider.hex}"

    -- Notifications (naughty)
    theme.notification_bg = theme.bg_normal
    theme.notification_fg = theme.fg_normal
    theme.notification_border_width = 2
    theme.notification_border_color = "${accent.info.Lc75.hex}"
    theme.notification_opacity = 0.95

    -- Hotkeys popup
    theme.hotkeys_bg = theme.bg_normal
    theme.hotkeys_fg = theme.fg_normal
    theme.hotkeys_border_width = 2
    theme.hotkeys_border_color = theme.border_focus
    theme.hotkeys_modifiers_fg = "${accent.focus.Lc75.hex}"
    theme.hotkeys_label_fg = "${accent.info.Lc75.hex}"
    theme.hotkeys_font = "Inter 12"
    theme.hotkeys_description_font = "Inter 10"

    -- Tooltip
    theme.tooltip_bg = theme.bg_focus
    theme.tooltip_fg = theme.fg_focus
    theme.tooltip_border_width = 1
    theme.tooltip_border_color = theme.border_normal

    return theme
  '';

  # Check if awesome should be themed
  shouldTheme = signalLib.shouldThemeApp "awesome" [
    "desktop"
    "wm"
    "awesome"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    xdg.configFile."awesome/signal-theme.lua".text = awesomeTheme;

    # Provide helper instructions via a README
    xdg.configFile."awesome/SIGNAL_THEME_README.txt".text = ''
      Signal Theme for Awesome WM

      To use this theme, add this line to your rc.lua:

        beautiful.init(gears.filesystem.get_configuration_dir() .. "signal-theme.lua")

      Replace any existing beautiful.init() call with the above line.

      The theme provides all color and styling variables for:
      - Window borders and focus
      - Titlebars
      - Taglist (workspace indicators)
      - Tasklist (window list)
      - Menu styling
      - Notifications (naughty)
      - Hotkeys popup
      - Tooltips

      Customize further by modifying signal-theme.lua or overriding
      specific theme values in your rc.lua after the beautiful.init() call.
    '';
  };
}
