{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: programs.lazygit.settings
# UPSTREAM SCHEMA: https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
# SCHEMA VERSION: 0.40.2
# LAST VALIDATED: 2026-01-17
# NOTES: Home-Manager provides freeform settings that serialize to YAML config.
#        Theme colors go under gui.theme attrset. Must match lazygit schema.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-subtle = signalColors.tonal."divider-primary";
    surface-emphasis = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    divider-primary = signalColors.tonal."divider-primary";
  };

  inherit (signalColors) accent;

  # Check if lazygit should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "lazygit" [
    "cli"
    "lazygit"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.lazygit.settings = {
      gui = {
        theme = {
          # Border colors
          activeBorderColor = [
            accent.secondary.Lc75.hex
            "bold"
          ];
          inactiveBorderColor = [ colors.divider-primary.hex ];
          searchingActiveBorderColor = [
            accent.secondary.Lc75.hex
            "bold"
          ];

          # Options/help text
          optionsTextColor = [ accent.secondary.Lc75.hex ];

          # Selected line colors
          selectedLineBgColor = [ colors.surface-subtle.hex ];
          selectedRangeBgColor = [ colors.surface-emphasis.hex ];
          inactiveViewSelectedLineBgColor = [ colors.surface-subtle.hex ];

          # Cherry-picked commit colors
          cherryPickedCommitFgColor = [ accent.secondary.Lc75.hex ];
          cherryPickedCommitBgColor = [ colors.surface-emphasis.hex ];

          # Marked base commit colors (for rebase)
          markedBaseCommitFgColor = [ accent.warning.Lc75.hex ];
          markedBaseCommitBgColor = [ colors.surface-emphasis.hex ];

          # File status colors
          unstagedChangesColor = [ accent.danger.Lc75.hex ];

          # Default text color
          defaultFgColor = [ colors.text-primary.hex ];
        };
      };
    };
  };
}
