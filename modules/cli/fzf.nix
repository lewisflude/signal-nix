{
  config,
  lib,
  signalColors,
  ...
}:
let
  inherit (lib) mkIf mkAfter mapAttrsToList;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-subtle = signalColors.tonal."divider-Lc15";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
  };

  inherit (signalColors) accent;

  # Define color mappings once
  colorMap = {
    fg = colors.text-primary.hex;
    bg = colors.surface-base.hex;
    hl = accent.focus.Lc75.hex;
    "fg+" = colors.text-primary.hex;
    "bg+" = colors.surface-subtle.hex;
    "hl+" = accent.focus.Lc75.hex;
    info = accent.info.Lc75.hex;
    prompt = accent.focus.Lc75.hex;
    pointer = accent.focus.Lc75.hex;
    marker = accent.success.Lc75.hex;
    spinner = accent.info.Lc75.hex;
    header = colors.text-secondary.hex;
  };

  # fzf requires hex colors WITH # prefix in --color options
  # Home Manager's programs.fzf.colors strips the # prefix, which causes errors
  # Solution: Use defaultOptions to set colors directly with # prefix preserved
  fzfColorOptions = mapAttrsToList (key: value: "--color=${key}:${value}") colorMap;

  # Check if fzf should be themed
  shouldTheme = cfg.cli.fzf.enable || (cfg.autoEnable && (config.programs.fzf.enable or false));
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    # Use defaultOptions to preserve # prefix (programs.fzf.colors strips it)
    programs.fzf.defaultOptions = mkAfter fzfColorOptions;
  };
}
