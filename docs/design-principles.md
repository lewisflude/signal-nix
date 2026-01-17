# Signal-nix Design Principles

## Core Philosophy: Color Theme, Not Configuration Manager

**Signal-nix is a color theme system, not a program configuration framework.**

Signal focuses exclusively on applying colors with maximum fidelity and accuracy, using professional-grade color conversion tools to ensure colors maintain their intended appearance across all applications.

### What Signal Does ✅

- Applies Signal Design System colors to your programs
- Provides consistent color palettes (dark/light/auto modes)
- Manages ANSI terminal colors
- Generates syntax highlighting themes
- Sets UI element colors (backgrounds, foregrounds, borders, selections)
- Ensures color consistency across your entire system
- **Converts colors with high fidelity using [nix-colorizer](https://github.com/nutsalhan87/nix-colorizer)**
  - OKLCh color space for perceptual accuracy
  - Proper hex ↔ sRGB ↔ OKLCh conversions
  - Alpha channel support for transparency
  - Maintains color precision for professional design systems

### What Signal Does NOT Do ❌

- **Enable programs** - You must set `programs.X.enable = true` yourself
- **Configure fonts** - Font family, size, weight are your choice
- **Set layout** - Margins, padding, spacing, border radius are yours
- **Configure behavior** - Keybindings, features, modes are your preferences
- **Manage services** - systemd, autostart, daemons are your responsibility
- **Set tooling** - Pagers, formatters, external tools are your choices

## Color vs. Behavior: Decision Matrix

### ✅ Allowed (Color/Theme Related)

```nix
# Colors in any format
foreground = "#e8e8ed";
background = "1a1b24";
color0 = colors.black.hex;

# Theme selection
theme = "signal-dark";

# Color mappings
syntax.string = colors.categorical.GA02;

# Transparency (color alpha channel)
opacity = 0.95;  # OK: affects color rendering
```

### ❌ Not Allowed (Behavior/Layout/Configuration)

```nix
# Typography
font-family = "monospace";  # ❌ User's choice
font-size = 14px;           # ❌ User's choice

# Layout
margin = 12px;              # ❌ User's choice
padding = "4px 16px";       # ❌ User's choice
border-radius = 16px;       # ❌ Visual style, not color

# Behavior
italic-text = "always";     # ❌ User preference
style = "numbers,changes";  # ❌ Display preference
pager = "less -FR";         # ❌ Tool preference

# Services
systemd = true;             # ❌ Service management
autostart = true;           # ❌ User's environment
```

## Correct Usage Pattern

### User's Configuration

```nix
{
  # Step 1: User enables and configures programs
  programs.bat = {
    enable = true;                    # You enable it
    
    config = {
      italic-text = "always";         # You configure it
      style = "numbers,changes,header";
      pager = "less -FR";
    };
  };
  
  programs.kitty = {
    enable = true;
    
    settings = {
      font_family = "JetBrains Mono"; # You choose fonts
      font_size = 12;
      
      # Other settings you want...
      scrollback_lines = 10000;
      enable_audio_bell = false;
    };
  };
  
  # Step 2: Signal applies colors to enabled programs
  theming.signal = {
    enable = true;
    mode = "dark";
    
    cli.bat.enable = true;           # Signal adds colors only
    terminals.kitty.enable = true;   # Signal adds colors only
  };
}
```

### What Signal Does Behind the Scenes

```nix
# Signal's bat.nix module
programs.bat.themes = {
  signal-dark = /* ... color definitions ... */;
};

programs.bat.config = {
  theme = "signal-dark";             # ✅ ONLY theme selection
  # Does NOT set: italic-text, style, pager, etc.
};

# Signal's kitty.nix module
programs.kitty.settings = {
  foreground = "#e8e8ed";            # ✅ Colors
  background = "#1a1b24";
  cursor = "#5a7dcf";
  color0 = "#15161d";
  # ... more colors ...
  
  # Does NOT set: font_family, font_size, scrollback, etc.
};
```

## Module Development Guidelines

### When Adding a New Module

1. **Identify color-only settings** - What configuration keys are purely color-related?
2. **Use conditional application** - Only apply if program is enabled
3. **Document user responsibilities** - What must users configure themselves?
4. **Test in isolation** - Module should not enable the program

### Color-Only Module Template

```nix
{
  config,
  lib,
  signalColors,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  
  # Extract colors you need
  colors = {
    background = signalColors.tonal."surface-Lc05";
    foreground = signalColors.tonal."text-Lc75";
    # ...
  };
  
  # Check if should theme (respects autoEnable)
  shouldTheme = cfg.yourModule.enable 
    || (cfg.autoEnable && (config.programs.yourApp.enable or false));
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.yourApp = {
      # ONLY set color-related properties
      colorSettings = {
        background = colors.background.hex;
        foreground = colors.foreground.hex;
      };
      
      # DO NOT set:
      # - enable = true;
      # - font sizes, families
      # - margins, padding
      # - keybindings
      # - feature flags
      # - service management
    };
  };
}
```

### CSS/Style File Generation

When generating CSS or config files, strip out non-color properties:

```nix
# ❌ BAD: Includes layout and typography
styleFile = pkgs.writeText "theme.css" ''
  * {
    font-family: monospace;  /* ❌ Remove */
    font-size: 14px;         /* ❌ Remove */
    color: ${colors.fg};     /* ✅ Keep */
  }
  
  .container {
    margin: 12px;            /* ❌ Remove */
    padding: 8px;            /* ❌ Remove */
    border-radius: 16px;     /* ❌ Remove */
    background: ${colors.bg}; /* ✅ Keep */
    border-color: ${colors.border}; /* ✅ Keep */
  }
'';

# ✅ GOOD: Colors only
styleFile = pkgs.writeText "theme.css" ''
  /* Signal Theme - Colors Only */
  /* Add your own layout/typography as needed */
  
  :root {
    --color-fg: ${colors.fg};
    --color-bg: ${colors.bg};
    --color-border: ${colors.border};
    --color-accent: ${colors.accent};
  }
  
  /* Or using @define-color for GTK */
  @define-color text_primary ${colors.fg};
  @define-color surface_base ${colors.bg};
'';
```

## Enforcement

### Code Review Checklist

- [ ] Does the module only set color-related properties?
- [ ] Does the module avoid setting `enable = true`?
- [ ] Does the module avoid fonts, sizes, spacing, margins?
- [ ] Does the module avoid behavior flags and features?
- [ ] Does the module avoid service management?
- [ ] Are user responsibilities clearly documented?

### CI Validation (Future)

Consider adding automated checks:

```nix
# Deny-list of non-color properties
validation.deniedProperties = [
  "enable"
  "font-family" "font-size" "font-weight"
  "margin" "padding" "border-radius"
  "systemd" "autostart"
  "italic-text" "style" "pager"
  # ...
];
```

## Migration Path for Existing Violations

1. **Identify** - Audit all modules (see REFACTORING_AUDIT.md)
2. **Document** - Add comments explaining what users should configure
3. **Remove** - Delete non-color settings
4. **Test** - Verify colors still apply correctly
5. **Announce** - Document breaking changes in CHANGELOG

## Examples

See `examples/` directory for correct usage patterns:
- `basic.nix` - Shows user enabling programs first, then Signal theming
- `auto-enable.nix` - Shows autoEnable feature with user-owned config
- `custom-brand.nix` - Shows extending colors without changing behavior

## Questions?

If unsure whether a setting is "color-related":

**Ask: Can this setting affect the visual output on a different user's system with different preferences?**

- Color: Yes → Allowed (universal)
- Font size: Yes → Not allowed (personal preference)
- Background color: Yes → Allowed (universal)
- Keybinding: No → Not allowed (personal preference)
- Border color: Yes → Allowed (universal)
- Border radius: Yes BUT personal preference → Not allowed

**When in doubt, leave it to the user.**
