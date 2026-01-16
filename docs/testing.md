# Testing Guide

This document explains how to test the Signal Design System NixOS/Home Manager integration.

## Quick Tests

### Run All Checks

```bash
nix flake check
```

This runs:
- **Format check**: Ensures all Nix code is formatted with `nixfmt`
- **Flake outputs**: Verifies the flake structure is valid
- **Modules exist**: Confirms all module files are present

### Check Specific Tests

```bash
# Run individual checks
nix build .#checks.x86_64-linux.format
nix build .#checks.x86_64-linux.flake-outputs
nix build .#checks.x86_64-linux.modules-exist
```

## Manual Testing

### 1. Test Module Evaluation

Verify that modules can be imported and evaluated:

```bash
# Test that homeManagerModules are accessible
nix eval .#homeManagerModules.default --apply 'x: "OK"'
nix eval .#homeManagerModules.signal --apply 'x: "OK"'
nix eval .#homeManagerModules.helix --apply 'x: "OK"'
nix eval .#homeManagerModules.gtk --apply 'x: "OK"'

# Test library functions
nix eval .#lib --apply 'x: "OK"'
```

### 2. Test Example Configurations

The examples directory contains standalone flake configurations. Test them locally:

```bash
# Create a temporary directory
mkdir -p /tmp/signal-test
cd /tmp/signal-test

# Copy an example
cp ~/Code/signal-nix/examples/basic.nix flake.nix

# Update the signal input to use your local version
nix flake lock --override-input signal ~/Code/signal-nix

# Build the configuration (dry-run)
nix build .#homeConfigurations.user.activationPackage --dry-run

# Or evaluate to check for errors
nix eval .#homeConfigurations.user.activationPackage --apply 'x: "OK"'
```

### 3. Test in a Real Home Manager Setup

To test the actual integration:

```bash
# Add to your flake.nix:
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "path:/home/lewis/Code/signal-nix";  # Use local path
  };

  outputs = { nixpkgs, home-manager, signal, ... }: {
    homeConfigurations.test = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        signal.homeManagerModules.default
        {
          home = {
            username = "test";
            homeDirectory = "/home/test";
            stateVersion = "24.11";
          };
          
          theming.signal = {
            enable = true;
            mode = "dark";
            terminals.ghostty.enable = true;
            helix.enable = true;
          };
        }
      ];
    };
  };
}

# Then build and check the output
nix build .#homeConfigurations.test.activationPackage
```

### 4. Test Specific Applications

Test individual application configurations:

```bash
# Ghostty config generation
nix eval .#homeManagerModules.ghostty --apply 'x: "Module loaded"'

# Test Helix theme generation
nix build .#homeManagerModules.helix --dry-run

# Test GTK theme
nix eval .#homeManagerModules.gtk --apply 'x: "Module loaded"'
```

## Code Quality Checks

### Format Code

```bash
# Format all Nix files
nixfmt .

# Check formatting without making changes
nixfmt --check .
```

### Lint Code (Optional)

```bash
# Enter development shell
nix develop

# Run static analysis
statix check .

# Find dead code
deadnix .
```

## CI/CD Tests

The GitHub Actions workflow (`.github/workflows/build-examples.yml`) runs:

1. **Format check**: `nixfmt --check .`
2. **Module evaluation**: Tests that all modules can be loaded
3. **Example validation**: Verifies example flake syntax and structure

You can run similar checks locally:

```bash
# Check flake syntax
nix flake check --no-build

# Build all checks
nix flake check
```

## Troubleshooting

### "warning: unknown flake output 'homeManagerModules'"

This is expected and can be safely ignored. `homeManagerModules` is a community convention for Home Manager modules, not a standard Nix flake output.

### Permission Denied Errors

If you encounter permission errors during checks, ensure you're running with appropriate Nix daemon permissions. The checks are designed to run in sandboxed builds.

### Evaluation Errors

If modules fail to evaluate:

1. Check that all dependencies are available
2. Verify the `signal-palette` input is accessible
3. Ensure you're using a compatible Nix version (2.19+)

## Testing Before Release

Before releasing a new version:

1. ✅ Run `nix flake check` - all checks must pass
2. ✅ Test all examples build successfully
3. ✅ Test in a real Home Manager configuration
4. ✅ Verify documentation is up to date
5. ✅ Check CHANGELOG.md is updated
6. ✅ Tag the release with semantic versioning

## Continuous Testing

As you develop:

```bash
# Watch for changes and run checks
nix flake check --watch  # (if your Nix version supports it)

# Or use a simple loop
while inotifywait -r -e modify modules/ lib/; do
  nix flake check --no-build
done
```
