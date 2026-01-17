{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
let
  inherit (lib) mkIf removePrefix;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-tertiary = signalColors.tonal."text-Lc45";
  };

  inherit (signalColors) accent;

  # Helper to convert hex to RGB values (space-separated, no #)
  hexToRgb =
    color:
    let
      hex = removePrefix "#" color.hex;
      r = builtins.fromTOML "x=0x${builtins.substring 0 2 hex}";
      g = builtins.fromTOML "x=0x${builtins.substring 2 2 hex}";
      b = builtins.fromTOML "x=0x${builtins.substring 4 2 hex}";
    in
    "${toString r.x} ${toString g.x} ${toString b.x}";

  # Check if zellij should be themed
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
            base = hexToRgb colors.text-primary;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.focus.Lc75;
            emphasis_1 = hexToRgb accent.info.Lc75;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          text_selected = {
            base = hexToRgb colors.text-primary;
            background = hexToRgb accent.focus.Lc75;
            emphasis_0 = hexToRgb colors.surface-base;
            emphasis_1 = hexToRgb colors.text-primary;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          # Ribbon components (tabs, status bar)
          ribbon_unselected = {
            base = hexToRgb colors.text-secondary;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.danger.Lc75;
            emphasis_1 = hexToRgb accent.warning.Lc75;
            emphasis_2 = hexToRgb accent.info.Lc75;
            emphasis_3 = hexToRgb accent.focus.Lc75;
          };

          ribbon_selected = {
            base = hexToRgb colors.text-primary;
            background = hexToRgb accent.focus.Lc75;
            emphasis_0 = hexToRgb colors.surface-base;
            emphasis_1 = hexToRgb colors.text-primary;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.info.Lc75;
          };

          # Table components
          table_title = {
            base = hexToRgb colors.text-primary;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.focus.Lc75;
            emphasis_1 = hexToRgb accent.info.Lc75;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          table_cell_unselected = {
            base = hexToRgb colors.text-secondary;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.focus.Lc75;
            emphasis_1 = hexToRgb accent.info.Lc75;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          table_cell_selected = {
            base = hexToRgb colors.text-primary;
            background = hexToRgb accent.focus.Lc75;
            emphasis_0 = hexToRgb colors.surface-base;
            emphasis_1 = hexToRgb colors.text-primary;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          # List components
          list_unselected = {
            base = hexToRgb colors.text-secondary;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.focus.Lc75;
            emphasis_1 = hexToRgb accent.info.Lc75;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          list_selected = {
            base = hexToRgb colors.text-primary;
            background = hexToRgb accent.focus.Lc75;
            emphasis_0 = hexToRgb colors.surface-base;
            emphasis_1 = hexToRgb colors.text-primary;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          # Frame (pane borders)
          frame_unselected = {
            base = hexToRgb colors.text-tertiary;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.focus.Lc75;
            emphasis_1 = hexToRgb accent.info.Lc75;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          frame_selected = {
            base = hexToRgb accent.focus.Lc75;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.focus.Lc75;
            emphasis_1 = hexToRgb accent.info.Lc75;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          frame_highlight = {
            base = hexToRgb accent.special.Lc75;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.special.Lc75;
            emphasis_1 = hexToRgb accent.info.Lc75;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.warning.Lc75;
          };

          # Exit codes
          exit_code_success = {
            base = hexToRgb accent.success.Lc75;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.success.Lc75;
            emphasis_1 = hexToRgb accent.success.Lc75;
            emphasis_2 = hexToRgb accent.success.Lc75;
            emphasis_3 = hexToRgb accent.success.Lc75;
          };

          exit_code_error = {
            base = hexToRgb accent.danger.Lc75;
            background = hexToRgb colors.surface-base;
            emphasis_0 = hexToRgb accent.danger.Lc75;
            emphasis_1 = hexToRgb accent.danger.Lc75;
            emphasis_2 = hexToRgb accent.danger.Lc75;
            emphasis_3 = hexToRgb accent.danger.Lc75;
          };

          # Multiplayer user colors
          multiplayer_user_colors = [
            (hexToRgb accent.focus.Lc75) # Player 1
            (hexToRgb accent.info.Lc75) # Player 2
            (hexToRgb accent.success.Lc75) # Player 3
            (hexToRgb accent.warning.Lc75) # Player 4
            (hexToRgb accent.special.Lc75) # Player 5
            (hexToRgb accent.danger.Lc75) # Player 6
            (hexToRgb signalColors.categorical.GA02) # Player 7
            (hexToRgb signalColors.categorical.GA06) # Player 8
            (hexToRgb signalColors.categorical.GA08) # Player 9
            (hexToRgb colors.text-primary) # Player 10
          ];
        };

        # Use Signal theme
        theme = "signal";
      };
    };
  };
}
