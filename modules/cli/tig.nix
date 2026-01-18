{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: xdg.configFile (programs.tig doesn't exist)
# UPSTREAM SCHEMA: https://github.com/jonas/tig
# SCHEMA VERSION: 2.5.8
# LAST VALIDATED: 2026-01-17
# NOTES: tig uses custom config format stored in ~/.config/tig/config.
#        home-manager doesn't have a programs.tig module, so we use xdg.configFile.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-dim = signalColors.tonal."text-tertiary";
    divider = signalColors.tonal."divider-primary";
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
    color cursor         ${colors.surface-base.hex} ${accent.secondary.Lc75.hex} bold
    color title-focus    ${colors.text-primary.hex} ${colors.surface-base.hex} bold
    color title-blur     ${colors.text-secondary.hex} ${colors.surface-base.hex}

    # Line numbers
    color line-number    ${colors.text-dim.hex} ${colors.surface-base.hex}

    # Diff colors
    color diff-header    ${accent.secondary.Lc75.hex} ${colors.surface-base.hex} bold
    color diff-index     ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}
    color diff-chunk     ${accent.secondary.Lc75.hex} ${colors.surface-base.hex} bold
    color diff-add       ${accent.primary.Lc75.hex} ${colors.surface-base.hex}
    color diff-del       ${accent.danger.Lc75.hex} ${colors.surface-base.hex}
    color diff-oldmode   ${accent.warning.Lc75.hex} ${colors.surface-base.hex}
    color diff-newmode   ${accent.warning.Lc75.hex} ${colors.surface-base.hex}
    color diff-copy-from ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}
    color diff-copy-to   ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}
    color diff-rename-from ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}
    color diff-rename-to ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}
    color diff-similarity ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}

    # Status
    color status         ${colors.text-primary.hex} ${colors.surface-base.hex}
    color stat-staged    ${accent.primary.Lc75.hex} ${colors.surface-base.hex}
    color stat-unstaged  ${accent.warning.Lc75.hex} ${colors.surface-base.hex}
    color stat-untracked ${accent.danger.Lc75.hex} ${colors.surface-base.hex}

    # Main view
    color main-commit    ${colors.text-primary.hex} ${colors.surface-base.hex}
    color main-tag       ${accent.warning.Lc75.hex} ${colors.surface-base.hex} bold
    color main-local-tag ${accent.warning.Lc75.hex} ${colors.surface-base.hex}
    color main-remote    ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}
    color main-tracked   ${accent.primary.Lc75.hex} ${colors.surface-base.hex}
    color main-ref       ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}
    color main-head      ${accent.secondary.Lc75.hex} ${colors.surface-base.hex} bold

    # Tree view
    color tree.directory ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}

    # Author colors
    color author         ${accent.tertiary.Lc75.hex} ${colors.surface-base.hex}

    # Commit message
    color commit         ${colors.text-primary.hex} ${colors.surface-base.hex}

    # Dates
    color date           ${colors.text-secondary.hex} ${colors.surface-base.hex}

    # Graph
    color graph-commit   ${accent.secondary.Lc75.hex} ${colors.surface-base.hex}
  '';

  # Check if tig should be themed
  shouldTheme = cfg.cli.tig.enable or false || cfg.autoEnable;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    # tig configuration is stored in ~/.config/tig/config
    # home-manager doesn't have a programs.tig module, so we use xdg.configFile
    xdg.configFile."tig/config".text = tigConfig;
  };
}
