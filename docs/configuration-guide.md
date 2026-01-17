# Configuration Guide

Complete reference for all Signal configuration options.

## Table of Contents

- [Quick Reference](#quick-reference)
- [Core Options](#core-options)
- [Theming Modes](#theming-modes)
- [Application Configuration](#application-configuration)
- [Desktop Environment](#desktop-environment)
- [Brand Customization](#brand-customization)
- [Per-Category Options](#per-category-options)

## Quick Reference

### Minimal Configuration

```nix
theming.signal = {
  enable = true;
  autoEnable = true;
  mode = "dark";
};
```

### Full Configuration Template

```nix
theming.signal = {
  # Core settings
  enable = true;
  autoEnable = true;
  mode = "dark";
  
  # Desktop
  ironbar = {
    enable = true;
    profile = "relaxed";
  };
  gtk = {
    enable = true;
    version = "both";
  };
  fuzzel.enable = true;
  
  # Editors
  editors = {
    helix.enable = true;
    neovim.enable = true;
  };
  
  # Terminals
  terminals = {
    ghostty.enable = true;
    alacritty.enable = true;
    kitty.enable = true;
    wezterm.enable = true;
  };
  
  # Multiplexers
  multiplexers = {
    tmux.enable = true;
    zellij.enable = true;
  };
  
  # CLI Tools
  cli = {
    bat.enable = true;
    delta.enable = true;
    eza.enable = true;
    fzf.enable = true;
    lazygit.enable = true;
    yazi.enable = true;
  };
  
  # System monitors
  monitors.btop.enable = true;
  
  # Shell prompts
  prompts.starship.enable = true;
  
  # Shells
  shells.zsh.enable = true;
  
  # Brand customization (optional)
  brandGovernance = {
    policy = "functional-override";
    decorativeBrandColors = { };
  };
};
```

## Core Options

### enable

**Type**: `boolean`  
**Default**: `false`

Master switch for Signal theming. Must be `true` for any theming to occur.

```nix
theming.signal.enable = true;
```

### autoEnable

**Type**: `boolean`  
**Default**: `false`  
**Recommended**: `true`

Automatically themes all programs that are enabled in your configuration.

```nix
theming.signal.autoEnable = true;
```

**How it works:**

- Detects `programs.<app>.enable = true`
- Applies Signal colors if the app is supported
- Can be overridden per-app with explicit enable/disable

**Precedence:**

1. Explicit `theming.signal.<category>.<app>.enable = true` → Always theme
2. Explicit `theming.signal.<category>.<app>.enable = false` → Never theme
3. No explicit setting + `autoEnable = true` → Theme if program enabled
4. No explicit setting + `autoEnable = false` → Don't theme

**Example with overrides:**

```nix
theming.signal = {
  enable = true;
  autoEnable = true;  # Theme everything by default
  
  # But don't theme these specific programs
  cli.bat.enable = false;
  terminals.alacritty.enable = false;
};
```

### mode

**Type**: `"light" | "dark" | "auto"`  
**Default**: `"dark"`

Color scheme mode.

```nix
theming.signal.mode = "dark";
```

**Options:**

- `"dark"` - Dark background, light text (recommended)
- `"light"` - Light background, dark text
- `"auto"` - Follow system preference (currently defaults to dark)

**Switching modes:**

Change the mode and rebuild:

```nix
theming.signal.mode = "light";
```

```bash
home-manager switch
```

All themed applications will switch to light mode.

## Theming Modes

### Automatic Mode (Recommended)

Best for most users. Enable programs normally, Signal themes them automatically.

```nix
# Enable programs as usual
programs = {
  helix.enable = true;
  kitty.enable = true;
  bat.enable = true;
  fzf.enable = true;
  starship.enable = true;
};

# Signal themes all of them
theming.signal = {
  enable = true;
  autoEnable = true;
  mode = "dark";
};
```

**When to use:**
- You want Signal to theme most/all programs
- You want a simple, low-maintenance config
- You're okay with explicitly disabling the few programs you don't want themed

### Manual Mode

Fine-grained control over what gets themed.

```nix
theming.signal = {
  enable = true;
  # autoEnable = false (default)
  mode = "dark";
  
  # Explicitly enable each program
  editors.helix.enable = true;
  terminals.kitty.enable = true;
  cli.bat.enable = true;
};
```

**When to use:**
- You only want to theme a few specific programs
- You want explicit control over every themed program
- You're migrating gradually and want to test each app

### Hybrid Mode

Automatic with selective exclusions.

```nix
theming.signal = {
  enable = true;
  autoEnable = true;  # Theme everything by default
  mode = "dark";
  
  # Exclude specific programs
  terminals.alacritty.enable = false;  # Has custom theme
  cli.lazygit.enable = false;          # Don't theme this
};
```

**When to use:**
- You want most programs themed
- You have a few programs with custom themes you want to preserve
- You want to try Signal gradually

## Application Configuration

### Desktop Applications

#### Ironbar

Wayland status bar with display-specific profiles.

```nix
theming.signal.ironbar = {
  enable = true;
  profile = "relaxed";  # "compact" | "relaxed" | "spacious"
};
```

**Profiles:**

| Profile | Resolution | Bar Height | Best For |
|---------|-----------|------------|----------|
| `compact` | 1080p | 40px | Smaller displays, maximize screen space |
| `relaxed` | 1440p+ | 48px | Most users, balanced appearance (default) |
| `spacious` | 4K | 56px | High-DPI displays, better touch targets |

**Important**: Signal only provides colors for Ironbar. You control layout, spacing, typography, and widget configuration via your own CSS.

**Complete example:**

```nix
{
  # Signal provides colors
  theming.signal.ironbar = {
    enable = true;
    profile = "relaxed";
  };
  
  # You configure layout and typography
  programs.ironbar = {
    enable = true;
    config = {
      # Your widget configuration
    };
    style = ./my-ironbar-layout.css;  # Your custom layout/typography
  };
}
```

See `examples/ironbar-complete.css` for a complete example combining Signal colors with custom layout.

#### GTK

GTK 3/4 application theming.

```nix
theming.signal.gtk = {
  enable = true;
  version = "both";  # "gtk3" | "gtk4" | "both"
};
```

**Options:**
- `"gtk3"` - Theme GTK 3 applications only
- `"gtk4"` - Theme GTK 4 applications only
- `"both"` - Theme both (recommended)

**What gets themed:**
- Window backgrounds
- Button colors
- Text colors
- Borders and dividers
- Selection colors

#### Fuzzel

Application launcher for Wayland.

```nix
theming.signal.fuzzel.enable = true;
```

**What gets themed:**
- Background color
- Text color
- Selection highlight
- Border color

### Editors

#### Helix

Modern modal text editor with comprehensive syntax highlighting.

```nix
theming.signal.editors.helix.enable = true;
```

**What gets themed:**
- Syntax highlighting (keywords, strings, functions, etc.)
- UI elements (statusline, menus, line numbers)
- Diagnostic colors (errors, warnings, hints)
- Selection and cursor colors
- Rainbow brackets

#### Neovim

Extensible Vim-based editor with full Treesitter and LSP support.

```nix
theming.signal.editors.neovim.enable = true;
```

**What gets themed:**
- Base colors (background, foreground, comments)
- Syntax groups (keywords, identifiers, types, etc.)
- Treesitter highlights
- LSP semantic tokens
- Diagnostic signs and underlines
- UI elements (statusline, popups, line numbers)

### Terminals

All terminals get a complete ANSI color palette plus application-specific UI elements.

#### Ghostty

```nix
theming.signal.terminals.ghostty.enable = true;
```

#### Alacritty

```nix
theming.signal.terminals.alacritty.enable = true;
```

#### Kitty

```nix
theming.signal.terminals.kitty.enable = true;
```

Includes tab bar colors.

#### WezTerm

```nix
theming.signal.terminals.wezterm.enable = true;
```

Includes tab bar and status bar colors.

### Terminal Multiplexers

#### tmux

```nix
theming.signal.multiplexers.tmux.enable = true;
```

**What gets themed:**
- Status bar
- Window names
- Pane borders
- Copy mode colors

#### Zellij

```nix
theming.signal.multiplexers.zellij.enable = true;
```

**What gets themed:**
- Frame colors
- Tab bar
- Pane colors
- Status bar

### CLI Tools

#### bat

Syntax-highlighted cat replacement.

```nix
theming.signal.cli.bat.enable = true;
```

Custom `.tmTheme` with Signal colors for syntax highlighting.

#### delta

Git diff viewer with syntax highlighting.

```nix
theming.signal.cli.delta.enable = true;
```

**What gets themed:**
- Line number colors
- Added/removed line colors
- File header colors
- Hunk header colors

#### eza

Modern ls replacement with colors for file types and git status.

```nix
theming.signal.cli.eza.enable = true;
```

#### fzf

Fuzzy finder with complete color scheme.

```nix
theming.signal.cli.fzf.enable = true;
```

**What gets themed:**
- Background and foreground
- Selection highlight
- Border colors
- Match highlights
- Info and prompt colors

#### lazygit

Git TUI with comprehensive theming.

```nix
theming.signal.cli.lazygit.enable = true;
```

#### yazi

File manager with complete theme.

```nix
theming.signal.cli.yazi.enable = true;
```

**What gets themed:**
- File manager UI
- Status bar
- Tab bar
- File type colors
- Selection colors

### System Monitors

#### btop

Resource monitor with gradients.

```nix
theming.signal.monitors.btop.enable = true;
```

**What gets themed:**
- Background and foreground
- Graph colors
- CPU, memory, network gradients
- Process list colors

### Shell Prompts

#### Starship

Cross-shell prompt with git integration.

```nix
theming.signal.prompts.starship.enable = true;
```

**What gets themed:**
- Git status colors
- Directory colors
- Success/error indicators
- Module colors

### Shells

#### zsh

Syntax highlighting for zsh.

```nix
theming.signal.shells.zsh.enable = true;
```

**What gets themed:**
- Command colors
- String colors
- Path colors
- Comment colors

## Desktop Environment

### Complete Desktop Setup

For a fully themed desktop environment:

```nix
{
  # Enable desktop applications
  programs.ironbar.enable = true;
  gtk.enable = true;
  programs.fuzzel.enable = true;
  
  # Theme them with Signal
  theming.signal = {
    enable = true;
    autoEnable = true;  # Will theme all of the above
    mode = "dark";
    
    # Configure ironbar profile for your display
    ironbar.profile = "relaxed";  # Adjust for your resolution
  };
}
```

### Per-Monitor Configuration

If you have multiple monitors with different resolutions, configure ironbar per-output:

```nix
programs.ironbar.config = {
  monitors = {
    "DP-1" = {
      # 4K monitor - use spacious profile colors
    };
    "HDMI-1" = {
      # 1080p monitor - use compact profile colors
    };
  };
};
```

Currently, Signal doesn't support per-monitor profiles directly. Choose the profile that fits your primary monitor.

## Brand Customization

Signal separates functional UI colors from decorative brand colors.

### Brand Governance Policies

```nix
theming.signal.brandGovernance = {
  policy = "functional-override";  # or "separate-layer" | "integrated"
  
  decorativeBrandColors = {
    brand-primary = "#5a7dcf";
    brand-secondary = "#4a9b6f";
    brand-accent = "#e8615d";
  };
};
```

**Policies:**

#### functional-override (Default, Safest)

Functional colors take priority. Brand colors are available for decorative use only.

```nix
brandGovernance.policy = "functional-override";
```

**Use when:**
- Accessibility is paramount
- You want consistent UI colors
- Brand colors are for logos/headers only

#### separate-layer

Brand colors exist alongside functional colors without replacing them.

```nix
brandGovernance.policy = "separate-layer";
```

**Use when:**
- You want both functional and brand colors available
- You'll manually choose when to use each
- You're building custom themes

#### integrated

Brand colors can replace functional colors (must meet accessibility requirements).

```nix
brandGovernance.policy = "integrated";
```

**Use when:**
- Your brand colors meet APCA contrast requirements
- You want brand identity throughout the UI
- You've verified accessibility

**Warning**: This policy can reduce accessibility if brand colors don't have sufficient contrast.

### Decorative Brand Colors

Colors for non-functional UI elements (logos, headers, decorations).

```nix
decorativeBrandColors = {
  brand-primary = "#5a7dcf";
  brand-secondary = "#4a9b6f";
  brand-tertiary = "#e8615d";
  brand-neutral = "#8b9dad";
};
```

These colors don't replace functional colors but are available for custom styling.

## Per-Category Options

### Disabling Entire Categories

You can disable entire categories while using autoEnable:

```nix
theming.signal = {
  enable = true;
  autoEnable = true;
  
  # Disable all CLI tools
  cli = {
    bat.enable = false;
    delta.enable = false;
    eza.enable = false;
    fzf.enable = false;
    lazygit.enable = false;
    yazi.enable = false;
  };
};
```

Or selectively enable within a category:

```nix
theming.signal = {
  enable = true;
  # autoEnable = false
  
  # Only theme these CLI tools
  cli = {
    bat.enable = true;
    fzf.enable = true;
  };
};
```

## Examples

See the [examples directory](../examples/) for complete configurations:

- [auto-enable.nix](../examples/auto-enable.nix) - Automatic theming
- [basic.nix](../examples/basic.nix) - Manual per-app configuration
- [full-desktop.nix](../examples/full-desktop.nix) - Complete desktop environment
- [custom-brand.nix](../examples/custom-brand.nix) - Brand color customization

## Next Steps

- **Advanced usage** - See [Advanced Usage Guide](advanced-usage.md)
- **Multi-machine setups** - See example configurations
- **Troubleshooting** - See [Troubleshooting Guide](troubleshooting.md)
