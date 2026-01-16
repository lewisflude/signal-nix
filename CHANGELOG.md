# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Theme naming inconsistencies when using `mode = "auto"`. Previously, some modules would try to use non-existent themes like "signal-auto" instead of resolving to "signal-dark" or "signal-light", causing warnings like "Unknown theme 'signal-dark'".
- Added `signalLib.resolveThemeMode` function to standardize theme mode resolution across all modules
- Updated bat, helix, and GTK modules to use resolved theme modes
- Updated color getter in common module to properly resolve "auto" mode before fetching colors

### Added
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
