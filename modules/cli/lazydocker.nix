{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: structured-settings (Tier 2)
# HOME-MANAGER MODULE: programs.lazydocker.settings
# UPSTREAM SCHEMA: https://github.com/jesseduffield/lazydocker
# SCHEMA VERSION: 0.23.1
# LAST VALIDATED: 2026-01-17
# NOTES: Home-Manager now has a lazydocker module with settings support (as of 2025).
#        Previously disabled due to conflict between xdg.configFile and home.file,
#        but the upstream module now properly uses home.file to avoid conflicts.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-raised = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-dim = signalColors.tonal."text-Lc45";
    divider = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # Check if lazydocker should be themed
  shouldTheme = signalLib.shouldThemeApp "lazydocker" [
    "cli"
    "lazydocker"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.lazydocker = {
      settings = {
        gui = {
          theme = {
            lightTheme = cfg.mode == "light";
            activeBorderColor = [
              accent.focus.Lc75.hex
              "bold"
            ];
            inactiveBorderColor = [ colors.divider.hex ];
            searchingActiveBorderColor = [
              accent.warning.Lc75.hex
              "bold"
            ];
            optionsTextColor = [ accent.focus.Lc75.hex ];
            selectedLineBgColor = [ colors.surface-raised.hex ];
            selectedRangeBgColor = [ colors.surface-raised.hex ];
            cherryPickedCommitBgColor = [ accent.info.Lc75.hex ];
            cherryPickedCommitFgColor = [ colors.surface-base.hex ];
            unstagedChangesColor = [ accent.danger.Lc75.hex ];
            defaultFgColor = [ colors.text-primary.hex ];
          };
        };
        reporting = {
          containerStatusHealthy = accent.success.Lc75.hex;
          containerStatusUnhealthy = accent.danger.Lc75.hex;
          containerStatusExited = colors.text-dim.hex;
          containerStatusRunning = accent.focus.Lc75.hex;
          containerStatusPaused = accent.warning.Lc75.hex;
        };
      };
    };
  };
}
