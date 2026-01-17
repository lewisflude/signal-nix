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
    window-bg = signalColors.tonal."surface-subtle";
    window-fg = signalColors.tonal."text-primary";
    view-bg = signalColors.tonal."surface-base";
    view-fg = signalColors.tonal."text-primary";
    headerbar-bg = signalColors.tonal."surface-subtle";
    headerbar-fg = signalColors.tonal."text-primary";
    headerbar-border = signalColors.tonal."text-primary";
    headerbar-backdrop = signalColors.tonal."surface-base";
    headerbar-shade = signalColors.tonal."divider-primary";
    headerbar-darker-shade = signalColors.tonal."divider-strong";
    sidebar-bg = signalColors.tonal."surface-hover";
    sidebar-fg = signalColors.tonal."text-primary";
    sidebar-backdrop = signalColors.tonal."surface-subtle";
    sidebar-shade = signalColors.tonal."divider-primary";
    sidebar-border = signalColors.tonal."divider-primary";
    secondary-sidebar-bg = signalColors.tonal."surface-hover";
    secondary-sidebar-fg = signalColors.tonal."text-primary";
    secondary-sidebar-backdrop = signalColors.tonal."surface-subtle";
    secondary-sidebar-shade = signalColors.tonal."divider-primary";
    secondary-sidebar-border = signalColors.tonal."divider-primary";
    card-bg = signalColors.tonal."surface-base";
    card-fg = signalColors.tonal."text-primary";
    card-shade = signalColors.tonal."divider-primary";
    dialog-bg = signalColors.tonal."surface-subtle";
    dialog-fg = signalColors.tonal."text-primary";
    popover-bg = signalColors.tonal."surface-base";
    popover-fg = signalColors.tonal."text-primary";
    popover-shade = signalColors.tonal."divider-primary";
    thumbnail-bg = signalColors.tonal."surface-base";
    thumbnail-fg = signalColors.tonal."text-primary";
    shade = signalColors.tonal."divider-primary";
    scrollbar-outline = signalColors.tonal."surface-base";
  } else {
    # Dark mode colors - using available Signal palette colors
    window-bg = signalColors.tonal."surface-hover";
    window-fg = signalColors.tonal."text-primary";
    view-bg = signalColors.tonal."surface-base";
    view-fg = signalColors.tonal."text-primary";
    headerbar-bg = signalColors.tonal."surface-hover";
    headerbar-fg = signalColors.tonal."text-primary";
    headerbar-border = signalColors.tonal."text-primary";
    headerbar-backdrop = signalColors.tonal."surface-base";
    headerbar-shade = signalColors.tonal."divider-strong";
    headerbar-darker-shade = signalColors.tonal."divider-strong";
    sidebar-bg = signalColors.tonal."surface-hover";
    sidebar-fg = signalColors.tonal."text-primary";
    sidebar-backdrop = signalColors.tonal."surface-subtle";
    sidebar-shade = signalColors.tonal."divider-primary";
    sidebar-border = signalColors.tonal."divider-strong";
    secondary-sidebar-bg = signalColors.tonal."surface-subtle";
    secondary-sidebar-fg = signalColors.tonal."text-primary";
    secondary-sidebar-backdrop = signalColors.tonal."surface-subtle";
    secondary-sidebar-shade = signalColors.tonal."divider-primary";
    secondary-sidebar-border = signalColors.tonal."divider-strong";
    card-bg = signalColors.tonal."surface-hover";
    card-fg = signalColors.tonal."text-primary";
    card-shade = signalColors.tonal."divider-strong";
    dialog-bg = signalColors.tonal."surface-hover";
    dialog-fg = signalColors.tonal."text-primary";
    popover-bg = signalColors.tonal."surface-base";
    popover-fg = signalColors.tonal."text-primary";
    popover-shade = signalColors.tonal."divider-primary";
    thumbnail-bg = signalColors.tonal."surface-base";
    thumbnail-fg = signalColors.tonal."text-primary";
    shade = signalColors.tonal."divider-primary";
    scrollbar-outline = signalColors.tonal."surface-subtle";
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
    @define-color theme_selected_bg_color ${accent.secondary.Lc60.hex};
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
    @define-color destructive_color ${accent.danger.Lc75.hex};

    /* Success states (levelbars, entries, labels, infobars) */
    @define-color success_bg_color ${accent.primary.Lc60.hex};
    @define-color success_fg_color ${colors.view-bg.hex};
    @define-color success_color ${accent.primary.Lc75.hex};

    /* Warning states */
    @define-color warning_bg_color ${accent.warning.Lc60.hex};
    @define-color warning_fg_color ${if themeMode == "light" then signalColors.tonal."text-primary" else colors.view-bg}.hex;
    @define-color warning_color ${accent.warning.Lc75.hex};

    /* Error states */
    @define-color error_bg_color ${accent.danger.Lc60.hex};
    @define-color error_fg_color ${colors.view-bg.hex};
    @define-color error_color ${accent.danger.Lc75.hex};

    /* Accent colors */
    @define-color accent_bg_color ${accent.secondary.Lc60.hex};
    @define-color accent_fg_color ${colors.view-bg.hex};
    @define-color accent_color ${accent.secondary.Lc75.hex};

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
