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
5. To evaluate `config`, Nix needs to evaluate the module
6. The module needs `signalLib` → back to step 1 (infinite loop)

## The Solution

```nix
# ✅ CORRECT - Module args must be unconditional
_module.args = {
  signalPalette = palette;
  inherit signalLib;
  signalColors = signalLib.getColors (signalLib.resolveThemeMode cfg.mode);
};

config = lib.mkIf cfg.enable {
  # ... your actual config here
};
```

**Why this works:**
- `_module.args` is evaluated before any module evaluation
- It doesn't depend on `config` evaluation
- Arguments are available immediately when modules need them

## Detection Strategy

To find similar issues:

```bash
# Find any _module.args inside config blocks
grep -r "_module.args" modules/ | grep -B5 "config = lib.mkIf"
```

## Best Practice

**Always declare `_module.args` at the top level of your module**, outside any conditional blocks:

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

  # Module arguments - ALWAYS UNCONDITIONAL
  _module.args = {
    inherit signalLib;
    signalColors = signalLib.getColors cfg.mode;
  };

  # Config - Can be conditional
  config = lib.mkIf cfg.enable {
    # ...
  };
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
3. But `_module.args` depends on `config` (directly or indirectly)

## Related NixOS Documentation

- [Module Arguments](https://nixos.org/manual/nixos/stable/#sec-module-arguments)
- [Module System](https://nixos.org/manual/nixos/stable/#sec-writing-modules)

## Applied Fixes

This issue was fixed in:
- `modules/common/default.nix` (commit: TBD)
- `modules/nixos/common/default.nix` (commit: TBD)

Date: 2026-01-18
