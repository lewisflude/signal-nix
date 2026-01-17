{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: environment-variables (Tier 5)
# HOME-MANAGER MODULE: home.sessionVariables
# UPSTREAM SCHEMA: https://www.greenwoodsoftware.com/less/
# SCHEMA VERSION: 643
# LAST VALIDATED: 2026-01-17
# NOTES: Less uses LESS_TERMCAP_* environment variables for colors.
#        These are typically used for man pages. We set them via sessionVariables.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    text-primary = signalColors.tonal."text-primary";
    text-dim = signalColors.tonal."text-tertiary";
  };

  inherit (signalColors) accent;

  # Convert a hex digit to decimal (0-15)
  hexDigitToInt = c:
    let
      lowerC = lib.toLower c;
    in
    if lowerC == "0" then 0
    else if lowerC == "1" then 1
    else if lowerC == "2" then 2
    else if lowerC == "3" then 3
    else if lowerC == "4" then 4
    else if lowerC == "5" then 5
    else if lowerC == "6" then 6
    else if lowerC == "7" then 7
    else if lowerC == "8" then 8
    else if lowerC == "9" then 9
    else if lowerC == "a" then 10
    else if lowerC == "b" then 11
    else if lowerC == "c" then 12
    else if lowerC == "d" then 13
    else if lowerC == "e" then 14
    else if lowerC == "f" then 15
    else throw "Invalid hex digit: ${c}";

  # Convert a 2-character hex string to decimal (0-255)
  hexPairToInt = pair:
    let
      first = hexDigitToInt (builtins.substring 0 1 pair);
      second = hexDigitToInt (builtins.substring 1 1 pair);
    in
    first * 16 + second;

  # Convert hex to ANSI escape sequence
  toAnsiEscape =
    color:
    let
      hex = lib.removePrefix "#" color.hex;
      r = hexPairToInt (builtins.substring 0 2 hex);
      g = hexPairToInt (builtins.substring 2 2 hex);
      b = hexPairToInt (builtins.substring 4 2 hex);
    in
    "\\e[38;2;${toString r};${toString g};${toString b}m";

  # Check if less should be themed
  # Note: less doesn't have programs.less, so we check if user wants CLI tools themed
  shouldTheme = cfg.cli.less.enable or false || cfg.autoEnable;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    home.sessionVariables = {
      # Less colors for man pages and scrolling
      LESS_TERMCAP_mb = toAnsiEscape accent.danger.Lc75; # begin blinking
      LESS_TERMCAP_md = toAnsiEscape accent.secondary.Lc75; # begin bold
      LESS_TERMCAP_me = "\\e[0m"; # end mode
      LESS_TERMCAP_so = toAnsiEscape accent.warning.Lc75; # begin standout-mode (search highlights)
      LESS_TERMCAP_se = "\\e[0m"; # end standout-mode
      LESS_TERMCAP_us = toAnsiEscape accent.primary.Lc75; # begin underline
      LESS_TERMCAP_ue = "\\e[0m"; # end underline

      # Additional less settings
      LESS = "-R"; # Enable raw control characters for color
    };
  };
}
