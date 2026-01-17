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
    text-primary = signalColors.tonal."text-Lc75";
    text-dim = signalColors.tonal."text-Lc45";
  };

  inherit (signalColors) accent;

  # Convert hex to ANSI escape sequence
  toAnsiEscape =
    color:
    let
      hex = lib.removePrefix "#" color.hex;
      r = lib.toInt "0x${builtins.substring 0 2 hex}";
      g = lib.toInt "0x${builtins.substring 2 2 hex}";
      b = lib.toInt "0x${builtins.substring 4 2 hex}";
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
      LESS_TERMCAP_md = toAnsiEscape accent.focus.Lc75; # begin bold
      LESS_TERMCAP_me = "\\e[0m"; # end mode
      LESS_TERMCAP_so = toAnsiEscape accent.warning.Lc75; # begin standout-mode (search highlights)
      LESS_TERMCAP_se = "\\e[0m"; # end standout-mode
      LESS_TERMCAP_us = toAnsiEscape accent.success.Lc75; # begin underline
      LESS_TERMCAP_ue = "\\e[0m"; # end underline

      # Additional less settings
      LESS = "-R"; # Enable raw control characters for color
    };
  };
}
