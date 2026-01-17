{
  lib,
  palette,
  ...
}:
rec {
  # Resolve theme mode to a concrete value (dark or light)
  # Converts "auto" to "dark" as the default
  # Validates input and provides helpful error messages
  resolveThemeMode =
    mode:
    assert lib.assertMsg (lib.elem mode [
      "auto"
      "dark"
      "light"
    ]) "Invalid theme mode '${mode}'. Must be 'auto', 'dark', or 'light'.";
    if mode == "auto" then "dark" else mode;

  # Centralized logic to determine if an application should be themed
  # Reduces boilerplate across all module files
  # Usage: shouldTheme = signalLib.shouldThemeApp "bat" cfg config;
  shouldThemeApp =
    appName: # Name of the app in signal config (e.g., "bat" for cfg.cli.bat)
    appPath: # Attribute path in signal config (e.g., ["cli" "bat"])
    cfg: # The theming.signal config
    config: # The full Home Manager config
    let
      signalEnable = lib.getAttrFromPath appPath cfg;
      programEnable = config.programs.${appName}.enable or false;
    in
    signalEnable.enable or false || (cfg.autoEnable && programEnable);

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

  # Get syntax highlighting colors for a specific mode
  # Provides consistent color mappings for code editors and syntax highlighters
  getSyntaxColors =
    mode:
    let
      colors = getColors mode;
    in
    {
      # Base colors - use palette for both modes
      background = colors.tonal."surface-Lc05".hex;
      foreground = colors.tonal."text-Lc75".hex;
      caret = colors.accent.focus.Lc75.hex;
      lineHighlight = colors.tonal."surface-Lc10".hex;
      selection = colors.tonal."divider-Lc15".hex;

      # Syntax elements - consistent across modes, palette handles lightness inversion
      comment = colors.tonal."text-Lc45".hex;
      string = colors.categorical.GA02.hex;
      number = colors.categorical.GA06.hex;
      keyword = colors.accent.special.Lc75.hex;
      operator = colors.accent.info.Lc75.hex;
      function = colors.accent.focus.Lc75.hex;
      type = colors.categorical.GA06.hex;
      variable = colors.tonal."text-Lc75".hex;
      constant = colors.categorical.GA06.hex;
      escape = colors.categorical.GA08.hex;
      punctuation = colors.tonal."text-Lc45".hex;

      # Markup
      heading = colors.accent.danger.Lc75.hex;
      link = colors.accent.focus.Lc75.hex;

      # Diff
      diffInserted = colors.categorical.GA02.hex;
      diffDeleted = colors.accent.danger.Lc75.hex;
      diffChanged = colors.accent.focus.Lc75.hex;
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
  # NOTE: These are simplified approximations for basic validation.
  # They do NOT implement full APCA (Accessible Perceptual Contrast Algorithm).
  # For production accessibility compliance, use proper APCA tools or manual verification.
  # See: https://github.com/Myndex/SAPC-APCA
  accessibility = {
    # Simple contrast estimation based on lightness difference
    # This is a rough approximation and should NOT be relied upon for accessibility compliance
    # Returns: Estimated contrast value (0-108, where higher is better)
    estimateContrast =
      {
        foreground,
        background,
      }:
      let
        fg = foreground.l;
        bg = background.l;
        diff =
          let
            raw = fg - bg;
          in
          if raw < 0.0 then -raw else raw;
      in
      # WARNING: This is a linear approximation, not actual APCA
      # Real APCA is non-linear and considers perceptual factors
      diff * 108.0;

    # Check if contrast meets minimum requirement (using simplified estimation)
    # WARNING: Do not rely on this for accessibility compliance
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
  # NOTE: These functions only manipulate LCH values and do NOT recalculate hex/RGB.
  # The returned hex/hexRaw/rgb values will be incorrect if you use them.
  # Use these only if you need to adjust LCH values and will recalculate colors separately.
  colors = {
    # Adjust lightness while preserving chroma and hue
    # Returns: Color with adjusted L value (but original hex/rgb - DO NOT USE THOSE)
    # Use case: Calculate target lightness before passing to color generation system
    adjustLightness =
      {
        color,
        delta,
      }:
      {
        l = lib.max 0.0 (lib.min 1.0 (color.l + delta));
        inherit (color) c h;
        # WARNING: These values are WRONG after lightness adjustment
        # Do not use hex/hexRaw/rgb from the returned value
        # Include them only for type compatibility
        hex = throw "adjustLightness does not recalculate hex - use LCH values only";
        hexRaw = throw "adjustLightness does not recalculate hexRaw - use LCH values only";
        rgb = throw "adjustLightness does not recalculate rgb - use LCH values only";
      };

    # Adjust chroma while preserving lightness and hue
    # Returns: Color with adjusted C value (but original hex/rgb - DO NOT USE THOSE)
    # Use case: Calculate target chroma before passing to color generation system
    adjustChroma =
      {
        color,
        delta,
      }:
      {
        inherit (color) l h;
        c = lib.max 0.0 (color.c + delta);
        # WARNING: These values are WRONG after chroma adjustment
        # Do not use hex/hexRaw/rgb from the returned value
        hex = throw "adjustChroma does not recalculate hex - use LCH values only";
        hexRaw = throw "adjustChroma does not recalculate hexRaw - use LCH values only";
        rgb = throw "adjustChroma does not recalculate rgb - use LCH values only";
      };
  };
}
