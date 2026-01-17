{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
let
  inherit (lib) mkIf removePrefix;
  cfg = config.theming.signal.nixos;

  inherit (signalColors) accent;

  # Helper to get hex without # prefix (console.colors requires no #)
  hexRaw = color: removePrefix "#" color.hex;

  # ANSI color mapping - matches terminal modules for consistency
  # console.colors expects an array of 16 hex colors (without #)
  ansiColors = [
    # Normal colors (0-7)
    (hexRaw signalColors.tonal."base-L015") # 0: black
    (hexRaw accent.danger.Lc75) # 1: red
    (hexRaw accent.success.Lc75) # 2: green
    (hexRaw accent.warning.Lc75) # 3: yellow
    (hexRaw accent.focus.Lc75) # 4: blue
    (hexRaw accent.special.Lc75) # 5: magenta
    (hexRaw accent.info.Lc75) # 6: cyan
    (hexRaw signalColors.tonal."text-Lc60") # 7: white

    # Bright colors (8-15)
    (hexRaw signalColors.tonal."text-Lc45") # 8: bright black
    (hexRaw accent.danger.Lc75) # 9: bright red
    (hexRaw accent.success.Lc75) # 10: bright green
    (hexRaw accent.warning.Lc75) # 11: bright yellow
    (hexRaw accent.focus.Lc75) # 12: bright blue
    (hexRaw accent.special.Lc75) # 13: bright magenta
    (hexRaw accent.info.Lc75) # 14: bright cyan
    (hexRaw signalColors.tonal."text-Lc75") # 15: bright white
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
