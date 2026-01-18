{
  config,
  lib,

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
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    text-primary = signalColors.tonal."text-primary";
    text-dim = signalColors.tonal."text-tertiary";
  };

  inherit (signalColors) accent;

  # Helper to convert hex color to ANSI escape sequence
  # Uses signalLib's RGB conversion which leverages nix-colorizer
  toAnsiEscape =
    color:
    let
      rgb = signalLib.hexToRgbSpaceSeparated color;
      parts = lib.splitString " " rgb;
    in
    "\\e[38;2;${lib.concatStringsSep ";" parts}m";

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
