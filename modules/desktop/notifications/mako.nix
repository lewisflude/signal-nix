     [1mSTDIN[0m
[38;5;8m   1[0m [37m{[0m
[38;5;8m   2[0m [37m  config,[0m
[38;5;8m   3[0m [37m  lib,[0m
[38;5;8m   4[0m [37m  signalColors,[0m
[38;5;8m   5[0m [37m  signalLib,[0m
[38;5;8m   6[0m [37m  ...[0m
[38;5;8m   7[0m [37m}:[0m
[38;5;8m   8[0m [37m# CONFIGURATION METHOD: freeform-settings (Tier 3)[0m
[38;5;8m   9[0m [37m# HOME-MANAGER MODULE: services.mako (via programs.mako in newer HM)[0m
[38;5;8m  10[0m [37m# UPSTREAM SCHEMA: https://github.com/emersion/mako[0m
[38;5;8m  11[0m [37m# SCHEMA VERSION: 1.8.0[0m
[38;5;8m  12[0m [37m# LAST VALIDATED: 2026-01-17[0m
[38;5;8m  13[0m [37m# NOTES: mako uses INI-like config. Home-Manager provides extraConfig or[0m
[38;5;8m  14[0m [37m#        direct configuration options.[0m
[38;5;8m  15[0m [37m#        Signal ONLY sets colors - users configure fonts, spacing, timeouts, etc.[0m
[38;5;8m  16[0m [37mlet[0m
[38;5;8m  17[0m [37m  inherit (lib) mkIf;[0m
[38;5;8m  18[0m [37m  cfg = config.theming.signal;[0m
[38;5;8m  19[0m 
[38;5;8m  20[0m [37m  colors = {[0m
[38;5;8m  21[0m [37m    surface-base = signalColors.tonal."surface-Lc05";[0m
[38;5;8m  22[0m [37m    surface-raised = signalColors.tonal."surface-Lc10";[0m
[38;5;8m  23[0m [37m    text-primary = signalColors.tonal."text-Lc75";[0m
[38;5;8m  24[0m [37m    text-secondary = signalColors.tonal."text-Lc60";[0m
[38;5;8m  25[0m [37m    divider = signalColors.tonal."divider-Lc15";[0m
[38;5;8m  26[0m [37m  };[0m
[38;5;8m  27[0m 
[38;5;8m  28[0m [37m  inherit (signalColors) accent;[0m
[38;5;8m  29[0m 
[38;5;8m  30[0m [37m  # mako uses hex colors without #[0m
[38;5;8m  31[0m [37m  toMakoColor = color: lib.removePrefix "#" color.hex;[0m
[38;5;8m  32[0m 
[38;5;8m  33[0m [37m  # Generate mako config - COLORS ONLY[0m
[38;5;8m  34[0m [37m  makoConfig = ''[0m
[38;5;8m  35[0m [37m    # Signal theme for mako - COLORS ONLY[0m
[38;5;8m  36[0m [37m    # Configure fonts, spacing, timeouts, etc. in your own mako config[0m
[38;5;8m  37[0m 
[38;5;8m  38[0m [37m    # Default notification colors[0m
[38;5;8m  39[0m [37m    background-color=${toMakoColor colors.surface-raised}[0m
[38;5;8m  40[0m [37m    text-color=${toMakoColor colors.text-primary}[0m
[38;5;8m  41[0m [37m    border-color=${toMakoColor colors.divider}[0m
[38;5;8m  42[0m 
[38;5;8m  43[0m [37m    # Progress bar color[0m
[38;5;8m  44[0m [37m    progress-color=${toMakoColor accent.focus.Lc75}[0m
[38;5;8m  45[0m 
[38;5;8m  46[0m [37m    # Low urgency colors[0m
[38;5;8m  47[0m [37m    [urgency=low][0m
[38;5;8m  48[0m [37m    background-color=${toMakoColor colors.surface-raised}[0m
[38;5;8m  49[0m [37m    border-color=${toMakoColor accent.info.Lc75}[0m
[38;5;8m  50[0m [37m    text-color=${toMakoColor colors.text-secondary}[0m
[38;5;8m  51[0m 
[38;5;8m  52[0m [37m    # Normal urgency colors[0m
[38;5;8m  53[0m [37m    [urgency=normal][0m
[38;5;8m  54[0m [37m    background-color=${toMakoColor colors.surface-raised}[0m
[38;5;8m  55[0m [37m    border-color=${toMakoColor accent.focus.Lc75}[0m
[38;5;8m  56[0m [37m    text-color=${toMakoColor colors.text-primary}[0m
[38;5;8m  57[0m 
[38;5;8m  58[0m [37m    # Critical urgency colors[0m
[38;5;8m  59[0m [37m    [urgency=critical][0m
[38;5;8m  60[0m [37m    background-color=${toMakoColor colors.surface-raised}[0m
[38;5;8m  61[0m [37m    border-color=${toMakoColor accent.danger.Lc75}[0m
[38;5;8m  62[0m [37m    text-color=${toMakoColor colors.text-primary}[0m
[38;5;8m  63[0m [37m  '';[0m
[38;5;8m  64[0m 
[38;5;8m  65[0m [37m  # Check if mako should be themed[0m
[38;5;8m  66[0m [37m  shouldTheme = signalLib.shouldThemeApp "mako" [[0m
[38;5;8m  67[0m [37m    "desktop"[0m
[38;5;8m  68[0m [37m    "notifications"[0m
[38;5;8m  69[0m [37m    "mako"[0m
[38;5;8m  70[0m [37m  ] cfg config;[0m
[38;5;8m  71[0m [37min[0m
[38;5;8m  72[0m [37m{[0m
[38;5;8m  73[0m [37m  config = mkIf (cfg.enable && shouldTheme) {[0m
[38;5;8m  74[0m [37m    # mako can be configured via services.mako or programs.mako[0m
[38;5;8m  75[0m [37m    # We use xdg.configFile for maximum compatibility[0m
[38;5;8m  76[0m [37m    xdg.configFile."mako/config".text = makoConfig;[0m
[38;5;8m  77[0m [37m  };[0m
[38;5;8m  78[0m [37m}[0m
