# Finding and Preventing Module Argument Infinite Recursion Errors

This guide helps you find and fix similar `_module.args` infinite recursion errors in NixOS/Home Manager modules.

## Quick Reference

**Problem Pattern:**
```nix
config = lib.mkIf cfg.enable {
  _module.args = { ... };  # ❌ WRONG - causes infinite recursion
}
```

**Solution Pattern:**
```nix
_module.args = { ... };  # ✅ CORRECT - at top level

config = lib.mkIf cfg.enable {
  # actual config here
};
```

## Detection Methods

### Method 1: Automated Check (Recommended)

We've added a flake check that automatically detects this issue:

```bash
nix build .#checks.x86_64-linux.module-args-placement
```

This check verifies that `_module.args` is not placed inside `config = lib.mkIf` blocks.

### Method 2: Manual Search

Search for the problematic pattern in your codebase:

```bash
# Find files with _module.args
grep -r "_module.args" modules/

# Check if any are inside config blocks
for file in $(grep -l "_module.args" modules/**/*.nix); do
  echo "Checking: $file"
  # Look for _module.args that comes after "config = lib.mkIf"
  if grep -B 10 "_module.args" "$file" | grep -q "config = lib.mkIf"; then
    echo "  ⚠️  POTENTIAL ISSUE: _module.args may be inside config block"
  else
    echo "  ✓ Looks OK"
  fi
done
```

### Method 3: Look for the Error Message

When users report errors, look for these key phrases:

```
error: infinite recursion encountered

… while evaluating the module argument `signalLib' in "..."

… noting that argument `signalLib` is not externally provided, 
so querying `_module.args` instead, requiring `config`
```

## Understanding the Error

### Why Does This Happen?

The NixOS module system evaluates modules in this order:

1. **Module structure parsing** - Identifies `options`, `config`, `imports`
2. **Argument resolution** - Resolves function arguments (like `signalLib`)
3. **Option evaluation** - Evaluates option values
4. **Config merging** - Merges all configs together

When `_module.args` is inside a conditional `config` block:

```
Module needs signalLib → Check _module.args → Evaluate config → Evaluate module → Needs signalLib (loop!)
```

When `_module.args` is at top level:

```
Module needs signalLib → Check _module.args → Found! → Continue evaluation ✓
```

### What Makes It Conditional?

Any of these patterns make `_module.args` conditional:

```nix
# Pattern 1: Inside mkIf
config = lib.mkIf condition {
  _module.args = { ... };  # ❌
}

# Pattern 2: Inside mkMerge
config = lib.mkMerge [
  {
    _module.args = { ... };  # ❌
  }
]

# Pattern 3: Inside optionalAttrs
config = lib.optionalAttrs condition {
  _module.args = { ... };  # ❌
}
```

## Step-by-Step Fix

### 1. Identify the Problem

```nix
# BEFORE (broken)
{
  config,
  lib,
  ...
}:
let
  cfg = config.theming.signal;
  signalLib = ...;
in
{
  options.theming.signal = { ... };

  config = lib.mkIf cfg.enable {
    _module.args = {
      inherit signalLib;
      signalColors = signalLib.getColors cfg.mode;
    };
    
    # other config...
  };
}
```

### 2. Extract _module.args

Move `_module.args` to the top level (same level as `options` and `config`):

```nix
# AFTER (fixed)
{
  config,
  lib,
  ...
}:
let
  cfg = config.theming.signal;
  signalLib = ...;
in
{
  options.theming.signal = { ... };

  # Module arguments are ALWAYS available unconditionally
  _module.args = {
    inherit signalLib;
    signalColors = signalLib.getColors cfg.mode;
  };

  config = lib.mkIf cfg.enable {
    # other config...
  };
}
```

### 3. Verify the Fix

```bash
# Test locally
nix flake check

# Test the specific check
nix build .#checks.x86_64-linux.module-args-placement
```

## Related Issues to Check

When fixing this issue, also verify:

### 1. Lazy Evaluation Dependencies

```nix
# If your _module.args depends on config:
_module.args = {
  # This is OK - cfg is evaluated lazily
  signalColors = signalLib.getColors cfg.mode;
};
```

The key insight: `cfg.mode` is evaluated **lazily** - it's not evaluated until something actually uses `signalColors`. This is fine because by that time, `config` is fully evaluated.

### 2. Import Cycles

Make sure you don't have circular imports:

```nix
# module-a.nix
imports = [ ./module-b.nix ];

# module-b.nix  
imports = [ ./module-a.nix ];  # ❌ Circular import
```

### 3. Other Module System Features

These should also stay at top level:
- `_module.args`
- `options`
- `imports`

These can be conditional:
- `config`
- `assertions`
- `warnings`

## Testing Your Fix

### Local Test

```bash
# Build a test configuration
nix build --expr '
  let
    pkgs = import <nixpkgs> {};
  in
    pkgs.nixos {
      imports = [ ./modules/nixos/common ];
      theming.signal.nixos.enable = true;
    }
'
```

### Integration Test

Create a minimal reproduction case:

```nix
# test-infinite-recursion.nix
{
  pkgs ? import <nixpkgs> {},
  system ? builtins.currentSystem,
}:
let
  testConfig = {
    imports = [ ./modules/common ];
    theming.signal = {
      enable = true;
      terminals.kitty.enable = true;
    };
    programs.kitty.enable = true;
  };
in
pkgs.nixos testConfig
```

Run it:
```bash
nix-build test-infinite-recursion.nix
```

## Prevention Checklist

When creating new modules:

- [ ] `_module.args` is at top level
- [ ] Not inside `config = lib.mkIf`
- [ ] Not inside `lib.mkMerge`
- [ ] Not inside `lib.optionalAttrs`
- [ ] Tested with `nix flake check`
- [ ] Added to the module-args-placement check if it's a core module

## Real-World Example

This was the actual fix applied to signal-nix on 2026-01-18:

**Files Fixed:**
- `modules/common/default.nix`
- `modules/nixos/common/default.nix`

**Error Reported:**
```
error: infinite recursion encountered
… while evaluating the module argument `signalLib' in 
   "/nix/store/.../modules/terminals/kitty.nix"
```

**Root Cause:**
Both common modules had `_module.args` inside `config = lib.mkIf cfg.enable { }` blocks.

**Solution:**
Moved `_module.args` to top level with clear comment:
```nix
# Make palette and lib available to all modules UNCONDITIONALLY
# This prevents infinite recursion when modules reference these in their arguments
# See: https://nixos.org/manual/nixos/stable/#sec-module-arguments
_module.args = {
  signalPalette = palette;
  inherit signalLib;
  signalColors = signalLib.getColors (signalLib.resolveThemeMode cfg.mode);
};
```

## Further Reading

- [NixOS Module System Documentation](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
- [Module Arguments](https://nixos.org/manual/nixos/stable/#sec-module-arguments)
- [docs/MODULE_ARGS_INFINITE_RECURSION.md](./MODULE_ARGS_INFINITE_RECURSION.md) - Detailed explanation
