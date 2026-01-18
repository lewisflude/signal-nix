# Preventing Infinite Recursion with _module.args

## The Problem

When using `_module.args` to provide module arguments (like `signalLib`, `signalColors`), placing it inside a conditional `config = lib.mkIf cfg.enable { }` block causes infinite recursion.

## Root Cause

```nix
# ❌ WRONG - Causes infinite recursion
config = lib.mkIf cfg.enable {
  _module.args = {
    signalLib = ...;
    signalColors = signalLib.getColors (signalLib.resolveThemeMode cfg.mode);
  };
};
```

**Why this fails:**
1. A module needs `signalLib` as a function argument
2. Nix evaluates the module to find `signalLib`
3. Since it's not provided externally, Nix queries `_module.args`
4. To evaluate `_module.args`, Nix needs to evaluate `config`
5. To evaluate `config`, Nix needs to check `cfg.enable` condition
6. This creates a circular dependency (infinite loop)

## The Solution

```nix
# ✅ CORRECT - Module args must be unconditional
config = lib.mkMerge [
  # Unconditional config section for _module.args
  {
    _module.args = {
      signalPalette = palette;
      inherit signalLib;
      signalColors = signalLib.getColors (signalLib.resolveThemeMode cfg.mode);
    };
  }

  # Conditional config section
  (lib.mkIf cfg.enable {
    # ... your actual config here
  })
];
```

**Why this works:**
- `_module.args` is inside `config` but **outside** the conditional `lib.mkIf` block
- It's evaluated unconditionally, before any conditional logic
- Arguments are available immediately when modules need them
- No circular dependency is created

## Important Note on Module Structure

The NixOS module system requires a specific structure:
- Top-level attributes must be: `imports`, `options`, or `config`
- `_module.args` is a **config option**, not a top-level attribute
- You cannot place `_module.args` directly at the module's top level like this:

```nix
# ❌ WRONG - This breaks the module system
{
  imports = [...];
  options = {...};
  _module.args = {...};  # ERROR: unsupported attribute
  config = {...};
}
```

The correct approach is to place it inside `config` but unconditionally using `lib.mkMerge`.

## Detection Strategy

To find similar issues:

```bash
# Find any _module.args inside conditional blocks
grep -r "_module.args" modules/ | xargs -I {} grep -B10 {} | grep "lib.mkIf"
```

## Best Practice

**Always declare `_module.args` inside config but outside conditional blocks:**

```nix
{ config, lib, ... }:
let
  cfg = config.theming.signal;
  signalLib = import ../../lib { inherit lib palette nix-colorizer; };
in
{
  # Options
  options.theming.signal = {
    enable = mkEnableOption "Signal Design System";
    # ...
  };

  # Config with unconditional _module.args
  config = lib.mkMerge [
    # Module arguments - ALWAYS UNCONDITIONAL
    {
      _module.args = {
        inherit signalLib;
        signalColors = signalLib.getColors cfg.mode;
      };
    }

    # Conditional config
    (lib.mkIf cfg.enable {
      # ...
    })
  ];
}
```

## Error Message to Watch For

```
error: infinite recursion encountered
...
… while evaluating the module argument `signalLib' in "/path/to/module.nix":

… noting that argument `signalLib` is not externally provided, so querying `_module.args` instead, requiring `config`

… if you get an infinite recursion here, you probably reference `config` in `imports`.
```

This error indicates that:
1. A module needs an argument (e.g., `signalLib`)
2. That argument is provided via `_module.args`
3. But `_module.args` depends on `config` evaluation that's conditional

## Related NixOS Documentation

- [Module Arguments](https://nixos.org/manual/nixos/stable/#sec-module-arguments)
- [Module System](https://nixos.org/manual/nixos/stable/#sec-writing-modules)

## Applied Fixes

This issue was fixed in:
- `modules/common/default.nix` (commit: e1009d0, fixed in follow-up)
- `modules/nixos/common/default.nix` (commit: e1009d0, fixed in follow-up)

Date: 2026-01-18
