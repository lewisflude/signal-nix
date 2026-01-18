{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: stylesheet (Tier 1) + JSON config
# HOME-MANAGER MODULE: programs.waybar.style
# UPSTREAM SCHEMA: https://github.com/Alexays/Waybar/wiki/Styling
# SCHEMA VERSION: 0.10.0
# LAST VALIDATED: 2026-01-17
# NOTES: Waybar uses CSS for styling. Home Manager provides a style option
#        that accepts a string containing CSS. We provide a comprehensive stylesheet.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-raised = signalColors.tonal."surface-hover";
    surface-hover = signalColors.tonal."surface-Lc15";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-tertiary = signalColors.tonal."text-tertiary";
    divider-primary = signalColors.tonal."divider-primary";
  };

  inherit (signalColors) accent;

  # Check if waybar should be themed
  shouldTheme = signalLib.shouldThemeApp "waybar" [
    "desktop"
    "bars"
    "waybar"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.waybar.style = ''
      * {
        font-family: "Inter", sans-serif;
        font-size: 13px;
        font-weight: 500;
        min-height: 0;
      }

      window#waybar {
        background-color: ${colors.surface-base.hex};
        color: ${colors.text-primary.hex};
        border-bottom: 2px solid ${colors.divider-primary.hex};
      }

      #workspaces button {
        padding: 0 8px;
        color: ${colors.text-secondary.hex};
        background-color: transparent;
        border: none;
        border-bottom: 2px solid transparent;
      }

      #workspaces button.focused,
      #workspaces button.active {
        color: ${colors.text-primary.hex};
        background-color: ${colors.surface-raised.hex};
        border-bottom: 2px solid ${accent.secondary.Lc75.hex};
      }

      #workspaces button.urgent {
        color: ${accent.danger.Lc75.hex};
        border-bottom: 2px solid ${accent.danger.Lc75.hex};
      }

      #workspaces button:hover {
        background-color: ${colors.surface-hover.hex};
        color: ${colors.text-primary.hex};
      }

      #mode {
        background-color: ${accent.warning.Lc75.hex};
        color: ${colors.surface-base.hex};
        padding: 0 12px;
        font-weight: 600;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd,
      #language {
        padding: 0 12px;
        color: ${colors.text-primary.hex};
      }

      #battery.charging,
      #battery.plugged {
        color: ${accent.primary.Lc75.hex};
      }

      #battery.critical:not(.charging) {
        background-color: ${accent.danger.Lc75.hex};
        color: ${colors.surface-base.hex};
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to {
          opacity: 0.7;
        }
      }

      #cpu.warning {
        color: ${accent.warning.Lc75.hex};
      }

      #cpu.critical {
        color: ${accent.danger.Lc75.hex};
      }

      #memory.warning {
        color: ${accent.warning.Lc75.hex};
      }

      #memory.critical {
        color: ${accent.danger.Lc75.hex};
      }

      #temperature.critical {
        color: ${accent.danger.Lc75.hex};
      }

      #network.disconnected {
        color: ${colors.text-tertiary.hex};
      }

      #pulseaudio.muted,
      #wireplumber.muted {
        color: ${colors.text-tertiary.hex};
      }

      #idle_inhibitor.activated {
        color: ${accent.secondary.Lc75.hex};
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: ${accent.danger.Lc75.hex};
      }

      tooltip {
        background-color: ${colors.surface-raised.hex};
        color: ${colors.text-primary.hex};
        border: 1px solid ${colors.divider-primary.hex};
        border-radius: 4px;
      }

      tooltip label {
        color: ${colors.text-primary.hex};
      }
    '';
  };
}
