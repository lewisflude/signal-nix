{
  config,
  lib,
  signalColors,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-subtle = signalColors.tonal."divider-Lc15";
    surface-emphasis = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    divider-primary = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;
in
{
  config = mkIf (cfg.enable && cfg.cli.lazygit.enable) {
    programs.lazygit.settings = {
      gui = {
        theme = {
          # Border colors
          activeBorderColor = [
            accent.focus.Lc75.hex
            "bold"
          ];
          inactiveBorderColor = [ colors.divider-primary.hex ];
          searchingActiveBorderColor = [
            accent.focus.Lc75.hex
            "bold"
          ];

          # Options/help text
          optionsTextColor = [ accent.info.Lc75.hex ];

          # Selected line colors
          selectedLineBgColor = [ colors.surface-subtle.hex ];
          selectedRangeBgColor = [ colors.surface-emphasis.hex ];
          inactiveViewSelectedLineBgColor = [ colors.surface-subtle.hex ];

          # Cherry-picked commit colors
          cherryPickedCommitFgColor = [ accent.info.Lc75.hex ];
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
