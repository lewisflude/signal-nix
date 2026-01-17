# Signal Design System - Nix/Home Manager

> **Perception, engineered.**

A scientific color scheme for Nix/Home Manager and NixOS that themes 20+ applications with OKLCH-based colors and APCA accessibility.

## What is Signal?

**Signal is a comprehensive theming system** that automatically themes your programs at both user and system level. It provides scientifically-designed colors but never installs or enables programs for you.

```
┌─────────────────────────────────────────────┐
│  You Enable Programs                        │
│  ├─ programs.helix.enable = true            │
│  ├─ programs.kitty.enable = true            │
│  └─ boot.loader.grub.enable = true          │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│  Signal Themes Them                         │
│  ├─ theming.signal.enable = true            │
│  ├─ theming.signal.autoEnable = true        │
│  ├─ theming.signal.nixos.boot.grub.enable  │
│  └─ Automatically applies colors ✨         │
└─────────────────────────────────────────────┘
```

## Features

- 🎨 **20+ Applications**: Terminals, editors, CLI tools, GTK, Ironbar, and more
- 🖥️ **System-Level Theming**: Boot screens, TTY, GRUB (NixOS modules) - **NEW**
- 🤖 **Automatic Detection**: Set `autoEnable = true` and Signal themes all your enabled programs
- 🔬 **Scientific Foundation**: OKLCH color space + APCA accessibility standards
- 🌓 **Dual Themes**: Light and dark modes with consistent semantics
- ⚡ **Zero Configuration**: Three lines to get started
- ✅ **Comprehensive Testing**: 59+ tests ensuring reliability and quality

## Quick Start (5 Minutes)

### 1. Add to your flake inputs

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "github:lewisflude/signal-nix";  # ← Add this
  };
}
```

### 2. Import and configure

```nix
{
  home-manager.users.yourname = {
    imports = [ signal.homeManagerModules.default ];
    
    # Enable the programs you want to use (as usual)
    programs = {
      helix.enable = true;
      kitty.enable = true;
      bat.enable = true;
      fzf.enable = true;
    };
    
    # Signal automatically themes all enabled programs ✨
    theming.signal = {
      enable = true;
      autoEnable = true;  # ← The magic setting
      mode = "dark";      # or "light"
    };
  };
}
```

### 3. Rebuild

```bash
home-manager switch
# or: sudo nixos-rebuild switch
# or: darwin-rebuild switch
```

That's it! All your enabled programs now use Signal colors.

> **Adding Signal to an existing config?** See [Getting Started Guide](docs/getting-started.md) for integration examples.

## NixOS System Theming (NEW)

Signal now supports system-level theming for NixOS components!

### Quick Start - NixOS

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs = { nixpkgs, signal, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      modules = [
        signal.nixosModules.default
        {
          # System-level Signal theming
          theming.signal.nixos = {
            enable = true;
            mode = "dark";
            
            boot = {
              console.enable = true;  # TTY colors
              grub.enable = true;     # GRUB theme
            };
          };
          
          # Your existing NixOS config
          boot.loader.grub.enable = true;
        }
      ];
    };
  };
}
```

### System Components Themed

- ✅ **Virtual Console (TTY)** - Colored text in Ctrl+Alt+F1-F6
- ✅ **GRUB Bootloader** - Themed boot menu
- ✅ **SDDM Display Manager** - KDE/Qt login screen (NEW)
- 🚧 **Plymouth** - Boot splash (coming soon)
- 🚧 **GDM** - GNOME display manager (planned)
- 🚧 **LightDM** - Alternative display manager (planned)

See [NixOS Module Documentation](docs/nixos-modules.md) for complete guide.

That's it! All your enabled programs now use Signal colors.

## How It Works

Signal uses Home Manager's module system to detect which programs you've enabled and applies color configurations to them. It follows a simple principle:

**You control what programs are installed. Signal controls what colors they use.**

```nix
# ❌ Signal does NOT do this
theming.signal.terminals.kitty.enable = true;  # Does NOT install kitty

# ✅ You do this
programs.kitty.enable = true;  # Installs kitty

# ✅ Then Signal does this
theming.signal.autoEnable = true;  # Themes your installed kitty
```

## Supported Applications

### Desktop

- **Ironbar** - Wayland status bar (with 3 display profiles)
- **GTK 3/4** - GTK application theming
- **Fuzzel** - Application launcher

### Editors

- **Helix** - Modern modal editor (comprehensive theme with palette structure)
- **Neovim** - Extensible Vim-based editor (full Lua colorscheme with Treesitter and LSP support) ✨

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
- **delta** - Git diff viewer (syntax-highlighted diffs with Signal theme) ✨
- **eza** - Modern ls replacement (comprehensive file type and git status colors) ✨
- **fzf** - Fuzzy finder (complete color configuration)
- **lazygit** - Git TUI (comprehensive theme)
- **yazi** - File manager (complete theme: manager, status, tabs, etc.)

## Configuration

Signal provides two approaches to theming your programs:

### Recommended: Automatic Mode

**Use this if:** You want Signal to automatically theme all your enabled programs.

```nix
theming.signal = {
  enable = true;
  autoEnable = true;  # ← Automatically themes all enabled programs
  mode = "dark";      # "light", "dark", or "auto"
};
```

You can selectively disable specific programs:

```nix
theming.signal = {
  enable = true;
  autoEnable = true;
  mode = "dark";
  
  # Don't theme these specific programs
  cli.bat.enable = false;
  terminals.kitty.enable = false;
};
```

### Advanced: Manual Mode

**Use this if:** You want fine-grained control over which programs are themed.

```nix
theming.signal = {
  enable = true;
  mode = "dark";
  # autoEnable = false (default)
  
  # Explicitly enable theming for each program
  editors.helix.enable = true;
  terminals.kitty.enable = true;
  cli.bat.enable = true;
};
```

> **Note**: With manual mode, you must explicitly enable theming for each program. Signal will not theme programs automatically.

### Theme Modes

Choose your preferred color scheme:

- `"dark"` - Dark background, light text (recommended for most users)
- `"light"` - Light background, dark text
- `"auto"` - Follows system preference (currently defaults to dark)

### Application-Specific Options

Some applications have additional configuration options:

#### Ironbar Display Profiles

```nix
theming.signal.ironbar = {
  enable = true;
  profile = "relaxed"; # "compact" | "relaxed" | "spacious"
};
```

- **compact**: 1080p displays (40px bar)
- **relaxed**: 1440p+ displays (48px bar) - default
- **spacious**: 4K displays (56px bar)

#### GTK Theming

```nix
theming.signal.gtk = {
  enable = true;
  version = "both"; # "gtk3" | "gtk4" | "both"
};
```

#### Brand Colors

Customize Signal with your brand colors:

```nix
theming.signal.brandGovernance = {
  policy = "functional-override";
  decorativeBrandColors = {
    brand-primary = "#5a7dcf";
  };
};
```

See [Configuration Guide](docs/configuration-guide.md) for all options.

## Examples

Real-world configuration examples:

- **[auto-enable.nix](examples/auto-enable.nix)** - Recommended: Automatic theming (3 lines)
- **[migrating-existing-config.nix](examples/migrating-existing-config.nix)** - Adding Signal to your existing config
- **[basic.nix](examples/basic.nix)** - Manual per-app theming
- **[multi-machine.nix](examples/multi-machine.nix)** - Shared config across multiple machines
- **[full-desktop.nix](examples/full-desktop.nix)** - Complete desktop environment
- **[custom-brand.nix](examples/custom-brand.nix)** - Custom brand colors

## Philosophy

Signal is built on three principles:

1. **Scientific**: Every color calculated using OKLCH color space
2. **Accessible**: APCA-compliant contrast for all elements  
3. **Perceptually Uniform**: Consistent lightness across all hues

Traditional RGB/HSL color spaces aren't perceptually uniform—L=50% looks different for different hues. OKLCH fixes this with consistent perceived lightness and accurate contrast predictions.

## Architecture

Signal uses a two-repository architecture:

- **[signal-palette](https://github.com/lewisflude/signal-palette)**: Platform-agnostic color definitions
- **[signal-nix](https://github.com/lewisflude/signal-nix)**: This repository - Nix/Home Manager integration

This separation enables stable color versioning, platform-agnostic usage, and simple dependency management.

## Comparison

| System | Approach | Philosophy |
|--------|----------|------------|
| **Signal** | Scientific, OKLCH | Calculated, accessible, professional |
| **Catppuccin** | Warm, pastel | Cute, cozy, friendly |
| **Gruvbox** | Retro, warm | Nostalgic, vintage |
| **Dracula** | High contrast, vivid | Bold, dramatic |

## Documentation

### Getting Started

- **[Getting Started Guide](docs/getting-started.md)** - Detailed setup for new and existing configs
- **[NixOS Modules Guide](docs/nixos-modules.md)** - System-level theming (NEW)
- **[Configuration Guide](docs/configuration-guide.md)** - All configuration options explained
- **[Architecture Overview](docs/architecture.md)** - How Signal works internally

### Testing

- **[Test Suite Overview](TEST_INDEX.md)** - Complete index of test resources
- **[Test Summary](TEST_SUMMARY.md)** - Quick reference and statistics
- **[Running Tests](TEST_SUITE.md)** - Comprehensive testing documentation
- **[Test Directory Guide](tests/README.md)** - Working with test files

### Reference

- **[Troubleshooting Guide](docs/troubleshooting.md)** - Common issues and solutions
- **[Theming Reference](docs/theming-reference.md)** - Complete theming guide
- **[Advanced Usage](docs/advanced-usage.md)** - Brand governance, multi-machine setups

### Philosophy & Design

- [Signal Palette Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md) - Design principles
- [OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md) - Color space overview
- [Accessibility Standards](https://github.com/lewisflude/signal-palette/blob/main/docs/accessibility.md) - APCA compliance

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Priority areas:
- Additional application integrations
- Light mode refinements  
- Documentation improvements

## License

MIT © Lewis Flude

## Related Projects

- [signal-palette](https://github.com/lewisflude/signal-palette) - Platform-agnostic color definitions

## Acknowledgments

- Built on the OKLCH color space specification
- Accessibility guidelines from [APCA](https://github.com/Myndex/SAPC-APCA)
- Inspired by modern color systems like Radix Colors and Catppuccin
