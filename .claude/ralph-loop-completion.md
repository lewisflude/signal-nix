# Ralph Loop Task Completion - GTK Theming Documentation Research

## Task Summary
Find the official docs or source of truth for GTK theming configuration that allows users to configure the color theme using Home Manager or Nix, similar to the ghostty example provided.

## Task Completed: ✅

### Official Documentation Found

**1. GTK/Adwaita Named Colors (Official Source of Truth)**
- **Primary Source**: [GNOME GTK Adwaita Colors SCSS](https://github.com/GNOME/gtk/blob/2dfb8de0ec93dfbb84df59841d8a43ff3c1cbb7f/gtk/theme/Adwaita/_colors.scss)
- **Documentation**: [Libadwaita Styles & Appearance](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/1.5/styles-and-appearance.html)
- **Complete palette**: 45 named colors (blue_1 through dark_5)

**2. Home Manager GTK Options (Official Configuration Method)**
- **Documentation**: [Home Manager Options Reference](https://nix-community.github.io/home-manager/options.xhtml)
- **Source Code**:
  - [gtk.nix](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk.nix)
  - [gtk3.nix](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk/gtk3.nix)
  - [gtk4.nix](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk/gtk4.nix)

### Best Choice Identified

**Home Manager Module Options:**
- `gtk.enable` - Enable GTK theming and configuration
- `gtk.gtk3.extraCss` - Custom CSS for GTK3 (`$XDG_CONFIG_HOME/gtk-3.0/gtk.css`)
- `gtk.gtk4.extraCss` - Custom CSS for GTK4 (`$XDG_CONFIG_HOME/gtk-4.0/gtk.css`)

### Comparison with Ghostty Example

**Ghostty:**
- Official docs: https://ghostty.org/docs/features/theme
- Home Manager option: `programs.ghostty.themes` (https://mynixos.com/home-manager/option/programs.ghostty.themes)

**GTK (Equivalent):**
- Official docs: https://github.com/GNOME/gtk/blob/main/gtk/theme/Adwaita/_colors.scss
- Home Manager options: `gtk.gtk3.extraCss` and `gtk.gtk4.extraCss`

### Why This Is The Best Choice

1. **Pure Nix/Home Manager Integration** ✅
   - Declarative configuration
   - No external tools required
   - Version controlled

2. **CSS-Based Color Overrides** ✅
   - Uses `@define-color` directives
   - Compatible with Adwaita base theme
   - Standard GTK theming method

3. **Complete Coverage** ✅
   - Supports all 45 Adwaita palette colors
   - Works with all GTK applications (Thunar, Nautilus, etc.)
   - Covers GTK3 and GTK4

4. **Matches Existing Implementation** ✅
   - Signal-Nix already uses this approach (modules/gtk/default.nix:405-406)
   - Proven to work correctly

### Verification

The current Signal-Nix implementation (modules/gtk/default.nix) confirms this approach:

```nix
config = mkIf cfg.enable {
  gtk = {
    enable = true;
    gtk3.extraCss = gtkCss;  # Line 405
    gtk4.extraCss = gtkCss;  # Line 406
  };
};
```

Where `gtkCss` contains all 45 Adwaita palette color definitions using `@define-color` directives.

## Conclusion

✅ **Task Complete**: Found official documentation for GTK theming
✅ **Best choice verified**: Home Manager `gtk.gtk3.extraCss` and `gtk.gtk4.extraCss` options
✅ **Implementation confirmed**: Signal-Nix already uses the correct approach
✅ **Documentation saved**: Full research in `.claude/gtk-theming-docs-research.md`

## All Official Sources Referenced

1. [GNOME GTK Adwaita Colors](https://github.com/GNOME/gtk/blob/2dfb8de0ec93dfbb84df59841d8a43ff3c1cbb7f/gtk/theme/Adwaita/_colors.scss)
2. [Libadwaita Styles & Appearance](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/1.5/styles-and-appearance.html)
3. [GNOME HIG - UI Styling](https://developer.gnome.org/hig/guidelines/ui-styling.html)
4. [Home Manager Options](https://nix-community.github.io/home-manager/options.xhtml)
5. [Home Manager GTK Module](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk.nix)
6. [Home Manager GTK3 Module](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk/gtk3.nix)
7. [Home Manager GTK4 Module](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk/gtk4.nix)
8. [MyNixOS GTK Options](https://mynixos.com/home-manager/options/gtk)
9. [Orchis Theme Libadwaita Colors](https://github.com/vinceliuice/Orchis-theme/blob/master/src/_sass/gtk/_colors-libadwaita.scss)

The task is complete and all documentation has been verified against official sources.
