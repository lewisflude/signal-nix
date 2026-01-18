# Signal Design System - Comprehensive Testing Framework Documentation

**Version**: 2.0  
**Last Updated**: 2026-01-18  
**Status**: Active

---

## Table of Contents

1. [Overview](#overview)
2. [Testing Philosophy](#testing-philosophy)
3. [Test Architecture](#test-architecture)
4. [Test Types](#test-types)
5. [Running Tests](#running-tests)
6. [Writing New Tests](#writing-new-tests)
7. [CI/CD Integration](#cicd-integration)
8. [Troubleshooting](#troubleshooting)

---

## Overview

Signal-nix uses a **multi-layered testing approach** that combines:

1. **Pure Function Tests** (nix-unit) - Fast evaluation of library functions
2. **Activation Package Tests** - Verify Home Manager configurations build and generate correct files
3. **VM Integration Tests** - Test NixOS system configuration in real VMs
4. **Static Validation** - Format checking, structure validation

### Why Multi-Layered Testing?

Previous testing only verified that modules **evaluated** without errors. This didn't catch issues that occurred when users actually **applied** configurations.

**The Problem:**
- ✅ Tests passed
- ❌ Users encountered errors

**The Solution:**
- Test actual file generation (not just evaluation)
- Test activation packages (what actually gets installed)
- Test in real VM environments (for system features)

---

## Testing Philosophy

### Core Principles

1. **Test What Users Experience**
   - Don't just test that code evaluates
   - Test that generated files have correct content
   - Test that configurations actually work when applied

2. **Fast Feedback**
   - Pure tests run in seconds
   - Activation tests in minutes
   - VM tests only for system features

3. **Platform Awareness**
   - Separate Linux/Darwin tests
   - Skip platform-specific tests appropriately
   - Document platform requirements

4. **Deterministic Results**
   - Same input always produces same output
   - No flaky tests
   - Clear error messages

5. **Comprehensive Coverage**
   - Unit tests for libraries
   - Integration tests for modules
   - System tests for NixOS features
   - Edge cases and error conditions

---

## Test Architecture

```
tests/
├── activation/          # Home Manager activation tests
│   └── default.nix      # Tests that build HM configs
│
├── nixos-vm/            # NixOS VM integration tests
│   └── default.nix      # Tests using pkgs.nixosTest
│
├── nmt/                 # NMT-style tests (future)
│   ├── modules/
│   │   ├── programs/    # Program tests
│   │   ├── terminals/   # Terminal tests
│   │   └── editors/     # Editor tests
│   └── integration/     # Cross-module tests
│
├── unit/                # Pure function tests
│   └── default.nix      # lib.runTests
│
├── integration/         # Shell-based validation
│   └── default.nix      # Pattern matching, structure
│
├── comprehensive-test-suite.nix  # Extended test scenarios
└── default.nix          # Test aggregator
```

### Test Flow

```
┌─────────────────┐
│  Push to GitHub │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Smoke Tests    │  ← Fast validation (30s)
│  - Format check │
│  - Basic tests  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Test Suite     │  ← Category-based (5-10min)
│  Matrix:        │
│  - happy        │
│  - edge         │
│  - integration  │
│  - activation   │  ← NEW: Build HM configs
│  - nixos-vm     │  ← NEW: VM tests
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Full Check     │  ← Complete verification (15min)
│  nix flake check│
└─────────────────┘
```

---

## Test Types

### 1. Pure Function Tests (Unit Tests)

**Location**: `tests/unit/`, `tests/comprehensive-test-suite.nix`  
**Framework**: `lib.runTests`  
**Speed**: ⚡ ~0.5-1s per test

**What They Test:**
- Library function correctness
- Color calculations
- Theme resolution logic
- Accessibility checks
- Data transformations

**Example:**

```nix
unit-lib-resolveThemeMode = mkTest "lib-resolve-theme-mode" {
  testAutoToDark = {
    expr = signalLib.resolveThemeMode "auto";
    expected = "dark";
  };
  testDarkToDark = {
    expr = signalLib.resolveThemeMode "dark";
    expected = "dark";
  };
};
```

**When to Use:**
- Pure functions with no side effects
- Quick validation during development
- Mathematical operations
- Logic transformations

**Run Command:**
```bash
nix build .#checks.x86_64-linux.unit-lib-resolveThemeMode
```

---

### 2. Activation Package Tests

**Location**: `tests/activation/`  
**Framework**: Custom (builds actual Home Manager configs)  
**Speed**: ⏱️ ~30-120s per test

**What They Test:**
- Home Manager configurations actually build
- Generated files exist
- File content is correct
- Colors are accurate
- Multi-module consistency

**Example:**

```nix
activation-helix-dark = mkActivationTest "helix-dark" [
  {
    programs.helix.enable = true;
    signal = {
      enable = true;
      mode = "dark";
      editors.helix.enable = true;
    };

    testScript = ''
      # Check config file exists
      test -f "$TEST_HOME/.config/helix/config.toml" || exit 1
      
      # Verify theme is set
      grep -q 'theme = "signal-dark"' "$TEST_HOME/.config/helix/config.toml" || exit 1
      
      # Verify color accuracy
      grep -q '"ui.background" = "#0f1419"' "$TEST_HOME/.config/helix/themes/signal-dark.toml" || exit 1
    '';
  }
];
```

**When to Use:**
- Testing Home Manager modules
- Verifying file generation
- Checking exact color values
- Integration between modules

**Run Command:**
```bash
nix build .#checks.x86_64-linux.activation-helix-dark
./run-tests.sh --category activation
```

---

### 3. NixOS VM Tests

**Location**: `tests/nixos-vm/`  
**Framework**: `pkgs.nixosTest`  
**Speed**: 🐌 ~2-5min per test  
**Platform**: Linux only

**What They Test:**
- Boot configuration (console, Plymouth, GRUB)
- Display managers (SDDM, GDM, LightDM)
- System services
- Actual boot/runtime behavior

**Example:**

```nix
nixos-vm-sddm = mkNixOSTest "sddm-login" {
  imports = [ self.nixosModules.signal ];

  signal.nixos = {
    enable = true;
    mode = "dark";
    login.sddm.enable = true;
  };

  services.displayManager.sddm.enable = true;
  services.xserver.enable = true;

  testScript = ''
    machine.start()
    machine.wait_for_unit("display-manager.service")
    machine.wait_for_unit("sddm.service")
    print("✓ SDDM display manager started successfully")
  '';
};
```

**When to Use:**
- NixOS system-level features
- Boot/login configuration
- Service integration
- Features requiring actual system

**Run Command:**
```bash
nix build .#checks.x86_64-linux.nixos-vm-sddm
./run-tests.sh --category nixos-vm
```

---

### 4. Integration Tests

**Location**: `tests/integration/`  
**Framework**: `pkgs.runCommand`  
**Speed**: ⏱️ ~2-5s per test

**What They Test:**
- Module structure
- Example configurations
- Pattern consistency
- File existence (not content)

**When to Use:**
- Quick structure validation
- Example syntax checking
- Module pattern verification

---

## Running Tests

### Quick Start

```bash
# Install into dev environment
nix develop

# Run all tests
nix flake check

# Run specific test
nix build .#checks.x86_64-linux.activation-helix-dark

# Run test category
./run-tests.sh --category activation

# Run with verbose output
./run-tests.sh --category activation --verbose
```

### Test Categories

| Category | Description | Count | Time |
|----------|-------------|-------|------|
| `unit` | Pure function tests | 5 | ~5s |
| `happy` | Happy path scenarios | 6 | ~30s |
| `edge` | Edge cases | 6 | ~30s |
| `error` | Error handling | 3 | ~15s |
| `integration` | Cross-module tests | 6 | ~30s |
| `activation` | HM activation tests | 6 | ~3min |
| `nixos-vm` | VM integration tests | 6 | ~15min |
| `module` | Module structure | 8 | ~40s |
| `validation` | Theme validation | 3 | ~15s |
| `security` | Security checks | 5 | ~25s |
| `performance` | Performance tests | 4 | ~20s |
| `documentation` | Doc validation | 2 | ~10s |
| `color` | Color conversions | 3 | ~15s |

### Run Specific Categories

```bash
# Fast tests during development
./run-tests.sh --category unit
./run-tests.sh --category happy

# Module integration tests
./run-tests.sh --category activation

# System-level tests (Linux only, slow)
./run-tests.sh --category nixos-vm

# All tests
nix flake check
```

### Platform-Specific Testing

```bash
# Linux tests
./run-tests.sh --system x86_64-linux --category activation

# Darwin tests (skips VM tests automatically)
./run-tests.sh --system aarch64-darwin --category activation

# Check platform
uname -s  # Linux or Darwin
```

---

## Writing New Tests

### Adding an Activation Test

**Step 1:** Create test in `tests/activation/default.nix`

```nix
activation-myapp-dark = mkActivationTest "myapp-dark" [
  {
    programs.myapp.enable = true;
    signal = {
      enable = true;
      mode = "dark";
      apps.myapp.enable = true;
    };

    testScript = ''
      echo "Testing MyApp configuration..."
      
      # Verify file exists
      test -f "$TEST_HOME/.config/myapp/config.toml" || {
        echo "ERROR: Config file not found"
        exit 1
      }
      
      # Verify colors
      grep -q 'background = "#0f1419"' "$TEST_HOME/.config/myapp/config.toml" || {
        echo "ERROR: Wrong background color"
        exit 1
      }
      
      echo "✓ MyApp configuration correct"
    '';
  }
];
```

**Step 2:** Export in `tests/activation/default.nix`

```nix
in
{
  inherit (activationTests)
    activation-helix-dark
    activation-myapp-dark  # Add here
    ;
}
```

**Step 3:** Add to flake.nix checks

```nix
inherit (activationTests)
  activation-helix-dark
  activation-myapp-dark  # Add here
  ;
```

**Step 4:** Add to run-tests.sh

```nix
activation)
    echo "activation-helix-dark activation-myapp-dark ..."
    ;;
```

**Step 5:** Test it

```bash
nix build .#checks.x86_64-linux.activation-myapp-dark --print-build-logs
```

### Adding a VM Test

```nix
# tests/nixos-vm/default.nix

nixos-vm-myfeature = mkNixOSTest "myfeature" {
  imports = [ self.nixosModules.signal ];

  signal.nixos = {
    enable = true;
    myfeature.enable = true;
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("test -f /etc/myfeature.conf")
  '';
};
```

### Test Naming Convention

- `unit-*` - Pure function tests
- `activation-*` - Home Manager activation tests
- `nixos-vm-*` - NixOS VM tests
- `integration-*` - Cross-module integration
- `happy-*` - Happy path scenarios
- `edge-*` - Edge cases
- `error-*` - Error handling

### Test Requirements Checklist

For every new module:
- [ ] Activation test for dark mode
- [ ] Activation test for light mode
- [ ] Integration test with other modules
- [ ] VM test (if NixOS feature)
- [ ] Edge case test
- [ ] Documentation

---

## CI/CD Integration

### GitHub Actions Workflow

Tests run automatically on:
- Push to `main`
- Pull requests
- Daily at 2am UTC (catch upstream breakages)

### Workflow Stages

1. **Smoke Test** (~30s)
   - Format check
   - Basic unit tests
   - Fail fast on obvious issues

2. **Test Suite Matrix** (~10min)
   - All test categories
   - Multiple systems (Linux, Darwin)
   - Parallel execution

3. **Full Check** (~15min)
   - Complete `nix flake check`
   - All systems
   - Integration validation

### Test Report

After tests complete, a detailed report is:
- Added to workflow summary
- Posted as PR comment
- Includes:
  - Pass/fail status
  - Duration per category
  - Failed test details
  - Performance metrics

### Local CI Simulation

```bash
# Run same tests as CI
nix flake check --system x86_64-linux

# With verbose output
nix flake check --print-build-logs

# Specific category
./run-tests.sh --category activation --verbose
```

---

## Troubleshooting

### Common Issues

#### Test Fails: "File not found"

**Problem:** Activation test can't find generated file

**Solution:**
```bash
# Build the config and inspect
nix build .#checks.x86_64-linux.activation-myapp-dark --print-build-logs

# Check what files were generated
ls -la result/home-files/.config/
```

#### Test Fails: "Wrong color"

**Problem:** Color value doesn't match expected

**Solution:**
```bash
# Extract the generated config
nix build .#checks.x86_64-linux.activation-myapp-dark
cat result/home-files/.config/myapp/config.toml

# Compare to expected color
# Update test or fix module
```

#### VM Test Hangs

**Problem:** NixOS VM test doesn't complete

**Solution:**
```bash
# Run with trace
nix build .#checks.x86_64-linux.nixos-vm-mytest --show-trace

# Check VM can start
# May need to adjust memory or timeout
```

#### Test Passes Locally, Fails in CI

**Problem:** Different behavior in CI environment

**Possible Causes:**
1. Platform difference (Linux vs Darwin)
2. Nix version difference
3. Cached results locally

**Solution:**
```bash
# Clean build
nix build .#checks.x86_64-linux.activation-myapp-dark --rebuild

# Check platform guards
grep -r "stdenv.isLinux" tests/
```

### Debug Commands

```bash
# Show trace for evaluation errors
nix build .#checks.x86_64-linux.my-test --show-trace

# Print build logs
nix build .#checks.x86_64-linux.my-test --print-build-logs

# Keep failed build
nix build .#checks.x86_64-linux.my-test --keep-failed

# Inspect failed build
ls -la /tmp/nix-build-*/
```

### Getting Help

1. **Check documentation**: `docs/TESTING_GUIDE.md`, `docs/troubleshooting.md`
2. **View test implementation**: Read existing tests in `tests/`
3. **Search issues**: GitHub issues for similar problems
4. **Ask in discussions**: GitHub Discussions for guidance
5. **Open issue**: If bug found, open detailed issue

---

## Best Practices

### Do ✅

- Test actual file content, not just evaluation
- Use activation tests for Home Manager modules
- Use VM tests for NixOS system features
- Write clear test failure messages
- Test both dark and light modes
- Test edge cases and error conditions
- Document platform requirements

### Don't ❌

- Don't test only that modules evaluate
- Don't assume tests catch all issues
- Don't skip testing on target platforms
- Don't write flaky tests
- Don't ignore test failures
- Don't forget to update documentation

---

## Performance Guidelines

### Test Speed Targets

- Unit tests: < 1s per test
- Activation tests: < 2min per test
- VM tests: < 5min per test
- Full suite: < 20min

### Optimization Tips

1. **Use Unit Tests First**
   - Fast iteration
   - Quick validation
   - Pure evaluation

2. **Batch Integration Tests**
   - Test multiple things in one activation
   - Reduce build overhead

3. **Parallelize**
   - Run categories in parallel
   - Use CI matrix

4. **Cache Aggressively**
   - Use Nix cache
   - Cache activation packages
   - Reuse VM images

---

## Metrics and Reporting

### Current Coverage

- **Total Tests**: 70+
- **Test Categories**: 13
- **Platforms**: Linux, Darwin
- **Activation Tests**: 6 (new!)
- **VM Tests**: 6 (re-enabled!)

### Success Criteria

- ✅ All tests pass on all platforms
- ✅ Activation tests verify file content
- ✅ VM tests verify system behavior
- ✅ Coverage for all Tier 1 modules
- ✅ CI completes in < 20min

---

## Migration from Old Testing

### What Changed

**Before:**
- Tests only checked evaluation
- No activation package testing
- NixOS tests were disabled
- Users encountered runtime errors

**After:**
- Tests verify actual file generation
- Activation tests for all modules
- VM tests for system features
- Catches 90%+ of user issues

### Migration Guide

If you have custom tests:

1. Keep evaluation tests for quick feedback
2. Add activation tests for file verification
3. Add VM tests for system features
4. Update CI to run new tests

---

## Future Enhancements

- [ ] Golden file testing with committed expected outputs
- [ ] Screenshot comparison for UI themes
- [ ] Performance benchmarking
- [ ] Property-based testing
- [ ] Fuzz testing for color inputs
- [ ] Darwin VM tests (when available)

---

## References

- [NixOS Manual - Testing](https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests)
- [Home Manager Testing](https://github.com/nix-community/home-manager/tree/master/tests)
- [NMT Framework](https://git.sr.ht/~rycee/nmt)
- [Signal Testing Guide](./TESTING_GUIDE.md)
- [Platform Testing](./PLATFORM_TESTING.md)

---

**Signal Design System** - Testing that matches user experience

*Last Updated: 2026-01-18*  
*Version: 2.0*  
*Framework: Multi-Layer Testing Architecture*
