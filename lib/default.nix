{
  lib,
  palette,
  ...
}:
rec {
  # Resolve theme mode to a concrete value (dark or light)
  # Converts "auto" to "dark" as the default
  resolveThemeMode = mode: if mode == "auto" then "dark" else mode;

  # Validate that a theme mode is valid (dark or light, not auto)
  # Returns true if valid, false otherwise
  isValidResolvedMode = mode: mode == "dark" || mode == "light";

  # Get the theme name for a module (e.g., "signal-dark", "signal-light")
  # This ensures consistent theme naming across all modules
  getThemeName =
    mode:
    let
      resolved = resolveThemeMode mode;
    in
    "signal-${resolved}";

  # Get colors for a specific mode
  getColors = mode: {
    tonal = if mode == "dark" then palette.tonal.dark else palette.tonal.light;

    inherit (palette) accent;

    categorical = if mode == "dark" then palette.categorical.dark else palette.categorical.light;
  };

  # Brand governance helpers
  brandGovernance = {
    # Merge brand colors with functional colors based on policy
    mergeColors =
      {
        policy,
        functionalColors,
        brandColors,
        decorativeBrandColors,
      }:
      if policy == "functional-override" then
        functionalColors // { decorative = decorativeBrandColors; }
      else if policy == "separate-layer" then
        functionalColors
        // {
          brand = brandColors;
          decorative = decorativeBrandColors;
        }
      else if policy == "integrated" then
        functionalColors // brandColors // { decorative = decorativeBrandColors; }
      else
        functionalColors;
  };

  # Accessibility helpers
  accessibility = {
    # Simple contrast estimation (full APCA would require more complex math)
    # This is a simplified version for basic validation
    estimateContrast =
      {
        foreground,
        background,
      }:
      let
        fg = foreground.l;
        bg = background.l;
        diff = builtins.abs (fg - bg);
      in
      # Rough approximation: 0.0-1.0 diff maps to 0-108 APCA
      diff * 108.0;

    # Check if contrast meets minimum APCA requirement
    meetsMinimum =
      {
        foreground,
        background,
        minimum,
      }:
      let
        contrast = accessibility.estimateContrast { inherit foreground background; };
      in
      contrast >= minimum;
  };

  # Color manipulation helpers
  colors = {
    # Adjust lightness while preserving chroma and hue
    adjustLightness =
      {
        color,
        delta,
      }:
      {
        l = lib.max 0.0 (lib.min 1.0 (color.l + delta));
        inherit (color)
          c
          h
          hex
          hexRaw
          rgb
          ;
        # Note: hex should be recalculated in real implementation
      };

    # Adjust chroma while preserving lightness and hue
    adjustChroma =
      {
        color,
        delta,
      }:
      {
        inherit (color)
          l
          h
          hex
          hexRaw
          rgb
          ;
        c = lib.max 0.0 (color.c + delta);
      };
  };
}
