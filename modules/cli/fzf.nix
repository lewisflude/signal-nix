{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: programs.fzf.defaultOptions
# UPSTREAM SCHEMA: https://github.com/junegunn/fzf#color-configuration
# SCHEMA VERSION: 0.47.0
# LAST VALIDATED: 2026-01-17
# NOTES: FZF colors require --color flags with # prefix. Home-Manager's
#        programs.fzf.colors strips the # prefix, causing errors. We use
#        defaultOptions to preserve the # prefix in color values.
let
  inherit (lib) mkIf mkAfter mapAttrsToList;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-subtle = signalColors.tonal."divider-primary";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
  };

  inherit (signalColors) accent;

  # Define color mappings once
  colorMap = {
    fg = colors.text-primary.hex;
    bg = colors.surface-base.hex;
    hl = accent.secondary.Lc75.hex;
    "fg+" = colors.text-primary.hex;
    "bg+" = colors.surface-subtle.hex;
    "hl+" = accent.secondary.Lc75.hex;
    info = accent.secondary.Lc75.hex;
    prompt = accent.secondary.Lc75.hex;
    pointer = accent.secondary.Lc75.hex;
    marker = accent.primary.Lc75.hex;
    spinner = accent.secondary.Lc75.hex;
    header = colors.text-secondary.hex;
  };

  # fzf requires hex colors WITH # prefix in --color options
  # Home Manager's programs.fzf.colors strips the # prefix, which causes errors
  # Solution: Use defaultOptions to set colors directly with # prefix preserved
  fzfColorOptions = mapAttrsToList (key: value: "--color=${key}:${value}") colorMap;

  # Check if fzf should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "fzf" [
    "cli"
    "fzf"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    # Use defaultOptions to preserve # prefix (programs.fzf.colors strips it)
    programs.fzf.defaultOptions = mkAfter fzfColorOptions;
  };
}
