# mkDefault Guide: Preventing Configuration Conflicts

## The Problem

When Signal modules set configuration values directly, they can conflict with users' own configurations. This causes build errors like:

```
error: The option `programs.swaylock.settings.indicator-radius' has conflicting definition values:
- In user config: 110
- In signal-nix: 100
```

## The Solution: lib.mkDefault

All Signal modules **MUST** wrap configuration values with `lib.mkDefault`. This gives Signal's values the lowest priority, allowing users to override them.

## How to Use mkDefault

### 1. Import mkDefault

```nix
let
  inherit (lib) mkIf mkDefault;  # Add mkDefault here
```

### 2. Wrap ALL Configuration Values

```nix
# ❌ WRONG - Direct assignment causes conflicts
programs.mpv.config = {
  osd-color = colors.text-primary.hex;
  osd-bar-h = 2;
  show-failed-attempts = true;
};

# ✅ CORRECT - mkDefault allows user overrides
programs.mpv.config = {
  osd-color = mkDefault colors.text-primary.hex;
  osd-bar-h = mkDefault 2;
  show-failed-attempts = mkDefault true;
};
```

### 3. Wrap Nested Values Too

```nix
# ❌ WRONG
programs.foot.settings = {
  colors = {
    background = toFootColor colors.surface-base;
    foreground = toFootColor colors.text-primary;
  };
};

# ✅ CORRECT
programs.foot.settings = {
  colors = {
    background = mkDefault (toFootColor colors.surface-base);
    foreground = mkDefault (toFootColor colors.text-primary);
  };
};
```

## Priority Levels in NixOS

NixOS has a priority system for merging definitions:

1. **mkForce (highest)** - Forces a value, overriding everything
2. **Normal** - Standard priority, conflicts if multiple definitions exist
3. **mkDefault (lowest)** - Provides defaults that can be overridden

Signal modules use **mkDefault** because we provide sensible defaults that users should be able to override.

## When to Use Each

| Priority | Use Case | Example |
|----------|----------|---------|
| `mkForce` | Override system defaults forcefully | Security settings, system-critical config |
| Normal | User's own configuration | User's personal preferences |
| `mkDefault` | Library/module defaults | Signal theming, framework defaults |

## Why This Matters

### Without mkDefault
```nix
# signal-nix sets: indicator-radius = 100;
# User sets:       indicator-radius = 110;
# Result: ERROR - conflicting definitions!
```

### With mkDefault
```nix
# signal-nix sets: indicator-radius = mkDefault 100;
# User sets:       indicator-radius = 110;
# Result: SUCCESS - user's value (110) wins!
```

## Checklist for New Modules

When creating or reviewing a module:

- [ ] `mkDefault` is imported in the `let` block
- [ ] ALL `programs.<app>.settings` values use `mkDefault`
- [ ] ALL `programs.<app>.config` values use `mkDefault`
- [ ] Nested attrset values also use `mkDefault`
- [ ] Numbers, booleans, and strings all use `mkDefault`
- [ ] Template examples show proper `mkDefault` usage

## Testing

Test that your module allows user overrides:

```nix
# In your test config
theming.signal = {
  enable = true;
  monitors.mangohud.enable = true;
};

# User's override
programs.mangohud.settings.background_alpha = "0.9";

# Build should succeed, using user's value (0.9) not Signal's (0.8)
```

## Common Mistakes

### ❌ Forgetting mkDefault entirely
```nix
programs.app.settings = {
  color = colors.text-primary.hex;  # Will conflict!
};
```

### ❌ Using mkDefault on attrset instead of values
```nix
programs.app.settings = mkDefault {  # Wrong place!
  color = colors.text-primary.hex;
};
```

### ❌ Inconsistent usage
```nix
programs.app.settings = {
  color = mkDefault colors.text-primary.hex;  # Good
  size = 12;                                   # Bad - missing mkDefault
};
```

### ✅ Correct usage
```nix
programs.app.settings = {
  color = mkDefault colors.text-primary.hex;
  size = mkDefault 12;
  enabled = mkDefault true;
};
```

## Related Resources

- [NixOS Manual: Module System](https://nixos.org/manual/nixos/stable/#sec-module-system)
- [Nixpkgs Manual: mkDefault](https://nixos.org/manual/nixpkgs/stable/#function-library-lib.modules.mkDefault)
- [Signal Templates](../templates/) - All use mkDefault correctly
