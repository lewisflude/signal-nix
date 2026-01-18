# Signal Design System - Platform-Specific Test Organization
#
# This document explains how tests are organized by platform and
# which tests run on which systems.

## Test Organization by Platform

### Linux-Only Tests

**NixOS VM Tests** (`tests/nixos-vm/`)
- Console colors
- Boot loaders (GRUB, Plymouth)
- Display managers (SDDM, GDM, LightDM)
- System integration

**Linux-Specific Activation Tests**
- Wayland compositors (Sway, Hyprland)
- X11 window managers
- Linux-only applications

### Darwin-Only Tests

**macOS-Specific Tests** (future implementation)
- AeroSpace window manager
- macOS appearance integration
- Darwin-specific applications

### Cross-Platform Tests

**Home Manager Activation Tests** (`tests/activation/`)
- Editors (Helix, Neovim, Emacs, VSCode, Zed)
- Terminals (Alacritty, Kitty, Ghostty, Wez Term, Foot)
- CLI tools (Bat, FZF, Lazygit, Yazi)
- Shells (Zsh, Fish, Nushell, Bash)
- Multiplexers (Tmux, Zellij)

**Pure Function Tests** (`tests/unit/`, `tests/comprehensive-test-suite.nix`)
- Library functions
- Color calculations
- Theme resolution
- Accessibility checks

## Platform Detection in Flake

```nix
checks = forAllSystems (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    isLinux = pkgs.stdenv.isLinux;
    isDarwin = pkgs.stdenv.isDarwin;
  in
  {
    # Cross-platform tests
    inherit (allTests) unit-lib-functions;
    inherit (activationTests) activation-helix-dark;
    
    # Linux-only tests
  }
  // lib.optionalAttrs isLinux {
    inherit (nixosVmTests) nixos-vm-console-colors;
  }
  // lib.optionalAttrs isDarwin {
    # Darwin-specific tests
  }
);
```

## CI/CD Platform Matrix

### GitHub Actions

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest]
    include:
      - os: ubuntu-latest
        tests: all
      - os: macos-latest
        tests: cross-platform-only
```

### Test Execution Time

| Platform | Test Suite | Time |
|----------|-----------|------|
| Linux | Pure functions | ~10s |
| Linux | Activation tests | ~2min |
| Linux | VM tests | ~5min |
| Darwin | Pure functions | ~10s |
| Darwin | Activation tests | ~2min |

## Adding Platform-Specific Tests

### For Linux-Specific Features

1. Add test to `tests/activation/` or `tests/nixos-vm/`
2. Guard with `lib.optionalAttrs pkgs.stdenv.isLinux`
3. Document Linux-only requirement

### For Darwin-Specific Features

1. Add test to `tests/activation/`
2. Guard with `lib.optionalAttrs pkgs.stdenv.isDarwin`
3. Document macOS-only requirement

### For Cross-Platform Features

1. Add test to `tests/activation/`
2. No platform guards needed
3. Ensure test works on both Linux and Darwin

## Future Enhancements

- [ ] Add Darwin-specific display manager tests
- [ ] Add WSL-specific tests
- [ ] Add container-based testing
- [ ] Add performance benchmarking by platform
