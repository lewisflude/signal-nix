# Ironbar Integration

Ironbar is a customizable GTK status bar for Wayland compositors. Signal provides a color palette for ironbar without configuring your bar layout or widgets.

## Overview

Signal provides **colors only** for ironbar. You maintain full control over:
- Layout (position, size, margins)
- Widget configuration (workspaces, clock, tray, etc.)
- Typography (fonts, sizes)
- Spacing and padding

Signal provides:
- Color definitions via CSS variables
- Semantic color tokens that adapt to light/dark mode
- Access to raw color values in Nix

## Quick Start

### 1. Enable Signal Colors

In your home-manager configuration:

```nix
theming.signal = {
  enable = true;
  ironbar.enable = true;
};
```

### 2. Import Colors in Your Ironbar Config

```nix
programs.ironbar = {
  enable = true;
  
  style = pkgs.writeText "ironbar-style.css" ''
    @import url("${config.theming.signal.colors.ironbar.cssFile}");
    
    /* Your custom styles using Signal colors */
    label {
      color: @text_primary;
    }
    
    #bar {
      background-color: @surface_base;
      border: 2px solid @surface_emphasis;
    }
  '';
  
  config = {
    /* Your widget configuration */
  };
};
```

## Available Color Tokens

Signal provides these CSS color tokens:

### Text Colors
- `@text_primary` - Primary text color (highest contrast)
- `@text_secondary` - Secondary text color (medium contrast)
- `@text_tertiary` - Tertiary text color (low contrast)

### Surface Colors
- `@surface_base` - Base surface color
- `@surface_emphasis` - Emphasized surface color

### Accent Colors
- `@accent_focus` - Focus/active state color
- `@accent_success` - Success state color
- `@accent_warning` - Warning state color
- `@accent_danger` - Danger/critical state color

## Advanced Usage

### Access Raw Color Values in Nix

```nix
let
  signalColors = config.theming.signal.colors.ironbar.tokens;
in
{
  # Access individual color values
  # signalColors.text.primary
  # signalColors.surface.base
  # signalColors.accent.focus
}
```

### Use Signal Colors with Custom CSS File

```nix
programs.ironbar = {
  enable = true;
  style = ./ironbar-style.css;
};
```

In `ironbar-style.css`:
```css
@import url("/nix/store/...-ironbar-signal-colors.css");
/* Note: You'll need to reference the actual store path */
```

## Complete Example

See `examples/ironbar-complete.css` for a full stylesheet using Signal colors.

## Color Adaptation

Colors automatically adapt to your theme mode:
- `theming.signal.mode = "dark"` - Dark mode colors
- `theming.signal.mode = "light"` - Light mode colors

## Troubleshooting

### Colors not applying
- Ensure `theming.signal.ironbar.enable = true`
- Verify the CSS import path is correct
- Check that ironbar is enabled: `programs.ironbar.enable = true`

### Want different color values
Signal uses specific tonal values from the design system. To customize:
1. Fork signal-nix
2. Edit `modules/ironbar/tokens.nix`
3. Change the tonal mappings (e.g., `"text-Lc75"` to `"text-Lc90"`)
