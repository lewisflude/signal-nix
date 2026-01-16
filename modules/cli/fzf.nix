{
  config,
  lib,
  signalColors,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkAfter;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-subtle = signalColors.tonal."divider-Lc15";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
  };

  accent = signalColors.accent;

  # fzf requires hex colors WITH # prefix in --color options
  # Home Manager's programs.fzf.colors strips the # prefix, which causes errors
  # Solution: Use defaultOptions to set colors directly with # prefix
  fzfColorOptions = [
    "--color=fg:${colors.text-primary.hex}"
    "--color=bg:${colors.surface-base.hex}"
    "--color=hl:${accent.focus.Lc75.hex}"
    "--color=fg+:${colors.text-primary.hex}"
    "--color=bg+:${colors.surface-subtle.hex}"
    "--color=hl+:${accent.focus.Lc75.hex}"
    "--color=info:${accent.info.Lc75.hex}"
    "--color=prompt:${accent.focus.Lc75.hex}"
    "--color=pointer:${accent.focus.Lc75.hex}"
    "--color=marker:${accent.success.Lc75.hex}"
    "--color=spinner:${accent.info.Lc75.hex}"
    "--color=header:${colors.text-secondary.hex}"
  ];
in
{
  config = mkIf (cfg.enable && cfg.cli.fzf.enable) (mkMerge [
    {
      # Set colors via defaultOptions to ensure # prefix is preserved
      programs.fzf.defaultOptions = mkAfter fzfColorOptions;
    }
    {
      # Also set programs.fzf.colors for consistency
      programs.fzf.colors = {
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
    }
  ]);
}
