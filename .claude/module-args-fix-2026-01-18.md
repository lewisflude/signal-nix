# Module Args Placement Fix (2026-01-18)

## Problem

Users experienced this error after updating to commit `e1009d0`:

```
error: Module ':anon-2:anon-1:anon-592' has an unsupported attribute `_module'. 
This is caused by introducing a top-level `config' or `options' attribute. 
Add configuration attributes immediately on the top level instead, or move all 
of them (namely: _module) into the explicit `config' attribute.
```

## Root Cause

Commit `e1009d0` attempted to fix an infinite recursion issue by moving `_module.args` 
to the top level of the module:

```nix
{
  imports = [...];
  options = {...};
  _module.args = {...};  # ❌ WRONG - breaks module system
  config = lib.mkIf cfg.enable {...};
}
```

However, this violates the NixOS module system structure requirements:
- Top-level attributes must be: `imports`, `options`, or `config`
- `_module.args` is a **config option**, not a top-level attribute
- Placing it at the top level creates the "unsupported attribute" error

## The Correct Solution

The fix uses `lib.mkMerge` to keep `_module.args` inside `config` but **outside** 
the conditional block:

```nix
{
  imports = [...];
  options = {...};
  
  config = lib.mkMerge [
    # Unconditional section for _module.args
    {
      _module.args = {
        signalPalette = palette;
        inherit signalLib;
        signalColors = signalLib.getColors (signalLib.resolveThemeMode cfg.mode);
      };
    }
    
    # Conditional section for the rest
    (lib.mkIf cfg.enable {
      # ... rest of config
    })
  ];
}
```

### Why This Works

1. **Prevents infinite recursion**: `_module.args` is evaluated unconditionally, 
   so there's no circular dependency when modules request these arguments
2. **Follows module system structure**: `_module.args` is inside `config`, 
   which is a valid top-level attribute
3. **Maintains conditionals**: The main configuration remains conditional 
   on `cfg.enable`

## Changes Made

### Files Modified
- `modules/common/default.nix`: Moved `_module.args` inside `config` using `mkMerge`
- `modules/nixos/common/default.nix`: Same change for NixOS modules
- `flake.nix`: Updated check to verify `_module.args` is outside conditional blocks
- `docs/MODULE_ARGS_INFINITE_RECURSION.md`: Updated with correct solution

### Commit
- Hash: `e39eda4`
- Fixes: `e1009d0`

## Testing

All checks pass:
```bash
$ nix flake check
✅ All 76 checks passed

$ nix eval .#homeManagerModules.default --apply 'x: "success"'
"success"

$ nix eval .#nixosModules.default --apply 'x: "success"'
"success"
```

## Key Takeaway

When providing module arguments via `_module.args`:
1. ✅ Place it inside `config`
2. ✅ Keep it unconditional (use `lib.mkMerge`)
3. ❌ Don't place it at the top level of the module
4. ❌ Don't place it inside conditional blocks (`lib.mkIf`)

This pattern satisfies both requirements:
- Module system structure (inside `config`)
- Infinite recursion prevention (unconditional evaluation)

## References

- [NixOS Module Arguments](https://nixos.org/manual/nixos/stable/#sec-module-arguments)
- [Module System Structure](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
- `docs/MODULE_ARGS_INFINITE_RECURSION.md` (updated documentation)
