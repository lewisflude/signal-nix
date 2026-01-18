{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: structured-colors (Tier 2)
# HOME-MANAGER MODULE: programs.alacritty.settings.colors
# UPSTREAM SCHEMA: https://alacritty.org/config-alacritty.html
# SCHEMA VERSION: 0.13.0
# LAST VALIDATED: 2026-01-17
# NOTES: Home-Manager provides structured color options within settings.colors.
#        This is well-typed and validates the color structure properly.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    divider-primary = signalColors.tonal."divider-primary";
    divider-secondary = signalColors.tonal."divider-strong";
  };

  inherit (signalColors) accent;

  # ANSI color mapping using Signal palette
  ansiColors = {
    # Normal colors
    black = signalColors.tonal."black";
    red = accent.danger.Lc75;
    green = accent.primary.Lc75;
    yellow = accent.warning.Lc75;
    blue = accent.secondary.Lc75;
    magenta = accent.tertiary.Lc75;
    cyan = accent.secondary.Lc75;
    white = signalColors.tonal."text-secondary";

    # Bright colors
    bright-black = signalColors.tonal."text-tertiary";
    bright-red = accent.danger.Lc75;
    bright-green = accent.primary.Lc75;
    bright-yellow = accent.warning.Lc75;
    bright-blue = accent.secondary.Lc75;
    bright-magenta = accent.tertiary.Lc75;
    bright-cyan = accent.secondary.Lc75;
    bright-white = signalColors.tonal."text-primary";
  };

  # Check if alacritty should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "alacritty" [
    "terminals"
    "alacritty"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
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
            cursor = accent.secondary.Lc75.hex;
          };

          # Vi mode cursor colors
          vi_mode_cursor = {
            text = colors.surface-base.hex;
            cursor = accent.tertiary.Lc75.hex;
          };

          # Search colors
          search = {
            matches = {
              foreground = colors.surface-base.hex;
              background = accent.warning.Lc75.hex;
            };
            focused_match = {
              foreground = colors.surface-base.hex;
              background = accent.secondary.Lc75.hex;
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
              background = accent.secondary.Lc75.hex;
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
