# Signal Delta Theme Module
#
# This module ONLY applies Signal colors to delta.
# It assumes you have already enabled delta with:
#   programs.delta.enable = true;
#
# The module will not install delta or configure its functional behavior.
{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: programs.delta.options
# UPSTREAM SCHEMA: https://dandavison.github.io/delta/configuration.html
# SCHEMA VERSION: 0.16.5
# LAST VALIDATED: 2026-01-17
# NOTES: Home-Manager provides freeform options attrset that serializes to gitconfig
#        format. All option names must match delta's configuration schema exactly.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  # Define color mappings for both dark and light modes
  deltaColors =
    if signalLib.resolveThemeMode cfg.mode == "dark" then
      {
        # Dark mode colors
        # Use Lc60 for emphasis backgrounds
        minus-style = "syntax ${signalColors.tonal."surface-hover".hex}";
        minus-emph-style = "syntax ${signalColors.accent.danger.Lc60.hex}";
        minus-non-emph-style = "syntax ${signalColors.tonal."surface-hover".hex}";
        plus-style = "syntax ${signalColors.tonal."surface-hover".hex}";
        plus-emph-style = "syntax ${signalColors.accent.primary.Lc60.hex}";
        plus-non-emph-style = "syntax ${signalColors.tonal."surface-hover".hex}";

        # Line numbers
        line-numbers-minus-style = signalColors.accent.danger.Lc75.hex;
        line-numbers-plus-style = signalColors.accent.primary.Lc75.hex;
        line-numbers-zero-style = signalColors.tonal."text-tertiary".hex;
        line-numbers-left-style = signalColors.tonal."text-tertiary".hex;
        line-numbers-right-style = signalColors.tonal."text-tertiary".hex;

        # File decoration
        file-style = signalColors.accent.secondary.Lc75.hex;
        file-decoration-style = "${signalColors.accent.secondary.Lc75.hex} ul";

        # Commit decoration
        commit-decoration-style = "${signalColors.accent.tertiary.Lc75.hex} box";
        commit-style = signalColors.accent.tertiary.Lc75.hex;

        # Hunk header
        hunk-header-style = "syntax ${signalColors.tonal."divider-primary".hex}";
        hunk-header-decoration-style = "${signalColors.accent.secondary.Lc75.hex} box";
        hunk-header-file-style = signalColors.accent.secondary.Lc75.hex;
        hunk-header-line-number-style = signalColors.tonal."text-secondary".hex;

        # Blame
        blame-palette = "${signalColors.categorical."data-viz-01".hex} ${
          signalColors.categorical."data-viz-02".hex
        } ${signalColors.categorical."data-viz-03".hex} ${signalColors.categorical."data-viz-04".hex} ${
          signalColors.categorical."data-viz-05".hex
        } ${signalColors.categorical."data-viz-06".hex}";

        # Merge conflict
        merge-conflict-begin-symbol = "▼";
        merge-conflict-end-symbol = "▲";
        merge-conflict-ours-diff-header-style = "${signalColors.accent.warning.Lc75.hex} bold";
        merge-conflict-theirs-diff-header-style = "${signalColors.accent.secondary.Lc75.hex} bold";
      }
    else
      {
        # Light mode colors
        minus-style = "syntax #f8e8e8";
        minus-emph-style = "syntax #f5cccc";
        minus-non-emph-style = "syntax #f8e8e8";
        plus-style = "syntax #e8f8e8";
        plus-emph-style = "syntax #ccf5cc";
        plus-non-emph-style = "syntax #e8f8e8";

        # Line numbers
        line-numbers-minus-style = "#b83226";
        line-numbers-plus-style = "#2d7a5e";
        line-numbers-zero-style = "#8e909f";
        line-numbers-left-style = "#8e909f";
        line-numbers-right-style = "#8e909f";

        # File decoration
        file-style = "#3557a0";
        file-decoration-style = "#3557a0 ul";

        # Commit decoration
        commit-decoration-style = "#7a5d8b box";
        commit-style = "#7a5d8b";

        # Hunk header
        hunk-header-style = "syntax #ececee";
        hunk-header-decoration-style = "#3570a8 box";
        hunk-header-file-style = "#3570a8";
        hunk-header-line-number-style = "#8e909f";

        # Blame
        blame-palette = "#6b5896 #2d7a5e #3557a0 #b83226 #8a6d3b #3570a8";

        # Merge conflict
        merge-conflict-begin-symbol = "▼";
        merge-conflict-end-symbol = "▲";
        merge-conflict-ours-diff-header-style = "#c97719 bold";
        merge-conflict-theirs-diff-header-style = "#3570a8 bold";
      };

  # Check if delta should be themed
  # Check if delta should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "delta" [
    "cli"
    "delta"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    # Assumes user has already set programs.delta.enable = true
    programs.delta.options = {
      # Syntax highlighting theme
      # Delta uses bat's themes, so we use the Signal theme we created for bat
      syntax-theme =
        if cfg.mode == "auto" then "auto" else "signal-${signalLib.resolveThemeMode cfg.mode}";

      # Apply Signal colors
      inherit (deltaColors)
        minus-style
        minus-emph-style
        minus-non-emph-style
        plus-style
        plus-emph-style
        plus-non-emph-style

        # Line numbers
        line-numbers-minus-style
        line-numbers-plus-style
        line-numbers-zero-style
        line-numbers-left-style
        line-numbers-right-style

        # File decoration
        file-style
        file-decoration-style

        # Commit decoration
        commit-decoration-style
        commit-style

        # Hunk header
        hunk-header-style
        hunk-header-decoration-style
        hunk-header-file-style
        hunk-header-line-number-style

        # Blame
        blame-palette

        # Merge conflict
        merge-conflict-begin-symbol
        merge-conflict-end-symbol
        merge-conflict-ours-diff-header-style
        merge-conflict-theirs-diff-header-style
        ;
    };
  };
}
