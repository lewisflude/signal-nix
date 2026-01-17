{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: programs.yazi.theme
# UPSTREAM SCHEMA: https://yazi-rs.github.io/docs/configuration/theme/
# SCHEMA VERSION: 0.2.4
# LAST VALIDATED: 2026-01-17
# NOTES: Home-Manager provides structured theme option that serializes to TOML.
#        The theme attrset structure matches yazi's theme.toml schema exactly.
let
  inherit (lib) mkIf removePrefix;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-subtle = signalColors.tonal."divider-primary";
    surface-emphasis = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    divider-primary = signalColors.tonal."divider-primary";
    divider-secondary = signalColors.tonal."divider-strong";
  };

  inherit (signalColors) accent;

  # Helper to get hex without # prefix
  hexRaw = color: removePrefix "#" color.hex;

  # Helper functions to reduce repetitive color mappings
  # These create consistent attribute structures for yazi theme
  mkColorPair = fg: bg: {
    fg = hexRaw fg;
    bg = hexRaw bg;
  };

  mkSingleColor = attr: color: {
    ${attr} = hexRaw color;
  };

  mkMarker = color: mkColorPair color color;

  mkModeStyle = fg: bg: {
    fg = hexRaw fg;
    bg = hexRaw bg;
    bold = true;
  };

  # Check if yazi should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "yazi" [
    "cli"
    "yazi"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.yazi.theme = {
      # App - Overall terminal background
      app = {
        overall = {
          bg = hexRaw colors.surface-base;
        };
      };

      # Indicator - Indicator bars for different panes
      indicator = {
        parent = {
          fg = hexRaw colors.divider-primary;
        };
        current = {
          fg = hexRaw accent.secondary.Lc75;
        };
        preview = {
          fg = hexRaw colors.divider-secondary;
        };
      };

      # Tabs - Tab styling
      tabs = {
        active = {
          fg = hexRaw colors.text-primary;
          bg = hexRaw colors.surface-base;
          bold = true;
        };
        inactive = {
          fg = hexRaw colors.text-secondary;
          bg = hexRaw colors.surface-subtle;
        };
        sep_inner = {
          open = "[";
          close = "]";
        };
        sep_outer = {
          open = "";
          close = "";
        };
      };

      # Mode - Mode indicators (normal, select, unset)
      mode = {
        normal_main = mkModeStyle colors.surface-base accent.secondary.Lc75;
        normal_alt = mkColorPair accent.secondary.Lc75 colors.surface-emphasis;
        select_main = mkModeStyle colors.surface-base accent.primary.Lc75;
        select_alt = mkColorPair accent.primary.Lc75 colors.surface-emphasis;
        unset_main = mkModeStyle colors.surface-base accent.warning.Lc75;
        unset_alt = mkColorPair accent.warning.Lc75 colors.surface-emphasis;
      };

      # Manager (file list) colors
      manager = {
        cwd = {
          fg = hexRaw accent.secondary.Lc75;
        };
        hovered = {
          fg = hexRaw colors.text-primary;
          bg = hexRaw colors.surface-emphasis;
        };
        preview_hovered = {
          fg = hexRaw colors.text-primary;
          bg = hexRaw colors.surface-subtle;
        };
        find_keyword = {
          fg = hexRaw accent.warning.Lc75;
          bold = true;
        };
        find_position = {
          fg = hexRaw accent.secondary.Lc75;
          bg = "reset";
          italic = true;
        };
        marker_copied = mkMarker accent.primary.Lc75;
        marker_cut = mkMarker accent.danger.Lc75;
        marker_marked = mkMarker accent.secondary.Lc75;
        marker_selected = mkMarker accent.warning.Lc75;
        tab_active = {
          fg = hexRaw colors.text-primary;
          bg = hexRaw colors.surface-base;
        };
        tab_inactive = {
          fg = hexRaw colors.text-secondary;
          bg = hexRaw colors.surface-subtle;
        };
        tab_width = 1;
        border_symbol = "│";
        border_style = {
          fg = hexRaw colors.divider-primary;
        };
      };

      # Status line
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = hexRaw colors.surface-emphasis;
          bg = hexRaw colors.surface-emphasis;
        };
        mode_normal = mkModeStyle colors.surface-base accent.secondary.Lc75;
        mode_select = mkModeStyle colors.surface-base accent.primary.Lc75;
        mode_unset = mkModeStyle colors.surface-base accent.warning.Lc75;
        progress_label = {
          fg = hexRaw colors.text-primary;
          bold = true;
        };
        progress_normal = {
          fg = hexRaw accent.secondary.Lc75;
          bg = hexRaw colors.surface-emphasis;
        };
        progress_error = {
          fg = hexRaw accent.danger.Lc75;
          bg = hexRaw colors.surface-emphasis;
        };
        permissions_t = {
          fg = hexRaw accent.primary.Lc75;
        };
        permissions_r = {
          fg = hexRaw accent.warning.Lc75;
        };
        permissions_w = {
          fg = hexRaw accent.danger.Lc75;
        };
        permissions_x = {
          fg = hexRaw accent.primary.Lc75;
        };
        permissions_s = {
          fg = hexRaw accent.tertiary.Lc75;
        };
      };

      # Input line
      input = {
        border = {
          fg = hexRaw accent.secondary.Lc75;
        };
        title = { };
        value = {
          fg = hexRaw colors.text-primary;
        };
        selected = {
          bg = hexRaw colors.surface-emphasis;
        };
      };

      # Select component
      select = {
        border = {
          fg = hexRaw accent.secondary.Lc75;
        };
        active = {
          fg = hexRaw accent.primary.Lc75;
          bold = true;
        };
        inactive = {
          fg = hexRaw colors.text-secondary;
        };
      };

      # Tasks
      tasks = {
        border = {
          fg = hexRaw accent.secondary.Lc75;
        };
        title = { };
        hovered = {
          fg = hexRaw accent.primary.Lc75;
          underline = true;
        };
      };

      # Which (keybinding help)
      which = {
        mask = {
          bg = hexRaw colors.surface-base;
        };
        cand = {
          fg = hexRaw accent.secondary.Lc75;
        };
        rest = {
          fg = hexRaw colors.text-secondary;
        };
        desc = {
          fg = hexRaw colors.text-primary;
        };
        separator = "  ";
        separator_style = {
          fg = hexRaw colors.divider-secondary;
        };
      };

      # Help
      help = {
        on = {
          fg = hexRaw accent.primary.Lc75;
        };
        run = {
          fg = hexRaw accent.secondary.Lc75;
        };
        desc = {
          fg = hexRaw colors.text-secondary;
        };
        hovered = {
          bg = hexRaw colors.surface-emphasis;
          bold = true;
        };
        footer = {
          fg = hexRaw colors.text-secondary;
          bg = hexRaw colors.surface-base;
        };
      };

      # Confirm - Confirmation dialogs
      confirm = {
        border = {
          fg = hexRaw accent.secondary.Lc75;
        };
        title = {
          fg = hexRaw colors.text-primary;
          bold = true;
        };
        body = {
          fg = hexRaw colors.text-primary;
        };
        list = {
          fg = hexRaw colors.text-secondary;
        };
        btn_yes = {
          fg = hexRaw colors.surface-base;
          bg = hexRaw accent.primary.Lc75;
          bold = true;
        };
        btn_no = {
          fg = hexRaw colors.surface-base;
          bg = hexRaw accent.danger.Lc75;
          bold = true;
        };
        btn_labels = [
          "Yes"
          "No"
        ];
      };

      # Spot - Spotlight/table view
      spot = {
        border = {
          fg = hexRaw accent.secondary.Lc75;
        };
        title = {
          fg = hexRaw colors.text-primary;
          bold = true;
        };
        tbl_col = {
          fg = hexRaw accent.secondary.Lc75;
          bg = hexRaw colors.surface-emphasis;
        };
        tbl_cell = {
          fg = hexRaw colors.text-primary;
          bg = hexRaw colors.surface-subtle;
        };
      };

      # Notify - Notification styling
      notify = {
        title_info = {
          fg = hexRaw accent.secondary.Lc75;
          bold = true;
        };
        title_warn = {
          fg = hexRaw accent.warning.Lc75;
          bold = true;
        };
        title_error = {
          fg = hexRaw accent.danger.Lc75;
          bold = true;
        };
      };

      # Pick - Picker/selection UI
      pick = {
        border = {
          fg = hexRaw accent.secondary.Lc75;
        };
        active = {
          fg = hexRaw accent.primary.Lc75;
          bold = true;
        };
        inactive = {
          fg = hexRaw colors.text-secondary;
        };
      };

      # Cmp - Completion menu
      cmp = {
        border = {
          fg = hexRaw accent.secondary.Lc75;
        };
        active = {
          fg = hexRaw colors.text-primary;
          bg = hexRaw colors.surface-emphasis;
          bold = true;
        };
        inactive = {
          fg = hexRaw colors.text-secondary;
        };
        icon_file = "";
        icon_folder = "";
        icon_command = "";
      };

      # File-specific colors
      filetype = {
        rules = [
          # Directories
          {
            mime = "inode/directory";
            fg = hexRaw accent.secondary.Lc75;
            bold = true;
          }
          # Executables
          {
            name = "*";
            is = "exec";
            fg = hexRaw accent.primary.Lc75;
          }
          # Links
          {
            name = "*";
            is = "link";
            fg = hexRaw accent.secondary.Lc75;
          }
          # Orphan links
          {
            name = "*";
            is = "orphan";
            fg = hexRaw accent.danger.Lc75;
          }
          # Documents
          {
            mime = "text/*";
            fg = hexRaw colors.text-primary;
          }
          # Images
          {
            mime = "image/*";
            fg = hexRaw accent.warning.Lc75;
          }
          # Videos
          {
            mime = "video/*";
            fg = hexRaw accent.tertiary.Lc75;
          }
          # Audio
          {
            mime = "audio/*";
            fg = hexRaw accent.secondary.Lc75;
          }
          # Archives
          {
            mime = "application/*zip";
            fg = hexRaw accent.danger.Lc75;
          }
          {
            mime = "application/*tar";
            fg = hexRaw accent.danger.Lc75;
          }
          {
            mime = "application/*rar";
            fg = hexRaw accent.danger.Lc75;
          }
        ];
      };
    };
  };
}
