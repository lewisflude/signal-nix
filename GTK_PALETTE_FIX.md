# GTK Adwaita Palette Fix - Summary

## Problem
Thunar file manager (and other GTK applications) were not fully themed with Signal colors because they rely on the Adwaita color palette variables (`blue_1`, `green_2`, `red_3`, etc.) which were not defined in the GTK module.

## Solution
Added complete Adwaita color palette definitions to the GTK module, mapping all 45 palette variables to appropriate Signal colors:

### Color Mappings

- **Blues** (`blue_1` through `blue_5`) → Signal secondary accent (Lc75 and Lc60)
- **Greens** (`green_1` through `green_5`) → Signal primary accent (Lc75 and Lc60)
- **Yellows** (`yellow_1` through `yellow_5`) → Signal warning accent (Lc75 and Lc60)
- **Oranges** (`orange_1` through `orange_5`) → Signal warning accent (Lc75 and Lc60)
- **Reds** (`red_1` through `red_5`) → Signal danger accent (Lc75 and Lc60)
- **Purples** (`purple_1` through `purple_5`) → Signal tertiary accent (Lc75 and Lc60)
- **Browns** (`brown_1` through `brown_5`) → Signal neutral tonal colors
- **Light grays** (`light_1` through `light_5`) → Signal surface colors (mode-aware)
- **Dark grays** (`dark_1` through `dark_5`) → Signal surface/text colors (mode-aware)

### Technical Details

Signal accent colors only provide two lightness levels (Lc60 and Lc75). The Adwaita palette requires 5 shades, so the mapping uses:
- **Shades 1-2**: Lc75 (lighter)
- **Shades 3-5**: Lc60 (darker, default for most UI elements)

This ensures GTK applications get consistent Signal colors while respecting the available palette structure.

## Files Changed

1. **`modules/gtk/default.nix`**
   - Added `adwaitaPalette` attribute set with all 45 color definitions
   - Added CSS `@define-color` directives for all palette variables
   - Updated module header comments to document the palette

2. **`CHANGELOG.md`**
   - Added entry documenting the new feature

3. **`docs/troubleshooting.md`**
   - Updated GTK theme troubleshooting section with note about palette colors

4. **`tests/comprehensive-test-suite.nix`**
   - Enhanced `integration-gtk-qt-theming` test to verify palette colors exist

## How to Use

If you're using signal-nix with GTK enabled, you automatically get these palette colors. Just rebuild:

```bash
home-manager switch
# or: nixos-rebuild switch
```

Then restart any GTK applications like Thunar:

```bash
pkill thunar
thunar &
```

## Verification

To verify the palette colors are in your GTK CSS:

```bash
# Check GTK 3 CSS
grep -E "@define-color (blue_|green_|red_)[1-5]" ~/.config/gtk-3.0/gtk.css

# Check GTK 4 CSS  
grep -E "@define-color (blue_|green_|red_)[1-5]" ~/.config/gtk-4.0/gtk.css
```

You should see all 45 color definitions in each file.

## Visual Result

Applications like Thunar, GNOME Files (Nautilus), and other GTK apps will now:
- Use Signal colors for all UI elements (not just backgrounds/text)
- Have properly themed icons, buttons, and widgets
- Match the Signal design system colors consistently

## Testing

Run the comprehensive test suite to verify:

```bash
cd /home/lewis/Code/signal-nix
nix flake check
```

The `integration-gtk-qt-theming` test specifically checks for these palette colors.

## Example CSS Output

Here's what the generated CSS looks like (example values):

```css
/* Blues - Signal secondary accent */
@define-color blue_1 #7fc9d5;  /* Lc75 - lighter */
@define-color blue_2 #7fc9d5;  /* Lc75 - lighter */
@define-color blue_3 #49acba;  /* Lc60 - default */
@define-color blue_4 #49acba;  /* Lc60 - darker */
@define-color blue_5 #49acba;  /* Lc60 - darker */

/* Greens - Signal primary/success */
@define-color green_1 #6ec584;  /* Lc75 - lighter */
@define-color green_2 #6ec584;  /* Lc75 - lighter */
@define-color green_3 #44a75f;  /* Lc60 - default */
@define-color green_4 #44a75f;  /* Lc60 - darker */
@define-color green_5 #44a75f;  /* Lc60 - darker */

/* ... and 35 more color definitions */
```

The lighter shades (1-2) use Lc75, while the darker shades (3-5) use Lc60, ensuring GTK apps have access to both light and dark variants of each accent color.

## References

- GTK Adwaita color palette: https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/named-colors.html
- Signal palette documentation: https://github.com/lewisflude/signal-palette
- Home Manager GTK options: https://nix-community.github.io/home-manager/options.xhtml#opt-gtk.enable
