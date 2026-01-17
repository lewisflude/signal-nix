{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: command-flags (Tier 5)
# HOME-MANAGER MODULE: xdg.configFile wrapper script
# UPSTREAM SCHEMA: https://tools.suckless.org/dmenu/
# SCHEMA VERSION: 5.2
# LAST VALIDATED: 2026-01-17
# NOTES: dmenu is configured via command-line flags. No config file.
#        We create a wrapper script with Signal colors.
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

  # dmenu wrapper script with Signal colors
  dmenuWrapper = ''
    #!/usr/bin/env bash
    # Signal-themed dmenu wrapper

    exec dmenu \
      -nb "${colors.surface-base.hex}" \
      -nf "${colors.text-primary.hex}" \
      -sb "${colors.surface-raised.hex}" \
      -sf "${accent.focus.Lc75.hex}" \
      -fn "Inter-14" \
      "$@"
  '';

  # Check if dmenu should be themed
  shouldTheme = signalLib.shouldThemeApp "dmenu" [
    "desktop"
    "launchers"
    "dmenu"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    # Create wrapper script
    home.file.".local/bin/dmenu-signal" = {
      text = dmenuWrapper;
      executable = true;
    };

    # Add to PATH
    home.sessionPath = [ "$HOME/.local/bin" ];

    # Create alias for convenience
    home.shellAliases = mkIf shouldTheme {
      dmenu = "dmenu-signal";
    };
  };
}
