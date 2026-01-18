# Module Development Checklist

Use this checklist when creating or modifying NixOS/Home Manager modules to avoid common pitfalls.

## Module Structure Requirements

### ✅ Top-Level Structure
- [ ] Module has only these top-level attributes: `imports`, `options`, `config`
- [ ] No other attributes at top level (no `_module`, `lib`, etc.)
- [ ] All configuration is inside `config = { }`

### ✅ _module.args Placement (Critical!)

If your module provides arguments to other modules via `_module.args`:

- [ ] `_module.args` is inside `config`, not at top level
- [ ] `_module.args` is **unconditional** (not inside `lib.mkIf cfg.enable`)
- [ ] Uses `lib.mkMerge` to separate unconditional and conditional config

**Correct pattern:**
```nix
{
  options = { ... };
  
  config = lib.mkMerge [
    # Unconditional - _module.args available immediately
    {
      _module.args = {
        myLib = ...;
        myColors = ...;
      };
    }
    
    # Conditional - only when enabled
    (lib.mkIf cfg.enable {
      # Your config here
    })
  ];
}
```

**Wrong patterns:**
```nix
# ❌ At top level - causes "unsupported attribute" error
{
  options = { ... };
  _module.args = { ... };  # WRONG!
  config = { ... };
}

# ❌ Inside conditional - causes infinite recursion
config = lib.mkIf cfg.enable {
  _module.args = { ... };  # WRONG!
};
```

### ✅ Options Definition
- [ ] All options have `type` specified
- [ ] All options have `description` or `example`
- [ ] Use `mkEnableOption` for boolean enable flags
- [ ] Enum options use `types.enum` with explicit values
- [ ] Default values are sensible and documented

### ✅ Config Section
- [ ] Uses `lib.mkIf` for conditional configuration
- [ ] Config only activates when module is explicitly enabled
- [ ] No side effects when module is disabled

### ✅ Dependencies
- [ ] Lists all required packages in `config.home.packages` or `config.environment.systemPackages`
- [ ] External arguments (like `pkgs`) are in function signature
- [ ] Module can be evaluated without errors when disabled

## Testing Requirements

### ✅ Pre-Commit
- [ ] Module passes `nix-instantiate --parse` (syntax check)
- [ ] Module passes `nixfmt --check` (formatting)
- [ ] Pre-commit hook doesn't show warnings

### ✅ Flake Checks
- [ ] `nix flake check` passes all tests
- [ ] Module evaluation tests pass (see `tests/module-structure-test.nix`)
- [ ] Module-specific tests added if complex

### ✅ Manual Testing
- [ ] Module can be imported in a minimal config
- [ ] Module works with `enable = true`
- [ ] Module has no effect with `enable = false`
- [ ] Module works with other Signal modules enabled
- [ ] Module args (if provided) are accessible to other modules

## Documentation Requirements

### ✅ Code Comments
- [ ] Complex logic has explanatory comments
- [ ] Non-obvious defaults are explained
- [ ] References to related issues/docs included

### ✅ Examples
- [ ] Basic usage example in module comments or separate example file
- [ ] Advanced usage documented if applicable
- [ ] Example in `examples/` directory updated if relevant

### ✅ CHANGELOG
- [ ] Change added to `CHANGELOG.md` under "Unreleased"
- [ ] Breaking changes clearly marked
- [ ] Migration guide provided for breaking changes

## Common Pitfalls Checklist

- [ ] ❌ No `_module.args` at top level
- [ ] ❌ No `_module.args` inside `lib.mkIf cfg.enable`
- [ ] ❌ No hardcoded paths (use `${pkgs.package}` instead)
- [ ] ❌ No references to `config.theming.signal.mode` inside `_module.args`
- [ ] ❌ No infinite recursion (test by importing module)
- [ ] ❌ No evaluation errors when disabled
- [ ] ❌ No missing package dependencies

## Before Committing

Run these commands:

```bash
# Format code
nix fmt

# Check syntax and structure (runs automatically via git hook)
git add modules/your-module.nix
git commit  # Pre-commit hook will validate

# Run full test suite
nix flake check

# Test module evaluation specifically
nix eval .#homeManagerModules.default --apply 'x: "success"'
nix eval .#nixosModules.default --apply 'x: "success"'

# Build an example configuration
nix build .#checks.x86_64-linux.structure-hm-basic
```

## After Committing

- [ ] Push to feature branch
- [ ] Open PR with description of changes
- [ ] Verify CI passes on GitHub
- [ ] Request review if unsure about module structure

## References

- [NixOS Module System](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
- [Module Arguments](https://nixos.org/manual/nixos/stable/#sec-module-arguments)
- [docs/MODULE_ARGS_INFINITE_RECURSION.md](../docs/MODULE_ARGS_INFINITE_RECURSION.md)
- [.claude/module-args-fix-2026-01-18.md](../.claude/module-args-fix-2026-01-18.md)

## Getting Help

If you're unsure about module structure:
1. Check existing modules for patterns
2. Read `docs/MODULE_ARGS_INFINITE_RECURSION.md`
3. Run `nix flake check` to catch issues early
4. Ask in PR review or discussions
