# Signal - Nix Color Theme

> **Scientifically-designed colors for your Nix environment**

Bring the Signal color palette to your NixOS, nix-darwin, or Home Manager setup. Signal provides OKLCH-based colors with APCA accessibility standards, automatically theming 63 applications across your system.

## What is signal-nix?

**signal-nix makes it easy to adopt the Signal color theme across your entire Nix environment.** It's a Home Manager module that applies Signal's scientifically-designed colors to your applications—without installing or configuring programs for you.

**The Concept:**

```
You enable programs → Signal provides the colors
```

You control which programs to install and use. Signal handles applying the Signal color palette to them.

## Why Signal?

- 🎨 **Consistent Colors Everywhere**: One color palette across 63 applications
- 🔬 **Science-Based Design**: OKLCH color space ensures perceptual uniformity
- ♿ **Accessibility First**: APCA contrast standards for readable text
- 🌓 **Light & Dark Modes**: Carefully calibrated themes for both modes
- ⚡ **Zero-Config Adoption**: Enable Signal and it themes all your programs automatically
- 🎯 **Nix-Native**: Built specifically for NixOS, nix-darwin, and Home Manager

## Quick Start

### 1. Add Signal to your flake

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "github:lewisflude/signal-nix";  # ← Add this
  };
}
```

### 2. Enable Signal theming

```nix
{
  home-manager.users.yourname = {
    imports = [ signal.homeManagerModules.default ];
    
    # Enable your programs as usual
    programs = {
      helix.enable = true;
      kitty.enable = true;
      bat.enable = true;
      fzf.enable = true;
    };
    
    # Signal automatically applies its colors to them
    theming.signal = {
      enable = true;
      autoEnable = true;  # Automatically theme all enabled programs
      mode = "dark";      # or "light"
    };
  };
}
```

### 3. Rebuild

```bash
home-manager switch --flake .
# or: sudo nixos-rebuild switch
# or: darwin-rebuild switch
```

**Done!** All your enabled programs now use Signal colors.

> **New to Nix or Home Manager?** See [Getting Started Guide](docs/getting-started.md) for detailed setup instructions.

## NixOS System Theming

Signal also provides system-level color theming for NixOS components like boot screens and display managers.

### Quick Example

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
              plymouth.enable = true; # Boot splash
            };
            
            login = {
              gdm.enable = true;      # GNOME display manager
              # or sddm.enable = true;
              # or lightdm.enable = true;
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

### What Gets Themed

- ✅ **Virtual Console (TTY)** - Colored text in Ctrl+Alt+F1-F6
- ✅ **GRUB Bootloader** - Themed boot menu
- ✅ **Plymouth** - Animated boot splash screen
- ✅ **Display Managers** - GDM, SDDM, LightDM login screens

See [NixOS Modules Guide](docs/nixos-modules.md) for complete documentation.

## How Signal Works

Signal is a Home Manager module that:

1. **Detects your enabled programs** - Checks which applications you've enabled in your config
2. **Applies Signal colors** - Generates color configurations for each program
3. **Respects your preferences** - Never installs programs or changes non-color settings

**You manage programs. Signal manages colors.**

```nix
# You enable programs
programs.kitty.enable = true;  # ← You install kitty

# Signal applies colors
theming.signal.enable = true;  # ← Signal themes kitty with Signal colors
```

## Supported Applications

Signal provides color themes for 63 applications across all categories:

### Desktop & Window Management

- **Hyprland** - Modern Wayland compositor ✨
- **Sway** - i3-compatible Wayland compositor ✨
- **i3** - X11 window manager ✨
- **bspwm** - Binary space partitioning WM ✨
- **awesome** - Lua-based WM ✨
- **rofi** - Application launcher ✨
- **wofi** - Wayland launcher ✨
- **tofi** - Minimal launcher ✨
- **dmenu** - Classic X11 launcher ✨
- **Fuzzel** - Wayland application launcher
- **waybar** - Wayland status bar ✨
- **polybar** - X11 status bar ✨
- **Ironbar** - Wayland status bar (3 display profiles)
- **dunst** - Notification daemon ✨
- **mako** - Wayland notifications ✨
- **SwayNC** - Sway Notification Center ✨
- **Swaylock** - Wayland screen locker (authentication states)
- **Satty** - Screenshot annotation tool (color palette)
- **GTK 3/4** - GTK application theming

### Editors & IDEs

- **Helix** - Modern modal editor (comprehensive theme) ✨
- **Neovim** - Extensible Vim (Treesitter + LSP support) ✨
- **Vim** - Classic modal editor ✨
- **VS Code/VSCodium** - GUI editor ✨
- **Emacs** - Extensible editor (Org, Magit support) ✨
- **Zed** - Modern collaborative editor (JSON theme)

### Terminals

- **Ghostty** - Fast terminal (full ANSI palette)
- **Alacritty** - GPU-accelerated terminal
- **Kitty** - Feature-rich terminal (16 colors + tabs)
- **WezTerm** - Lua-configured terminal (full theme)
- **Foot** - Minimal Wayland terminal ✨

### CLI Tools & Utilities

- **bat** - Cat replacement (custom syntax highlighting)
- **delta** - Git diff viewer (Signal theme)
- **eza** - Modern ls (file types + git status)
- **fzf** - Fuzzy finder
- **lazygit** - Git TUI
- **lazydocker** - Docker TUI
- **yazi** - Modern file manager
- **ranger** - Vim-like file manager ✨
- **lf** - Fast minimal file manager ✨
- **nnn** - Super fast file manager ✨
- **btop++** - Resource monitor (with gradients)
- **htop** - Classic system monitor ✨
- **bottom** - Modern resource monitor ✨
- **procs** - Modern ps replacement (state/usage coloring)
- **MangoHud** - Gaming overlay (HUD colors)
- **tealdeer** - Fast tldr client ✨
- **less** - Pager (man page colors) ✨
- **ripgrep** - Fast search tool ✨
- **glow** - Markdown viewer ✨
- **tig** - Text-mode git interface ✨

### Shells & Prompts

- **zsh** - Z shell (syntax highlighting)
- **fish** - Friendly shell ✨
- **bash** - Bourne Again Shell ✨
- **nushell** - Structured data shell ✨
- **Starship** - Cross-shell prompt (custom palette)

### Terminal Multiplexers

- **tmux** - Terminal multiplexer (status bar, panes)
- **Zellij** - Modern multiplexer (comprehensive KDL theme)

### Browsers

- **Firefox** - userChrome.css theming ✨
- **Qutebrowser** - Vim-like browser ✨

### Media Players

- **MPV** - Media player (OSD + subtitle theming)

✨ = Fully implemented with comprehensive theming

See [Theming Reference](docs/theming-reference.md) for complete application list and theming details.

## Configuration Options

### Automatic Theming (Recommended)

Enable Signal once and it themes all your enabled programs:

```nix
theming.signal = {
  enable = true;
  autoEnable = true;  # Automatically theme all enabled programs
  mode = "dark";      # "light", "dark", or "auto"
};
```

### Selective Theming

Choose exactly which programs get themed:

```nix
theming.signal = {
  enable = true;
  mode = "dark";
  
  # Explicitly enable theming for specific programs
  editors.helix.enable = true;
  terminals.kitty.enable = true;
  cli.bat.enable = true;
};
```

### Selective Disabling

Theme everything except specific programs:

```nix
theming.signal = {
  enable = true;
  autoEnable = true;
  mode = "dark";
  
  # Don't theme these
  cli.bat.enable = false;
  terminals.kitty.enable = false;
};
```

### Theme Modes

- `"dark"` - Dark background, light text (recommended)
- `"light"` - Light background, dark text
- `"auto"` - Follow system preference (currently defaults to dark)

Switch modes by changing `mode` and rebuilding:

```bash
# In your config: mode = "light"
home-manager switch --flake .
```

See [Configuration Guide](docs/configuration-guide.md) for all options.

## Examples

Real-world configuration examples:

- **[auto-enable.nix](examples/auto-enable.nix)** - Recommended: Automatic theming
- **[migrating-existing-config.nix](examples/migrating-existing-config.nix)** - Add Signal to existing config
- **[basic.nix](examples/basic.nix)** - Manual program-by-program theming
- **[multi-machine.nix](examples/multi-machine.nix)** - Shared config across machines
- **[full-desktop.nix](examples/full-desktop.nix)** - Complete desktop environment
- **[custom-brand.nix](examples/custom-brand.nix)** - Custom brand colors
- **[nixos-complete.nix](examples/nixos-complete.nix)** - NixOS system theming

## The Signal Color System

### What Makes Signal Different

Signal uses **OKLCH color space** instead of traditional RGB or HSL. This provides:

1. **Perceptual Uniformity** - Colors with the same lightness value appear equally bright
2. **Accurate Contrast** - APCA (Advanced Perceptual Contrast Algorithm) for accessibility
3. **Professional Design** - Color relationships based on human perception, not math

Traditional RGB/HSL color spaces aren't perceptually uniform—a blue at 50% lightness looks different than a red at 50% lightness. OKLCH fixes this.

### Color Philosophy

Signal follows three principles:

1. **Scientific** - Every color calculated using OKLCH
2. **Accessible** - APCA-compliant contrast for all text
3. **Consistent** - Perceptually uniform lightness across hues

Learn more about Signal's color science:
- [Signal Palette Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md)
- [OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md)
- [Accessibility Standards](https://github.com/lewisflude/signal-palette/blob/main/docs/accessibility.md)

## Architecture

Signal uses a two-repository design:

- **[signal-palette](https://github.com/lewisflude/signal-palette)** - Platform-agnostic color definitions (OKLCH values, hex codes, RGB)
- **[signal-nix](https://github.com/lewisflude/signal-nix)** - This repository: Nix/Home Manager integration

This separation enables:
- Stable color versioning across platforms
- Use Signal colors outside of Nix (web, design tools)
- Simple dependency management

See [Architecture Guide](docs/architecture.md) for technical details.

## Platform Support

Signal works on:

- ✅ **NixOS** - System and user-level theming
- ✅ **nix-darwin** - macOS with Nix
- ✅ **Home Manager** - Standalone on any Linux distro
- ✅ **Flakes** - First-class flake support
- ⚠️ **Channels** - Supported but not recommended

See [Getting Started Guide](docs/getting-started.md) for setup instructions for your platform.

## Comparison with Other Themes

| Theme | Approach | Philosophy |
|-------|----------|------------|
| **Signal** | Scientific OKLCH | Calculated, accessible, professional |
| **Catppuccin** | Warm pastels | Cute, cozy, friendly |
| **Gruvbox** | Retro warm tones | Nostalgic, vintage |
| **Dracula** | High contrast vivid | Bold, dramatic |
| **Nord** | Arctic cool tones | Calm, minimalist |

Signal prioritizes:
- **Science over aesthetics** - Colors chosen for perceptual accuracy
- **Accessibility** - APCA contrast standards
- **Consistency** - Uniform appearance across applications
- **Nix-first design** - Built specifically for Nix environments

## Documentation

### Getting Started

- [**Getting Started Guide**](docs/getting-started.md) - Setup for NixOS, nix-darwin, and Home Manager
- [**Configuration Guide**](docs/configuration-guide.md) - All configuration options
- [**NixOS Modules Guide**](docs/nixos-modules.md) - System-level theming

### Using Signal

- [**Supported Applications**](docs/theming-reference.md) - Complete list with implementation status
- [**Examples Directory**](examples/) - Real-world configurations
- [**Troubleshooting**](docs/troubleshooting.md) - Common issues and solutions

### Understanding Signal

- [**Architecture**](docs/architecture.md) - How Signal works internally
- [**Design Principles**](docs/design-principles.md) - What Signal does and doesn't do
- [**Advanced Usage**](docs/advanced-usage.md) - Power user features

### For Contributors

- [**Contributing Guide**](CONTRIBUTING.md) - How to contribute
- [**Application Guide**](CONTRIBUTING_APPLICATIONS.md) - Step-by-step guide for adding applications
- [**Syntax Validation**](docs/SYNTAX_VALIDATION.md) - Tooling to prevent syntax errors
- [**Test Suite**](docs/TEST_SUITE.md) - Running and writing tests
- [**Theming Reference**](docs/theming-reference.md) - Color usage and integration standards

## Contributing

We welcome contributions! Areas where you can help:

- **Add application support** - See [Application Contribution Guide](CONTRIBUTING_APPLICATIONS.md) for step-by-step instructions
- **Improve documentation** - Help make Signal easier to use
- **Report issues** - Found a bug or color issue? Let us know
- **Share configs** - Show us your Signal setup

See [CONTRIBUTING.md](CONTRIBUTING.md) for general guidelines and [CONTRIBUTING_APPLICATIONS.md](CONTRIBUTING_APPLICATIONS.md) for adding new applications.

## License

MIT © Lewis Flude

## Related Projects

- [signal-palette](https://github.com/lewisflude/signal-palette) - Platform-agnostic Signal color definitions

## Acknowledgments

- OKLCH color space specification
- [APCA](https://github.com/Myndex/SAPC-APCA) for accessibility guidelines
- Inspired by modern color systems like Radix Colors
- The Nix and Home Manager communities
