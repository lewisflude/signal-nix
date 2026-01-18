# GTK Theming Documentation Research

## Task
Find the official docs or source of truth for GTK theming to configure the color theme while allowing a user to use home manager or nix to configure everything else.

## Official Documentation Sources

### 1. GTK/Adwaita Named Colors (Official Source of Truth)

**Primary Documentation:**
- **Libadwaita Named Colors**: The complete Adwaita color palette is defined in the libadwaita project
  - Source code reference: [GNOME GTK Adwaita Colors](https://github.com/GNOME/gtk/blob/2dfb8de0ec93dfbb84df59841d8a43ff3c1cbb7f/gtk/theme/Adwaita/_colors.scss)
  - Community implementation: [Orchis Theme Libadwaita Colors](https://github.com/vinceliuice/Orchis-theme/blob/master/src/_sass/gtk/_colors-libadwaita.scss)

**Complete Named Color Palette (45 colors):**

The Adwaita design system defines 45 named colors organized into 9 families:

1. **Blues** (5): `blue_1`, `blue_2`, `blue_3`, `blue_4`, `blue_5`
2. **Greens** (5): `green_1`, `green_2`, `green_3`, `green_4`, `green_5`
3. **Yellows** (5): `yellow_1`, `yellow_2`, `yellow_3`, `yellow_4`, `yellow_5`
4. **Oranges** (5): `orange_1`, `orange_2`, `orange_3`, `orange_4`, `orange_5`
5. **Reds** (5): `red_1`, `red_2`, `red_3`, `red_4`, `red_5`
6. **Purples** (5): `purple_1`, `purple_2`, `purple_3`, `purple_4`, `purple_5`
7. **Browns** (5): `brown_1`, `brown_2`, `brown_3`, `brown_4`, `brown_5`
8. **Light Grays** (5): `light_1`, `light_2`, `light_3`, `light_4`, `light_5`
9. **Dark Grays** (5): `dark_1`, `dark_2`, `dark_3`, `dark_4`, `dark_5`

**Color Intensity Scale:**
- Shade 1: Lightest
- Shade 2: Light
- Shade 3: Medium (default/most commonly used)
- Shade 4: Dark
- Shade 5: Darkest

**Official Documentation Links:**
- [GNOME Developer HIG - UI Styling](https://developer.gnome.org/hig/guidelines/ui-styling.html)
- [Libadwaita Styles & Appearance](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/1.5/styles-and-appearance.html)

### 2. Home Manager GTK Configuration (NixOS/Home Manager)

**Official Documentation:**
- **Home Manager Options Reference**: [Appendix A - Configuration Options](https://nix-community.github.io/home-manager/options.xhtml)
- **MyNixOS GTK Options**: [gtk options search](https://mynixos.com/home-manager/options/gtk)
- **Source Code**: [home-manager/modules/misc/gtk.nix](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk.nix)

**Key Home Manager GTK Options:**

#### Main Option:
- `gtk.enable` - Enables GTK theming and configuration

#### Global Options (apply to all GTK versions):
- `gtk.theme` - Default theme for all GTK versions
- `gtk.font` - Default font for all GTK versions
- `gtk.iconTheme` - Default icon theme for all GTK versions
- `gtk.cursorTheme` - Default cursor theme for all GTK versions

#### Version-Specific Options:
- `gtk.gtk2.*` - GTK 2 specific configuration
- `gtk.gtk3.*` - GTK 3 specific configuration
- `gtk.gtk4.*` - GTK 4 specific configuration

#### Custom CSS Injection (The Best Choice for Color Theming):

**GTK 3 Custom CSS:**
```nix
gtk.gtk3.extraCss = mkOption {
  type = types.lines;
  default = "";
  description = "Extra CSS for `$XDG_CONFIG_HOME/gtk-3.0/gtk.css`.";
};
```

**GTK 4 Custom CSS:**
```nix
gtk.gtk4.extraCss = mkOption {
  type = types.lines;
  default = "";
  description = "Extra CSS for $XDG_CONFIG_HOME/gtk-4.0/gtk.css";
};
```

**Implementation:**
- GTK 3: CSS written to `$XDG_CONFIG_HOME/gtk-3.0/gtk.css`
- GTK 4: CSS written to `$XDG_CONFIG_HOME/gtk-4.0/gtk.css`
- Both support theme imports and custom CSS concatenation

## Best Choice for Signal-Nix

**Recommendation: Home Manager `gtk.gtk3.extraCss` and `gtk.gtk4.extraCss`**

### Why This Is the Best Choice:

1. **Pure Nix/Home Manager Integration**
   - No external tools or manual configuration required
   - Declarative configuration in Nix
   - Version controlled with your dotfiles

2. **CSS-Based Color Overrides**
   - Use `@define-color` directives to override Adwaita palette colors
   - Maintains compatibility with Adwaita base theme
   - GTK apps automatically pick up the colors

3. **Support for All 45 Adwaita Colors**
   - Can define all palette colors (blue_1 through dark_5)
   - Apps like Thunar, Nautilus, GNOME apps use these named colors
   - Provides comprehensive coverage

4. **Works With Existing Configurations**
   - User can still configure everything else through Home Manager
   - No conflicts with other Home Manager options
   - Follows the principle: "one source of truth" (all in Nix)

### Example Implementation:

```nix
{
  gtk = {
    enable = true;

    gtk3.extraCss = ''
      @define-color blue_1 #7fc9d5;
      @define-color blue_2 #7fc9d5;
      @define-color blue_3 #49acba;
      @define-color blue_4 #49acba;
      @define-color blue_5 #49acba;

      @define-color green_1 #6ec584;
      @define-color green_2 #6ec584;
      @define-color green_3 #44a75f;
      /* ... all 45 colors */
    '';

    gtk4.extraCss = ''
      /* Same color definitions for GTK4 */
    '';
  };
}
```

## Alternative Options Considered

### 1. NixOS Module Option
- **Path**: `theming.signal.gtk.enable` (custom module)
- **Pros**: Integrated with Signal theming system
- **Cons**: Requires custom module, less standard than Home Manager

### 2. Nix-Darwin Module Option
- **Not applicable**: GTK is primarily for Linux/GNOME
- Darwin users typically don't use GTK apps

### 3. GTK Theme Package
- **Option**: `gtk.theme.package` and `gtk.theme.name`
- **Pros**: Clean separation of theme code
- **Cons**: Requires building/packaging a full GTK theme, more complex

### 4. Direct File Configuration
- **Not recommended**: Bypasses Nix declarative model
- Files would not be version controlled or reproducible

## Verification

The current Signal-Nix implementation already uses this approach:

**File**: `modules/gtk/default.nix`
```nix
config = mkIf cfg.enable {
  gtk = {
    enable = true;
    theme = { ... };

    gtk3.extraCss = ''
      /* Adwaita palette colors */
      ${adwaitaPaletteCss}
      /* Signal colors */
      ${signalColorsCss}
    '';

    gtk4.extraCss = ''
      /* Same as GTK3 */
    '';
  };
};
```

This confirms that **Home Manager's `gtk.gtk3.extraCss` and `gtk.gtk4.extraCss`** are the official, correct, and best choice for GTK color theming in a Nix-based workflow.

## Sources

- [GNOME GTK Adwaita Colors SCSS](https://github.com/GNOME/gtk/blob/2dfb8de0ec93dfbb84df59841d8a43ff3c1cbb7f/gtk/theme/Adwaita/_colors.scss)
- [Orchis Theme Libadwaita Colors](https://github.com/vinceliuice/Orchis-theme/blob/master/src/_sass/gtk/_colors-libadwaita.scss)
- [Libadwaita Styles & Appearance](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/1.5/styles-and-appearance.html)
- [GNOME HIG - UI Styling](https://developer.gnome.org/hig/guidelines/ui-styling.html)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.xhtml)
- [Home Manager GTK Module Source](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk.nix)
- [Home Manager GTK3 Module](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk/gtk3.nix)
- [Home Manager GTK4 Module](https://github.com/nix-community/home-manager/blob/master/modules/misc/gtk/gtk4.nix)
- [MyNixOS GTK Options](https://mynixos.com/home-manager/options/gtk)
