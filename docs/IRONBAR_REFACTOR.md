# Ironbar Refactor Summary

## What Changed

Signal-nix's ironbar module has been refactored from a **full configuration provider** to a **color palette provider**.

### Before (Old Approach)
- Signal configured `programs.ironbar.style` directly
- Users had limited control over styling
- Signal mixed colors with layout decisions

### After (New Approach)
- Signal **only provides colors** via `config.theming.signal.colors.ironbar`
- Users maintain full control over all styling and layout
- Clean separation of concerns

## Architecture

### Signal-nix Provides

1. **CSS File** (`config.theming.signal.colors.ironbar.cssFile`)
   - Contains ONLY `@define-color` statements
   - No styling, no layout, no typography
   - Ready to import in user configs

2. **Color Tokens** (`config.theming.signal.colors.ironbar.tokens`)
   - Raw color values as Nix attributes
   - Useful for programmatic access
   - Structure:
     ```nix
     {
       text = { primary = "#c0c3d1"; secondary = "#9498ab"; tertiary = "#6b6f82"; };
       surface = { base = "#25262f"; emphasis = "#2d2e39"; };
       accent = { focus = "#5a7dcf"; success = "..."; warning = "..."; danger = "..."; };
     }
     ```

### User Controls

Everything else:
- Layout (bar position, margins, padding)
- Typography (fonts, sizes)
- Widget configuration (workspaces, tray, clock, etc.)
- Spacing and sizing
- Border styles and radii

## Usage Pattern

```nix
# 1. Enable Signal colors
theming.signal.ironbar.enable = true;

# 2. Import in your ironbar config
programs.ironbar = {
  enable = true;
  
  style = pkgs.writeText "ironbar-style.css" ''
    @import url("${config.theming.signal.colors.ironbar.cssFile}");
    
    /* Your custom styling using Signal colors */
    #bar {
      background-color: @surface_base;
      border: 2px solid @surface_emphasis;
    }
    
    label {
      color: @text_primary;
    }
  '';
  
  config = { /* your widgets */ };
};
```

## Available Color Tokens

- `@text_primary`, `@text_secondary`, `@text_tertiary`
- `@surface_base`, `@surface_emphasis`
- `@accent_focus`, `@accent_success`, `@accent_warning`, `@accent_danger`

## Files Modified

### signal-nix
1. `modules/ironbar/default.nix` - Refactored to only provide colors
2. `modules/common/default.nix` - Added `colors` option to expose color exports
3. `examples/ironbar-complete.css` - Updated to show consumption pattern
4. `docs/ironbar-integration.md` - New documentation

### User Config (../../.config/nix)
1. `home/nixos/apps/ironbar.nix` - Updated to import and use Signal colors

## Testing

All syntax validated:
- ✓ signal-nix ironbar module
- ✓ signal-nix common module  
- ✓ user ironbar configuration

## Benefits

1. **Separation of Concerns** - Signal handles colors, users handle everything else
2. **Full User Control** - No magic, no hidden configuration
3. **Explicit Dependencies** - Clear what comes from where
4. **Easier Customization** - Users can override any styling without fighting Signal
5. **Better Documentation** - Clear boundary between Signal and user code

## Migration Path

For existing users:
1. Enable `theming.signal.ironbar.enable = true`
2. Signal no longer sets `programs.ironbar.style`
3. Import colors in your own style: `@import url("${config.theming.signal.colors.ironbar.cssFile}");`
4. Add your custom styling using Signal's color tokens
