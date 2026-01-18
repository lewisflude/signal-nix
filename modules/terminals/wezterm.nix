{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: programs.wezterm.extraConfig
# UPSTREAM SCHEMA: https://wezfurlong.org/wezterm/config/appearance.html
# SCHEMA VERSION: 20230712-072601-f4abf8fd
# LAST VALIDATED: 2026-01-17
# NOTES: WezTerm uses Lua configuration. Home-Manager's wezterm module only
#        provides extraConfig for Lua code generation. No structured options exist.
#        We generate a Lua table that matches WezTerm's color scheme structure.
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

  # Check if wezterm should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "wezterm" [
    "terminals"
    "wezterm"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.wezterm = {
      # Wezterm config in Lua
      extraConfig = ''
        -- Signal Theme for WezTerm
        local signal_theme = {
          -- Terminal colors
          foreground = "${colors.text-primary.hex}",
          background = "${colors.surface-base.hex}",

          -- Cursor
          cursor_bg = "${accent.secondary.Lc75.hex}",
          cursor_fg = "${colors.surface-base.hex}",
          cursor_border = "${accent.secondary.Lc75.hex}",

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
