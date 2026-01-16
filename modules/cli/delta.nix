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
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  # Define color mappings for both dark and light modes
  deltaColors =
    if signalLib.resolveThemeMode cfg.mode == "dark" then
      {
        # Dark mode colors
        minus-style = "syntax ${signalColors.tonal."surface-Lc10".hex}";
        minus-emph-style = "syntax ${signalColors.accent.danger.Lc25.hex}";
        minus-non-emph-style = "syntax ${signalColors.tonal."surface-Lc10".hex}";
        plus-style = "syntax ${signalColors.tonal."surface-Lc10".hex}";
        plus-emph-style = "syntax ${signalColors.accent.success.Lc25.hex}";
        plus-non-emph-style = "syntax ${signalColors.tonal."surface-Lc10".hex}";

        # Line numbers
        line-numbers-minus-style = signalColors.accent.danger.Lc75.hex;
        line-numbers-plus-style = signalColors.accent.success.Lc75.hex;
        line-numbers-zero-style = signalColors.tonal."text-Lc45".hex;
        line-numbers-left-style = signalColors.tonal."text-Lc45".hex;
        line-numbers-right-style = signalColors.tonal."text-Lc45".hex;

        # File decoration
        file-style = signalColors.accent.focus.Lc75.hex;
        file-decoration-style = "${signalColors.accent.focus.Lc75.hex} ul";

        # Commit decoration
        commit-decoration-style = "${signalColors.accent.special.Lc75.hex} box";
        commit-style = signalColors.accent.special.Lc75.hex;

        # Hunk header
        hunk-header-style = "syntax ${signalColors.tonal."divider-Lc15".hex}";
        hunk-header-decoration-style = "${signalColors.accent.info.Lc75.hex} box";
        hunk-header-file-style = signalColors.accent.info.Lc75.hex;
        hunk-header-line-number-style = signalColors.tonal."text-Lc60".hex;

        # Blame
        blame-palette = "${signalColors.categorical.GA01.hex} ${signalColors.categorical.GA02.hex} ${signalColors.categorical.GA03.hex} ${signalColors.categorical.GA04.hex} ${signalColors.categorical.GA05.hex} ${signalColors.categorical.GA06.hex}";

        # Merge conflict
        merge-conflict-begin-symbol = "▼";
        merge-conflict-end-symbol = "▲";
        merge-conflict-ours-diff-header-style = "${signalColors.accent.warning.Lc75.hex} bold";
        merge-conflict-theirs-diff-header-style = "${signalColors.accent.info.Lc75.hex} bold";
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
in
{
  config = mkIf (cfg.enable && cfg.cli.delta.enable) {
    # Assumes user has already set programs.delta.enable = true
    programs.delta.options = {
      # Syntax highlighting theme
      # Delta uses bat's themes, so we use the Signal theme we created for bat
      syntax-theme =
        if cfg.mode == "auto" then "auto" else "signal-${signalLib.resolveThemeMode cfg.mode}";

      # Apply Signal colors
      minus-style = deltaColors.minus-style;
      minus-emph-style = deltaColors.minus-emph-style;
      minus-non-emph-style = deltaColors.minus-non-emph-style;
      plus-style = deltaColors.plus-style;
      plus-emph-style = deltaColors.plus-emph-style;
      plus-non-emph-style = deltaColors.plus-non-emph-style;

      # Line numbers
      line-numbers-minus-style = deltaColors.line-numbers-minus-style;
      line-numbers-plus-style = deltaColors.line-numbers-plus-style;
      line-numbers-zero-style = deltaColors.line-numbers-zero-style;
      line-numbers-left-style = deltaColors.line-numbers-left-style;
      line-numbers-right-style = deltaColors.line-numbers-right-style;

      # File decoration
      file-style = deltaColors.file-style;
      file-decoration-style = deltaColors.file-decoration-style;

      # Commit decoration
      commit-decoration-style = deltaColors.commit-decoration-style;
      commit-style = deltaColors.commit-style;

      # Hunk header
      hunk-header-style = deltaColors.hunk-header-style;
      hunk-header-decoration-style = deltaColors.hunk-header-decoration-style;
      hunk-header-file-style = deltaColors.hunk-header-file-style;
      hunk-header-line-number-style = deltaColors.hunk-header-line-number-style;

      # Blame
      blame-palette = deltaColors.blame-palette;

      # Merge conflict
      merge-conflict-begin-symbol = deltaColors.merge-conflict-begin-symbol;
      merge-conflict-end-symbol = deltaColors.merge-conflict-end-symbol;
      merge-conflict-ours-diff-header-style = deltaColors.merge-conflict-ours-diff-header-style;
      merge-conflict-theirs-diff-header-style = deltaColors.merge-conflict-theirs-diff-header-style;
    };
  };
}
