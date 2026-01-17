{
  config,
  lib,
  pkgs,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: gtk.gtk3.extraCss / gtk.gtk4.extraCss
# UPSTREAM SCHEMA: https://docs.gtk.org/gtk3/css-properties.html
# SCHEMA VERSION: GTK 3.24 / GTK 4.12
# LAST VALIDATED: 2026-01-17
# NOTES: GTK theming requires CSS overrides using @define-color directives.
#        Home-Manager provides extraCss for custom CSS. No structured GTK color
#        options exist. Uses Adwaita base theme with color overrides.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-subtle = signalColors.tonal."divider-Lc15";
    surface-emphasis = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-tertiary = signalColors.tonal."text-Lc45";
    divider-primary = signalColors.tonal."divider-Lc15";
    divider-secondary = signalColors.tonal."divider-Lc30";
  };

  inherit (signalColors) accent;

  # Generate GTK CSS
  gtkCss = ''
    /* Signal Color Theme - GTK Overrides */

    /* Base color definitions */
    @define-color theme_bg_color ${colors.surface-base.hex};
    @define-color theme_fg_color ${colors.text-primary.hex};
    @define-color theme_base_color ${colors.surface-base.hex};
    @define-color theme_text_color ${colors.text-primary.hex};
    @define-color theme_selected_bg_color ${accent.focus.Lc75.hex};
    @define-color theme_selected_fg_color ${colors.surface-base.hex};

    /* Insensitive (disabled) states */
    @define-color insensitive_bg_color ${colors.surface-subtle.hex};
    @define-color insensitive_fg_color ${colors.text-tertiary.hex};
    @define-color insensitive_base_color ${colors.surface-subtle.hex};

    /* Borders */
    @define-color borders ${colors.divider-primary.hex};
    @define-color unfocused_borders ${colors.divider-primary.hex};
    @define-color divider_color ${colors.divider-primary.hex};

    /* State colors */
    @define-color warning_color ${accent.warning.Lc75.hex};
    @define-color error_color ${accent.danger.Lc75.hex};
    @define-color success_color ${accent.success.Lc75.hex};

    /* Window decorations */
    @define-color wm_title ${colors.text-primary.hex};
    @define-color wm_unfocused_title ${colors.text-secondary.hex};
    @define-color wm_bg ${colors.surface-base.hex};
    @define-color wm_border ${colors.divider-secondary.hex};

    /* Additional semantic colors */
    @define-color accent_bg_color ${accent.focus.Lc75.hex};
    @define-color accent_fg_color ${colors.surface-base.hex};
    @define-color accent_color ${accent.focus.Lc75.hex};
    @define-color destructive_bg_color ${accent.danger.Lc75.hex};
    @define-color destructive_fg_color ${colors.surface-base.hex};
    @define-color destructive_color ${accent.danger.Lc75.hex};

    /* View colors */
    @define-color view_bg_color ${colors.surface-base.hex};
    @define-color view_fg_color ${colors.text-primary.hex};

    /* Hover states */
    @define-color theme_hover_color ${colors.surface-subtle.hex};

    /* Card backgrounds */
    @define-color card_bg_color ${colors.surface-subtle.hex};
    @define-color card_fg_color ${colors.text-primary.hex};

    /* Dialog backgrounds */
    @define-color dialog_bg_color ${colors.surface-base.hex};
    @define-color dialog_fg_color ${colors.text-primary.hex};

    /* Popover backgrounds */
    @define-color popover_bg_color ${colors.surface-subtle.hex};
    @define-color popover_fg_color ${colors.text-primary.hex};
  '';

  # Check if gtk should be themed
  # Note: GTK uses config.gtk.enable (not programs.gtk.enable) so we keep custom logic
  shouldTheme = cfg.gtk.enable || (cfg.autoEnable && (config.gtk.enable or false));
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    gtk = {
      theme = {
        name = if themeMode == "light" then "Adwaita" else "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      gtk3.extraCss = gtkCss;
      gtk4.extraCss = gtkCss;
    };
  };
}
