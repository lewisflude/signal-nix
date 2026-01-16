{
  lib,
  palette,
  ...
}: rec {
  # Get colors for a specific mode
  getColors = mode: {
    tonal =
      if mode == "dark"
      then palette.tonal.dark
      else palette.tonal.light;
    
    accent = palette.accent;
    
    categorical =
      if mode == "dark"
      then palette.categorical.dark
      else palette.categorical.light;
  };

  # Brand governance helpers
  brandGovernance = {
    # Merge brand colors with functional colors based on policy
    mergeColors = {
      policy,
      functionalColors,
      brandColors,
      decorativeBrandColors,
    }:
      if policy == "functional-override"
      then functionalColors // {decorative = decorativeBrandColors;}
      else if policy == "separate-layer"
      then functionalColors // {brand = brandColors; decorative = decorativeBrandColors;}
      else if policy == "integrated"
      then functionalColors // brandColors // {decorative = decorativeBrandColors;}
      else functionalColors;
  };

  # Accessibility helpers
  accessibility = {
    # Simple contrast estimation (full APCA would require more complex math)
    # This is a simplified version for basic validation
    estimateContrast = {
      foreground,
      background,
    }: let
      fg = foreground.l;
      bg = background.l;
      diff = builtins.abs (fg - bg);
    in
      # Rough approximation: 0.0-1.0 diff maps to 0-108 APCA
      diff * 108.0;

    # Check if contrast meets minimum APCA requirement
    meetsMinimum = {
      foreground,
      background,
      minimum,
    }: let
      contrast = accessibility.estimateContrast {inherit foreground background;};
    in
      contrast >= minimum;
  };

  # Color manipulation helpers
  colors = {
    # Adjust lightness while preserving chroma and hue
    adjustLightness = {
      color,
      delta,
    }: {
      l = lib.max 0.0 (lib.min 1.0 (color.l + delta));
      c = color.c;
      h = color.h;
      hex = color.hex; # Note: hex should be recalculated in real implementation
      hexRaw = color.hexRaw;
      rgb = color.rgb;
    };

    # Adjust chroma while preserving lightness and hue
    adjustChroma = {
      color,
      delta,
    }: {
      l = color.l;
      c = lib.max 0.0 (color.c + delta);
      h = color.h;
      hex = color.hex;
      hexRaw = color.hexRaw;
      rgb = color.rgb;
    };
  };
}
