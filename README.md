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
    
    theming.signal = {
      enable = true;
      mode = "dark"; # or "light"
      
      # Enable applications
      ironbar.enable = true;
      gtk.enable = true;
      helix.enable = true;
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
- **Mako** - Notification daemon (coming soon)
- **SwayNC** - Notification center (coming soon)

### Editors

- **Helix** - Modern modal editor (full theme)
- **Zed** - Code editor (coming soon)
- **Cursor** - AI code editor (coming soon)

### Terminals

- **Ghostty** - Fast terminal emulator
- **Zellij** - Terminal multiplexer (coming soon)

### CLI Tools

- **bat** - Cat replacement with syntax highlighting
- **fzf** - Fuzzy finder
- **lazygit** - Git TUI
- **yazi** - File manager

## Configuration

### Basic Configuration

```nix
theming.signal = {
  enable = true;
  mode = "dark"; # "light", "dark", or "auto"
};
```

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

### CLI Tools

Enable individual CLI tools:

```nix
theming.signal.cli = {
  bat.enable = true;
  fzf.enable = true;
  lazygit.enable = true;
  yazi.enable = true;
};
```

## Examples

See the `examples/` directory for complete configurations:

- [`basic.nix`](examples/basic.nix) - Minimal setup
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

- [Installation Guide](docs/installation.md)
- [Configuration Reference](docs/configuration.md)
- [Application Guide](docs/applications.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md)
- [OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md)
- [Accessibility](https://github.com/lewisflude/signal-palette/blob/main/docs/accessibility.md)

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
