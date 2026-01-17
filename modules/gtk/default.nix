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

  # Color mappings based on theme mode
  # Light mode uses lighter surfaces, dark mode uses darker surfaces
  colors = if themeMode == "light" then {
    # Light mode colors - using available Signal palette colors
    window-bg = signalColors.tonal."surface-Lc05";
    window-fg = signalColors.tonal."text-Lc75";
    view-bg = signalColors.tonal."surface-Lc05";
    view-fg = signalColors.tonal."text-Lc75";
    headerbar-bg = signalColors.tonal."surface-Lc05";
    headerbar-fg = signalColors.tonal."text-Lc75";
    headerbar-border = signalColors.tonal."text-Lc75";
    headerbar-backdrop = signalColors.tonal."surface-Lc05";
    headerbar-shade = signalColors.tonal."divider-Lc12";
    headerbar-darker-shade = signalColors.tonal."divider-Lc12";
    sidebar-bg = signalColors.tonal."surface-Lc10";
    sidebar-fg = signalColors.tonal."text-Lc75";
    sidebar-backdrop = signalColors.tonal."surface-Lc05";
    sidebar-shade = signalColors.tonal."divider-Lc07";
    sidebar-border = signalColors.tonal."divider-Lc07";
    secondary-sidebar-bg = signalColors.tonal."surface-Lc10";
    secondary-sidebar-fg = signalColors.tonal."text-Lc75";
    secondary-sidebar-backdrop = signalColors.tonal."surface-Lc05";
    secondary-sidebar-shade = signalColors.tonal."divider-Lc07";
    secondary-sidebar-border = signalColors.tonal."divider-Lc07";
    card-bg = signalColors.tonal."surface-Lc05";
    card-fg = signalColors.tonal."text-Lc75";
    card-shade = signalColors.tonal."divider-Lc07";
    dialog-bg = signalColors.tonal."surface-Lc05";
    dialog-fg = signalColors.tonal."text-Lc75";
    popover-bg = signalColors.tonal."surface-Lc05";
    popover-fg = signalColors.tonal."text-Lc75";
    popover-shade = signalColors.tonal."divider-Lc07";
    thumbnail-bg = signalColors.tonal."surface-Lc05";
    thumbnail-fg = signalColors.tonal."text-Lc75";
    shade = signalColors.tonal."divider-Lc07";
    scrollbar-outline = signalColors.tonal."surface-Lc05";
  } else {
    # Dark mode colors - using available Signal palette colors
    window-bg = signalColors.tonal."surface-Lc10";
    window-fg = signalColors.tonal."text-Lc75";
    view-bg = signalColors.tonal."surface-Lc10";
    view-fg = signalColors.tonal."text-Lc75";
    headerbar-bg = signalColors.tonal."surface-Lc10";
    headerbar-fg = signalColors.tonal."text-Lc75";
    headerbar-border = signalColors.tonal."text-Lc75";
    headerbar-backdrop = signalColors.tonal."surface-Lc10";
    headerbar-shade = signalColors.tonal."divider-Lc12";
    headerbar-darker-shade = signalColors.tonal."divider-Lc12";
    sidebar-bg = signalColors.tonal."surface-Lc10";
    sidebar-fg = signalColors.tonal."text-Lc75";
    sidebar-backdrop = signalColors.tonal."surface-Lc05";
    sidebar-shade = signalColors.tonal."divider-Lc07";
    sidebar-border = signalColors.tonal."divider-Lc12";
    secondary-sidebar-bg = signalColors.tonal."surface-Lc05";
    secondary-sidebar-fg = signalColors.tonal."text-Lc75";
    secondary-sidebar-backdrop = signalColors.tonal."surface-Lc05";
    secondary-sidebar-shade = signalColors.tonal."divider-Lc07";
    secondary-sidebar-border = signalColors.tonal."divider-Lc12";
    card-bg = signalColors.tonal."surface-Lc10";
    card-fg = signalColors.tonal."text-Lc75";
    card-shade = signalColors.tonal."divider-Lc12";
    dialog-bg = signalColors.tonal."surface-Lc10";
    dialog-fg = signalColors.tonal."text-Lc75";
    popover-bg = signalColors.tonal."surface-Lc10";
    popover-fg = signalColors.tonal."text-Lc75";
    popover-shade = signalColors.tonal."divider-Lc07";
    thumbnail-bg = signalColors.tonal."surface-Lc10";
    thumbnail-fg = signalColors.tonal."text-Lc75";
    shade = signalColors.tonal."divider-Lc07";
    scrollbar-outline = signalColors.tonal."surface-Lc05";
  };

  inherit (signalColors) accent;

  # Generate GTK CSS with ALL Adwaita named colors
  gtkCss = ''
    /* Signal Color Theme - Complete Adwaita Named Colors */
    
    /* ============================================ */
    /* Legacy GTK 3 Base Colors                     */
    /* ============================================ */
    
    @define-color theme_bg_color ${colors.window-bg.hex};
    @define-color theme_fg_color ${colors.window-fg.hex};
    @define-color theme_base_color ${colors.view-bg.hex};
    @define-color theme_text_color ${colors.view-fg.hex};
    @define-color theme_selected_bg_color ${accent.focus.Lc60.hex};
    @define-color theme_selected_fg_color ${colors.view-bg.hex};
    
    @define-color insensitive_bg_color ${colors.window-bg.hex};
    @define-color insensitive_fg_color ${colors.shade.hex};
    @define-color insensitive_base_color ${colors.view-bg.hex};
    
    @define-color borders ${colors.shade.hex};
    @define-color unfocused_borders ${colors.shade.hex};
    
    @define-color wm_title ${colors.headerbar-fg.hex};
    @define-color wm_unfocused_title ${colors.headerbar-fg.hex};
    @define-color wm_bg ${colors.headerbar-bg.hex};
    @define-color wm_border ${colors.headerbar-border.hex};

    /* ============================================ */
    /* Modern GTK 4 / Adwaita Named Colors          */
    /* ============================================ */

    /* Destructive action buttons */
    @define-color destructive_bg_color ${accent.danger.Lc60.hex};
    @define-color destructive_fg_color ${colors.view-bg.hex};
    @define-color destructive_color ${accent.danger.Lc50.hex};

    /* Success states (levelbars, entries, labels, infobars) */
    @define-color success_bg_color ${accent.success.Lc60.hex};
    @define-color success_fg_color ${colors.view-bg.hex};
    @define-color success_color ${accent.success.Lc50.hex};

    /* Warning states */
    @define-color warning_bg_color ${accent.warning.Lc60.hex};
    @define-color warning_fg_color ${if themeMode == "light" then signalColors.tonal."text-Lc75" else colors.view-bg}.hex;
    @define-color warning_color ${accent.warning.Lc50.hex};

    /* Error states */
    @define-color error_bg_color ${accent.danger.Lc60.hex};
    @define-color error_fg_color ${colors.view-bg.hex};
    @define-color error_color ${accent.danger.Lc50.hex};

    /* Accent colors */
    @define-color accent_bg_color ${accent.focus.Lc60.hex};
    @define-color accent_fg_color ${colors.view-bg.hex};
    @define-color accent_color ${accent.focus.Lc50.hex};

    /* Window colors */
    @define-color window_bg_color ${colors.window-bg.hex};
    @define-color window_fg_color ${colors.window-fg.hex};

    /* View colors (text view, tree view) */
    @define-color view_bg_color ${colors.view-bg.hex};
    @define-color view_fg_color ${colors.view-fg.hex};

    /* Header bar, search bar, tab bar */
    @define-color headerbar_bg_color ${colors.headerbar-bg.hex};
    @define-color headerbar_fg_color ${colors.headerbar-fg.hex};
    @define-color headerbar_border_color ${colors.headerbar-border.hex};
    @define-color headerbar_backdrop_color ${colors.headerbar-backdrop.hex};
    @define-color headerbar_shade_color ${colors.headerbar-shade.hex};
    @define-color headerbar_darker_shade_color ${colors.headerbar-darker-shade.hex};

    /* Split pane views - Primary sidebar */
    @define-color sidebar_bg_color ${colors.sidebar-bg.hex};
    @define-color sidebar_fg_color ${colors.sidebar-fg.hex};
    @define-color sidebar_backdrop_color ${colors.sidebar-backdrop.hex};
    @define-color sidebar_shade_color ${colors.sidebar-shade.hex};
    @define-color sidebar_border_color ${colors.sidebar-border.hex};

    /* Split pane views - Secondary sidebar */
    @define-color secondary_sidebar_bg_color ${colors.secondary-sidebar-bg.hex};
    @define-color secondary_sidebar_fg_color ${colors.secondary-sidebar-fg.hex};
    @define-color secondary_sidebar_backdrop_color ${colors.secondary-sidebar-backdrop.hex};
    @define-color secondary_sidebar_shade_color ${colors.secondary-sidebar-shade.hex};
    @define-color secondary_sidebar_border_color ${colors.secondary-sidebar-border.hex};

    /* Cards, boxed lists */
    @define-color card_bg_color ${colors.card-bg.hex};
    @define-color card_fg_color ${colors.card-fg.hex};
    @define-color card_shade_color ${colors.card-shade.hex};

    /* Dialogs */
    @define-color dialog_bg_color ${colors.dialog-bg.hex};
    @define-color dialog_fg_color ${colors.dialog-fg.hex};

    /* Popovers */
    @define-color popover_bg_color ${colors.popover-bg.hex};
    @define-color popover_fg_color ${colors.popover-fg.hex};
    @define-color popover_shade_color ${colors.popover-shade.hex};

    /* Thumbnails */
    @define-color thumbnail_bg_color ${colors.thumbnail-bg.hex};
    @define-color thumbnail_fg_color ${colors.thumbnail-fg.hex};

    /* Miscellaneous */
    @define-color shade_color ${colors.shade.hex};
    @define-color scrollbar_outline_color ${colors.scrollbar-outline.hex};
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
