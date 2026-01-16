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
  config = mkIf (cfg.enable && cfg.terminals.wezterm.enable) {
    programs.wezterm = {
      # Wezterm config in Lua
      extraConfig = ''
        -- Signal Theme for WezTerm
        local signal_theme = {
          -- Terminal colors
          foreground = "${colors.text-primary.hex}",
          background = "${colors.surface-base.hex}",

          -- Cursor
          cursor_bg = "${accent.focus.Lc75.hex}",
          cursor_fg = "${colors.surface-base.hex}",
          cursor_border = "${accent.focus.Lc75.hex}",

          -- Selection
          selection_fg = "${colors.text-primary.hex}",
          selection_bg = "${colors.divider-primary.hex}",

          -- Scrollbar
          scrollbar_thumb = "${colors.divider-primary.hex}",

          -- Split separators
          split = "${colors.divider-primary.hex}",

          -- ANSI colors
          ansi = {
            "${ansiColors.black.hex}",
            "${ansiColors.red.hex}",
            "${ansiColors.green.hex}",
            "${ansiColors.yellow.hex}",
            "${ansiColors.blue.hex}",
            "${ansiColors.magenta.hex}",
            "${ansiColors.cyan.hex}",
            "${ansiColors.white.hex}",
          },

          brights = {
            "${ansiColors.bright-black.hex}",
            "${ansiColors.bright-red.hex}",
            "${ansiColors.bright-green.hex}",
            "${ansiColors.bright-yellow.hex}",
            "${ansiColors.bright-blue.hex}",
            "${ansiColors.bright-magenta.hex}",
            "${ansiColors.bright-cyan.hex}",
            "${ansiColors.bright-white.hex}",
          },

          -- Tab bar
          tab_bar = {
            background = "${colors.surface-base.hex}",
            active_tab = {
              bg_color = "${colors.surface-base.hex}",
              fg_color = "${colors.text-primary.hex}",
            },
            inactive_tab = {
              bg_color = "${colors.divider-primary.hex}",
              fg_color = "${colors.text-secondary.hex}",
            },
            inactive_tab_hover = {
              bg_color = "${colors.divider-primary.hex}",
              fg_color = "${colors.text-primary.hex}",
            },
            new_tab = {
              bg_color = "${colors.divider-primary.hex}",
              fg_color = "${colors.text-secondary.hex}",
            },
            new_tab_hover = {
              bg_color = "${colors.divider-primary.hex}",
              fg_color = "${colors.text-primary.hex}",
            },
          },
        }

        return {
          colors = signal_theme,
        }
      '';
    };
  };
}
