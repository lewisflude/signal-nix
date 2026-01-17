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
# NOTES: mako uses INI-like config. Home-Manager provides extraConfig or
#        direct configuration options.
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

  # Generate mako config
  makoConfig = ''
    # Signal theme for mako

    # Default notification style
    background-color=${toMakoColor colors.surface-raised}
    text-color=${toMakoColor colors.text-primary}
    border-color=${toMakoColor colors.divider}
    border-size=2
    border-radius=8
    padding=12
    margin=8
    font=Inter 12
    default-timeout=5000
    max-visible=3

    # Progress bar
    progress-color=${toMakoColor accent.focus.Lc75}

    # Low urgency
    [urgency=low]
    background-color=${toMakoColor colors.surface-raised}
    border-color=${toMakoColor accent.info.Lc75}
    text-color=${toMakoColor colors.text-secondary}

    # Normal urgency
    [urgency=normal]
    background-color=${toMakoColor colors.surface-raised}
    border-color=${toMakoColor accent.focus.Lc75}
    text-color=${toMakoColor colors.text-primary}

    # Critical urgency
    [urgency=critical]
    background-color=${toMakoColor colors.surface-raised}
    border-color=${toMakoColor accent.danger.Lc75}
    text-color=${toMakoColor colors.text-primary}
    default-timeout=0
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
