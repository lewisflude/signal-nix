{
  config,
  lib,
  signalColors,
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

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-raised = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    divider = signalColors.tonal."divider-Lc15";
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
    progress-color=${toMakoColor accent.focus.Lc75}

    # Low urgency colors
    [urgency=low]
    background-color=${toMakoColor colors.surface-raised}
    border-color=${toMakoColor accent.info.Lc75}
    text-color=${toMakoColor colors.text-secondary}

    # Normal urgency colors
    [urgency=normal]
    background-color=${toMakoColor colors.surface-raised}
    border-color=${toMakoColor accent.focus.Lc75}
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
