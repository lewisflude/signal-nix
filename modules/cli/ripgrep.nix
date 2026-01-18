{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: environment-variables (Tier 5)
# HOME-MANAGER MODULE: home.sessionVariables
# UPSTREAM SCHEMA: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#colors
# SCHEMA VERSION: 14.1.0
# LAST VALIDATED: 2026-01-17
# NOTES: Ripgrep uses RIPGREP_CONFIG_PATH or command-line flags for colors.
#        We use environment variables for color configuration via RIPGREP_COLORS.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-dim = signalColors.tonal."text-tertiary";
  };

  inherit (signalColors) accent;

  # Convert a hex digit to decimal (0-15)
  hexDigitToInt =
    c:
    let
      lowerC = lib.toLower c;
    in
    if lowerC == "0" then
      0
    else if lowerC == "1" then
      1
    else if lowerC == "2" then
      2
    else if lowerC == "3" then
      3
    else if lowerC == "4" then
      4
    else if lowerC == "5" then
      5
    else if lowerC == "6" then
      6
    else if lowerC == "7" then
      7
    else if lowerC == "8" then
      8
    else if lowerC == "9" then
      9
    else if lowerC == "a" then
      10
    else if lowerC == "b" then
      11
    else if lowerC == "c" then
      12
    else if lowerC == "d" then
      13
    else if lowerC == "e" then
      14
    else if lowerC == "f" then
      15
    else
      throw "Invalid hex digit: ${c}";

  # Convert a 2-character hex string to decimal (0-255)
  hexPairToInt =
    pair:
    let
      first = hexDigitToInt (builtins.substring 0 1 pair);
      second = hexDigitToInt (builtins.substring 1 1 pair);
    in
    first * 16 + second;

  # Convert hex to RGB triplet for ripgrep (format: R,G,B)
  toRgbTriplet =
    color:
    let
      hex = lib.removePrefix "#" color.hex;
      r = hexPairToInt (builtins.substring 0 2 hex);
      g = hexPairToInt (builtins.substring 2 2 hex);
      b = hexPairToInt (builtins.substring 4 2 hex);
    in
    "${toString r},${toString g},${toString b}";

  # Check if ripgrep should be themed
  shouldTheme = cfg.cli.ripgrep.enable or false || cfg.autoEnable;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    home.sessionVariables = {
      # Ripgrep color configuration
      # Format: type:style:foreground:background:intense
      # We use fg: for foreground RGB colors
      RIPGREP_COLORS = lib.concatStringsSep ":" [
        "match:fg:${toRgbTriplet accent.secondary.Lc75}" # Matched text
        "match:style:bold" # Make matches bold
        "path:fg:${toRgbTriplet accent.secondary.Lc75}" # File paths
        "line:fg:${toRgbTriplet accent.primary.Lc75}" # Line numbers
        "column:fg:${toRgbTriplet colors.text-secondary}" # Column numbers
      ];
    };

    # Also set ripgrep to use colors by default
    home.shellAliases = mkIf shouldTheme {
      rg = "rg --color=auto";
    };
  };
}
