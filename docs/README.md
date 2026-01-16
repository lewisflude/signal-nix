# Signal Documentation

Welcome to the Signal Design System documentation!

## Quick Links

- **[Installation & Quick Start](../README.md#quick-start)** - Get started in 5 minutes
- **[Configuration Guide](#configuration)** - Detailed configuration options
- **[Application Guide](#applications)** - Per-application setup
- **[Theming Reference](theming-reference.md)** - Complete theming documentation for all applications
- **[Troubleshooting](troubleshooting.md)** - Common issues and solutions
- **[Contributing](../CONTRIBUTING.md)** - How to contribute
- **[Launch Announcement](launch-announcement.md)** - Announcement materials

## Philosophy & Design

Understanding Signal's design principles:

- **[Design Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md)** - Core principles and approach
- **[OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md)** - Why we use OKLCH color space
- **[Accessibility](https://github.com/lewisflude/signal-palette/blob/main/docs/accessibility.md)** - APCA and accessibility standards

## Configuration

### Basic Setup

The minimal configuration to get Signal running:

```nix
{
  inputs.signal.url = "github:lewisflude/signal-nix";

  outputs = { self, nixpkgs, home-manager, signal, ... }: {
    homeConfigurations.yourname = home-manager.lib.homeManagerConfiguration {
      modules = [
        signal.homeManagerModules.default
        {
          theming.signal = {
            enable = true;
            mode = "dark";  # or "light"
          };
        }
      ];
    };
  };
}
```

### Theme Modes

Signal supports three theme modes:

```nix
theming.signal.mode = "dark";   # Dark theme (default)
theming.signal.mode = "light";  # Light theme
theming.signal.mode = "auto";   # Follow system preference (planned)
```

### Brand Governance

Control how brand colors interact with functional colors:

```nix
theming.signal.brandGovernance = {
  policy = "functional-override";  # Safest option
  
  decorativeBrandColors = {
    brand-primary = "#5a7dcf";     # Your primary brand color
    brand-secondary = "#4a9b6f";   # Secondary brand color
  };
};
```

**Available Policies:**

- `functional-override` (recommended) - Functional colors always take priority
- `separate-layer` - Brand colors exist alongside functional colors
- `integrated` - Brand colors can replace functional colors (must meet accessibility standards)

### Color Overrides

Override specific color tokens:

```nix
theming.signal.colorOverrides = {
  text.primary = "#e0e0e0";
  surface.primary = "#1a1a1a";
  accent.primary = "#5a7dcf";
};
```

## Applications

### Desktop Environment

#### Ironbar

Wayland status bar with three display profiles:

```nix
theming.signal.ironbar = {
  enable = true;
  profile = "relaxed";  # Options: "compact" | "relaxed" | "spacious"
};
```

**Profiles:**
- `compact` - 40px bar height, 1080p displays
- `relaxed` - 48px bar height, 1440p+ displays (default)
- `spacious` - 56px bar height, 4K displays

#### GTK

Theme GTK 3 and/or GTK 4 applications:

```nix
theming.signal.gtk = {
  enable = true;
  version = "both";  # Options: "gtk3" | "gtk4" | "both"
};
```

#### Fuzzel

Application launcher for Wayland:

```nix
theming.signal.fuzzel.enable = true;
```

### Editors

#### Helix

Complete theme with syntax highlighting:

```nix
theming.signal.editors.helix.enable = true;
```

Includes themes for:
- UI elements (selection, cursor, line numbers)
- Syntax highlighting (keywords, functions, strings, etc.)
- LSP diagnostics (errors, warnings, hints)
- Git diff indicators

### Terminals

#### Ghostty

Fast, native terminal emulator:

```nix
theming.signal.terminals.ghostty.enable = true;
```

### CLI Tools

Enable individual CLI tool themes:

```nix
theming.signal.cli = {
  bat.enable = true;       # Syntax highlighting
  fzf.enable = true;       # Fuzzy finder
  lazygit.enable = true;   # Git TUI
  yazi.enable = true;      # File manager
};
```

## Examples

Complete example configurations are available in the [`examples/`](../examples/) directory:

### Basic Configuration

[`examples/basic.nix`](../examples/basic.nix) - Minimal setup with essential applications:

```nix
{
  theming.signal = {
    enable = true;
    mode = "dark";
    
    gtk.enable = true;
    terminals.ghostty.enable = true;
  };
}
```

### Full Desktop

[`examples/full-desktop.nix`](../examples/full-desktop.nix) - All applications enabled:

```nix
{
  theming.signal = {
    enable = true;
    mode = "dark";
    
    ironbar = {
      enable = true;
      profile = "relaxed";
    };
    
    gtk.enable = true;
    fuzzel.enable = true;
    editors.helix.enable = true;
    terminals.ghostty.enable = true;
    
    cli = {
      bat.enable = true;
      fzf.enable = true;
      lazygit.enable = true;
      yazi.enable = true;
    };
  };
}
```

### Custom Brand Colors

[`examples/custom-brand.nix`](../examples/custom-brand.nix) - Brand governance with custom colors:

```nix
{
  theming.signal = {
    enable = true;
    mode = "dark";
    
    brandGovernance = {
      policy = "separate-layer";
      decorativeBrandColors = {
        brand-primary = "#5a7dcf";
        brand-secondary = "#4a9b6f";
      };
    };
    
    gtk.enable = true;
    ironbar.enable = true;
  };
}
```

## Advanced Usage

### Using Library Functions

Signal provides library functions for color manipulation:

```nix
{
  # Import Signal lib
  signalLib = signal.lib;
  
  # Use library functions
  myColor = signalLib.colorUtils.lighten "#ff0000" 0.1;
  myContrast = signalLib.colorUtils.contrast "#ffffff" "#000000";
}
```

Available functions (see [`lib/default.nix`](../lib/default.nix) for details):
- Color manipulation (lighten, darken, saturate)
- Contrast calculation (APCA)
- Color space conversion
- Brand governance logic

### Per-Application Modules

Advanced users can import specific application modules:

```nix
{
  imports = [
    signal.homeManagerModules.ironbar
    signal.homeManagerModules.gtk
    signal.homeManagerModules.helix
  ];
  
  # Configure without the unified theming.signal namespace
  programs.ironbar.signal.enable = true;
}
```

**Note**: Most users should use the unified `signal.homeManagerModules.default` interface.

## Platform Support

Signal supports multiple platforms with the same configuration:

- **Linux** (x86_64, aarch64) - Full support
- **macOS** (x86_64, aarch64) - Full support with nix-darwin

Platform-specific considerations:
- Some applications may be Linux-only (check application documentation)
- GTK theming works best on Linux
- Terminal and CLI tools work on all platforms

## Architecture

### Two-Repository Design

Signal uses a two-repository architecture:

1. **[signal-palette](https://github.com/lewisflude/signal-palette)**
   - Platform-agnostic color definitions
   - Exports: JSON, CSS, JavaScript, Nix, and more
   - Versioned and locked for stability
   - Usable outside of Nix

2. **[signal-nix](https://github.com/lewisflude/signal-nix)** (this repository)
   - Nix/Home Manager modules
   - Application integrations
   - Library functions
   - Example configurations

**Benefits:**
- Stable color versioning (v1.0.0 = colors locked)
- Platform-agnostic palette (web, print, design tools)
- Simple dependency management (automatic via flake)
- Easy updates (update palette independently)

### Module Structure

```
signal-nix/
├── flake.nix              # Flake definition
├── modules/
│   ├── common/            # Core module system & unified interface
│   ├── desktop/           # Desktop apps (launchers, bars)
│   ├── editors/           # Text and code editors
│   ├── terminals/         # Terminal emulators
│   ├── cli/               # Command-line tools
│   ├── gtk/               # GTK theming
│   └── ironbar/           # Ironbar (complex, own directory)
├── lib/                   # Library functions
├── examples/              # Example configurations
└── docs/                  # Documentation
```

## Comparison with Other Themes

| Theme | Philosophy | Color Space | Accessibility | Platform |
|-------|-----------|-------------|---------------|----------|
| **Signal** | Scientific, calculated | OKLCH | APCA standards | Multi-platform |
| **Catppuccin** | Aesthetic, cozy | HSL | WCAG 2.1 | Multi-platform |
| **Gruvbox** | Retro, warm | RGB | Manual tuning | Multi-platform |
| **Dracula** | Bold, vivid | RGB | WCAG 2.1 | Multi-platform |
| **Nord** | Minimal, arctic | HSL | Manual tuning | Multi-platform |

**Signal's unique features:**
- Only OKLCH-based Nix theme (perceptually uniform)
- APCA accessibility (more accurate than WCAG)
- Brand governance system
- Atomic design tokens
- Scientific color theory foundation

## Troubleshooting

Having issues? Check the **[Troubleshooting Guide](troubleshooting.md)** for solutions to common problems.

Quick links:
- [Installation Issues](troubleshooting.md#installation-issues)
- [Flake Issues](troubleshooting.md#flake-issues)
- [Application-Specific Issues](troubleshooting.md#application-specific-issues)
- [Color Display Issues](troubleshooting.md#color-display-issues)

## Contributing

Interested in contributing? We'd love your help!

See **[CONTRIBUTING.md](../CONTRIBUTING.md)** for guidelines on:
- Development setup
- Coding standards
- Testing procedures
- Application integration guide
- Submitting changes

**For application integration contributors:**
- **[Theming Reference](theming-reference.md)** - Comprehensive documentation for 70+ applications with official theming links

**Priority areas:**
- Additional application integrations
- Light mode refinements
- Documentation improvements
- Testing and bug reports

## Community

- **GitHub Issues**: [Report bugs](https://github.com/lewisflude/signal-nix/issues)
- **Discussions**: [Ask questions, share ideas](https://github.com/lewisflude/signal-nix/discussions)
- **Twitter/X**: [@lewisflude](https://twitter.com/lewisflude)
- **NixOS Discourse**: [Community discussions](https://discourse.nixos.org/)

## Roadmap

Planned features and improvements:

**Short-term:**
- Additional application integrations (Zellij, Mako, SwayNC)
- Light mode refinements
- Auto theme mode (follow system preference)
- More examples and tutorials

**Medium-term:**
- Additional editor themes (Zed, Cursor, nvim)
- Browser theming (Firefox, Chrome)
- Email client theming
- Community showcase gallery

**Long-term:**
- Visual theme customizer
- Theme variants (Signal Vibrant, Signal Muted, etc.)
- Package submission to nixpkgs
- Conference talk/presentation

## Changelog

See **[CHANGELOG.md](../CHANGELOG.md)** for version history and release notes.

## License

Signal is released under the **MIT License**. See [LICENSE](../LICENSE) for details.

## Acknowledgments

- Built on the OKLCH color space specification
- Accessibility guidelines from [APCA](https://github.com/Myndex/SAPC-APCA)
- Inspired by Radix Colors, Catppuccin, and modern design systems
- Thanks to the NixOS and Home Manager communities

---

**Perception, engineered.** 🎨✨
