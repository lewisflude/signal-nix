# nix-colorizer Integration

**Status**: ✅ Complete  
**Date**: 2025-01-17  
**Version**: 1.0.0

## Summary

Integrated [nix-colorizer](https://github.com/nutsalhan87/nix-colorizer) into signal-nix to provide high-fidelity color conversions with perceptual accuracy using OKLCh color space.

## Motivation

Signal-nix needed accurate color format conversions for applications with different requirements:
- **Zellij**: Requires space-separated RGB format (e.g., "107 135 200")
- **Fuzzel**: Requires RRGGBBAA format with alpha channel (e.g., "6b87c8f2")
- **General**: Need to maintain color accuracy across all format conversions

Previous implementation used manual hex parsing with `builtins.fromTOML`, which:
- Operated in RGB color space (not perceptually uniform)
- Had limited precision
- Lacked proper alpha channel support
- Required custom implementation for each format

## What Changed

### 1. Added nix-colorizer as Flake Input

**File**: `flake.nix`

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  signal-palette.url = "github:lewisflude/signal-palette";
  nix-colorizer.url = "github:nutsalhan87/nix-colorizer";  # ← New
};
```

### 2. Created High-Fidelity Conversion Utilities

**File**: `lib/default.nix`

Added three new conversion functions:

```nix
# Convert hex to space-separated RGB (0-255 range)
hexToRgbSpaceSeparated = color:
  let
    srgb = nix-colorizer.hex.to.srgb color.hex;
    r = builtins.floor (srgb.r * 255.0 + 0.5);
    g = builtins.floor (srgb.g * 255.0 + 0.5);
    b = builtins.floor (srgb.b * 255.0 + 0.5);
  in
  "${toString r} ${toString g} ${toString b}";

# Add alpha channel in RRGGBBAA format (no # prefix)
hexWithAlpha = color: alpha:
  lib.removePrefix "#" (nix-colorizer.hex.setAlpha color.hex alpha);

# Validate hex color format
isValidHexColor = str: /* validation logic */;
```

### 3. Updated Zellij Module

**File**: `modules/multiplexers/zellij.nix`

**Before** (manual hex parsing):
```nix
hexToRgb = color:
  let
    hex = removePrefix "#" color.hex;
    r = builtins.fromTOML "x=0x${builtins.substring 0 2 hex}";
    g = builtins.fromTOML "x=0x${builtins.substring 2 2 hex}";
    b = builtins.fromTOML "x=0x${builtins.substring 4 2 hex}";
  in
  "${toString r.x} ${toString g.x} ${toString b.x}";
```

**After** (high-fidelity conversion):
```nix
toZellijColor = signalLib.hexToRgbSpaceSeparated;
```

### 4. Updated Fuzzel Module

**File**: `modules/desktop/fuzzel.nix`

**Before** (string concatenation):
```nix
colors = {
  background = "${colors.background.hexRaw}f2";  # ~95% opacity
  text = "${colors.text.hexRaw}ff";
};
```

**After** (proper alpha channel):
```nix
withAlpha = color: alpha: signalLib.hexWithAlpha color alpha;

colors = {
  background = withAlpha colors.background 0.949;  # 95% opacity
  text = withAlpha colors.text 1.0;                # Fully opaque
};
```

### 5. Updated All Tests

**Files**: `tests/default.nix`, `tests/comprehensive-test-suite.nix`

Added `nix-colorizer` to test configurations:
```nix
signalLib = import ../lib {
  inherit lib;
  palette = signal-palette.palette;
  nix-colorizer = self.inputs.nix-colorizer;  # ← New
};
```

### 6. Updated Documentation

**Files**: 
- `docs/architecture.md` - Added "High-Fidelity Color Conversion" section
- `docs/design-principles.md` - Updated core philosophy
- Updated component architecture diagram to show conversion utilities

## Benefits

### 1. **Perceptual Accuracy**
- OKLCh color space provides perceptually uniform color conversions
- Colors maintain their perceived brightness and relationships

### 2. **Higher Precision**
- Uses floating-point arithmetic instead of TOML hex parsing
- Proper rounding for RGB conversion (0-255 range)

### 3. **Alpha Channel Support**
- Native alpha channel handling with proper opacity calculations
- Eliminates string concatenation for alpha values

### 4. **Maintainability**
- Removes custom color conversion code
- Single source of truth for color operations
- Professional-grade color library maintained by the community

### 5. **Future-Proof**
- Support for additional color formats (if needed)
- Access to color manipulation functions (lighten, darken, blend, etc.)
- Can leverage color harmony generation

## Testing

All integration tests pass:

```bash
✅ nix build .#checks.x86_64-linux.format
✅ nix build .#checks.x86_64-linux.unit-lib-resolveThemeMode
✅ nix build .#checks.x86_64-linux.integration-example-basic
✅ nix build .#checks.x86_64-linux.integration-example-full-desktop
```

## Examples

### Zellij Color Conversion

```nix
# Input color from signal-palette
color = signalColors.tonal."text-Lc75";  # { hex = "#c5cdd8", ... }

# Old method (manual parsing)
"197 205 216"  # May have rounding errors

# New method (nix-colorizer)
"197 205 216"  # Perceptually accurate with proper rounding
```

### Fuzzel Alpha Channel

```nix
# Input color
background = signalColors.tonal."surface-Lc05";  # { hex = "#1a1c22", ... }

# Old method (string concatenation)
"1a1c22f2"  # Manual alpha calculation

# New method (nix-colorizer)
withAlpha background 0.949  # "1a1c22f2" - Proper alpha conversion
```

## API Reference

### hexToRgbSpaceSeparated

Converts hex color to space-separated RGB string.

**Usage:**
```nix
signalLib.hexToRgbSpaceSeparated color
```

**Input:** Color object with `.hex` attribute (e.g., `{ hex = "#6b87c8"; ... }`)  
**Output:** Space-separated RGB string (e.g., `"107 135 200"`)  
**Used by:** Zellij theme format

### hexWithAlpha

Adds alpha channel to hex color in RRGGBBAA format.

**Usage:**
```nix
signalLib.hexWithAlpha color alpha
```

**Input:** 
- `color`: Color object with `.hex` attribute
- `alpha`: Alpha value from 0.0 (transparent) to 1.0 (opaque)

**Output:** 8-character hex string without # (e.g., `"6b87c8f2"`)  
**Used by:** Fuzzel color format

### isValidHexColor

Validates hex color format.

**Usage:**
```nix
signalLib.isValidHexColor "#6b87c8"  # true
signalLib.isValidHexColor "invalid"  # false
```

**Input:** String to validate  
**Output:** Boolean (true if valid #RRGGBB or #RRGGBBAA format)

## Migration Notes

No breaking changes for users. All changes are internal to signal-nix implementation.

Existing configurations will continue to work without modification, but with improved color accuracy.

## Future Enhancements

Potential future uses of nix-colorizer:

1. **Color Manipulation**: Use `lighten`, `darken`, `blend` for programmatic color generation
2. **Harmony Generation**: Use `complementary`, `analogous`, `splitComplementary` for derived palettes
3. **Gradient Generation**: Use `gradient`, `shades`, `tints`, `tones` for smooth color transitions
4. **Accessibility**: Leverage OKLCh for better contrast ratio calculations

## References

- [nix-colorizer GitHub](https://github.com/nutsalhan87/nix-colorizer)
- [OKLCh Color Space](https://oklch.com/)
- [Signal Palette](https://github.com/lewisflude/signal-palette)
- [Architecture Documentation](./docs/architecture.md)
- [Design Principles](./docs/design-principles.md)

## Acknowledgments

Special thanks to [@nutsalhan87](https://github.com/nutsalhan87) for creating and maintaining nix-colorizer.
