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

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-tertiary = signalColors.tonal."text-Lc45";
  };

  inherit (signalColors) accent;

  # Use high-fidelity color conversion from signalLib
  # Converts hex to space-separated RGB string (0-255 range) for Zellij theme format
  toZellijColor = signalLib.hexToRgbSpaceSeparated;

  # Check if zellij should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "zellij" [
    "multiplexers"
    "zellij"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.zellij = {
      # Zellij theme in KDL format
      settings = {
        themes.signal = {
          # Text components
          text_unselected = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.focus.Lc75;
            emphasis_1 = toZellijColor accent.info.Lc75;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          text_selected = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor accent.focus.Lc75;
            emphasis_0 = toZellijColor colors.surface-base;
            emphasis_1 = toZellijColor colors.text-primary;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          # Ribbon components (tabs, status bar)
          ribbon_unselected = {
            base = toZellijColor colors.text-secondary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.danger.Lc75;
            emphasis_1 = toZellijColor accent.warning.Lc75;
            emphasis_2 = toZellijColor accent.info.Lc75;
            emphasis_3 = toZellijColor accent.focus.Lc75;
          };

          ribbon_selected = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor accent.focus.Lc75;
            emphasis_0 = toZellijColor colors.surface-base;
            emphasis_1 = toZellijColor colors.text-primary;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.info.Lc75;
          };

          # Table components
          table_title = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.focus.Lc75;
            emphasis_1 = toZellijColor accent.info.Lc75;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          table_cell_unselected = {
            base = toZellijColor colors.text-secondary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.focus.Lc75;
            emphasis_1 = toZellijColor accent.info.Lc75;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          table_cell_selected = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor accent.focus.Lc75;
            emphasis_0 = toZellijColor colors.surface-base;
            emphasis_1 = toZellijColor colors.text-primary;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          # List components
          list_unselected = {
            base = toZellijColor colors.text-secondary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.focus.Lc75;
            emphasis_1 = toZellijColor accent.info.Lc75;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          list_selected = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor accent.focus.Lc75;
            emphasis_0 = toZellijColor colors.surface-base;
            emphasis_1 = toZellijColor colors.text-primary;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          # Frame (pane borders)
          frame_unselected = {
            base = toZellijColor colors.text-tertiary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.focus.Lc75;
            emphasis_1 = toZellijColor accent.info.Lc75;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          frame_selected = {
            base = toZellijColor accent.focus.Lc75;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.focus.Lc75;
            emphasis_1 = toZellijColor accent.info.Lc75;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          frame_highlight = {
            base = toZellijColor accent.special.Lc75;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.special.Lc75;
            emphasis_1 = toZellijColor accent.info.Lc75;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          # Exit codes
          exit_code_success = {
            base = toZellijColor accent.success.Lc75;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.success.Lc75;
            emphasis_1 = toZellijColor accent.success.Lc75;
            emphasis_2 = toZellijColor accent.success.Lc75;
            emphasis_3 = toZellijColor accent.success.Lc75;
          };

          exit_code_error = {
            base = toZellijColor accent.danger.Lc75;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.danger.Lc75;
            emphasis_1 = toZellijColor accent.danger.Lc75;
            emphasis_2 = toZellijColor accent.danger.Lc75;
            emphasis_3 = toZellijColor accent.danger.Lc75;
          };

          # Multiplayer user colors
          multiplayer_user_colors = [
            (toZellijColor accent.focus.Lc75) # Player 1
            (toZellijColor accent.info.Lc75) # Player 2
            (toZellijColor accent.success.Lc75) # Player 3
            (toZellijColor accent.warning.Lc75) # Player 4
            (toZellijColor accent.special.Lc75) # Player 5
            (toZellijColor accent.danger.Lc75) # Player 6
            (toZellijColor signalColors.categorical.GA02) # Player 7
            (toZellijColor signalColors.categorical.GA06) # Player 8
            (toZellijColor signalColors.categorical.GA08) # Player 9
            (toZellijColor colors.text-primary) # Player 10
          ];
        };

        # Use Signal theme
        theme = "signal";
      };
    };
  };
}
