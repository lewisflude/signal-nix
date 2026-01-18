{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: freeform-settings (Tier 3)
# HOME-MANAGER MODULE: wayland.windowManager.hyprland.settings
# UPSTREAM SCHEMA: https://wiki.hyprland.org/Configuring/Variables/
# SCHEMA VERSION: 0.45.0
# LAST VALIDATED: 2026-01-17
# NOTES: Hyprland uses a hierarchical config format. Home-Manager provides a settings
#        attrset that gets serialized to hyprland.conf. We theme the general colors,
#        decorations, and group (window) colors.
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
    divider-primary = signalColors.tonal."divider-primary";
    divider-secondary = signalColors.tonal."divider-Lc20";
  };

  inherit (signalColors) accent;

  # Hyprland uses RGBA format: 0xRRGGBBAA
  # We need to convert hex colors to this format
  toHyprlandRgba =
    color: alpha:
    let
      hex = lib.removePrefix "#" color.hex;
      # Convert alpha from 0.0-1.0 to 00-ff hex
      alphaHex = lib.toHexString (builtins.floor (alpha * 255.0));
      # Pad to 2 digits
      alphaPadded = if builtins.stringLength alphaHex == 1 then "0${alphaHex}" else alphaHex;
    in
    "0x${hex}${alphaPadded}";

  # Check if Hyprland should be themed
  shouldTheme = signalLib.shouldThemeApp "hyprland" [
    "desktop"
    "compositors"
    "hyprland"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    wayland.windowManager.hyprland.settings = {
      # General colors
      general = {
        "col.active_border" = "${toHyprlandRgba accent.secondary.Lc75 1.0}";
        "col.inactive_border" = "${toHyprlandRgba colors.divider-primary 0.8}";
      };

      # Group (tabbed/stacked windows) colors
      group = {
        "col.border_active" = "${toHyprlandRgba accent.secondary.Lc75 1.0}";
        "col.border_inactive" = "${toHyprlandRgba colors.divider-primary 0.8}";
        "col.border_locked_active" = "${toHyprlandRgba accent.warning.Lc75 1.0}";
        "col.border_locked_inactive" = "${toHyprlandRgba accent.warning.Lc75 0.6}";

        groupbar = {
          "col.active" = "${toHyprlandRgba accent.secondary.Lc75 1.0}";
          "col.inactive" = "${toHyprlandRgba colors.divider-secondary 0.8}";
          "col.locked_active" = "${toHyprlandRgba accent.warning.Lc75 1.0}";
          "col.locked_inactive" = "${toHyprlandRgba accent.warning.Lc75 0.6}";
        };
      };

      # Decoration colors (shadows, blur overlay)
      decoration = {
        "col.shadow" = "${toHyprlandRgba colors.surface-base 0.7}";
        "col.shadow_inactive" = "${toHyprlandRgba colors.surface-base 0.5}";
      };

      # Misc colors
      misc = {
        background_color = "${toHyprlandRgba colors.surface-base 1.0}";
      };
    };
  };
}
