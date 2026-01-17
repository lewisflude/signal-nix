# Signal Documentation

Welcome to the Signal Design System documentation!

## Getting Started

New to Signal? Start here:

- **[Main README](../README.md)** - Overview and Quick Start (5 minutes)
- **[Getting Started Guide](getting-started.md)** - Detailed setup for all scenarios
  - New configurations
  - Existing configurations (migration)
  - NixOS with Home Manager
  - Nix-darwin (macOS)
  - Without flakes

## Configuration

Learn how to configure Signal:

- **[Configuration Guide](configuration-guide.md)** - Complete configuration reference
  - Automatic vs Manual modes
  - Per-application options
  - Theme modes
  - Brand customization
- **[Examples Directory](../examples/)** - Real-world configurations
  - [auto-enable.nix](../examples/auto-enable.nix) - Recommended approach
  - [migrating-existing-config.nix](../examples/migrating-existing-config.nix) - Add to existing config
  - [multi-machine.nix](../examples/multi-machine.nix) - Shared config across machines
  - [basic.nix](../examples/basic.nix) - Manual configuration
  - [full-desktop.nix](../examples/full-desktop.nix) - Complete desktop
  - [custom-brand.nix](../examples/custom-brand.nix) - Brand colors

## Advanced

Power user features:

- **[Advanced Usage](advanced-usage.md)** - Advanced patterns and techniques
  - Multi-machine configuration
  - Brand governance
  - Theme conflicts and precedence
  - Custom color mappings
  - Integration with other themes
- **[Architecture Overview](architecture.md)** - How Signal works internally
  - Component architecture
  - Data flow
  - Module system
  - Extension patterns

## Reference

Technical documentation:

- **[Theming Reference](theming-reference.md)** - Complete theming guide for 70+ applications
- **[Troubleshooting Guide](troubleshooting.md)** - Common issues and solutions
  - Diagnostic flowchart
  - Application-specific issues
  - Performance tips
  - Getting help
- **[Testing Guide](testing.md)** - Test suite documentation
  - Running tests
  - Writing new tests
  - Test coverage
- **[Design Principles](design-principles.md)** - Signal's design philosophy
  - What Signal does and doesn't do
  - Color-only scope
  - Integration patterns

## Contributing

Help make Signal better:

- **[Integration Roadmap](integration-standards.md)** - Programs to integrate and their priority
- **[Tier System](tier-system.md)** - Configuration method standards and hierarchy
- **[Contributing Guide](../CONTRIBUTING.md)** - Complete contributor guide
  - Development setup
  - Integration checklist
  - Coding standards
  - Submission process

## Philosophy & Design

Understanding Signal's design principles:

- **[Design Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md)** - Core principles and approach
- **[OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md)** - Why we use OKLCH color space
- **[Accessibility](https://github.com/lewisflude/signal-palette/blob/main/docs/accessibility.md)** - APCA and accessibility standards

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
