{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: programs.tig.extraConfig
# UPSTREAM SCHEMA: https://github.com/jonas/tig
# SCHEMA VERSION: 2.5.8
# LAST VALIDATED: 2026-01-17
# NOTES: tig uses custom config format. Home-Manager provides settings and
#        extraConfig. We use extraConfig for color definitions.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-dim = signalColors.tonal."text-Lc45";
    divider = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # tig uses color names or 'color<N>' or '#RRGGBB'
  # It also uses terminal color names: black, red, green, yellow, blue, magenta, cyan, white
  # We'll use hex colors for precision

  # Generate tig color config
  tigConfig = ''
    # Signal theme for tig

    # General UI
    color default        ${colors.text-primary.hex} ${colors.surface-base.hex}
    color cursor         ${colors.surface-base.hex} ${accent.focus.Lc75.hex} bold
    color title-focus    ${colors.text-primary.hex} ${colors.surface-base.hex} bold
    color title-blur     ${colors.text-secondary.hex} ${colors.surface-base.hex}

    # Line numbers
    color line-number    ${colors.text-dim.hex} ${colors.surface-base.hex}

    # Diff colors
    color diff-header    ${accent.info.Lc75.hex} ${colors.surface-base.hex} bold
    color diff-index     ${accent.info.Lc75.hex} ${colors.surface-base.hex}
    color diff-chunk     ${accent.focus.Lc75.hex} ${colors.surface-base.hex} bold
    color diff-add       ${accent.success.Lc75.hex} ${colors.surface-base.hex}
    color diff-del       ${accent.danger.Lc75.hex} ${colors.surface-base.hex}
    color diff-oldmode   ${accent.warning.Lc75.hex} ${colors.surface-base.hex}
    color diff-newmode   ${accent.warning.Lc75.hex} ${colors.surface-base.hex}
    color diff-copy-from ${accent.info.Lc75.hex} ${colors.surface-base.hex}
    color diff-copy-to   ${accent.info.Lc75.hex} ${colors.surface-base.hex}
    color diff-rename-from ${accent.info.Lc75.hex} ${colors.surface-base.hex}
    color diff-rename-to ${accent.info.Lc75.hex} ${colors.surface-base.hex}
    color diff-similarity ${accent.info.Lc75.hex} ${colors.surface-base.hex}

    # Status
    color status         ${colors.text-primary.hex} ${colors.surface-base.hex}
    color stat-staged    ${accent.success.Lc75.hex} ${colors.surface-base.hex}
    color stat-unstaged  ${accent.warning.Lc75.hex} ${colors.surface-base.hex}
    color stat-untracked ${accent.danger.Lc75.hex} ${colors.surface-base.hex}

    # Main view
    color main-commit    ${colors.text-primary.hex} ${colors.surface-base.hex}
    color main-tag       ${accent.warning.Lc75.hex} ${colors.surface-base.hex} bold
    color main-local-tag ${accent.warning.Lc75.hex} ${colors.surface-base.hex}
    color main-remote    ${accent.info.Lc75.hex} ${colors.surface-base.hex}
    color main-tracked   ${accent.success.Lc75.hex} ${colors.surface-base.hex}
    color main-ref       ${accent.focus.Lc75.hex} ${colors.surface-base.hex}
    color main-head      ${accent.focus.Lc75.hex} ${colors.surface-base.hex} bold

    # Tree view
    color tree.directory ${accent.focus.Lc75.hex} ${colors.surface-base.hex}

    # Author colors
    color author         ${accent.special.Lc75.hex} ${colors.surface-base.hex}

    # Commit message
    color commit         ${colors.text-primary.hex} ${colors.surface-base.hex}

    # Dates
    color date           ${colors.text-secondary.hex} ${colors.surface-base.hex}

    # Graph
    color graph-commit   ${accent.focus.Lc75.hex} ${colors.surface-base.hex}
  '';

  # Check if tig should be themed
  shouldTheme = cfg.cli.tig.enable or false || cfg.autoEnable;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.tig.extraConfig = tigConfig;
  };
}
