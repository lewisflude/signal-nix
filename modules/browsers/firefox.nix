{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-css (Tier 5)
# HOME-MANAGER MODULE: programs.firefox.profiles.<name>.userChrome
# UPSTREAM SCHEMA: https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/theme
# SCHEMA VERSION: 122.0
# LAST VALIDATED: 2026-01-17
# NOTES: Firefox uses userChrome.css for UI theming. This is advanced and may
#        break with Firefox updates. Home-Manager supports this via profile configs.
let
  inherit (lib) mkIf mkDefault;
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

  # Generate userChrome.css content
  userChromeCSS = ''
    /* Signal Firefox Theme */
    /* WARNING: This may break with Firefox updates */

    :root {
      --signal-bg: ${colors.surface-base.hex};
      --signal-bg-alt: ${colors.surface-raised.hex};
      --signal-bg-hover: ${colors.surface-hover.hex};
      --signal-fg: ${colors.text-primary.hex};
      --signal-fg-alt: ${colors.text-secondary.hex};
      --signal-fg-dim: ${colors.text-dim.hex};
      --signal-border: ${colors.divider.hex};
      --signal-accent: ${accent.focus.Lc75.hex};
      --signal-success: ${accent.success.Lc75.hex};
      --signal-warning: ${accent.warning.Lc75.hex};
      --signal-danger: ${accent.danger.Lc75.hex};
    }

    /* Toolbar */
    #navigator-toolbox {
      background-color: var(--signal-bg) !important;
      border-color: var(--signal-border) !important;
    }

    /* Tabs */
    .tabbrowser-tab {
      color: var(--signal-fg-alt) !important;
    }

    .tabbrowser-tab[selected] {
      color: var(--signal-fg) !important;
      background-color: var(--signal-bg-alt) !important;
    }

    .tab-background {
      background-color: var(--signal-bg) !important;
    }

    .tab-background[selected] {
      background-color: var(--signal-bg-alt) !important;
    }

    /* URL bar */
    #urlbar, #searchbar {
      background-color: var(--signal-bg-alt) !important;
      color: var(--signal-fg) !important;
      border-color: var(--signal-border) !important;
    }

    #urlbar:focus, #searchbar:focus {
      border-color: var(--signal-accent) !important;
    }

    /* Sidebar */
    #sidebar-box {
      background-color: var(--signal-bg) !important;
      color: var(--signal-fg) !important;
    }

    /* Context menus */
    menupopup, popup {
      background-color: var(--signal-bg-alt) !important;
      color: var(--signal-fg) !important;
      border-color: var(--signal-border) !important;
    }

    menuitem:hover, menu:hover {
      background-color: var(--signal-bg-hover) !important;
    }
  '';

  # Check if firefox should be themed
  shouldTheme = signalLib.shouldThemeApp "firefox" [
    "browsers"
    "firefox"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme && (config.programs.firefox.enable or false)) {
    # Apply userChrome.css to all Firefox profiles
    programs.firefox.profiles = lib.mkIf (config.programs.firefox ? profiles) (
      lib.mapAttrs (name: profile: {
        userChrome = mkDefault userChromeCSS;

        # Also set some about:config preferences for better theming
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
          "browser.theme.content-theme" = if cfg.mode == "dark" then 0 else 1;
          "browser.theme.toolbar-theme" = if cfg.mode == "dark" then 0 else 1;
        };
      }) config.programs.firefox.profiles
    );
  };
}
