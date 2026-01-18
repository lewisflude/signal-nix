{
  config,
  lib,
  signalLib,
  ...
}:
let
  inherit (lib) mkIf removePrefix;
  cfg = config.theming.signal.nixos;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  inherit (signalColors) accent;

  # Helper to get hex without # prefix (console.colors requires no #)
  hexRaw = color: removePrefix "#" color.hex;

  # ANSI color mapping - matches terminal modules for consistency
  # console.colors expects an array of 16 hex colors (without #)
  ansiColors = [
    # Normal colors (0-7)
    (hexRaw signalColors.tonal."black") # 0: black
    (hexRaw accent.danger.Lc75) # 1: red
    (hexRaw accent.primary.Lc75) # 2: green
    (hexRaw accent.warning.Lc75) # 3: yellow
    (hexRaw accent.secondary.Lc75) # 4: blue
    (hexRaw accent.tertiary.Lc75) # 5: magenta
    (hexRaw accent.info.Lc75) # 6: cyan
    (hexRaw signalColors.tonal."text-secondary") # 7: white

    # Bright colors (8-15)
    (hexRaw signalColors.tonal."text-tertiary") # 8: bright black
    (hexRaw accent.danger.Lc75) # 9: bright red
    (hexRaw accent.primary.Lc75) # 10: bright green
    (hexRaw accent.warning.Lc75) # 11: bright yellow
    (hexRaw accent.secondary.Lc75) # 12: bright blue
    (hexRaw accent.tertiary.Lc75) # 13: bright magenta
    (hexRaw accent.info.Lc75) # 14: bright cyan
    (hexRaw signalColors.tonal."text-primary") # 15: bright white
  ];

  # Determine if console should be themed
  shouldTheme = cfg.enable && cfg.boot.console.enable;
in
{
  config = mkIf shouldTheme {
    # Apply Signal ANSI colors to virtual console (TTY)
    # These colors appear in:
    # - Virtual terminals (Ctrl+Alt+F1-F6)
    # - Emergency/recovery mode
    # - Boot messages (before display manager)
    console.colors = ansiColors;
  };
}
