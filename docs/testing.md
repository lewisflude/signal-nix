# Signal Testing Suite

Comprehensive test coverage for the Signal Design System NixOS/Home Manager integration.

## Overview

Signal-nix includes **32 automated tests** covering:
- ✅ Library function unit tests
- ✅ Module evaluation tests
- ✅ Integration tests for examples
- ✅ Edge case validation
- ✅ Theme resolution consistency
- ✅ Accessibility validation
- ✅ Color manipulation verification

## Running Tests

### Run All Tests

```bash
nix flake check
```

### Run Specific Test Category

```bash
# Unit tests
nix build .#checks.x86_64-linux.unit-lib-resolveThemeMode
nix build .#checks.x86_64-linux.unit-lib-getThemeName

# Integration tests
nix build .#checks.x86_64-linux.integration-example-basic
nix build .#checks.x86_64-linux.integration-example-full-desktop

# Module tests
nix build .#checks.x86_64-linux.module-helix-dark
nix build .#checks.x86_64-linux.module-gtk-evaluates

# Edge case tests
nix build .#checks.x86_64-linux.edge-case-brand-governance
nix build .#checks.x86_64-linux.edge-case-multiple-terminals

# Validation tests
nix build .#checks.x86_64-linux.validation-theme-names
nix build .#checks.x86_64-linux.accessibility-contrast-estimation
```

## Test Coverage

### 1. Unit Tests - Library Functions (5 tests)

Tests for pure functions in `lib/default.nix`:

- **`unit-lib-resolveThemeMode`**: Tests theme mode resolution
  - `auto` → `dark`
  - `dark` → `dark`
  - `light` → `light`

- **`unit-lib-isValidResolvedMode`**: Tests mode validation
  - `dark` is valid
  - `light` is valid
  - `auto` is invalid (must be resolved first)

- **`unit-lib-getThemeName`**: Tests theme name generation
  - `dark` → `"signal-dark"`
  - `light` → `"signal-light"`
  - `auto` → `"signal-dark"` (resolved)

- **`unit-lib-getColors`**: Tests color structure retrieval
  - Verifies presence of `tonal`, `accent`, `categorical` attributes
  - Tests both dark and light modes

- **`unit-lib-getSyntaxColors`**: Tests syntax color generation
  - Verifies all required syntax color keys exist
  - Tests both dark and light modes

### 2. Integration Tests - Examples (4 tests)

Tests that example configurations are valid:

- **`integration-example-basic`**: Tests `examples/basic.nix`
- **`integration-example-auto-enable`**: Tests `examples/auto-enable.nix`
- **`integration-example-full-desktop`**: Tests `examples/full-desktop.nix`
- **`integration-example-custom-brand`**: Tests `examples/custom-brand.nix`
- **`integration-example-migrating`**: Tests `examples/migrating-existing-config.nix` syntax and structure
- **`integration-example-multi-machine`**: Tests `examples/multi-machine.nix` syntax and multi-host patterns

### 3. Module Tests - Individual Modules (8 tests)

Tests that modules have correct structure and imports:

- **`module-common-evaluates`**: Core common module
- **`module-helix-dark`**: Helix editor module structure
- **`module-helix-light`**: Helix uses theme resolution
- **`module-ghostty-evaluates`**: Ghostty terminal module
- **`module-bat-evaluates`**: Bat syntax highlighter module
- **`module-fzf-evaluates`**: Fzf fuzzy finder module
- **`module-gtk-evaluates`**: GTK theming module
- **`module-ironbar-evaluates`**: Ironbar status bar module

### 4. Edge Case Tests (4 tests)

Tests for option combinations and conflicts:

- **`edge-case-all-disabled`**: Signal disabled configuration works
- **`edge-case-multiple-terminals`**: Multiple terminals can be enabled
- **`edge-case-brand-governance`**: Brand governance policies work correctly
  - `functional-override` policy
  - `separate-layer` policy
  - `integrated` policy
- **`edge-case-ironbar-profiles`**: All ironbar profiles are defined
  - compact (1080p)
  - relaxed (1440p+)
  - spacious (4K)

### 5. Validation Tests (2 tests)

Tests for consistency and correctness:

- **`validation-theme-names`**: Ensures modules use resolved theme names
  - Checks `bat`, `helix`, `gtk` use `resolveThemeMode`
  - Checks `fzf` uses pre-resolved `signalColors`
  - Checks `common` module resolves mode

- **`validation-no-auto-theme-names`**: Ensures no module uses `"signal-auto"`
  - Searches all modules for invalid `signal-auto` references

### 6. Accessibility Tests (1 test)

Tests for accessibility functions:

- **`accessibility-contrast-estimation`**:
  - Tests high contrast detection
  - Tests `meetsMinimum` function
  - Tests low contrast rejection

### 7. Color Manipulation Tests (2 tests)

Tests for color transformation functions:

- **`color-manipulation-lightness`**: Tests lightness adjustment
  - Lightness increases correctly
  - Chroma preserved
  - Hue preserved

- **`color-manipulation-chroma`**: Tests chroma adjustment
  - Chroma increases correctly
  - Lightness preserved
  - Hue preserved

### 8. Static Checks (4 tests)

Existing static validation tests:

- **`format`**: All Nix files are properly formatted
- **`flake-outputs`**: Flake structure is valid
- **`modules-exist`**: All module files exist
- **`theme-resolution`**: Theme resolution patterns are correct

## Test Implementation

### Testing Methodology

Signal-nix uses **pure Nix-based testing** with no external dependencies:

1. **Unit Tests**: Use `lib.runTests` for pure function testing
2. **Integration Tests**: Use `pkgs.runCommand` with shell validation
3. **Module Tests**: Use file existence and grep-based structure validation
4. **No External Frameworks**: Everything uses built-in Nix tooling

### Test Structure

Tests are organized into three directories for better maintainability:

```
tests/
├── default.nix           # Main test aggregator (imports from subdirectories)
├── unit/                 # Pure Nix unit tests (fast, no shell)
│   └── default.nix       # Library functions, colors, accessibility
├── integration/          # Shell-based validation (slower, file checks)
│   └── default.nix       # Module structure, examples, patterns
├── nixos.nix            # NixOS-specific tests (separate)
└── comprehensive-test-suite.nix  # Additional test scenarios
```

**Why this structure?**

- **Clear separation**: Pure tests vs shell tests are immediately distinguishable
- **Performance**: Easy to run only fast unit tests during development
- **Maintainability**: Related tests grouped together in focused files
- **Future-ready**: Prepares for potential nix-unit migration of pure tests

### Test Categories

#### Unit Tests (`tests/unit/`)

Fast, pure Nix evaluation tests using `lib.runTests`:

```nix
# tests/unit/default.nix
unit-lib-resolveThemeMode = mkTest "lib-resolve-theme-mode" {
  testAutoToDark = {
    expr = signalLib.resolveThemeMode "auto";
    expected = "dark";
  };
};
```

**Characteristics:**
- No shell commands
- Pure function evaluation
- Runs in ~0.5-1 second per test
- Ideal for library functions, color manipulation, accessibility

#### Integration Tests (`tests/integration/`)

Shell-based validation tests using `pkgs.runCommand`:

```nix
# tests/integration/default.nix
module-helix-dark = pkgs.runCommand "test-module-helix" {} ''
  test -f ${../../modules/editors/helix.nix} || exit 1
  ${pkgs.gnugrep}/bin/grep -q "programs.helix" ${../../modules/editors/helix.nix}
  echo "✓ Test passed"
  touch $out
'';
```

**Characteristics:**
- Uses shell commands (test, grep, etc.)
- File system access required
- Runs in ~2-5 seconds per test
- Ideal for module structure validation, pattern matching, examples

### Helper Functions

- **`mkTest`**: Creates a test derivation from `lib.runTests` output
- **`lib.runTests`**: Built-in Nix function for pure unit testing
- **`pkgs.runCommand`**: Creates derivations for shell-based tests
- **`assertFileExists`**: Helper for file existence checks (integration tests)
- **`assertFileContains`**: Helper for pattern matching (integration tests)

## Test Output

All tests provide clear output:

```
✅ checks.x86_64-linux.unit-lib-resolveThemeMode
✅ checks.x86_64-linux.integration-example-basic
✅ checks.x86_64-linux.module-helix-dark
✅ checks.x86_64-linux.edge-case-brand-governance
✅ checks.x86_64-linux.validation-theme-names
✅ checks.x86_64-linux.accessibility-contrast-estimation
✅ checks.x86_64-linux.color-manipulation-lightness
...
```

Failed tests show clear error messages:

```
❌ checks.x86_64-linux.validation-theme-names
error: FAIL: helix.nix should use signalLib.resolveThemeMode
```

## Continuous Integration

All tests run automatically in GitHub Actions on:
- Push to `main` branch
- Pull requests
- Manual workflow dispatch

See `.github/workflows/flake-check.yml` for CI configuration.

## Adding New Tests

### Unit Test for Library Function

Add to `tests/unit/default.nix`:

```nix
unit-lib-myFunction = mkTest "my-function" {
  testCase1 = {
    expr = signalLib.myFunction "input";
    expected = "expected-output";
  };
  testCase2 = {
    expr = signalLib.myFunction "other";
    expected = "other-output";
  };
};
```

Then export it in `tests/default.nix`:

```nix
inherit (unitTests)
  # ... existing tests
  unit-lib-myFunction
  ;
```

### Integration Test for Module Structure

Add to `tests/integration/default.nix`:

```nix
module-myapp-evaluates = pkgs.runCommand "test-module-myapp" {} ''
  echo "Testing myapp module..."
  
  test -f ${../../modules/apps/myapp.nix} || {
    echo "FAIL: myapp.nix not found"
    exit 1
  }
  
  ${pkgs.gnugrep}/bin/grep -q "programs.myapp" ${../../modules/apps/myapp.nix} || {
    echo "FAIL: myapp.nix missing programs.myapp config"
    exit 1
  }
  
  echo "✓ myapp module structure is valid"
  touch $out
'';
```

Then export it in `tests/default.nix`:

```nix
inherit (integrationTests)
  # ... existing tests
  module-myapp-evaluates
  ;
```

### Integration Test for Examples

Add to `tests/integration/default.nix`:

```nix
integration-example-myconfig = mkExampleTest 
  "myconfig" 
  ../../examples/myconfig.nix 
  "requiredField";
```

Then export it in `tests/default.nix`:

```nix
inherit (integrationTests)
  # ... existing tests
  integration-example-myconfig
  ;
```

### Guidelines for Test Placement

**Use Unit Tests (`tests/unit/`) when:**
- Testing pure functions
- No file system access needed
- Fast execution is critical
- Examples: color calculations, theme resolution, accessibility checks

**Use Integration Tests (`tests/integration/`) when:**
- Validating file structure
- Pattern matching with grep
- Checking module configuration
- Examples: module validation, example syntax, file existence

## Test Philosophy

Signal-nix testing follows these principles:

1. **Pure Nix**: No external test frameworks or dependencies
2. **Fast**: All tests run in parallel, complete in seconds
3. **Deterministic**: Same input always produces same output
4. **Comprehensive**: Cover unit, integration, and edge cases
5. **Clear Output**: Tests provide actionable error messages
6. **CI-First**: All tests run automatically on every change

## Coverage Summary

| Category | Tests | Status |
|----------|-------|--------|
| Library Functions | 5 | ✅ 100% |
| Integration Examples | 4 | ✅ 100% |
| Module Evaluation | 8 | ✅ 100% |
| Edge Cases | 4 | ✅ 100% |
| Validation | 2 | ✅ 100% |
| Accessibility | 1 | ✅ 100% |
| Color Manipulation | 2 | ✅ 100% |
| Static Checks | 4 | ✅ 100% |
| **Total** | **30** | **✅ 100%** |

## Performance

Test suite performance on typical hardware:

- **Evaluation**: ~2-3 seconds
- **Build (cold)**: ~10-15 seconds
- **Build (cached)**: ~2-5 seconds
- **CI (GitHub Actions)**: ~30-45 seconds

All tests leverage Nix's binary caching for fast execution.

### Performance by Test Type

The organized test structure enables targeted test runs:

**Unit Tests Only (Fast Development Loop):**
```bash
# Run all pure unit tests (~5-10 seconds)
nix build .#checks.x86_64-linux.unit-lib-resolveThemeMode \
          .#checks.x86_64-linux.unit-lib-getColors \
          .#checks.x86_64-linux.accessibility-contrast-estimation \
          .#checks.x86_64-linux.color-manipulation-lightness
```

- Pure Nix evaluation (9 tests)
- No shell commands
- ~0.5-1 second per test
- Ideal for TDD and rapid iteration

**Integration Tests (Slower but Comprehensive):**
```bash
# Run all integration tests (~30-60 seconds)
nix build .#checks.x86_64-linux.integration-example-basic \
          .#checks.x86_64-linux.module-helix-dark \
          .#checks.x86_64-linux.validation-theme-names
```

- Shell-based validation (15 tests)
- File system access required
- ~2-5 seconds per test
- Run before commits or in CI

**Full Test Suite:**
```bash
# Run everything (60+ tests, ~6 minutes)
nix flake check
```

### Optimization Tips

1. **During development**: Run only unit tests for immediate feedback
2. **Before committing**: Run relevant integration tests
3. **In CI**: Run full suite with parallel execution
4. **Cache hits**: Most tests complete in <1s when cached

## Troubleshooting

### Test Fails with "not formatted"

Run `nixfmt` on the affected files:

```bash
nixfmt flake.nix tests/default.nix modules/**/*.nix
```

### Test Fails with "file not found"

Ensure the file is tracked by git:

```bash
git add path/to/file
```

### Test Fails with Evaluation Error

Run the specific test with `--show-trace`:

```bash
nix build .#checks.x86_64-linux.test-name --show-trace
```

### All Tests Hang

Check for infinite recursion in new code:

```bash
nix eval .#lib --show-trace
nix eval .#homeManagerModules.default --show-trace
```

## Related Documentation

- [Testing Guide](docs/testing.md) - General testing instructions
- [Contributing Guide](CONTRIBUTING.md) - How to contribute tests
- [CI/CD Workflows](.github/workflows/) - Automated testing setup

---

**Signal Design System** - Testing built on scientific principles.
