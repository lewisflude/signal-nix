# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

#### Documentation Overhaul
- **New comprehensive guides**:
  - `docs/getting-started.md` - Complete setup guide covering new configs, migration, NixOS, nix-darwin, and non-flake setups
  - `docs/configuration-guide.md` - Full configuration reference with automatic vs manual modes, per-app options, and brand customization
  - `docs/advanced-usage.md` - Power user features including multi-machine configs, brand governance, theme conflicts, and custom color mappings
  - `docs/architecture.md` - Internal architecture documentation with visual diagrams, data flow, and extension patterns
- **Enhanced troubleshooting**:
  - Added diagnostic flowchart at the beginning of troubleshooting guide
  - Quick application checklist for debugging
  - Diagnostic commands for checking configuration state
  - Quick reference table for common issues
- **Restructured main README**:
  - Leading with `autoEnable` as the recommended approach
  - Clear "What is Signal?" section with visual diagrams
  - Simplified Quick Start to 3 clear steps
  - Progressive disclosure: 5-minute → 15-minute → Advanced tiers

#### Example Configurations
- `examples/migrating-existing-config.nix` - Comprehensive guide for adding Signal to existing Home Manager configurations
  - Covers gradual migration approach
  - Multiple migration scenarios (from Catppuccin, stylix, etc.)
  - Reverting instructions
- `examples/multi-machine.nix` - Multi-machine setup patterns
  - Shared config with per-machine overrides
  - Examples for desktop, laptop, work, server, and macOS
  - Automatic machine detection patterns

#### User Experience Improvements
- **Helpful assertions in `modules/common/default.nix`**:
  - Warns if Signal enabled but no applications selected for theming
  - Validates theme mode values with helpful error messages
  - Catches brand governance misconfigurations
  - Provides actionable solutions in error messages
- **Updated `docs/README.md`** with new documentation structure and clear navigation

#### Visual Improvements
- Added ASCII diagrams showing Signal's role in the system
- Flowcharts for troubleshooting and decision-making
- Architecture diagrams for understanding data flow

### Improved
- Documentation now follows progressive disclosure pattern for better onboarding
- Clearer mental model communication: "You enable programs, Signal themes them"
- Better error prevention through assertions and validation

### Fixed
- Theme naming inconsistencies when using `mode = "auto"`. Previously, some modules would try to use non-existent themes like "signal-auto" instead of resolving to "signal-dark" or "signal-light", causing warnings like "Unknown theme 'signal-dark'".
- Added `signalLib.resolveThemeMode` function to standardize theme mode resolution across all modules
- Updated bat, helix, and GTK modules to use resolved theme modes
- Updated color getter in common module to properly resolve "auto" mode before fetching colors

### Added (from previous unreleased)
- Theme resolution validation check in flake checks to prevent future regressions
- Documentation in testing.md about theme validation and common issues
- New library functions: `isValidResolvedMode`, `getThemeName` for consistent theme handling

## [1.0.0] - 2026-01-16

### Added
- Initial stable release of Signal Design System for Nix/Home Manager
- Complete integration with signal-palette v1.0.0
- Supported applications:
  - **Desktop**: Ironbar (3 profiles), GTK3/4, Fuzzel
  - **Editors**: Helix
  - **Terminals**: Ghostty, Zellij
  - **CLI Tools**: bat, fzf, lazygit, yazi
- Brand governance system for managing functional vs decorative colors
- Comprehensive documentation and examples
- Three display profiles for Ironbar (compact/relaxed/spacious)
- MIT license

### Philosophy
- Scientific, OKLCH-based color system
- APCA-compliant accessibility
- Dual-theme support (light/dark)
- Platform-agnostic palette integration

[1.0.0]: https://github.com/lewisflude/signal-nix/releases/tag/v1.0.0
