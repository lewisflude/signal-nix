# Accessibility Testing in Signal-nix

## Overview

Signal-nix includes basic accessibility validation helpers, but they are **simplified approximations** and do NOT implement full APCA (Accessible Perceptual Contrast Algorithm).

## Current Implementation

### What We Have: `lib.accessibility.estimateContrast`

```nix
# lib/default.nix
accessibility.estimateContrast {
  foreground = { l = 0.9; c = 0.0; h = 0.0; };
  background = { l = 0.1; c = 0.0; h = 0.0; };
}
# Returns: ~86.4 (rough approximation)
```

**How it works:**
- Calculates absolute difference between foreground and background lightness
- Multiplies by 108 to approximate APCA scale (0-108)
- **This is a linear calculation** - real APCA is non-linear

### Limitations

❌ **NOT** full APCA implementation  
❌ **NOT** suitable for accessibility compliance  
❌ **DOES NOT** consider:
- Perceptual non-linearity
- Spatial frequency
- Polarity (light-on-dark vs dark-on-light)
- Chroma influence on perceived contrast
- Font size and weight adjustments

✅ **CAN** be used for:
- Quick sanity checks during development
- Rough ordering of contrast levels
- Detecting obviously poor contrast

## Why Not Full APCA?

APCA requires:
1. Complex perceptual models
2. Non-linear transformations
3. Lookup tables or approximation functions
4. Context-aware calculations

Implementing this in pure Nix would be:
- Complex (hundreds of lines)
- Slow (many calculations)
- Hard to maintain
- Potentially inaccurate without proper testing

## Recommendations

### For Development

Use the simplified helpers for quick checks:

```nix
let
  contrast = signalLib.accessibility.estimateContrast {
    foreground = colors.text-primary;
    background = colors.surface-base;
  };
  isGoodEnough = contrast >= 60.0;  # Rough heuristic
in
  # ... use isGoodEnough for basic validation
```

### For Production

**Manual verification required:**

1. **Use proper APCA tools:**
   - https://www.myndex.com/APCA/
   - https://contrast.tools/
   - Browser extensions (e.g., APCA Checker)

2. **Validate with signal-palette:**
   If signal-palette repository implements proper APCA, use that:
   ```bash
   cd ../signal-palette
   # Use their validation tools
   ```

3. **Test with real users:**
   - Various lighting conditions
   - Different screen types
   - Assistive technologies
   - Colorblindness simulation tools

4. **Check WCAG compliance:**
   While APCA is more advanced, WCAG 2.1 AA/AAA is still the legal standard:
   - https://webaim.org/resources/contrastchecker/

## Testing Strategy

### What We Test

```nix
# tests/default.nix
accessibility-contrast-estimation = mkTest "accessibility-contrast" {
  testHighContrast = {
    # Verify basic math works
    expr = /* ... */;
    expected = true;
  };
};
```

**These tests verify:**
- Helper functions don't crash
- Basic ordering is correct (high > low)
- Edge cases are handled

**These tests DO NOT verify:**
- Actual accessibility compliance
- APCA accuracy
- Real-world usability

### What We Should Test

For proper accessibility testing, we would need:

```nix
# Future: Integration with proper APCA implementation
accessibility-apca-compliance = let
  # Call external APCA tool
  apcaResult = pkgs.runCommand "check-apca" {} ''
    ${pkgs.signal-palette-tools}/bin/check-apca \
      --fg "${colors.text-primary.hex}" \
      --bg "${colors.surface-base.hex}" \
      > $out
  '';
in
  # Verify APCA score meets requirements
  # ...
```

## Documentation for Users

### In Module Comments

All modules using accessibility helpers should include:

```nix
# NOTE: Color contrast is validated using simplified approximation.
# For accessibility compliance, verify colors with proper APCA tools:
# https://www.myndex.com/APCA/
```

### In README / Docs

Add to documentation:

> **Accessibility:** Signal colors are designed with APCA guidelines in mind, but users should independently verify accessibility compliance for their specific use cases. The project's built-in contrast checking is approximate and should not be relied upon for legal/compliance requirements.

## Future Improvements

### Option 1: External Tool Integration

```nix
# Call signal-palette if it has APCA implementation
accessibility.realAPCA = { foreground, background }:
  let
    result = pkgs.runCommand "apca" {} ''
      ${signal-palette}/bin/apca-check \
        --fg ${foreground.hex} \
        --bg ${background.hex}
    '';
  in
    # Parse and return result
```

### Option 2: Nix Implementation

If someone wants to implement proper APCA in Nix:
- Port the reference implementation
- Add comprehensive tests against known values
- Document the algorithms used
- Keep it updated with APCA spec changes

### Option 3: Remove Helpers

If the approximation is more harmful than helpful:
- Remove `accessibility.*` from lib
- Remove tests that give false confidence
- Document that users must verify manually
- Provide links to proper tools

## References

- **APCA:** https://github.com/Myndex/SAPC-APCA
- **APCA Calculator:** https://www.myndex.com/APCA/
- **WCAG 2.1:** https://www.w3.org/WAI/WCAG21/quickref/
- **WebAIM Contrast Checker:** https://webaim.org/resources/contrastchecker/
- **Contrast.tools:** https://contrast.tools/

## Summary

✅ Use simplified helpers for development sanity checks  
❌ Do NOT rely on them for accessibility compliance  
✅ Always validate with proper APCA tools  
✅ Document limitations clearly  
✅ Test with real users and assistive technologies

**The simplified helpers are better than nothing, but they are NOT a substitute for proper accessibility testing.**
