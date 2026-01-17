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
    window-bg = signalColors.tonal."surface-subtle".hex;
    window-fg = signalColors.tonal."text-primary".hex;
    view-bg = signalColors.tonal."surface-base".hex;
    view-fg = signalColors.tonal."text-primary".hex;
    headerbar-bg = signalColors.tonal."surface-subtle".hex;
    headerbar-fg = signalColors.tonal."text-primary".hex;
    headerbar-border = signalColors.tonal."text-primary".hex;
    headerbar-backdrop = signalColors.tonal."surface-base".hex;
    headerbar-shade = signalColors.tonal."divider-primary".hex;
    headerbar-darker-shade = signalColors.tonal."divider-strong".hex;
    sidebar-bg = signalColors.tonal."surface-hover".hex;
    sidebar-fg = signalColors.tonal."text-primary".hex;
    sidebar-backdrop = signalColors.tonal."surface-subtle".hex;
    sidebar-shade = signalColors.tonal."divider-primary".hex;
    sidebar-border = signalColors.tonal."divider-primary".hex;
    secondary-sidebar-bg = signalColors.tonal."surface-hover".hex;
    secondary-sidebar-fg = signalColors.tonal."text-primary".hex;
    secondary-sidebar-backdrop = signalColors.tonal."surface-subtle".hex;
    secondary-sidebar-shade = signalColors.tonal."divider-primary".hex;
    secondary-sidebar-border = signalColors.tonal."divider-primary".hex;
    card-bg = signalColors.tonal."surface-base".hex;
    card-fg = signalColors.tonal."text-primary".hex;
    card-shade = signalColors.tonal."divider-primary".hex;
    dialog-bg = signalColors.tonal."surface-subtle".hex;
    dialog-fg = signalColors.tonal."text-primary".hex;
    popover-bg = signalColors.tonal."surface-base".hex;
    popover-fg = signalColors.tonal."text-primary".hex;
    popover-shade = signalColors.tonal."divider-primary".hex;
    thumbnail-bg = signalColors.tonal."surface-base".hex;
    thumbnail-fg = signalColors.tonal."text-primary".hex;
    shade = signalColors.tonal."divider-primary".hex;
    scrollbar-outline = signalColors.tonal."surface-base".hex;
  } else {
    # Dark mode colors - using available Signal palette colors
    window-bg = signalColors.tonal."surface-hover".hex;
    window-fg = signalColors.tonal."text-primary".hex;
    view-bg = signalColors.tonal."surface-base".hex;
    view-fg = signalColors.tonal."text-primary".hex;
    headerbar-bg = signalColors.tonal."surface-hover".hex;
    headerbar-fg = signalColors.tonal."text-primary".hex;
    headerbar-border = signalColors.tonal."text-primary".hex;
    headerbar-backdrop = signalColors.tonal."surface-base".hex;
    headerbar-shade = signalColors.tonal."divider-strong".hex;
    headerbar-darker-shade = signalColors.tonal."divider-strong".hex;
    sidebar-bg = signalColors.tonal."surface-hover".hex;
    sidebar-fg = signalColors.tonal."text-primary".hex;
    sidebar-backdrop = signalColors.tonal."surface-subtle".hex;
    sidebar-shade = signalColors.tonal."divider-primary".hex;
    sidebar-border = signalColors.tonal."divider-strong".hex;
    secondary-sidebar-bg = signalColors.tonal."surface-subtle".hex;
    secondary-sidebar-fg = signalColors.tonal."text-primary".hex;
    secondary-sidebar-backdrop = signalColors.tonal."surface-subtle".hex;
    secondary-sidebar-shade = signalColors.tonal."divider-primary".hex;
    secondary-sidebar-border = signalColors.tonal."divider-strong".hex;
    card-bg = signalColors.tonal."surface-hover".hex;
    card-fg = signalColors.tonal."text-primary".hex;
    card-shade = signalColors.tonal."divider-strong".hex;
    dialog-bg = signalColors.tonal."surface-hover".hex;
    dialog-fg = signalColors.tonal."text-primary".hex;
    popover-bg = signalColors.tonal."surface-base".hex;
    popover-fg = signalColors.tonal."text-primary".hex;
    popover-shade = signalColors.tonal."divider-primary".hex;
    thumbnail-bg = signalColors.tonal."surface-base".hex;
    thumbnail-fg = signalColors.tonal."text-primary".hex;
    shade = signalColors.tonal."divider-primary".hex;
    scrollbar-outline = signalColors.tonal."surface-subtle".hex;
  };

  inherit (signalColors) accent;

  # Map Signal colors to Adwaita palette
  # These are the standard GNOME color palette that GTK apps use
  adwaitaPalette = {
    # Blues - Using Signal secondary accent
    blue_1 = accent.secondary.Lc85.hex;
    blue_2 = accent.secondary.Lc75.hex;
    blue_3 = accent.secondary.Lc65.hex;
    blue_4 = accent.secondary.Lc60.hex;
    blue_5 = accent.secondary.Lc55.hex;
    
    # Greens - Using Signal primary accent (success)
    green_1 = accent.primary.Lc85.hex;
    green_2 = accent.primary.Lc75.hex;
    green_3 = accent.primary.Lc65.hex;
    green_4 = accent.primary.Lc60.hex;
    green_5 = accent.primary.Lc55.hex;
    
    # Yellows - Using Signal warning accent
    yellow_1 = accent.warning.Lc85.hex;
    yellow_2 = accent.warning.Lc75.hex;
    yellow_3 = accent.warning.Lc65.hex;
    yellow_4 = accent.warning.Lc60.hex;
    yellow_5 = accent.warning.Lc55.hex;
    
    # Oranges - Using Signal warning accent (shifted)
    orange_1 = accent.warning.Lc80.hex;
    orange_2 = accent.warning.Lc70.hex;
    orange_3 = accent.warning.Lc60.hex;
    orange_4 = accent.warning.Lc55.hex;
    orange_5 = accent.warning.Lc50.hex;
    
    # Reds - Using Signal danger accent
    red_1 = accent.danger.Lc85.hex;
    red_2 = accent.danger.Lc75.hex;
    red_3 = accent.danger.Lc65.hex;
    red_4 = accent.danger.Lc60.hex;
    red_5 = accent.danger.Lc55.hex;
    
    # Purples - Using Signal tertiary accent
    purple_1 = accent.tertiary.Lc85.hex;
    purple_2 = accent.tertiary.Lc75.hex;
    purple_3 = accent.tertiary.Lc65.hex;
    purple_4 = accent.tertiary.Lc60.hex;
    purple_5 = accent.tertiary.Lc55.hex;
    
    # Browns - Using neutral tonal colors
    brown_1 = signalColors.tonal."text-tertiary".hex;
    brown_2 = signalColors.tonal."text-secondary".hex;
    brown_3 = signalColors.tonal."text-primary".hex;
    brown_4 = signalColors.tonal."divider-strong".hex;
    brown_5 = signalColors.tonal."divider-primary".hex;
    
    # Light grays (light_1 through light_5)
    light_1 = if themeMode == "light" then "#ffffff" else signalColors.tonal."surface-base".hex;
    light_2 = if themeMode == "light" then signalColors.tonal."surface-base".hex else signalColors.tonal."surface-subtle".hex;
    light_3 = if themeMode == "light" then signalColors.tonal."surface-subtle".hex else signalColors.tonal."surface-hover".hex;
    light_4 = if themeMode == "light" then signalColors.tonal."divider-primary".hex else signalColors.tonal."divider-primary".hex;
    light_5 = if themeMode == "light" then signalColors.tonal."divider-strong".hex else signalColors.tonal."divider-strong".hex;
    
    # Dark grays (dark_1 through dark_5)
    dark_1 = if themeMode == "light" then signalColors.tonal."text-tertiary".hex else signalColors.tonal."divider-strong".hex;
    dark_2 = if themeMode == "light" then signalColors.tonal."text-secondary".hex else signalColors.tonal."text-tertiary".hex;
    dark_3 = if themeMode == "light" then signalColors.tonal."surface-hover".hex else signalColors.tonal."surface-hover".hex;
    dark_4 = if themeMode == "light" then signalColors.tonal."surface-subtle".hex else signalColors.tonal."surface-subtle".hex;
    dark_5 = if themeMode == "light" then signalColors.tonal."surface-base".hex else "#000000";
  };

  # Generate GTK CSS with ALL Adwaita named colors
  gtkCss = ''
    /* Signal Color Theme - Complete Adwaita Named Colors */
    
    /* ============================================ */
    /* Adwaita Color Palette                        */
    /* ============================================ */
    
    /* Blues */
    @define-color blue_1 ${adwaitaPalette.blue_1};
    @define-color blue_2 ${adwaitaPalette.blue_2};
    @define-color blue_3 ${adwaitaPalette.blue_3};
    @define-color blue_4 ${adwaitaPalette.blue_4};
    @define-color blue_5 ${adwaitaPalette.blue_5};
    
    /* Greens */
    @define-color green_1 ${adwaitaPalette.green_1};
    @define-color green_2 ${adwaitaPalette.green_2};
    @define-color green_3 ${adwaitaPalette.green_3};
    @define-color green_4 ${adwaitaPalette.green_4};
    @define-color green_5 ${adwaitaPalette.green_5};
    
    /* Yellows */
    @define-color yellow_1 ${adwaitaPalette.yellow_1};
    @define-color yellow_2 ${adwaitaPalette.yellow_2};
    @define-color yellow_3 ${adwaitaPalette.yellow_3};
    @define-color yellow_4 ${adwaitaPalette.yellow_4};
    @define-color yellow_5 ${adwaitaPalette.yellow_5};
    
    /* Oranges */
    @define-color orange_1 ${adwaitaPalette.orange_1};
    @define-color orange_2 ${adwaitaPalette.orange_2};
    @define-color orange_3 ${adwaitaPalette.orange_3};
    @define-color orange_4 ${adwaitaPalette.orange_4};
    @define-color orange_5 ${adwaitaPalette.orange_5};
    
    /* Reds */
    @define-color red_1 ${adwaitaPalette.red_1};
    @define-color red_2 ${adwaitaPalette.red_2};
    @define-color red_3 ${adwaitaPalette.red_3};
    @define-color red_4 ${adwaitaPalette.red_4};
    @define-color red_5 ${adwaitaPalette.red_5};
    
    /* Purples */
    @define-color purple_1 ${adwaitaPalette.purple_1};
    @define-color purple_2 ${adwaitaPalette.purple_2};
    @define-color purple_3 ${adwaitaPalette.purple_3};
    @define-color purple_4 ${adwaitaPalette.purple_4};
    @define-color purple_5 ${adwaitaPalette.purple_5};
    
    /* Browns */
    @define-color brown_1 ${adwaitaPalette.brown_1};
    @define-color brown_2 ${adwaitaPalette.brown_2};
    @define-color brown_3 ${adwaitaPalette.brown_3};
    @define-color brown_4 ${adwaitaPalette.brown_4};
    @define-color brown_5 ${adwaitaPalette.brown_5};
    
    /* Light grays */
    @define-color light_1 ${adwaitaPalette.light_1};
    @define-color light_2 ${adwaitaPalette.light_2};
    @define-color light_3 ${adwaitaPalette.light_3};
    @define-color light_4 ${adwaitaPalette.light_4};
    @define-color light_5 ${adwaitaPalette.light_5};
    
    /* Dark grays */
    @define-color dark_1 ${adwaitaPalette.dark_1};
    @define-color dark_2 ${adwaitaPalette.dark_2};
    @define-color dark_3 ${adwaitaPalette.dark_3};
    @define-color dark_4 ${adwaitaPalette.dark_4};
    @define-color dark_5 ${adwaitaPalette.dark_5};
    
    /* ============================================ */
    /* Legacy GTK 3 Base Colors                     */
    /* ============================================ */
    
    @define-color theme_bg_color ${colors.window-bg};
    @define-color theme_fg_color ${colors.window-fg};
    @define-color theme_base_color ${colors.view-bg};
    @define-color theme_text_color ${colors.view-fg};
    @define-color theme_selected_bg_color ${accent.secondary.Lc60.hex};
    @define-color theme_selected_fg_color ${colors.view-bg};
    
    @define-color insensitive_bg_color ${colors.window-bg};
    @define-color insensitive_fg_color ${colors.shade};
    @define-color insensitive_base_color ${colors.view-bg};
    
    @define-color borders ${colors.shade};
    @define-color unfocused_borders ${colors.shade};
    
    @define-color wm_title ${colors.headerbar-fg};
    @define-color wm_unfocused_title ${colors.headerbar-fg};
    @define-color wm_bg ${colors.headerbar-bg};
    @define-color wm_border ${colors.headerbar-border};

    /* ============================================ */
    /* Modern GTK 4 / Adwaita Named Colors          */
    /* ============================================ */

    /* Destructive action buttons */
    @define-color destructive_bg_color ${accent.danger.Lc60.hex};
    @define-color destructive_fg_color ${colors.view-bg};
    @define-color destructive_color ${accent.danger.Lc75.hex};

    /* Success states (levelbars, entries, labels, infobars) */
    @define-color success_bg_color ${accent.primary.Lc60.hex};
    @define-color success_fg_color ${colors.view-bg};
    @define-color success_color ${accent.primary.Lc75.hex};

    /* Warning states */
    @define-color warning_bg_color ${accent.warning.Lc60.hex};
    @define-color warning_fg_color ${if themeMode == "light" then signalColors.tonal."text-primary" else colors.view-bg}.hex;
    @define-color warning_color ${accent.warning.Lc75.hex};

    /* Error states */
    @define-color error_bg_color ${accent.danger.Lc60.hex};
    @define-color error_fg_color ${colors.view-bg};
    @define-color error_color ${accent.danger.Lc75.hex};

    /* Accent colors */
    @define-color accent_bg_color ${accent.secondary.Lc60.hex};
    @define-color accent_fg_color ${colors.view-bg};
    @define-color accent_color ${accent.secondary.Lc75.hex};

    /* Window colors */
    @define-color window_bg_color ${colors.window-bg};
    @define-color window_fg_color ${colors.window-fg};

    /* View colors (text view, tree view) */
    @define-color view_bg_color ${colors.view-bg};
    @define-color view_fg_color ${colors.view-fg};

    /* Header bar, search bar, tab bar */
    @define-color headerbar_bg_color ${colors.headerbar-bg};
    @define-color headerbar_fg_color ${colors.headerbar-fg};
    @define-color headerbar_border_color ${colors.headerbar-border};
    @define-color headerbar_backdrop_color ${colors.headerbar-backdrop};
    @define-color headerbar_shade_color ${colors.headerbar-shade};
    @define-color headerbar_darker_shade_color ${colors.headerbar-darker-shade};

    /* Split pane views - Primary sidebar */
    @define-color sidebar_bg_color ${colors.sidebar-bg};
    @define-color sidebar_fg_color ${colors.sidebar-fg};
    @define-color sidebar_backdrop_color ${colors.sidebar-backdrop};
    @define-color sidebar_shade_color ${colors.sidebar-shade};
    @define-color sidebar_border_color ${colors.sidebar-border};

    /* Split pane views - Secondary sidebar */
    @define-color secondary_sidebar_bg_color ${colors.secondary-sidebar-bg};
    @define-color secondary_sidebar_fg_color ${colors.secondary-sidebar-fg};
    @define-color secondary_sidebar_backdrop_color ${colors.secondary-sidebar-backdrop};
    @define-color secondary_sidebar_shade_color ${colors.secondary-sidebar-shade};
    @define-color secondary_sidebar_border_color ${colors.secondary-sidebar-border};

    /* Cards, boxed lists */
    @define-color card_bg_color ${colors.card-bg};
    @define-color card_fg_color ${colors.card-fg};
    @define-color card_shade_color ${colors.card-shade};

    /* Dialogs */
    @define-color dialog_bg_color ${colors.dialog-bg};
    @define-color dialog_fg_color ${colors.dialog-fg};

    /* Popovers */
    @define-color popover_bg_color ${colors.popover-bg};
    @define-color popover_fg_color ${colors.popover-fg};
    @define-color popover_shade_color ${colors.popover-shade};

    /* Thumbnails */
    @define-color thumbnail_bg_color ${colors.thumbnail-bg};
    @define-color thumbnail_fg_color ${colors.thumbnail-fg};

    /* Miscellaneous */
    @define-color shade_color ${colors.shade};
    @define-color scrollbar_outline_color ${colors.scrollbar-outline};

    /* ============================================ */
    /* Button Styles                                 */
    /* ============================================ */

    /* Secondary/normal buttons */
    button {
      background-color: ${colors.card-bg};
      color: ${colors.window-fg};
      border-color: ${colors.shade};
    }

    button:hover {
      background-color: ${colors.sidebar-bg};
    }

    /* Primary/selected buttons (suggested-action) */
    button.suggested-action,
    button:active,
    button:checked {
      background-color: ${accent.secondary.Lc60.hex};
      color: ${colors.view-bg};
    }

    button.suggested-action:hover {
      background-color: ${accent.secondary.Lc75.hex};
    }

    button:disabled {
      background-color: ${colors.window-bg};
      color: ${colors.shade};
    }
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
