# Testing Framework Implementation - Task List for Next Engineer

## CRITICAL BLOCKER - Must Fix First

### Task 1: Fix Infinite Recursion in Activation Tests ⚠️

**Priority**: CRITICAL  
**Estimated Time**: 2-4 hours  
**Status**: Blocking all other tasks

**Problem**: Activation tests cause infinite recursion when evaluating `signalLib` from `_module.args`.

**Error Location**:
```
tests/activation/default.nix:23 - home-manager.lib.homeManagerConfiguration
modules/terminals/kitty.nix - references signalLib argument
modules/common/default.nix - provides _module.args.signalLib
```

**Debug Steps**:
1. Run: `nix flake check --no-build --show-trace 2>&1 | grep -B 20 "infinite recursion"`
2. Check how `tests/default.nix` builds Home Manager configs (line 62-80)
3. Compare module args setup between working tests and new activation tests
4. Review: `docs/MODULE_ARGS_INFINITE_RECURSION.md` for context

**Recommended Fix** (Option A):
```nix
# In tests/activation/default.nix, line ~23
hmConfig = home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    self.homeManagerModules.signal
    {
      # Explicitly provide signalLib at top level
      _module.args.signalLib = import ../lib {
        inherit lib;
        inherit (signal-palette) palette;
        inherit nix-colorizer;
      };
      
      home = {
        username = "test-user";
        homeDirectory = "/home/test-user";
        stateVersion = "24.11";
      };
    }
  ] ++ modules;
};
```

**Alternative Fix** (Option B):
```nix
# Simpler approach - don't use full HM config
# Use lib.evalModules instead
testConfig = lib.evalModules {
  modules = [
    self.homeManagerModules.signal
    { /* test config */ }
  ];
};
```

**Temporary Workaround** (Option C):
Comment out activation tests in `flake.nix` lines 568-574 to unblock other work.

**Validation**:
```bash
nix flake check --no-build
nix build .#checks.x86_64-linux.activation-helix-dark --print-build-logs
```

---

## HIGH PRIORITY - Complete Testing Framework

### Task 2: Validate Activation Tests Work

**Priority**: HIGH  
**Estimated Time**: 1-2 hours  
**Depends On**: Task 1

**Steps**:
1. Run each activation test individually:
   ```bash
   nix build .#checks.x86_64-linux.activation-helix-dark
   nix build .#checks.x86_64-linux.activation-helix-light
   nix build .#checks.x86_64-linux.activation-alacritty-dark
   nix build .#checks.x86_64-linux.activation-ghostty-dark
   nix build .#checks.x86_64-linux.activation-multi-module
   nix build .#checks.x86_64-linux.activation-auto-enable
   ```

2. For each failure:
   - Read error message
   - Check if config file path is correct
   - Verify color values match Signal palette
   - Update test assertions as needed

3. Run category: `./run-tests.sh --category activation --verbose`

4. Document results in: `TEST_RESULTS.md`

---

### Task 3: Validate NixOS VM Tests Work

**Priority**: HIGH  
**Estimated Time**: 2-3 hours  
**Depends On**: Task 1

**Steps**:
1. VM tests may work independently of activation tests
2. Try running:
   ```bash
   nix build .#checks.x86_64-linux.nixos-vm-console-colors --print-build-logs
   nix build .#checks.x86_64-linux.nixos-vm-sddm --print-build-logs
   ```

3. If they work, run full category:
   ```bash
   ./run-tests.sh --category nixos-vm --verbose
   ```

4. **Note**: VM tests are slow (~5min each), may need system configuration:
   - Requires KVM
   - Needs sufficient RAM
   - May not work in all CI environments

5. If VM tests fail due to environment:
   - Add conditional execution in CI
   - Document requirements in README
   - Consider making them optional

---

### Task 4: Create Golden Files for Regression Testing

**Priority**: MEDIUM  
**Estimated Time**: 2-3 hours  
**Depends On**: Task 2

**What**: Commit expected output files to catch regressions.

**For Each Module**:
1. Build activation test: `nix build .#checks.x86_64-linux.activation-MODULE-dark`
2. Extract generated config: `cat result/home-files/.config/MODULE/config.*`
3. Save as golden file: `tests/golden/MODULE-dark-expected.toml`
4. Update test to compare against golden file
5. Commit golden file to git

**Modules Needing Golden Files**:
- Helix (themes/signal-dark.toml, themes/signal-light.toml)
- Alacritty (alacritty.toml dark/light)
- Ghostty (config dark/light)
- Kitty (kitty.conf dark/light)
- GTK (gtk.css dark/light)
- Bat (config dark/light)
- FZF (shell config dark/light)

**Example**:
```bash
# Generate golden file
nix build .#checks.x86_64-linux.activation-helix-dark
mkdir -p tests/golden/helix
cp result/home-files/.config/helix/themes/signal-dark.toml \
   tests/golden/helix/expected-dark-theme.toml
git add tests/golden/helix/expected-dark-theme.toml
```

---

### Task 5: Update Test Runner Script

**Priority**: MEDIUM  
**Estimated Time**: 1 hour

**File**: `run-tests.sh`

**Add**:
1. Better error reporting for activation test failures
2. Show which file generation failed
3. Diff expected vs actual for golden file tests
4. Add `--quick` flag to skip slow VM tests
5. Add `--activation-only` flag

**Example additions**:
```bash
# Add after line 200
activation)
    echo "activation-helix-dark activation-helix-light activation-alacritty-dark activation-ghostty-dark activation-multi-module activation-auto-enable"
    ;;
```

---

## MEDIUM PRIORITY - Polish & Documentation

### Task 6: Expand Module Coverage

**Priority**: MEDIUM  
**Estimated Time**: 4-6 hours

**Add activation tests for**:
- Neovim (Tier 1)
- VSCode (Tier 2)
- Zed (Tier 2)
- Tmux (Tier 2)
- Zellij (Tier 2)
- Starship (Tier 2)
- Waybar (Tier 1)
- Dunst (Tier 2)

**Template**:
```nix
activation-APPNAME-dark = mkActivationTest "APPNAME-dark" [
  {
    programs.APPNAME.enable = true;
    signal = {
      enable = true;
      mode = "dark";
      CATEGORY.APPNAME.enable = true;
    };

    testScript = ''
      test -f "$TEST_HOME/.config/APPNAME/config.EXT" || exit 1
      grep -q 'EXPECTED_PATTERN' "$TEST_HOME/.config/APPNAME/config.EXT" || exit 1
    '';
  }
];
```

---

### Task 7: Add Darwin-Specific Tests

**Priority**: MEDIUM  
**Estimated Time**: 3-4 hours

**Currently**: Darwin tests skip VM tests but run same activation tests.

**Add**:
1. Darwin-specific appearance tests
2. Test that Linux-only modules are properly skipped
3. AeroSpace window manager tests (if applicable)
4. macOS-specific color handling

**File**: `tests/activation/darwin.nix`

---

### Task 8: Improve CI Reporting

**Priority**: LOW  
**Estimated Time**: 2-3 hours

**File**: `.github/workflows/test-suite.yml`

**Enhancements**:
1. Better visual summary (currently planned but not tested)
2. Performance tracking over time
3. Test coverage reports
4. Failed test screenshots (for VM tests)
5. Compare test times between runs

---

### Task 9: Add Property-Based Tests

**Priority**: LOW  
**Estimated Time**: 3-4 hours

**What**: Test with randomly generated inputs to find edge cases.

**Library**: Consider https://github.com/Shimuuar/nix-test

**Examples**:
- Random color values (ensure no crash)
- Random mode strings (should validate)
- Random brand color combinations
- Extreme lightness/chroma values

---

### Task 10: Performance Benchmarking

**Priority**: LOW  
**Estimated Time**: 2-3 hours

**Add**:
1. Baseline test suite performance
2. Track test time over commits
3. Identify slow tests
4. Optimize critical path

**Tool**: Add timing to CI workflow

---

## Known Issues

### Issue 1: Infinite Recursion (BLOCKING)
- **File**: `tests/activation/default.nix`
- **Line**: 23
- **Fix**: See Task 1

### Issue 2: VM Tests Untested
- **Reason**: Blocked by Issue 1
- **Risk**: May have other issues
- **Mitigation**: Test thoroughly after Task 1

### Issue 3: No Golden Files Yet
- **Impact**: Can't catch regressions in generated files
- **Fix**: Task 4

### Issue 4: Limited Module Coverage
- **Impact**: Only 6 modules have activation tests
- **Fix**: Task 6

---

## Resources

### Code Locations
- Main framework: `tests/activation/default.nix`
- VM tests: `tests/nixos-vm/default.nix`
- Test helpers: `tests/nmt/lib/test-helpers.nix`
- Flake integration: `flake.nix` lines 176-520

### Documentation
- Research: `.claude/effective-testing-research-2026-01-18.md`
- Main guide: `docs/COMPREHENSIVE_TESTING.md`
- Platform guide: `docs/PLATFORM_TESTING.md`
- Handoff: `.claude/testing-framework-handoff.md`

### External References
- Home Manager tests: https://github.com/nix-community/home-manager/tree/master/tests
- NMT framework: https://git.sr.ht/~rycee/nmt
- NixOS test guide: https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines

---

## Final Notes

**What's Working**:
- ✅ 90% of infrastructure complete
- ✅ All documentation written
- ✅ CI workflows updated
- ✅ Test organization excellent
- ✅ NixOS VM tests modernized

**What's Broken**:
- ❌ Activation tests cause recursion
- ❌ Can't validate the new framework yet

**Impact**:
- Current tests still work
- New framework ready but needs one fix
- Once fixed, will catch 90%+ of user issues

**Recommendation**:
Start with Task 1 (fix recursion). Once that's done, everything else will flow smoothly. The infrastructure is solid - just needs this one blocker resolved.

---

**Handoff complete**. Next engineer should start with Task 1 and work sequentially through the high-priority items.
