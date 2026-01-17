{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: toml-config (Tier 2)
# HOME-MANAGER MODULE: programs.bottom (via xdg.configFile)
# UPSTREAM SCHEMA: https://github.com/ClementTsang/bottom
# SCHEMA VERSION: 0.9.6
# LAST VALIDATED: 2026-01-17
# NOTES: bottom (btm) uses TOML config. Home-Manager doesn't have a dedicated
#        module yet, so we use xdg.configFile to write the config.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    bg = signalColors.tonal."surface-Lc05";
    fg = signalColors.tonal."text-Lc75";
    fg-alt = signalColors.tonal."text-Lc60";
    fg-dim = signalColors.tonal."text-Lc45";
    border = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # Generate bottom config in TOML format
  bottomConfig = ''
    # Signal theme for bottom
    
    [colors]
    # Widget styling
    border_color = "${colors.border.hex}"
    highlighted_border_color = "${accent.focus.Lc75.hex}"
    text_color = "${colors.fg.hex}"
    selected_text_color = "${colors.fg.hex}"
    selected_bg_color = "${colors.border.hex}"
    widget_title_color = "${colors.fg.hex}"
    graph_color = "${accent.focus.Lc75.hex}"
    
    # CPU colors
    cpu_core_colors = [
      "${accent.focus.Lc75.hex}",
      "${accent.info.Lc75.hex}",
      "${accent.success.Lc75.hex}",
      "${accent.warning.Lc75.hex}",
      "${accent.danger.Lc75.hex}",
      "${accent.special.Lc75.hex}",
      "${signalColors.categorical.GA02.hex}",
      "${signalColors.categorical.GA04.hex}",
    ]
    
    # Memory/Swap colors
    ram_color = "${accent.focus.Lc75.hex}"
    swap_color = "${accent.warning.Lc75.hex}"
    
    # Network colors
    rx_color = "${accent.success.Lc75.hex}"
    tx_color = "${accent.danger.Lc75.hex}"
    
    # Battery colors
    high_battery_color = "${accent.success.Lc75.hex}"
    medium_battery_color = "${accent.warning.Lc75.hex}"
    low_battery_color = "${accent.danger.Lc75.hex}"
    
    # Disk colors
    arc_color = "${accent.focus.Lc75.hex}"
    
    # Temperature colors
    # These are gradients from cold to hot
    [[colors.temperature_colors]]
    temperature = 0
    color = "${accent.info.Lc75.hex}"
    
    [[colors.temperature_colors]]
    temperature = 50
    color = "${accent.success.Lc75.hex}"
    
    [[colors.temperature_colors]]
    temperature = 70
    color = "${accent.warning.Lc75.hex}"
    
    [[colors.temperature_colors]]
    temperature = 90
    color = "${accent.danger.Lc75.hex}"
  '';

  # Check if bottom should be themed
  shouldTheme = cfg.monitors.bottom.enable or false || cfg.autoEnable;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    xdg.configFile."bottom/bottom.toml".text = bottomConfig;
  };
}
