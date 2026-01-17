{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: programs.qutebrowser.settings
# UPSTREAM SCHEMA: https://github.com/qutebrowser/qutebrowser
# SCHEMA VERSION: 3.1.0
# LAST VALIDATED: 2026-01-17
# NOTES: Qutebrowser uses Python config. Home-Manager provides settings attrset
#        that gets serialized to config.py. Colors are in the 'colors' namespace.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-raised = signalColors.tonal."surface-Lc10";
    surface-hover = signalColors.tonal."surface-Lc15";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-dim = signalColors.tonal."text-Lc45";
    divider = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # Check if qutebrowser should be themed
  shouldTheme = signalLib.shouldThemeApp "qutebrowser" [
    "browsers"
    "qutebrowser"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.qutebrowser.settings = {
      colors = {
        # Background/foreground
        webpage.bg = colors.surface-base.hex;

        # Completion widget
        completion = {
          fg = colors.text-primary.hex;
          odd.bg = colors.surface-base.hex;
          even.bg = colors.surface-base.hex;
          category = {
            fg = colors.text-primary.hex;
            bg = colors.surface-raised.hex;
            border = {
              top = colors.divider.hex;
              bottom = colors.divider.hex;
            };
          };
          item.selected = {
            fg = colors.text-primary.hex;
            bg = colors.surface-hover.hex;
            border = {
              top = accent.focus.Lc75.hex;
              bottom = accent.focus.Lc75.hex;
            };
          };
          match.fg = accent.focus.Lc75.hex;
          scrollbar = {
            fg = colors.divider.hex;
            bg = colors.surface-base.hex;
          };
        };

        # Downloads
        downloads = {
          bar.bg = colors.surface-raised.hex;
          start = {
            fg = colors.surface-base.hex;
            bg = accent.info.Lc75.hex;
          };
          stop = {
            fg = colors.surface-base.hex;
            bg = accent.success.Lc75.hex;
          };
          error.fg = accent.danger.Lc75.hex;
        };

        # Hints
        hints = {
          fg = colors.surface-base.hex;
          bg = accent.warning.Lc75.hex;
          match.fg = accent.focus.Lc75.hex;
        };

        # Keyhints
        keyhint = {
          fg = colors.text-primary.hex;
          bg = colors.surface-raised.hex;
          suffix.fg = accent.focus.Lc75.hex;
        };

        # Messages
        messages = {
          error = {
            fg = colors.surface-base.hex;
            bg = accent.danger.Lc75.hex;
            border = accent.danger.Lc75.hex;
          };
          warning = {
            fg = colors.surface-base.hex;
            bg = accent.warning.Lc75.hex;
            border = accent.warning.Lc75.hex;
          };
          info = {
            fg = colors.text-primary.hex;
            bg = colors.surface-raised.hex;
            border = colors.divider.hex;
          };
        };

        # Prompts
        prompts = {
          fg = colors.text-primary.hex;
          bg = colors.surface-raised.hex;
          border = colors.divider.hex;
          selected.bg = colors.surface-hover.hex;
        };

        # Status bar
        statusbar = {
          normal = {
            fg = colors.text-primary.hex;
            bg = colors.surface-base.hex;
          };
          insert = {
            fg = colors.surface-base.hex;
            bg = accent.success.Lc75.hex;
          };
          passthrough = {
            fg = colors.surface-base.hex;
            bg = accent.info.Lc75.hex;
          };
          private = {
            fg = colors.surface-base.hex;
            bg = accent.special.Lc75.hex;
          };
          command = {
            fg = colors.text-primary.hex;
            bg = colors.surface-raised.hex;
            private = {
              fg = colors.text-primary.hex;
              bg = colors.surface-raised.hex;
            };
          };
          caret = {
            fg = colors.surface-base.hex;
            bg = accent.special.Lc75.hex;
            selection = {
              fg = colors.surface-base.hex;
              bg = accent.info.Lc75.hex;
            };
          };
          progress.bg = accent.focus.Lc75.hex;
          url = {
            fg = colors.text-primary.hex;
            error.fg = accent.danger.Lc75.hex;
            hover.fg = accent.info.Lc75.hex;
            success = {
              http.fg = accent.success.Lc75.hex;
              https.fg = accent.success.Lc75.hex;
            };
            warn.fg = accent.warning.Lc75.hex;
          };
        };

        # Tabs
        tabs = {
          bar.bg = colors.surface-base.hex;
          indicator = {
            start = accent.info.Lc75.hex;
            stop = accent.success.Lc75.hex;
            error = accent.danger.Lc75.hex;
          };
          odd = {
            fg = colors.text-secondary.hex;
            bg = colors.surface-base.hex;
          };
          even = {
            fg = colors.text-secondary.hex;
            bg = colors.surface-base.hex;
          };
          pinned = {
            even = {
              fg = colors.text-secondary.hex;
              bg = colors.surface-raised.hex;
            };
            odd = {
              fg = colors.text-secondary.hex;
              bg = colors.surface-raised.hex;
            };
            selected = {
              even = {
                fg = colors.text-primary.hex;
                bg = colors.surface-hover.hex;
              };
              odd = {
                fg = colors.text-primary.hex;
                bg = colors.surface-hover.hex;
              };
            };
          };
          selected = {
            odd = {
              fg = colors.text-primary.hex;
              bg = colors.surface-raised.hex;
            };
            even = {
              fg = colors.text-primary.hex;
              bg = colors.surface-raised.hex;
            };
          };
        };
      };
    };
  };
}
