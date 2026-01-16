# Signal Design System - Nix/Home Manager

> **Perception, engineered.**

Complete Nix/Home Manager integration for the Signal Design System - a scientific, OKLCH-based design system for NixOS and nix-darwin.

## Features

- 🎨 **Complete Desktop Theming**: Ironbar, GTK3/4, launchers, terminals, editors, CLI tools
- 🎯 **Unified Configuration**: Single module to theme your entire environment
- 🔬 **Scientific Foundation**: Built on Signal palette (OKLCH color space + APCA accessibility)
- 🌓 **Dual-Theme Support**: Light and dark modes with consistent semantics
- 🏢 **Brand Governance**: Separate functional and decorative brand colors
- ⚡ **Easy Setup**: One flake input, minimal configuration

## Quick Start

### 1. Add to your flake inputs

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "github:lewisflude/signal-nix";
  };
}
```

### 2. Add the Home Manager module

```nix
{
  home-manager.users.yourname = {
    imports = [signal.homeManagerModules.default];
    
    # First, enable the programs you want to use
    programs = {
      helix.enable = true;
      ghostty.enable = true;
      # ... other programs
    };
    
    # Then apply Signal theme to enabled programs
    theming.signal = {
      enable = true;
      mode = "dark"; # or "light"
      
      # Apply theme (requires programs to be enabled first)
      editors.helix.enable = true;
      fuzzel.enable = true;
      terminals.ghostty.enable = true;
    };
  };
}
```

### 3. Rebuild your system

```bash
sudo nixos-rebuild switch # NixOS
# or
darwin-rebuild switch # macOS
```

## Supported Applications

### Desktop

- **Ironbar** - Wayland status bar (with 3 display profiles)
- **GTK 3/4** - GTK application theming
- **Fuzzel** - Application launcher

### Editors

- **Helix** - Modern modal editor (comprehensive theme with palette structure)
- **Neovim** - Extensible Vim-based editor (full Lua colorscheme with Treesitter and LSP support)

### Terminals

- **Ghostty** - Fast terminal emulator (full ANSI palette)
- **Alacritty** - GPU-accelerated terminal (complete color scheme)
- **Kitty** - Feature-rich terminal (16 colors + tab bar)
- **WezTerm** - Lua-based terminal (full theme with tab bar)

### Terminal Multiplexers

- **tmux** - Terminal multiplexer (status bar, panes, windows)
- **Zellij** - Modern multiplexer (comprehensive KDL theme)

### System Monitors

- **btop++** - Resource monitor (complete theme with gradients)

### Shell Prompts

- **Starship** - Cross-shell prompt (custom palette with git integration)

### Shells

- **zsh** - Z shell (syntax highlighting colors)

### CLI Tools

- **bat** - Cat replacement (custom .tmTheme with Signal colors)
- **delta** - Git diff viewer (syntax-highlighted diffs with Signal theme)
- **eza** - Modern ls replacement (comprehensive file type and git status colors)
- **fzf** - Fuzzy finder (complete color configuration)
- **lazygit** - Git TUI (comprehensive theme)
- **yazi** - File manager (complete theme: manager, status, tabs, etc.)

## Configuration

> **Important**: Signal only applies color themes. You must enable programs separately using `programs.<name>.enable = true` before applying the Signal theme.

### Basic Configuration

```nix
# Enable programs first
programs.helix.enable = true;
programs.bat.enable = true;

# Then apply Signal theme
theming.signal = {
  enable = true;
  mode = "dark"; # "light", "dark", or "auto"
  
  editors.helix.enable = true;
  cli.bat.enable = true;
};
```

### Auto-Enable Mode

Signal can automatically detect and theme all enabled programs:

```nix
# Enable your programs as usual
programs = {
  helix.enable = true;
  bat.enable = true;
  kitty.enable = true;
  starship.enable = true;
};

# Signal will auto-detect and theme them all
theming.signal = {
  enable = true;
  autoEnable = true;  # Auto-theme all enabled programs
  mode = "dark";
};
```

With `autoEnable = true`, Signal automatically applies theming to any program that is enabled in your configuration. You can still explicitly enable/disable theming for specific programs:

```nix
theming.signal = {
  enable = true;
  autoEnable = true;
  mode = "dark";
  
  # Explicitly disable theming for specific programs
  cli.bat.enable = false;  # Don't theme bat, even though it's enabled
  
  # Or explicitly enable (redundant with autoEnable, but clearer)
  editors.helix.enable = true;
};
```

**Precedence rules:**
1. Explicit `theming.signal.<category>.<app>.enable = true` always applies theming
2. Explicit `theming.signal.<category>.<app>.enable = false` never applies theming
3. If not explicitly set, `autoEnable = true` themes the app if `programs.<app>.enable = true`
4. If `autoEnable = false` (default), theming must be explicitly enabled per-app

### Ironbar Display Profiles

Ironbar includes 3 optimized display profiles:

```nix
theming.signal.ironbar = {
  enable = true;
  profile = "relaxed"; # Options: "compact" | "relaxed" | "spacious"
};
```

- **compact**: 1080p displays (40px bar, tighter spacing)
- **relaxed**: 1440p+ displays (48px bar, balanced) - **default**
- **spacious**: 4K displays (56px bar, generous spacing)

### Brand Governance

Signal separates functional colors (for UI) from brand colors (for identity):

```nix
theming.signal = {
  enable = true;
  
  brandGovernance = {
    policy = "functional-override"; # functional colors take priority
    
    decorativeBrandColors = {
      brand-primary = "#5a7dcf";
      brand-secondary = "#4a9b6f";
    };
  };
};
```

**Policies:**
- `functional-override`: Functional colors always win (safest)
- `separate-layer`: Brand colors exist alongside functional colors
- `integrated`: Brand colors can replace functional colors (must meet accessibility)

### GTK Configuration

```nix
theming.signal.gtk = {
  enable = true;
  version = "both"; # "gtk3" | "gtk4" | "both"
};
```

### All Applications

Enable all theming categories:

```nix
theming.signal = {
  enable = true;
  mode = "dark"; # "light", "dark", or "auto"
  
  # Desktop
  ironbar.enable = true;
  gtk.enable = true;
  fuzzel.enable = true;
  
  # Editors
  editors = {
    helix.enable = true;
    neovim.enable = true;
  };
  
  # Terminals (choose one or more)
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
  
  # Monitors
  monitors.btop.enable = true;
  
  # Prompts
  prompts.starship.enable = true;
  
  # Shells
  shells.zsh.enable = true;
};
```

## Examples

See the `examples/` directory for complete configurations:

- [`basic.nix`](examples/basic.nix) - Minimal setup with explicit theming
- [`auto-enable.nix`](examples/auto-enable.nix) - Auto-detect and theme all enabled programs
- [`full-desktop.nix`](examples/full-desktop.nix) - All applications enabled
- [`custom-brand.nix`](examples/custom-brand.nix) - Brand color customization

## Philosophy

Signal is built on three principles:

1. **Scientific**: Every color is a calculated solution to a functional problem
2. **Accessible**: APCA-compliant contrast for all text and interactive elements
3. **Perceptually Uniform**: OKLCH color space ensures consistent perceived lightness

Read more: [Signal Palette Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md)

## Why OKLCH?

Traditional RGB/HSL color spaces aren't perceptually uniform - L=50% looks different for different hues. OKLCH fixes this:

- ✅ Consistent perceived lightness across all hues
- ✅ Accurate contrast predictions for accessibility
- ✅ Future-proof (CSS Color Level 4 standard)

Read more: [OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md)

## Architecture

Signal uses a two-repository architecture:

- **[signal-palette](https://github.com/lewisflude/signal-palette)**: Platform-agnostic color definitions (JSON, Nix, CSS, JS)
- **[signal-nix](https://github.com/lewisflude/signal-nix)**: This repository - Nix/Home Manager modules

This separation allows:
- Stable color versioning (v1.0.0 = colors locked)
- Platform-agnostic palette (web, print, etc.)
- Simple user experience (one input, automatic dependency)

## Comparison

| System | Approach | Philosophy |
|--------|----------|------------|
| **Signal** | Scientific, OKLCH | Calculated, accessible, professional |
| **Catppuccin** | Warm, pastel | Cute, cozy, friendly |
| **Gruvbox** | Retro, warm | Nostalgic, vintage |
| **Dracula** | High contrast, vivid | Bold, dramatic |

## Documentation

- [Documentation Index](docs/README.md) - Complete documentation overview
- [Theming Reference](docs/theming-reference.md) - Complete theming guide for 70+ applications
- [Troubleshooting Guide](docs/troubleshooting.md) - Common issues and solutions
- [Contributing Guide](CONTRIBUTING.md) - How to contribute
- [Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md) - Design principles
- [OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md) - Color space overview
- [Accessibility](https://github.com/lewisflude/signal-palette/blob/main/docs/accessibility.md) - APCA standards

## Contributing

Contributions welcome! Priority areas:

- Additional application integrations
- Light mode refinements
- Accessibility improvements
- Documentation enhancements

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT © Lewis Flude

## Related Projects

- [signal-palette](https://github.com/lewisflude/signal-palette) - Platform-agnostic color definitions

## Acknowledgments

- Built on the OKLCH color space specification
- Accessibility guidelines from [APCA](https://github.com/Myndex/SAPC-APCA)
- Inspired by modern color systems like Radix Colors and Catppuccin
