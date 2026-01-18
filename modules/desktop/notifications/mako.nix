{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: services.mako (via programs.mako in newer HM)
# UPSTREAM SCHEMA: https://github.com/emersion/mako
# SCHEMA VERSION: 1.8.0
# LAST VALIDATED: 2026-01-17
# NOTES: mako uses INI-like config. Home Manager provides extraConfig or
#        direct configuration options.
#        Signal ONLY sets colors - users configure fonts, spacing, timeouts, etc.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-raised = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    divider = signalColors.tonal."divider-primary";
  };

  inherit (signalColors) accent;

  # mako uses hex colors without #
  toMakoColor = color: lib.removePrefix "#" color.hex;

  # Generate mako config - COLORS ONLY
  makoConfig = ''
    # Signal theme for mako - COLORS ONLY
    # Configure fonts, spacing, timeouts, etc. in your own mako config

    # Default notification colors
    background-color=${toMakoColor colors.surface-raised}
    text-color=${toMakoColor colors.text-primary}
    border-color=${toMakoColor colors.divider}

    # Progress bar color
    progress-color=${toMakoColor accent.secondary.Lc75}

    # Low urgency colors
    [urgency=low]
    background-color=${toMakoColor colors.surface-raised}
    border-color=${toMakoColor accent.secondary.Lc75}
    text-color=${toMakoColor colors.text-secondary}

    # Normal urgency colors
    [urgency=normal]
    background-color=${toMakoColor colors.surface-raised}
    border-color=${toMakoColor accent.secondary.Lc75}
    text-color=${toMakoColor colors.text-primary}

    # Critical urgency colors
    [urgency=critical]
    background-color=${toMakoColor colors.surface-raised}
    border-color=${toMakoColor accent.danger.Lc75}
    text-color=${toMakoColor colors.text-primary}
  '';

  # Check if mako should be themed
  shouldTheme = signalLib.shouldThemeApp "mako" [
    "desktop"
    "notifications"
    "mako"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    # mako can be configured via services.mako or programs.mako
    # We use xdg.configFile for maximum compatibility
    xdg.configFile."mako/config".text = makoConfig;
  };
}
