     [1mSTDIN[0m
[38;5;8m   1[0m [37m{[0m
[38;5;8m   2[0m [37m  config,[0m
[38;5;8m   3[0m [37m  lib,[0m
[38;5;8m   4[0m [37m  signalColors,[0m
[38;5;8m   5[0m [37m  signalLib,[0m
[38;5;8m   6[0m [37m  ...[0m
[38;5;8m   7[0m [37m}:[0m
[38;5;8m   8[0m [37m# CONFIGURATION METHOD: freeform-settings (Tier 3)[0m
[38;5;8m   9[0m [37m# HOME-MANAGER MODULE: services.dunst.settings[0m
[38;5;8m  10[0m [37m# UPSTREAM SCHEMA: https://dunst-project.org/documentation/[0m
[38;5;8m  11[0m [37m# SCHEMA VERSION: 1.11.0[0m
[38;5;8m  12[0m [37m# LAST VALIDATED: 2026-01-17[0m
[38;5;8m  13[0m [37m# NOTES: Dunst uses an INI-style config format. Home Manager provides a settings[0m
[38;5;8m  14[0m [37m#        attrset that gets serialized to dunstrc. We theme ONLY colors.[0m
[38;5;8m  15[0m [37m#        Users configure fonts, frame_width, timeouts, etc. in their own config.[0m
[38;5;8m  16[0m [37mlet[0m
[38;5;8m  17[0m [37m  inherit (lib) mkIf;[0m
[38;5;8m  18[0m [37m  cfg = config.theming.signal;[0m
[38;5;8m  19[0m 
[38;5;8m  20[0m [37m  colors = {[0m
[38;5;8m  21[0m [37m    surface-base = signalColors.tonal."surface-Lc05";[0m
[38;5;8m  22[0m [37m    surface-raised = signalColors.tonal."surface-Lc10";[0m
[38;5;8m  23[0m [37m    text-primary = signalColors.tonal."text-Lc75";[0m
[38;5;8m  24[0m [37m    text-secondary = signalColors.tonal."text-Lc60";[0m
[38;5;8m  25[0m [37m    divider-primary = signalColors.tonal."divider-Lc15";[0m
[38;5;8m  26[0m [37m  };[0m
[38;5;8m  27[0m 
[38;5;8m  28[0m [37m  inherit (signalColors) accent;[0m
[38;5;8m  29[0m 
[38;5;8m  30[0m [37m  # Check if dunst should be themed[0m
[38;5;8m  31[0m [37m  shouldTheme = signalLib.shouldThemeApp "dunst" [[0m
[38;5;8m  32[0m [37m    "desktop"[0m
[38;5;8m  33[0m [37m    "notifications"[0m
[38;5;8m  34[0m [37m    "dunst"[0m
[38;5;8m  35[0m [37m  ] cfg config;[0m
[38;5;8m  36[0m [37min[0m
[38;5;8m  37[0m [37m{[0m
[38;5;8m  38[0m [37m  config = mkIf (cfg.enable && shouldTheme) {[0m
[38;5;8m  39[0m [37m    services.dunst.settings = {[0m
[38;5;8m  40[0m [37m      global = {[0m
[38;5;8m  41[0m [37m        # Frame (border) color - ONLY COLOR[0m
[38;5;8m  42[0m [37m        frame_color = accent.focus.Lc75.hex;[0m
[38;5;8m  43[0m 
[38;5;8m  44[0m [37m        # Separator between notifications color[0m
[38;5;8m  45[0m [37m        separator_color = "frame";[0m
[38;5;8m  46[0m [37m      };[0m
[38;5;8m  47[0m 
[38;5;8m  48[0m [37m      # Low urgency notifications (informational) - ONLY COLORS[0m
[38;5;8m  49[0m [37m      urgency_low = {[0m
[38;5;8m  50[0m [37m        background = colors.surface-base.hex;[0m
[38;5;8m  51[0m [37m        foreground = colors.text-secondary.hex;[0m
[38;5;8m  52[0m [37m        frame_color = accent.info.Lc75.hex;[0m
[38;5;8m  53[0m [37m      };[0m
[38;5;8m  54[0m 
[38;5;8m  55[0m [37m      # Normal urgency notifications (default) - ONLY COLORS[0m
[38;5;8m  56[0m [37m      urgency_normal = {[0m
[38;5;8m  57[0m [37m        background = colors.surface-raised.hex;[0m
[38;5;8m  58[0m [37m        foreground = colors.text-primary.hex;[0m
[38;5;8m  59[0m [37m        frame_color = accent.focus.Lc75.hex;[0m
[38;5;8m  60[0m [37m      };[0m
[38;5;8m  61[0m 
[38;5;8m  62[0m [37m      # Critical urgency notifications (important) - ONLY COLORS[0m
[38;5;8m  63[0m [37m      urgency_critical = {[0m
[38;5;8m  64[0m [37m        background = accent.danger.Lc75.hex;[0m
[38;5;8m  65[0m [37m        foreground = colors.surface-base.hex;[0m
[38;5;8m  66[0m [37m        frame_color = accent.danger.Lc75.hex;[0m
[38;5;8m  67[0m [37m      };[0m
[38;5;8m  68[0m [37m    };[0m
[38;5;8m  69[0m [37m  };[0m
[38;5;8m  70[0m [37m}[0m
