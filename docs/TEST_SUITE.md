# Signal-Nix Test Suite Documentation

This document provides comprehensive information about the test suite for the Signal Design System.

## Table of Contents

- [Overview](#overview)
- [Running Tests](#running-tests)
- [Test Categories](#test-categories)
- [Test Files](#test-files)
- [Writing New Tests](#writing-new-tests)
- [CI/CD Integration](#cicd-integration)

## Overview

The Signal-Nix test suite is designed to ensure the reliability, security, and performance of the Signal Design System integration for NixOS and Home Manager. Tests are written using Nix's built-in testing framework and are automatically run via `nix flake check`.

### Test Philosophy

1. **Comprehensive Coverage**: Tests cover all major categories - happy paths, edge cases, error handling, integration, performance, and security
2. **Fast Execution**: Unit tests run quickly; integration tests are optimized
3. **Clear Failures**: When a test fails, the error message clearly indicates what went wrong
4. **Maintainable**: Tests are well-organized and documented

## Running Tests

### Run All Tests

```bash
nix flake check
```

### Run Specific Test Category

```bash
# Run only unit tests
nix build .#checks.x86_64-linux.unit-lib-resolveThemeMode

# Run only integration tests
nix build .#checks.x86_64-linux.integration-example-basic

# Run only performance tests
nix build .#checks.x86_64-linux.performance-color-lookups
```

### Run Tests for Specific System

```bash
# For x86_64 Linux
nix flake check --system x86_64-linux

# For aarch64 Linux
nix flake check --system aarch64-linux

# For macOS (Darwin)
nix flake check --system x86_64-darwin
nix flake check --system aarch64-darwin
```

### Show Test Results

```bash
# Verbose output
nix flake check --print-build-logs

# Show only failed tests
nix flake check 2>&1 | grep FAIL
```

## Test Categories

### 1. Happy Path Tests

**Purpose**: Verify normal, expected usage patterns work correctly.

**Tests**:
- `happy-basic-dark-mode`: Dark mode configuration
- `happy-basic-light-mode`: Light mode configuration
- `happy-auto-mode-defaults-dark`: Auto mode defaults to dark
- `happy-color-structure`: Color palette structure validation
- `happy-syntax-colors-complete`: Syntax highlighting colors completeness
- `happy-brand-governance-functional-override`: Brand governance functional override policy

**Example**:
```bash
nix build .#checks.x86_64-linux.happy-basic-dark-mode
```

### 2. Edge Case Tests

**Purpose**: Test boundary conditions and unusual but valid inputs.

**Tests**:
- `edge-empty-brand-colors`: Empty brand color sets
- `edge-lightness-boundaries`: Lightness clamping at 0.0 and 1.0
- `edge-chroma-boundaries`: Chroma clamping at 0.0
- `edge-contrast-extreme-values`: Maximum and zero contrast
- `edge-all-modules-disabled`: All modules disabled (valid config)
- `edge-ironbar-profiles`: All Ironbar profile options
- `edge-case-multiple-terminals`: Multiple terminal modules

**Example**:
```bash
nix build .#checks.x86_64-linux.edge-lightness-boundaries
```

### 3. Error Handling Tests

**Purpose**: Ensure invalid inputs are properly rejected with clear error messages.

**Tests**:
- `error-invalid-theme-mode`: Invalid theme mode rejection
- `error-brand-governance-invalid-policy`: Invalid brand policy fallback
- `error-color-manipulation-throws`: Color manipulation hex access throws error

**Example**:
```bash
nix build .#checks.x86_64-linux.error-invalid-theme-mode
```

### 4. Integration Tests

**Purpose**: Test interactions between different components.

**Tests**:
- `integration-module-lib-interaction`: Module and library interaction
- `integration-colors-and-syntax`: Color and syntax coordination
- `integration-brand-with-colors`: Brand colors merging with functional colors
- `integration-theme-resolution-consistency`: Consistent theme resolution across modules
- `integration-auto-enable-logic`: Auto-enable feature logic
- `integration-example-basic`: Basic example configuration
- `integration-example-auto-enable`: Auto-enable example
- `integration-example-full-desktop`: Full desktop example
- `integration-example-custom-brand`: Custom brand example
- `integration-helix-builds`: Helix module builds correctly
- `integration-ghostty-builds`: Ghostty module builds correctly

**Example**:
```bash
nix build .#checks.x86_64-linux.integration-auto-enable-logic
```

### 5. Performance Tests

**Purpose**: Ensure acceptable performance and resource usage.

**Tests**:
- `performance-color-lookups`: Color lookup speed
- `performance-theme-resolution-cached`: Theme resolution caching
- `performance-large-brand-colors`: Large brand color sets
- `performance-module-evaluation`: Module evaluation speed

**Example**:
```bash
nix build .#checks.x86_64-linux.performance-module-evaluation
```

### 6. Security Tests

**Purpose**: Validate input sanitization and prevent vulnerabilities.

**Tests**:
- `security-color-hex-validation`: Hex color format validation
- `security-no-code-injection`: No code injection through user inputs
- `security-mode-enum-validation`: Theme mode enum validation
- `security-brand-policy-enum-validation`: Brand policy enum validation
- `security-no-path-traversal`: No path traversal in imports

**Example**:
```bash
nix build .#checks.x86_64-linux.security-no-code-injection
```

### 7. Unit Tests (Library Functions)

**Purpose**: Test individual library functions in isolation.

**Tests**:
- `unit-lib-resolveThemeMode`: Theme mode resolution
- `unit-lib-isValidResolvedMode`: Resolved mode validation
- `unit-lib-getThemeName`: Theme name generation
- `unit-lib-getColors`: Color palette retrieval
- `unit-lib-getSyntaxColors`: Syntax color retrieval

**Example**:
```bash
nix build .#checks.x86_64-linux.unit-lib-getColors
```

### 8. Module Tests

**Purpose**: Test individual module structure and evaluation.

**Tests**:
- `module-common-evaluates`: Common module structure
- `module-helix-dark`: Helix module structure
- `module-ghostty-evaluates`: Ghostty module structure
- `module-bat-evaluates`: Bat module structure
- `module-fzf-evaluates`: Fzf module structure
- `module-gtk-evaluates`: GTK module structure
- `module-ironbar-evaluates`: Ironbar module structure

**Example**:
```bash
nix build .#checks.x86_64-linux.module-helix-dark
```

### 9. Validation Tests

**Purpose**: Ensure consistency and correctness across the codebase.

**Tests**:
- `validation-theme-names`: Theme name consistency
- `validation-no-auto-theme-names`: No "signal-auto" usage
- `accessibility-contrast-estimation`: Contrast calculations

**Example**:
```bash
nix build .#checks.x86_64-linux.validation-theme-names
```

### 10. Documentation Tests

**Purpose**: Ensure documentation and examples are correct.

**Tests**:
- `documentation-examples-valid-nix`: All examples parse correctly
- `documentation-readme-references`: README references valid files

**Example**:
```bash
nix build .#checks.x86_64-linux.documentation-examples-valid-nix
```

## Test Files

### `tests/default.nix`

The main test file that imports and organizes all tests. Contains:
- Test helper functions
- Unit tests for library functions
- Integration tests for examples
- Module structure tests
- Edge case tests
- Accessibility tests
- Color manipulation tests

### `tests/comprehensive-test-suite.nix`

Extended test suite covering:
- Happy path scenarios
- Edge cases
- Error handling
- Integration testing
- Performance testing
- Security testing
- Documentation validation

## Writing New Tests

### Basic Test Structure

```nix
# Unit test using mkTest helper
my-new-test = mkTest "my-new-test" {
  testDescription = {
    expr = signalLib.someFunction "input";
    expected = "expected-output";
  };
};

# Integration test using pkgs.runCommand
my-integration-test = pkgs.runCommand "test-my-feature" {} ''
  echo "Testing my feature..."
  
  # Test logic here
  test -f ${./some-file} || {
    echo "FAIL: File not found"
    exit 1
  }
  
  echo "✓ Test passed"
  touch $out
'';
```

### Test Helper Functions

#### `mkTest`
Creates a pure Nix test that checks expression results:
```nix
mkTest "test-name" {
  testCase1 = {
    expr = actualValue;
    expected = expectedValue;
  };
  testCase2 = { ... };
}
```

#### `mkModuleTest`
Tests that a module file exists and has correct structure:
```nix
mkModuleTest "module-name" ./path/to/module.nix "programName"
```

#### `mkExampleTest`
Tests that an example file exists and contains required patterns:
```nix
mkExampleTest "example-name" ./path/to/example.nix "required-pattern"
```

### Adding Tests to the Suite

1. **Write the test** in `tests/comprehensive-test-suite.nix` or `tests/default.nix`
2. **Export the test** in the file's return value
3. **Add to flake.nix** in the appropriate category under `checks`
4. **Run the test** with `nix build .#checks.x86_64-linux.your-test-name`

### Test Naming Convention

- Prefix: Category name (`unit-`, `integration-`, `edge-`, `error-`, `performance-`, `security-`, `validation-`, `documentation-`)
- Body: Descriptive name using kebab-case
- Example: `integration-theme-resolution-consistency`

## CI/CD Integration

### GitHub Actions

The test suite is automatically run on:
- Pull requests
- Pushes to main branch
- Manual workflow dispatch

See `.github/workflows/flake-check.yml` for CI configuration.

### Test Matrix

Tests run on multiple systems:
- `x86_64-linux` (Primary)
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

### Performance Benchmarks

Performance tests track:
- Module evaluation time
- Color lookup speed
- Theme resolution caching

Performance regressions will be flagged in CI.

## Troubleshooting

### Test Failures

If tests fail:

1. **Read the error message**: Tests provide clear failure descriptions
2. **Check recent changes**: Did you modify related code?
3. **Run locally**: `nix flake check --print-build-logs`
4. **Isolate the test**: `nix build .#checks.x86_64-linux.failing-test-name`
5. **Review test code**: Check the test in `tests/` directory

### Common Issues

**Issue**: "signal-auto" found in module files
- **Fix**: Use `signalLib.resolveThemeMode` instead of hardcoding theme names

**Issue**: Module evaluation is slow
- **Check**: Performance tests for regression
- **Optimize**: Review color lookups and theme resolution

**Issue**: Example doesn't parse
- **Fix**: Ensure valid Nix syntax with `nix-instantiate --parse`

## Test Coverage

Current test coverage:

| Category | Tests | Coverage |
|----------|-------|----------|
| Happy Path | 6 | Core functionality |
| Edge Cases | 6 | Boundary conditions |
| Error Handling | 3 | Invalid inputs |
| Integration | 12 | Component interactions |
| Performance | 4 | Speed & resources |
| Security | 5 | Input validation |
| Unit Tests | 5 | Library functions |
| Module Tests | 8 | Module structure |
| Validation | 3 | Consistency checks |
| Documentation | 2 | Examples & docs |

**Total**: 54+ test checks

## Future Improvements

Planned test enhancements:

1. **Visual Regression Testing**: Compare theme outputs visually
2. **Accessibility Compliance**: Full APCA implementation
3. **Load Testing**: Test with 100+ modules enabled
4. **Mutation Testing**: Ensure tests catch bugs
5. **Property-Based Testing**: Generate random valid inputs
6. **Real-World Scenarios**: Test against actual user configurations

## Contributing

When contributing:

1. **Add tests** for new features
2. **Update tests** when changing existing functionality
3. **Run full suite** before submitting PR: `nix flake check`
4. **Document tests** in this file if adding new categories
5. **Keep tests fast**: Unit tests should complete in < 1 second

## Resources

- [NixOS Testing Documentation](https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests)
- [Nix Language Basics](https://nixos.org/guides/nix-pills/)
- [Home Manager Tests](https://github.com/nix-community/home-manager/tree/master/tests)

---

Last updated: 2026-01-17
