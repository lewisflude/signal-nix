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
    background = signalColors.tonal."surface-Lc05";
    text = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    match = signalColors.accent.focus.Lc75;
    selection-background = signalColors.tonal."divider-Lc15";
    selection-text = signalColors.tonal."text-Lc75";
    border = signalColors.accent.focus.Lc75;
  };
in
{
  config = mkIf (cfg.enable && cfg.fuzzel.enable) {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "monospace:size=14";
          dpi-aware = true;
          icon-theme = "Adwaita";
          layer = "overlay";
          width = 50;
          horizontal-pad = 40;
          vertical-pad = 20;
          inner-pad = 10;
        };

        colors = {
          background = "${colors.background.hexRaw}f2"; # ~95% opacity
          text = "${colors.text.hexRaw}ff";
          match = "${colors.match.hexRaw}ff";
          selection-background = "${colors.selection-background.hexRaw}ff";
          selection-text = "${colors.selection-text.hexRaw}ff";
          selection-match = "${colors.match.hexRaw}ff";
          border = "${colors.border.hexRaw}ff";
        };

        border = {
          width = 2;
          radius = 12;
        };
      };
    };
  };
}
