     [1mSTDIN[0m
[38;5;8m   1[0m [37m{[0m
[38;5;8m   2[0m [37m  config,[0m
[38;5;8m   3[0m [37m  lib,[0m
[38;5;8m   4[0m [37m  signalColors,[0m
[38;5;8m   5[0m [37m  signalLib,[0m
[38;5;8m   6[0m [37m  ...[0m
[38;5;8m   7[0m [37m}:[0m
[38;5;8m   8[0m [37m# CONFIGURATION METHOD: lua-config (Tier 4)[0m
[38;5;8m   9[0m [37m# HOME-MANAGER MODULE: xsession.windowManager.awesome (via xdg.configFile)[0m
[38;5;8m  10[0m [37m# UPSTREAM SCHEMA: https://awesomewm.org/[0m
[38;5;8m  11[0m [37m# SCHEMA VERSION: 4.3[0m
[38;5;8m  12[0m [37m# LAST VALIDATED: 2026-01-17[0m
[38;5;8m  13[0m [37m# NOTES: awesome uses Lua for config. We provide a theme file with ONLY colors.[0m
[38;5;8m  14[0m [37m#        Users configure borders, gaps, fonts, menu sizes, etc. in their own theme.[0m
[38;5;8m  15[0m [37mlet[0m
[38;5;8m  16[0m [37m  inherit (lib) mkIf;[0m
[38;5;8m  17[0m [37m  cfg = config.theming.signal;[0m
[38;5;8m  18[0m 
[38;5;8m  19[0m [37m  colors = {[0m
[38;5;8m  20[0m [37m    surface-base = signalColors.tonal."surface-Lc05";[0m
[38;5;8m  21[0m [37m    surface-raised = signalColors.tonal."surface-Lc10";[0m
[38;5;8m  22[0m [37m    text-primary = signalColors.tonal."text-Lc75";[0m
[38;5;8m  23[0m [37m    text-secondary = signalColors.tonal."text-Lc60";[0m
[38;5;8m  24[0m [37m    text-dim = signalColors.tonal."text-Lc45";[0m
[38;5;8m  25[0m [37m    divider = signalColors.tonal."divider-Lc15";[0m
[38;5;8m  26[0m [37m  };[0m
[38;5;8m  27[0m 
[38;5;8m  28[0m [37m  inherit (signalColors) accent;[0m
[38;5;8m  29[0m 
[38;5;8m  30[0m [37m  # Generate awesome theme file in Lua - COLORS ONLY[0m
[38;5;8m  31[0m [37m  awesomeTheme = ''[0m
[38;5;8m  32[0m [37m    -- Signal theme for awesome WM - COLORS ONLY[0m
[38;5;8m  33[0m [37m    -- To use: require("signal-theme") in your rc.lua[0m
[38;5;8m  34[0m [37m    -- Configure borders, gaps, fonts, sizes, etc. in your own theme file[0m
[38;5;8m  35[0m 
[38;5;8m  36[0m [37m    local theme = {}[0m
[38;5;8m  37[0m 
[38;5;8m  38[0m [37m    -- Background colors[0m
[38;5;8m  39[0m [37m    theme.bg_normal     = "${colors.surface-base.hex}"[0m
[38;5;8m  40[0m [37m    theme.bg_focus      = "${colors.surface-raised.hex}"[0m
[38;5;8m  41[0m [37m    theme.bg_urgent     = "${accent.danger.Lc75.hex}"[0m
[38;5;8m  42[0m [37m    theme.bg_minimize   = "${colors.divider.hex}"[0m
[38;5;8m  43[0m [37m    theme.bg_systray    = theme.bg_normal[0m
[38;5;8m  44[0m 
[38;5;8m  45[0m [37m    -- Foreground colors[0m
[38;5;8m  46[0m [37m    theme.fg_normal     = "${colors.text-secondary.hex}"[0m
[38;5;8m  47[0m [37m    theme.fg_focus      = "${colors.text-primary.hex}"[0m
[38;5;8m  48[0m [37m    theme.fg_urgent     = "${colors.surface-base.hex}"[0m
[38;5;8m  49[0m [37m    theme.fg_minimize   = "${colors.text-dim.hex}"[0m
[38;5;8m  50[0m 
[38;5;8m  51[0m [37m    -- Border colors (not border_width)[0m
[38;5;8m  52[0m [37m    theme.border_normal = "${colors.divider.hex}"[0m
[38;5;8m  53[0m [37m    theme.border_focus  = "${accent.focus.Lc75.hex}"[0m
[38;5;8m  54[0m [37m    theme.border_marked = "${accent.warning.Lc75.hex}"[0m
[38;5;8m  55[0m 
[38;5;8m  56[0m [37m    -- Titlebar colors[0m
[38;5;8m  57[0m [37m    theme.titlebar_bg_normal = theme.bg_normal[0m
[38;5;8m  58[0m [37m    theme.titlebar_bg_focus  = theme.bg_focus[0m
[38;5;8m  59[0m [37m    theme.titlebar_fg_normal = theme.fg_normal[0m
[38;5;8m  60[0m [37m    theme.titlebar_fg_focus  = theme.fg_focus[0m
[38;5;8m  61[0m 
[38;5;8m  62[0m [37m    -- Taglist colors[0m
[38;5;8m  63[0m [37m    theme.taglist_bg_focus    = "${accent.focus.Lc75.hex}"[0m
[38;5;8m  64[0m [37m    theme.taglist_fg_focus    = "${colors.surface-base.hex}"[0m
[38;5;8m  65[0m [37m    theme.taglist_bg_occupied = theme.bg_focus[0m
[38;5;8m  66[0m [37m    theme.taglist_fg_occupied = theme.fg_normal[0m
[38;5;8m  67[0m [37m    theme.taglist_bg_empty    = theme.bg_normal[0m
[38;5;8m  68[0m [37m    theme.taglist_fg_empty    = theme.fg_minimize[0m
[38;5;8m  69[0m [37m    theme.taglist_bg_urgent   = theme.bg_urgent[0m
[38;5;8m  70[0m [37m    theme.taglist_fg_urgent   = theme.fg_urgent[0m
[38;5;8m  71[0m 
[38;5;8m  72[0m [37m    -- Tasklist colors[0m
[38;5;8m  73[0m [37m    theme.tasklist_bg_normal = theme.bg_normal[0m
[38;5;8m  74[0m [37m    theme.tasklist_fg_normal = theme.fg_normal[0m
[38;5;8m  75[0m [37m    theme.tasklist_bg_focus  = theme.bg_focus[0m
[38;5;8m  76[0m [37m    theme.tasklist_fg_focus  = theme.fg_focus[0m
[38;5;8m  77[0m [37m    theme.tasklist_bg_urgent = theme.bg_urgent[0m
[38;5;8m  78[0m [37m    theme.tasklist_fg_urgent = theme.fg_urgent[0m
[38;5;8m  79[0m 
[38;5;8m  80[0m [37m    -- Menu colors (not sizes)[0m
[38;5;8m  81[0m [37m    theme.menu_bg_normal = theme.bg_normal[0m
[38;5;8m  82[0m [37m    theme.menu_bg_focus  = theme.bg_focus[0m
[38;5;8m  83[0m [37m    theme.menu_fg_normal = theme.fg_normal[0m
[38;5;8m  84[0m [37m    theme.menu_fg_focus  = theme.fg_focus[0m
[38;5;8m  85[0m [37m    theme.menu_border_color = "${colors.divider.hex}"[0m
[38;5;8m  86[0m 
[38;5;8m  87[0m [37m    -- Notification colors (not sizes)[0m
[38;5;8m  88[0m [37m    theme.notification_bg = theme.bg_normal[0m
[38;5;8m  89[0m [37m    theme.notification_fg = theme.fg_normal[0m
[38;5;8m  90[0m [37m    theme.notification_border_color = "${accent.info.Lc75.hex}"[0m
[38;5;8m  91[0m [37m    theme.notification_opacity = 0.95[0m
[38;5;8m  92[0m 
[38;5;8m  93[0m [37m    -- Hotkeys popup colors (not fonts)[0m
[38;5;8m  94[0m [37m    theme.hotkeys_bg = theme.bg_normal[0m
[38;5;8m  95[0m [37m    theme.hotkeys_fg = theme.fg_normal[0m
[38;5;8m  96[0m [37m    theme.hotkeys_border_color = theme.border_focus[0m
[38;5;8m  97[0m [37m    theme.hotkeys_modifiers_fg = "${accent.focus.Lc75.hex}"[0m
[38;5;8m  98[0m [37m    theme.hotkeys_label_fg = "${accent.info.Lc75.hex}"[0m
[38;5;8m  99[0m 
[38;5;8m 100[0m [37m    -- Tooltip colors (not sizes)[0m
[38;5;8m 101[0m [37m    theme.tooltip_bg = theme.bg_focus[0m
[38;5;8m 102[0m [37m    theme.tooltip_fg = theme.fg_focus[0m
[38;5;8m 103[0m [37m    theme.tooltip_border_color = theme.border_normal[0m
[38;5;8m 104[0m 
[38;5;8m 105[0m [37m    return theme[0m
[38;5;8m 106[0m [37m  '';[0m
[38;5;8m 107[0m 
[38;5;8m 108[0m [37m  # Check if awesome should be themed[0m
[38;5;8m 109[0m [37m  shouldTheme = signalLib.shouldThemeApp "awesome" [[0m
[38;5;8m 110[0m [37m    "desktop"[0m
[38;5;8m 111[0m [37m    "wm"[0m
[38;5;8m 112[0m [37m    "awesome"[0m
[38;5;8m 113[0m [37m  ] cfg config;[0m
[38;5;8m 114[0m [37min[0m
[38;5;8m 115[0m [37m{[0m
[38;5;8m 116[0m [37m  config = mkIf (cfg.enable && shouldTheme) {[0m
[38;5;8m 117[0m [37m    xdg.configFile."awesome/signal-theme.lua".text = awesomeTheme;[0m
[38;5;8m 118[0m 
[38;5;8m 119[0m [37m    # Provide helper instructions via a README[0m
[38;5;8m 120[0m [37m    xdg.configFile."awesome/SIGNAL_THEME_README.txt".text = ''[0m
[38;5;8m 121[0m [37m      Signal Theme for Awesome WM - COLORS ONLY[0m
[38;5;8m 122[0m 
[38;5;8m 123[0m [37m      To use this theme, add this line to your rc.lua:[0m
[38;5;8m 124[0m 
[38;5;8m 125[0m [37m        beautiful.init(gears.filesystem.get_configuration_dir() .. "signal-theme.lua")[0m
[38;5;8m 126[0m 
[38;5;8m 127[0m [37m      Replace any existing beautiful.init() call with the above line.[0m
[38;5;8m 128[0m 
[38;5;8m 129[0m [37m      The theme provides ONLY colors. You must configure:[0m
[38;5;8m 130[0m [37m      - border_width, useless_gap[0m
[38;5;8m 131[0m [37m      - fonts (theme.font, theme.hotkeys_font, etc.)[0m
[38;5;8m 132[0m [37m      - menu dimensions (menu_height, menu_width)[0m
[38;5;8m 133[0m [37m      - notification sizes (notification_width, etc.)[0m
[38;5;8m 134[0m [37m      - Other layout/sizing properties[0m
[38;5;8m 135[0m 
[38;5;8m 136[0m [37m      Example additions to your rc.lua after beautiful.init():[0m
[38;5;8m 137[0m [37m        beautiful.border_width = 2[0m
[38;5;8m 138[0m [37m        beautiful.useless_gap = 8[0m
[38;5;8m 139[0m [37m        beautiful.font = "Inter 12"[0m
[38;5;8m 140[0m [37m        beautiful.hotkeys_font = "Inter 12"[0m
[38;5;8m 141[0m [37m        beautiful.hotkeys_description_font = "Inter 10"[0m
[38;5;8m 142[0m [37m        beautiful.menu_height = 24[0m
[38;5;8m 143[0m [37m        beautiful.menu_width = 200[0m
[38;5;8m 144[0m [37m    '';[0m
[38;5;8m 145[0m [37m  };[0m
[38;5;8m 146[0m [37m}[0m
