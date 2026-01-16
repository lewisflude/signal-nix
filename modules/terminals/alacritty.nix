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
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    divider-primary = signalColors.tonal."divider-Lc15";
    divider-secondary = signalColors.tonal."divider-Lc30";
  };

  inherit (signalColors) accent;

  # ANSI color mapping using Signal palette
  ansiColors = {
    # Normal colors
    black = signalColors.tonal."base-L015";
    red = accent.danger.Lc75;
    green = accent.success.Lc75;
    yellow = accent.warning.Lc75;
    blue = accent.focus.Lc75;
    magenta = accent.special.Lc75;
    cyan = accent.info.Lc75;
    white = signalColors.tonal."text-Lc60";

    # Bright colors
    bright-black = signalColors.tonal."text-Lc45";
    bright-red = accent.danger.Lc75;
    bright-green = accent.success.Lc75;
    bright-yellow = accent.warning.Lc75;
    bright-blue = accent.focus.Lc75;
    bright-magenta = accent.special.Lc75;
    bright-cyan = accent.info.Lc75;
    bright-white = signalColors.tonal."text-Lc75";
  };
in
{
  config = mkIf (cfg.enable && cfg.terminals.alacritty.enable) {
    programs.alacritty = {
      settings = {
        colors = {
          # Primary colors
          primary = {
            background = colors.surface-base.hex;
            foreground = colors.text-primary.hex;
          };

          # Cursor colors
          cursor = {
            text = colors.surface-base.hex;
            cursor = accent.focus.Lc75.hex;
          };

          # Vi mode cursor colors
          vi_mode_cursor = {
            text = colors.surface-base.hex;
            cursor = accent.special.Lc75.hex;
          };

          # Search colors
          search = {
            matches = {
              foreground = colors.surface-base.hex;
              background = accent.warning.Lc75.hex;
            };
            focused_match = {
              foreground = colors.surface-base.hex;
              background = accent.focus.Lc75.hex;
            };
          };

          # Hints
          hints = {
            start = {
              foreground = colors.surface-base.hex;
              background = accent.warning.Lc75.hex;
            };
            end = {
              foreground = colors.surface-base.hex;
              background = accent.info.Lc75.hex;
            };
          };

          # Line indicator
          line_indicator = {
            foreground = "None";
            background = "None";
          };

          # Footer bar
          footer_bar = {
            foreground = colors.surface-base.hex;
            background = colors.text-primary.hex;
          };

          # Selection colors
          selection = {
            text = colors.text-primary.hex;
            background = colors.divider-primary.hex;
          };

          # Normal colors
          normal = {
            black = ansiColors.black.hex;
            red = ansiColors.red.hex;
            green = ansiColors.green.hex;
            yellow = ansiColors.yellow.hex;
            blue = ansiColors.blue.hex;
            magenta = ansiColors.magenta.hex;
            cyan = ansiColors.cyan.hex;
            white = ansiColors.white.hex;
          };

          # Bright colors
          bright = {
            black = ansiColors.bright-black.hex;
            red = ansiColors.bright-red.hex;
            green = ansiColors.bright-green.hex;
            yellow = ansiColors.bright-yellow.hex;
            blue = ansiColors.bright-blue.hex;
            magenta = ansiColors.bright-magenta.hex;
            cyan = ansiColors.bright-cyan.hex;
            white = ansiColors.bright-white.hex;
          };

          # Dim colors (automatically calculated if not set)
          # We'll let alacritty calculate these

          # Transparent background colors
          transparent_background_colors = false;

          # Draw bold text with bright colors
          draw_bold_text_with_bright_colors = false;
        };
      };
    };
  };
}
