# Testing Framework Documentation Index

## 🎯 Start Here

**If you're the next engineer**: Read `.claude/README-NEXT-ENGINEER.md`

**If you're a contributor**: Read `docs/COMPREHENSIVE_TESTING.md`

**If tests are failing**: Read `TESTING_TASKS.md`

---

## Documentation Organization

### For Engineers/Maintainers

#### Implementation Documents (`.claude/`)
1. **README-NEXT-ENGINEER.md** ⭐ START HERE
   - Quick start for next engineer
   - The blocker and how to fix it
   - Success criteria

2. **testing-implementation-summary.md**
   - What's complete vs incomplete
   - Architecture overview
   - Status dashboard

3. **testing-framework-handoff.md**
   - Detailed technical handoff
   - Debugging commands
   - File locations

4. **effective-testing-research-2026-01-18.md**
   - Original research findings
   - Why we need this
   - Comparison with other projects

### For Contributors

#### User-Facing Documentation (`docs/`)
1. **COMPREHENSIVE_TESTING.md** ⭐ CONTRIBUTOR GUIDE
   - How to run tests
   - How to write tests
   - Testing philosophy
   - CI/CD integration

2. **PLATFORM_TESTING.md**
   - Platform-specific testing
   - Linux vs Darwin tests
   - Cross-platform patterns

3. **TESTING_GUIDE.md** (existing)
   - Original testing guide
   - Still relevant for unit tests

### Task Management

1. **TESTING_TASKS.md** (root directory)
   - Detailed task breakdown
   - Priorities and estimates
   - Dependencies

---

## Document Purpose Guide

### "I need to fix the blocker"
→ Read: `.claude/README-NEXT-ENGINEER.md`  
→ Then: `.claude/testing-framework-handoff.md`

### "I want to understand why"
→ Read: `.claude/effective-testing-research-2026-01-18.md`

### "I want to add a test"
→ Read: `docs/COMPREHENSIVE_TESTING.md`

### "I need to know what's done"
→ Read: `.claude/testing-implementation-summary.md`

### "I need the task list"
→ Read: `TESTING_TASKS.md`

### "I'm testing on Darwin"
→ Read: `docs/PLATFORM_TESTING.md`

---

## File Tree

```
signal-nix/
├── .claude/
│   ├── README-NEXT-ENGINEER.md           ⭐ Start here (engineers)
│   ├── testing-implementation-summary.md  Status & overview
│   ├── testing-framework-handoff.md       Technical details
│   └── effective-testing-research-2026-01-18.md  Research
│
├── docs/
│   ├── COMPREHENSIVE_TESTING.md           ⭐ Start here (contributors)
│   ├── PLATFORM_TESTING.md                Platform guide
│   └── TESTING_GUIDE.md                   Original guide
│
├── TESTING_TASKS.md                       Task breakdown
│
└── tests/
    ├── activation/                        ← NEEDS FIX
    ├── nixos-vm/                          ← Ready
    ├── nmt/                               ← Infrastructure
    ├── unit/                              ← Working
    ├── integration/                       ← Working
    └── comprehensive-test-suite.nix       ← Working
```

---

## Key Concepts

### Evaluation vs Activation

**Old approach** (evaluation only):
```
Test → Does module evaluate? → Yes → ✅ Pass
User → Applies config → Error → ❌ Fails
```

**New approach** (activation testing):
```
Test → Does module evaluate? → Yes
Test → Does activation build? → Yes
Test → Are files correct? → Yes → ✅ Pass
User → Applies config → Works → ✅ Success
```

### Why This Matters

Previous testing only checked if code was syntactically correct. New testing checks if generated configurations actually work.

**Example**:
- Old: "Does helix module reference colors?" ✅
- New: "Does helix generate correct theme file with exact color values?" ✅

---

## Quick Reference

### Run Tests
```bash
# Fast unit tests
./run-tests.sh --category unit

# Activation tests (blocked)
./run-tests.sh --category activation

# VM tests (may work)
./run-tests.sh --category nixos-vm

# All tests
nix flake check
```

### Debug
```bash
# See the recursion
nix flake check --no-build --show-trace 2>&1 | grep -B 20 "infinite"

# Check one test
nix build .#checks.x86_64-linux.activation-helix-dark --show-trace

# Compare to working tests
diff tests/default.nix tests/activation/default.nix
```

### Fix Pattern
```bash
# 1. Edit tests/activation/default.nix
# 2. Test evaluation
nix flake check --no-build
# 3. Build test
nix build .#checks.x86_64-linux.activation-helix-dark
# 4. Run category
./run-tests.sh --category activation
```

---

## Questions?

1. Check documentation in `.claude/` first
2. Review `docs/COMPREHENSIVE_TESTING.md`
3. Look at Home Manager's test approach
4. Check `docs/MODULE_ARGS_INFINITE_RECURSION.md` (existing doc about this issue)

---

**Status**: Ready for next engineer to fix recursion and complete validation

**Impact**: High - will dramatically improve user experience

**Confidence**: High - infrastructure is solid, just needs bug fix

*Created: 2026-01-18*
