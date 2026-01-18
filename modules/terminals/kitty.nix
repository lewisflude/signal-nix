{ lib, signalPalette, nix-colorizer, ... }:
let
  # Import signalLib directly to avoid circular dependencies with _module.args
  signalLib = import ../../lib { inherit lib; palette = signalPalette; inherit nix-colorizer; };
  
  # Create the module using mkTier3Module
  # This returns a module function, so we need to "unwrap" it by calling it with module args
in
# Return a proper module that imports the generated module
{
  imports = [
    (signalLib.mkTier3Module {
      appName = "kitty";
      category = [ "terminals" ];

      settingsGenerator = signalColors: signalLib:
    let
      inherit (signalColors) accent;

      # Use the standard ANSI color helper
      ansiColors = signalLib.makeAnsiColors signalColors;

      # Use the standard UI colors helper
      uiColors = signalLib.makeUIColors signalColors;
    in
    {
    # Basic colors
    foreground = uiColors.text-primary.hex;
    background = uiColors.surface-base.hex;

    # Cursor colors
    cursor = uiColors.accent-secondary.hex;
    cursor_text_color = uiColors.surface-base.hex;

    # Selection colors
    selection_foreground = uiColors.text-primary.hex;
    selection_background = uiColors.divider-primary.hex;

    # URL underline color
    url_color = uiColors.accent-secondary.hex;

    # Tab bar colors
    active_tab_foreground = uiColors.text-primary.hex;
    active_tab_background = uiColors.surface-base.hex;
    inactive_tab_foreground = uiColors.text-secondary.hex;
    inactive_tab_background = uiColors.divider-primary.hex;

    # Marks
    mark1_foreground = uiColors.surface-base.hex;
    mark1_background = uiColors.accent-secondary.hex;
    mark2_foreground = uiColors.surface-base.hex;
    mark2_background = uiColors.accent-tertiary.hex;
    mark3_foreground = uiColors.surface-base.hex;
    mark3_background = uiColors.warning.hex;

    # The 16 terminal colors

    # Black
    color0 = ansiColors.black.hex;
    color8 = ansiColors.bright-black.hex;

    # Red
    color1 = ansiColors.red.hex;
    color9 = ansiColors.bright-red.hex;

    # Green
    color2 = ansiColors.green.hex;
    color10 = ansiColors.bright-green.hex;

    # Yellow
    color3 = ansiColors.yellow.hex;
    color11 = ansiColors.bright-yellow.hex;

    # Blue
    color4 = ansiColors.blue.hex;
    color12 = ansiColors.bright-blue.hex;

    # Magenta
    color5 = ansiColors.magenta.hex;
    color13 = ansiColors.bright-magenta.hex;

    # Cyan
    color6 = ansiColors.cyan.hex;
    color14 = ansiColors.bright-cyan.hex;

      # White
      color7 = ansiColors.white.hex;
      color15 = ansiColors.bright-white.hex;
    };
    })
  ];
}
