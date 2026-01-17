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
    surface-base = signalColors.tonal."surface-subtle";
    surface-raised = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    divider = signalColors.tonal."divider-primary";
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
      -sf "${accent.secondary.Lc75.hex}" \
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
    home = {
      # Create wrapper script
      file.".local/bin/dmenu-signal" = {
        text = dmenuWrapper;
        executable = true;
      };

      # Add to PATH
      sessionPath = [ "$HOME/.local/bin" ];

      # Create alias for convenience
      shellAliases = mkIf shouldTheme {
        dmenu = "dmenu-signal";
      };
    };
  };
}
