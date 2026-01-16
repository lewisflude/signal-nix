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
          selectedLineBgColor = [ colors.surface-subtle.hex ];
          selectedRangeBgColor = [ colors.surface-emphasis.hex ];
          activeBorderColor = [ accent.focus.Lc75.hex ];
          inactiveBorderColor = [ colors.divider-primary.hex ];
          searchingActiveBorderColor = [ accent.focus.Lc75.hex ];
          optionsTextColor = [ accent.info.Lc75.hex ];
          defaultFgColor = [ colors.text-primary.hex ];
        };
      };
    };
  };
}
