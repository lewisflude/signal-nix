# Signal Documentation

Welcome to the Signal documentation! These guides will help you adopt the Signal color theme in your Nix environment.

## Getting Started

New to Signal? Start here:

- **[Main README](../README.md)** - Overview and quick start
- **[Getting Started Guide](getting-started.md)** - Detailed setup instructions
  - New Nix configurations
  - Adding Signal to existing setups
  - NixOS with Home Manager
  - Nix-darwin (macOS)
  - Without flakes (not recommended)

## Configuration

Learn how to configure Signal:

- **[Configuration Guide](configuration-guide.md)** - All configuration options
  - Automatic vs manual theming modes
  - Per-application options
  - Theme modes (light/dark/auto)
  - Brand customization
- **[Examples Directory](../examples/)** - Real-world configurations
  - [auto-enable.nix](../examples/auto-enable.nix) - Recommended approach
  - [migrating-existing-config.nix](../examples/migrating-existing-config.nix) - Adding to existing config
  - [multi-machine.nix](../examples/multi-machine.nix) - Shared config across machines
  - [basic.nix](../examples/basic.nix) - Manual configuration
  - [full-desktop.nix](../examples/full-desktop.nix) - Complete desktop
  - [custom-brand.nix](../examples/custom-brand.nix) - Custom brand colors

## System-Level Theming

For NixOS users:

- **[NixOS Modules Guide](nixos-modules.md)** - System-level theming
  - Boot screens (GRUB, Plymouth)
  - Display managers (GDM, SDDM, LightDM)
  - Virtual console (TTY)

## Reference

Technical documentation:

- **[Supported Applications](theming-reference.md)** - Complete application list
- **[Troubleshooting Guide](troubleshooting.md)** - Common issues and solutions
- **[Design Principles](design-principles.md)** - What Signal does and doesn't do

## Advanced

Power user features:

- **[Advanced Usage](advanced-usage.md)** - Advanced patterns
  - Multi-machine configuration
  - Brand governance
  - Theme conflicts and precedence
  - Custom color mappings
- **[Architecture Overview](architecture.md)** - How Signal works internally
  - Component architecture
  - Data flow
  - Module system
  - Extension patterns

## Contributing

Help make Signal better:

- **[Contributing Guide](../CONTRIBUTING.md)** - How to contribute
  - Development setup
  - Adding application support
  - Coding standards
- **[Contributing Applications](../CONTRIBUTING_APPLICATIONS.md)** - Step-by-step guide for adding new apps
- **[Testing Guide](TESTING_GUIDE.md)** - Writing and running tests
  - Unit vs integration tests
  - Test templates and examples
  - Debugging test failures
- **[Theming Reference](theming-reference.md)** - Application integration guide

## Color Science

Understanding Signal's design:

- **[Signal Palette Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md)** - Core principles
- **[OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md)** - Why OKLCH color space
- **[Accessibility](https://github.com/lewisflude/signal-palette/blob/main/docs/accessibility.md)** - APCA standards

## Quick Reference

### Minimal Configuration

```nix
{
  inputs.signal.url = "github:lewisflude/signal-nix";
  
  outputs = { home-manager, signal, ... }: {
    homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
      modules = [
        signal.homeManagerModules.default
        {
          programs.helix.enable = true;
          programs.kitty.enable = true;
          
          theming.signal = {
            enable = true;
            autoEnable = true;  # ← Automatically theme all enabled programs
            mode = "dark";
          };
        }
      ];
    };
  };
}
```

### Common Commands

```bash
# Update Signal
nix flake update signal

# Rebuild configuration
home-manager switch --flake .

# Check for errors
home-manager switch --flake . --show-trace

# Preview changes without applying
home-manager build --flake .
```
