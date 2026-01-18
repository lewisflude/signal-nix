# Testing Framework Implementation - Next Steps

## 🎯 Quick Start for Next Engineer

You're picking up a **90% complete** testing framework implementation. One critical bug is blocking validation.

### The Blocker 🚨

**Infinite recursion** in activation tests when building Home Manager configurations.

**Location**: `tests/activation/default.nix:23`

**To see it**:
```bash
nix flake check --no-build --show-trace 2>&1 | grep -B 20 "infinite recursion"
```

---

## 📋 Task Priority

### CRITICAL (Do First)
1. **Fix infinite recursion** in activation tests
   - File: `tests/activation/default.nix`
   - See: `testing-framework-handoff.md` for 3 solution options
   - Time: 2-4 hours

### HIGH (Do Next)
2. **Validate activation tests work** after fix
   - Run: `./run-tests.sh --category activation`
   - Time: 1-2 hours

3. **Validate VM tests work**
   - Run: `./run-tests.sh --category nixos-vm`
   - Time: 1-2 hours

### MEDIUM (Nice to Have)
4. **Create golden files** for regression testing
5. **Expand test coverage** to more modules
6. **Add Darwin-specific tests**

---

## 📚 Documentation

**Start here**:
1. `testing-implementation-summary.md` - What's done, what's not
2. `testing-framework-handoff.md` - Detailed technical handoff
3. `../docs/TESTING_GUIDE.md` - Testing guide and reference

**Research**:
- `effective-testing-research-2026-01-18.md` - Why we're doing this

**User-facing**:
- `../docs/COMPREHENSIVE_TESTING.md` - User guide
- `../docs/PLATFORM_TESTING.md` - Platform specifics

---

## 🔧 Quick Fix Guide

### Option A: Fix Module Args (Recommended)

Edit `tests/activation/default.nix` around line 23:

```nix
hmConfig = home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    self.homeManagerModules.signal
    {
      # ADD THIS: Explicitly provide signalLib
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
      
      manual.manpages.enable = false;
      manual.html.enable = false;
      manual.json.enable = false;
    }
  ] ++ modules;
};
```

**Then test**:
```bash
nix flake check --no-build
nix build .#checks.x86_64-linux.activation-helix-dark --print-build-logs
```

### Option B: Simplify Approach

If Option A doesn't work, use simpler evaluation:
```nix
# Replace mkActivationTest with:
mkActivationTest = name: modules:
  pkgs.runCommand "test-activation-${name}" {} ''
    # Evaluate module without full HM machinery
    ${pkgs.nix}/bin/nix-instantiate --eval --strict -E '
      let
        hmModule = import ${self.homeManagerModules.signal};
        # ... test evaluation
      in
        testCondition
    '
    touch $out
  '';
```

### Option C: Disable Temporarily

Comment out lines 568-574 in `flake.nix`:
```nix
# inherit (activationTests)
#   activation-helix-dark
#   # ... rest
#   ;
```

This unblocks VM tests and other work.

---

## 🎯 Success Looks Like

```bash
$ nix flake check
checking checks.x86_64-linux.unit-lib-resolveThemeMode
checking checks.x86_64-linux.activation-helix-dark        ✅ NEW
checking checks.x86_64-linux.activation-multi-module      ✅ NEW
checking checks.x86_64-linux.nixos-vm-console-colors      ✅ NEW
checking checks.x86_64-linux.nixos-vm-sddm                ✅ NEW
...
✅ All checks passed!
```

Then users get:
- ✅ Configs that actually work
- ✅ Errors caught before release
- ✅ Confidence in updates

---

## 📊 Progress

```
Implementation: ████████████████████░ 90%
Documentation:  ████████████████████░ 100%
Validation:     ░░░░░░░░░░░░░░░░░░░░ 0% (blocked)
Overall:        ████████████░░░░░░░░ 60%
```

**Next milestone**: Fix recursion → 95% complete

---

## 💡 Tips

1. **Start small**: Fix recursion for one test first
2. **Use existing tests**: `tests/default.nix` has working Home Manager setup
3. **Check module args**: Review `docs/MODULE_ARGS_INFINITE_RECURSION.md`
4. **Ask for help**: This is a known Nix issue with documented solutions

---

## 🔗 Key Files

| File | Purpose | Status |
|------|---------|--------|
| `tests/activation/default.nix` | Activation tests | ❌ Has bug |
| `tests/nixos-vm/default.nix` | VM tests | ✅ Ready |
| `flake.nix` | Integration | ⚠️ Won't eval |
| `run-tests.sh` | Test runner | ✅ Updated |
| `.github/workflows/test-suite.yml` | CI | ✅ Updated |

---

**You've got this!** The hard work is done - just needs one bug fix to unlock everything. 🚀

*Last Updated: 2026-01-18*
