{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: ini-config (Tier 2)
# HOME-MANAGER MODULE: services.polybar.settings
# UPSTREAM SCHEMA: https://github.com/polybar/polybar
# SCHEMA VERSION: 3.7.1
# LAST VALIDATED: 2026-01-17
# NOTES: Polybar uses INI-style config with [bar/...] and [module/...] sections.
#        Home-Manager provides settings attrset. We define colors section.
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

  # Polybar uses hex with optional alpha: #AARRGGBB or #RRGGBB
  # Check if polybar should be themed
  shouldTheme = signalLib.shouldThemeApp "polybar" [
    "desktop"
    "bars"
    "polybar"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    services.polybar.settings = {
      # Colors section that can be referenced in bar configs
      "colors" = {
        background = colors.surface-base.hex;
        background-alt = colors.surface-raised.hex;
        foreground = colors.text-primary.hex;
        foreground-alt = colors.text-secondary.hex;
        foreground-dim = colors.text-dim.hex;

        # Accent colors
        primary = accent.focus.Lc75.hex;
        secondary = accent.info.Lc75.hex;
        alert = accent.danger.Lc75.hex;
        warning = accent.warning.Lc75.hex;
        success = accent.success.Lc75.hex;

        # UI elements
        border = colors.divider.hex;

        # Module-specific colors
        cpu = accent.focus.Lc75.hex;
        memory = accent.info.Lc75.hex;
        network = accent.success.Lc75.hex;
        battery = accent.warning.Lc75.hex;
        temperature = accent.danger.Lc75.hex;
      };

      # Example bar config using Signal colors
      # Users can override this in their own config
      "bar/signal" = {
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        border-color = "\${colors.border}";

        # Module colors
        module-margin = 1;

        # Font (users should override)
        font-0 = "Inter:size=10;2";
      };

      # Example module configs
      "module/cpu" = {
        type = "internal/cpu";
        format-prefix = "CPU ";
        format-prefix-foreground = "\${colors.cpu}";
        label = "%percentage%%";
      };

      "module/memory" = {
        type = "internal/memory";
        format-prefix = "RAM ";
        format-prefix-foreground = "\${colors.memory}";
        label = "%percentage_used%%";
      };

      "module/date" = {
        type = "internal/date";
        date = "%Y-%m-%d%";
        time = "%H:%M";
        label = "%date% %time%";
        format-foreground = "\${colors.foreground}";
      };

      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "AC";
        format-charging = "<label-charging>";
        format-charging-foreground = "\${colors.success}";
        format-discharging = "<label-discharging>";
        format-discharging-foreground = "\${colors.foreground}";
        format-full = "<label-full>";
        format-full-foreground = "\${colors.success}";
        label-charging = "⚡ %percentage%%";
        label-discharging = "🔋 %percentage%%";
        label-full = "🔌 Full";
      };
    };
  };
}
