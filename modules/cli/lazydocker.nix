{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: yaml-config (Tier 2)
# HOME-MANAGER MODULE: xdg.configFile
# UPSTREAM SCHEMA: https://github.com/jesseduffield/lazydocker
# SCHEMA VERSION: 0.23.1
# LAST VALIDATED: 2026-01-17
# NOTES: lazydocker uses YAML config similar to lazygit. No dedicated Home-Manager
#        module yet, so we use xdg.configFile.
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

  # Generate lazydocker config in YAML format
  lazydockerConfig = ''
    # Signal theme for lazydocker
    gui:
      theme:
        lightTheme: ${if cfg.mode == "light" then "true" else "false"}
        activeBorderColor:
          - "${accent.focus.Lc75.hex}"
          - bold
        inactiveBorderColor:
          - "${colors.divider.hex}"
        searchingActiveBorderColor:
          - "${accent.warning.Lc75.hex}"
          - bold
        optionsTextColor:
          - "${accent.focus.Lc75.hex}"
        selectedLineBgColor:
          - "${colors.surface-raised.hex}"
        selectedRangeBgColor:
          - "${colors.surface-raised.hex}"
        cherryPickedCommitBgColor:
          - "${accent.info.Lc75.hex}"
        cherryPickedCommitFgColor:
          - "${colors.surface-base.hex}"
        unstagedChangesColor:
          - "${accent.danger.Lc75.hex}"
        defaultFgColor:
          - "${colors.text-primary.hex}"
    
    # Container status colors
    reporting:
      containerStatusHealthy: "${accent.success.Lc75.hex}"
      containerStatusUnhealthy: "${accent.danger.Lc75.hex}"
      containerStatusExited: "${colors.text-dim.hex}"
      containerStatusRunning: "${accent.focus.Lc75.hex}"
      containerStatusPaused: "${accent.warning.Lc75.hex}"
  '';

  # Check if lazydocker should be themed
  shouldTheme = cfg.cli.lazydocker.enable or false || cfg.autoEnable;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    xdg.configFile."lazydocker/config.yml".text = lazydockerConfig;
  };
}
