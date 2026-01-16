{
  config,
  lib,
  signalColors,
  ...
}: let
  inherit (lib) mkIf removePrefix;
  cfg = config.theming.signal;
  
  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-subtle = signalColors.tonal."divider-Lc15";
    surface-emphasis = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    divider-primary = signalColors.tonal."divider-Lc15";
    divider-secondary = signalColors.tonal."divider-Lc30";
  };
  
  accent = signalColors.accent;
  
  # Helper to get hex without # prefix
  hexRaw = color: removePrefix "#" color.hex;
in {
  config = mkIf (cfg.enable && cfg.cli.yazi.enable) {
    programs.yazi.theme = {
      # Manager (file list) colors
      manager = {
        cwd = {
          fg = hexRaw accent.focus.Lc75;
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
          fg = hexRaw accent.info.Lc75;
          bg = "reset";
          italic = true;
        };
        marker_copied = {
          fg = hexRaw accent.success.Lc75;
          bg = hexRaw accent.success.Lc75;
        };
        marker_cut = {
          fg = hexRaw accent.danger.Lc75;
          bg = hexRaw accent.danger.Lc75;
        };
        marker_marked = {
          fg = hexRaw accent.focus.Lc75;
          bg = hexRaw accent.focus.Lc75;
        };
        marker_selected = {
          fg = hexRaw accent.warning.Lc75;
          bg = hexRaw accent.warning.Lc75;
        };
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
        mode_normal = {
          fg = hexRaw colors.surface-base;
          bg = hexRaw accent.focus.Lc75;
          bold = true;
        };
        mode_select = {
          fg = hexRaw colors.surface-base;
          bg = hexRaw accent.success.Lc75;
          bold = true;
        };
        mode_unset = {
          fg = hexRaw colors.surface-base;
          bg = hexRaw accent.warning.Lc75;
          bold = true;
        };
        progress_label = {
          fg = hexRaw colors.text-primary;
          bold = true;
        };
        progress_normal = {
          fg = hexRaw accent.focus.Lc75;
          bg = hexRaw colors.surface-emphasis;
        };
        progress_error = {
          fg = hexRaw accent.danger.Lc75;
          bg = hexRaw colors.surface-emphasis;
        };
        permissions_t = {
          fg = hexRaw accent.success.Lc75;
        };
        permissions_r = {
          fg = hexRaw accent.warning.Lc75;
        };
        permissions_w = {
          fg = hexRaw accent.danger.Lc75;
        };
        permissions_x = {
          fg = hexRaw accent.success.Lc75;
        };
        permissions_s = {
          fg = hexRaw accent.special.Lc75;
        };
      };

      # Input line
      input = {
        border = {
          fg = hexRaw accent.focus.Lc75;
        };
        title = {};
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
          fg = hexRaw accent.focus.Lc75;
        };
        active = {
          fg = hexRaw accent.success.Lc75;
          bold = true;
        };
        inactive = {
          fg = hexRaw colors.text-secondary;
        };
      };

      # Tasks
      tasks = {
        border = {
          fg = hexRaw accent.focus.Lc75;
        };
        title = {};
        hovered = {
          fg = hexRaw accent.success.Lc75;
          underline = true;
        };
      };

      # Which (keybinding help)
      which = {
        mask = {
          bg = hexRaw colors.surface-base;
        };
        cand = {
          fg = hexRaw accent.info.Lc75;
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
          fg = hexRaw accent.success.Lc75;
        };
        run = {
          fg = hexRaw accent.info.Lc75;
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

      # File-specific colors
      filetype = {
        rules = [
          # Directories
          {
            mime = "inode/directory";
            fg = hexRaw accent.focus.Lc75;
            bold = true;
          }
          # Executables
          {
            name = "*";
            is = "exec";
            fg = hexRaw accent.success.Lc75;
          }
          # Links
          {
            name = "*";
            is = "link";
            fg = hexRaw accent.info.Lc75;
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
            fg = hexRaw accent.special.Lc75;
          }
          # Audio
          {
            mime = "audio/*";
            fg = hexRaw accent.info.Lc75;
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
