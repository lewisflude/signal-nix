# Signal Theme Quick Reference

Quick lookup guide for theming applications with Signal color palette.

## Color Format Quick Lookup

| Application | Color Format | Example | Notes |
|------------|--------------|---------|-------|
| Alacritty | Hex with # | `"#6b87c8"` | Standard hex |
| Kitty | Hex with # | `"#6b87c8"` | Standard hex |
| WezTerm | Hex with # (in Lua) | `"#6b87c8"` | Standard hex |
| Ghostty | Mixed | basic: `"6b87c8"` palette: `"0=#6b87c8"` | No # for basic, with # for palette |
| Bat | Hex with # (XML) | `<string>#6b87c8</string>` | In tmTheme XML |
| Delta | Hex with # | `"#6b87c8"` | Can use color names too |
| Eza | ANSI codes | `"38;5;107"` or `"1;34"` | 256-color or standard ANSI |
| FZF | Hex with # | `"#6b87c8"` | Can use color names too |
| Lazygit | Hex with # (YAML) | `"#6b87c8"` | Standard hex |
| Yazi | Hex without # | `"6b87c8"` | Via removePrefix helper |
| Helix | Hex with # | `"#6b87c8"` | In TOML palette |
| Neovim | Hex with # (Lua) | `"#6b87c8"` | In highlight definitions |
| Tmux | Hex with # | `"#6b87c8"` | In tmux commands |
| Zellij | RGB space-separated | `"107 135 200"` | **Special: RGB not hex!** |
| Starship | Hex with # | `"#6b87c8"` | In TOML palette |
| Zsh | Hex with # | `fg=#6b87c8` | In ZSH_HIGHLIGHT_STYLES |
| Btop | Hex without # | `"6b87c8"` | In theme file |
| Fuzzel | RRGGBBAA no # | `"6b87c8ff"` | **8-digit with alpha** |
| GTK | Hex with # (CSS) | `#6b87c8` | CSS @define-color |
| Ironbar | Hex with # (CSS) | `#6b87c8` | GTK CSS |

## Nix Integration Quick Lookup

| Application | Integration Method | Example |
|------------|-------------------|---------|
| Alacritty | `programs.alacritty.settings` | Native HM module |
| Kitty | `programs.kitty.settings` | Native HM module |
| WezTerm | `programs.wezterm.extraConfig` | Lua generation |
| Ghostty | `programs.ghostty.settings` | Native HM module |
| Bat | `programs.bat.themes` + `programs.bat.config` | Theme file + config |
| Delta | `programs.delta.options` | Native HM module |
| Eza | `home.sessionVariables.EZA_COLORS` | Environment variable |
| FZF | `programs.fzf.colors` | Native HM module |
| Lazygit | `programs.lazygit.settings` | Native HM module |
| Yazi | `programs.yazi.theme` | Native HM module |
| Helix | `programs.helix.themes` + `settings` | Theme definition |
| Neovim | `programs.neovim.extraLuaConfig` | Lua generation |
| Tmux | `programs.tmux.extraConfig` | Tmux command strings |
| Zellij | `programs.zellij.settings.themes` | Native HM module |
| Starship | `programs.starship.settings` | Native HM module |
| Zsh | `programs.zsh.initExtra` | Shell initialization |
| Btop | `programs.btop.settings` + `xdg.configFile` | Config + theme file |
| Fuzzel | `programs.fuzzel.settings` | Native HM module |
| GTK | `gtk.gtk3.extraCss` + `gtk.gtk4.extraCss` | CSS injection |
| Ironbar | `programs.ironbar.style` + `config` | CSS + JSON config |

## Common Property Names

### Terminal Emulators (Standard)
```nix
{
  foreground = "#hex";
  background = "#hex";
  cursor = "#hex";
  selection_foreground = "#hex";
  selection_background = "#hex";
  
  # ANSI colors (0-15)
  color0 = "#hex";  # black
  color1 = "#hex";  # red
  color2 = "#hex";  # green
  color3 = "#hex";  # yellow
  color4 = "#hex";  # blue
  color5 = "#hex";  # magenta
  color6 = "#hex";  # cyan
  color7 = "#hex";  # white
  # 8-15 for bright variants
}
```

### Syntax Highlighters (Common Scopes)
```
comment
string
number
keyword
operator
function
type
variable
constant
escape
punctuation
```

### UI Elements (Common)
```
background
foreground
border
selection
hover/hovered
active/inactive
focused/unfocused
warning/error/success/info
```

## Special Format Notes

### Zellij RGB Conversion
```nix
# Helper function used in zellij.nix
hexToRgb = color:
  let
    hex = removePrefix "#" color.hex;
    r = builtins.fromTOML "x=0x${builtins.substring 0 2 hex}";
    g = builtins.fromTOML "x=0x${builtins.substring 2 2 hex}";
    b = builtins.fromTOML "x=0x${builtins.substring 4 2 hex}";
  in
  "${toString r.x} ${toString g.x} ${toString b.x}";
```

### Fuzzel RRGGBBAA
```nix
# Requires hex without # plus alpha channel
"${hexRaw colors.background}f2"  # ~95% opacity
"${hexRaw colors.text}ff"        # fully opaque
```

### Eza ANSI Codes
```bash
# Format: key=code
# Codes:
# 0-7: normal colors
# 30-37: foreground colors
# 40-47: background colors
# 1=bold, 2=dim, 3=italic, 4=underline
# 38;5;N: 256-color foreground
# 48;5;N: 256-color background

"di=1;34"        # bold blue directories
"ex=1;32"        # bold green executables
"ga=38;5;120"    # 256-color green for git added
```

### Bat tmTheme XML
```xml
<dict>
  <key>settings</key>
  <dict>
    <key>foreground</key>
    <string>#6b87c8</string>
    <key>background</key>
    <string>#1a1c22</string>
  </dict>
</dict>
```

## Signal Color Access Patterns

### Direct Access
```nix
signalColors.tonal."surface-Lc05"       # Returns color object
signalColors.accent.focus.Lc75          # Returns color object
signalColors.categorical.GA02           # Returns color object
```

### Hex Formats
```nix
color.hex        # "#rrggbb" - with hash
color.hexRaw     # "rrggbb" - without hash (for fuzzel, ghostty)
```

### RGB Conversion (for Zellij)
```nix
hexToRgb color   # "R G B" - space-separated
```

## Troubleshooting Checklist

Color not applying?

1. **Check format**:
   - Does app need # prefix or not?
   - Is it RGB instead of hex? (zellij)
   - Does it need alpha channel? (fuzzel)

2. **Check property names**:
   - Verify exact spelling from THEME_SOURCES.md
   - Check for hyphens vs underscores
   - Confirm casing (some are case-sensitive)

3. **Check Nix integration**:
   - Using correct home-manager option path?
   - File in correct xdg.configFile location?
   - Need to restart application?

4. **Check dependencies**:
   - Delta requires bat themes
   - Some need plugins (zsh-syntax-highlighting)

## Quick Start Examples

### Adding a New Color Property

1. Find app in THEME_SOURCES.md
2. Locate color schema section
3. Check format requirements
4. Use appropriate Signal color:
   ```nix
   property = signalColors.accent.focus.Lc75.hex;
   ```

### Creating New Theme Module

```nix
{config, lib, signalColors, ...}: let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  
  # Define colors
  colors = {
    bg = signalColors.tonal."surface-Lc05";
    fg = signalColors.tonal."text-Lc75";
  };
  
  shouldTheme = cfg.category.app.enable || 
    (cfg.autoEnable && (config.programs.app.enable or false));
in {
  config = mkIf (cfg.enable && shouldTheme) {
    programs.app.settings = {
      # Apply colors here
      background = colors.bg.hex;
      foreground = colors.fg.hex;
    };
  };
}
```

---

**Quick Reference Version**: 1.0  
**Last Updated**: 2026-01-17  
**See Also**: THEME_SOURCES.md for complete documentation
