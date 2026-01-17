{
  config,
  lib,
  pkgs,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: xdg.configFile (custom theme file)
# UPSTREAM SCHEMA: https://github.com/aristocratos/btop#themes
# SCHEMA VERSION: 1.3.0
# LAST VALIDATED: 2026-01-17
# NOTES: Btop requires theme files in custom format at ~/.config/btop/themes/.
#        Home-Manager's programs.btop.settings doesn't support inline theme definition.
#        We generate theme file and link it via xdg.configFile.
let
  inherit (lib) mkIf removePrefix;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-tertiary = signalColors.tonal."text-Lc45";
    divider-primary = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent categorical;

  # Helper to get hex without # prefix
  hexRaw = color: removePrefix "#" color.hex;

  # Generate btop theme file
  btopTheme = pkgs.writeText "signal.theme" ''
    # Signal Theme for btop++
    # Generated from Signal Design System

    # Main background
    theme[main_bg]="${hexRaw colors.surface-base}"

    # Main text color
    theme[main_fg]="${hexRaw colors.text-primary}"

    # Title color for boxes
    theme[title]="${hexRaw colors.text-primary}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="${hexRaw accent.focus.Lc75}"

    # Background color of selected items
    theme[selected_bg]="${hexRaw colors.divider-primary}"

    # Foreground color of selected items
    theme[selected_fg]="${hexRaw colors.text-primary}"

    # Color of inactive/disabled text
    theme[inactive_fg]="${hexRaw colors.text-tertiary}"

    # Color of text appearing on top of graphs
    theme[graph_text]="${hexRaw colors.text-secondary}"

    # Misc colors for processes box
    theme[proc_misc]="${hexRaw accent.success.Lc75}"

    # Box outline colors
    theme[cpu_box]="${hexRaw colors.divider-primary}"
    theme[mem_box]="${hexRaw colors.divider-primary}"
    theme[net_box]="${hexRaw colors.divider-primary}"
    theme[proc_box]="${hexRaw colors.divider-primary}"

    # Box divider line and small boxes line color
    theme[div_line]="${hexRaw colors.divider-primary}"

    # Temperature graph colors (green -> yellow -> red)
    theme[temp_start]="${hexRaw accent.success.Lc75}"
    theme[temp_mid]="${hexRaw accent.warning.Lc75}"
    theme[temp_end]="${hexRaw accent.danger.Lc75}"

    # CPU graph colors (blue gradient)
    theme[cpu_start]="${hexRaw accent.focus.Lc75}"
    theme[cpu_mid]="${hexRaw accent.info.Lc75}"
    theme[cpu_end]="${hexRaw accent.special.Lc75}"

    # Mem/Disk free meter (red -> yellow -> green)
    theme[free_start]="${hexRaw accent.danger.Lc75}"
    theme[free_mid]="${hexRaw accent.warning.Lc75}"
    theme[free_end]="${hexRaw accent.success.Lc75}"

    # Mem/Disk cached meter (blue gradient)
    theme[cached_start]="${hexRaw accent.focus.Lc75}"
    theme[cached_mid]="${hexRaw accent.info.Lc75}"
    theme[cached_end]="${hexRaw accent.success.Lc75}"

    # Mem/Disk available meter (purple gradient)
    theme[available_start]="${hexRaw accent.special.Lc75}"
    theme[available_mid]="${hexRaw categorical.GA06}"
    theme[available_end]="${hexRaw accent.warning.Lc75}"

    # Mem/Disk used meter (green -> yellow -> red)
    theme[used_start]="${hexRaw accent.success.Lc75}"
    theme[used_mid]="${hexRaw accent.warning.Lc75}"
    theme[used_end]="${hexRaw accent.danger.Lc75}"

    # Download graph colors (green gradient)
    theme[download_start]="${hexRaw accent.success.Lc75}"
    theme[download_mid]="${hexRaw categorical.GA02}"
    theme[download_end]="${hexRaw accent.info.Lc75}"

    # Upload graph colors (red gradient)
    theme[upload_start]="${hexRaw accent.danger.Lc75}"
    theme[upload_mid]="${hexRaw accent.warning.Lc75}"
    theme[upload_end]="${hexRaw categorical.GA06}"

    # Process box color gradient
    theme[process_start]="${hexRaw accent.focus.Lc75}"
    theme[process_mid]="${hexRaw accent.warning.Lc75}"
    theme[process_end]="${hexRaw accent.danger.Lc75}"
  '';

  # Check if btop should be themed
  # Check if btop should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "btop" [
    "monitors"
    "btop"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.btop = {
      settings = {
        # Set theme name
        color_theme = "signal";

        # Theme override using extraConfig
        # This creates a custom theme in the btop config
        theme_background = false; # Use terminal background
      };

      # Link the theme file
      # btop looks for themes in ~/.config/btop/themes/
      extraConfig = ''
        # Signal theme is defined via file in themes directory
      '';
    };

    # Create the theme file in the correct location
    xdg.configFile."btop/themes/signal.theme".source = btopTheme;
  };
}
