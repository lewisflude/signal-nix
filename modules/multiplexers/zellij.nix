{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: programs.zellij.settings.themes
# UPSTREAM SCHEMA: https://zellij.dev/documentation/themes.html
# SCHEMA VERSION: 0.39.0
# LAST VALIDATED: 2026-01-17
# NOTES: Home-Manager provides freeform settings that serialize to KDL format.
#        Zellij themes require RGB values as space-separated strings (0-255).
#        Theme structure must match Zellij's component-based schema exactly.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-tertiary = signalColors.tonal."text-tertiary";
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
            emphasis_0 = toZellijColor accent.secondary.Lc75;
            emphasis_1 = toZellijColor accent.secondary.Lc75;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          text_selected = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor accent.secondary.Lc75;
            emphasis_0 = toZellijColor colors.surface-base;
            emphasis_1 = toZellijColor colors.text-primary;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          # Ribbon components (tabs, status bar)
          ribbon_unselected = {
            base = toZellijColor colors.text-secondary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.danger.Lc75;
            emphasis_1 = toZellijColor accent.warning.Lc75;
            emphasis_2 = toZellijColor accent.secondary.Lc75;
            emphasis_3 = toZellijColor accent.secondary.Lc75;
          };

          ribbon_selected = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor accent.secondary.Lc75;
            emphasis_0 = toZellijColor colors.surface-base;
            emphasis_1 = toZellijColor colors.text-primary;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.secondary.Lc75;
          };

          # Table components
          table_title = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.secondary.Lc75;
            emphasis_1 = toZellijColor accent.secondary.Lc75;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          table_cell_unselected = {
            base = toZellijColor colors.text-secondary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.secondary.Lc75;
            emphasis_1 = toZellijColor accent.secondary.Lc75;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          table_cell_selected = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor accent.secondary.Lc75;
            emphasis_0 = toZellijColor colors.surface-base;
            emphasis_1 = toZellijColor colors.text-primary;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          # List components
          list_unselected = {
            base = toZellijColor colors.text-secondary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.secondary.Lc75;
            emphasis_1 = toZellijColor accent.secondary.Lc75;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          list_selected = {
            base = toZellijColor colors.text-primary;
            background = toZellijColor accent.secondary.Lc75;
            emphasis_0 = toZellijColor colors.surface-base;
            emphasis_1 = toZellijColor colors.text-primary;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          # Frame (pane borders)
          frame_unselected = {
            base = toZellijColor colors.text-tertiary;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.secondary.Lc75;
            emphasis_1 = toZellijColor accent.secondary.Lc75;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          frame_selected = {
            base = toZellijColor accent.secondary.Lc75;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.secondary.Lc75;
            emphasis_1 = toZellijColor accent.secondary.Lc75;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          frame_highlight = {
            base = toZellijColor accent.tertiary.Lc75;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.tertiary.Lc75;
            emphasis_1 = toZellijColor accent.secondary.Lc75;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.warning.Lc75;
          };

          # Exit codes
          exit_code_success = {
            base = toZellijColor accent.primary.Lc75;
            background = toZellijColor colors.surface-base;
            emphasis_0 = toZellijColor accent.primary.Lc75;
            emphasis_1 = toZellijColor accent.primary.Lc75;
            emphasis_2 = toZellijColor accent.primary.Lc75;
            emphasis_3 = toZellijColor accent.primary.Lc75;
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
            (toZellijColor accent.secondary.Lc75) # Player 1
            (toZellijColor accent.secondary.Lc75) # Player 2
            (toZellijColor accent.primary.Lc75) # Player 3
            (toZellijColor accent.warning.Lc75) # Player 4
            (toZellijColor accent.tertiary.Lc75) # Player 5
            (toZellijColor accent.danger.Lc75) # Player 6
            (toZellijColor signalColors.categorical."data-viz-02") # Player 7
            (toZellijColor signalColors.categorical."data-viz-06") # Player 8
            (toZellijColor signalColors.categorical."data-viz-08") # Player 9
            (toZellijColor colors.text-primary) # Player 10
          ];
        };

        # Use Signal theme
        theme = "signal";
      };
    };
  };
}
