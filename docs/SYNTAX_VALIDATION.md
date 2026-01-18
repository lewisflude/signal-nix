# Preventing Syntax Errors - Tooling Guide

This document explains the layers of protection against syntax errors in the Signal codebase.

## Problem

A typo like `|}:` instead of `}:` can break the entire build for all users. We need multiple layers of validation to catch these errors before they reach production.

## Solution: Defense in Depth

We use multiple layers of validation, each catching errors at different stages:

### Layer 1: Editor Integration (Immediate Feedback)

**Tools:**
- Nix Language Server (`nil`) - Real-time syntax checking
- EditorConfig - Consistent formatting rules
- Format on save - Auto-formatting

**Setup:**
```bash
# Using VS Code/Cursor (automatic with .vscode/settings.json)
# Install recommended extension: jnoortheen.nix-ide

# Using Helix (add to config)
[language-server.nil]
command = "nil"

# Using Neovim (use nvim-lspconfig)
require('lspconfig').nil_ls.setup{}
```

**Benefits:**
- ✅ Instant feedback while typing
- ✅ Syntax errors highlighted in red
- ✅ Auto-formatting on save
- ✅ Zero overhead - happens automatically

### Layer 2: Pre-commit Hooks (Before Commit)

**Tool:** `.githooks/pre-commit`

**What it does:**
```bash
# For each staged .nix file:
nix-instantiate --parse <file>
```

**Setup:**
```bash
# One-time configuration
git config core.hooksPath .githooks
```

**Benefits:**
- ✅ Catches syntax errors before they're committed
- ✅ Fast - only checks changed files
- ✅ Blocks bad commits locally
- ✅ Saves CI time and embarrassment

**Example output:**
```
🔍 Running pre-commit checks...
📝 Checking Nix files for syntax errors...
  Checking modules/terminals/kitty.nix...
❌ Syntax error in modules/terminals/kitty.nix
error: syntax error, unexpected invalid token, expecting '}'
at modules/terminals/kitty.nix:7:1:
    6|   ...
    7| |}:
     | ^
❌ Found 1 file(s) with syntax errors
   Fix the errors above and try again
```

### Layer 3: CI/CD Pipeline (Before Merge)

**Workflows:** `.github/workflows/`

**What they check:**
1. **flake-check.yml** - `nix flake check --all-systems`
   - Validates all Nix code evaluates correctly
   - Tests on Linux and macOS
   - Checks all platforms (x86_64, aarch64)

2. **format-check.yml** - Code quality
   - `nix fmt --check` - Formatting validation
   - `statix check` - Nix linting
   - `deadnix --fail` - Dead code detection

3. **test-suite.yml** - Functional tests
   - Evaluates all modules
   - Tests examples
   - Validates configuration

**Benefits:**
- ✅ Catches issues that pass local checks
- ✅ Tests on multiple platforms
- ✅ Validates entire system integration
- ✅ Required before PR merge

### Layer 4: Manual Testing (Optional)

**Commands:**
```bash
# Quick syntax check
nix-instantiate --parse modules/terminals/kitty.nix

# Full evaluation check
nix eval .#homeManagerModules.default

# Complete validation
nix flake check --show-trace

# Test specific module
nix eval --expr '
  let
    flake = builtins.getFlake (toString ./.);
  in
    flake.homeManagerModules.default
'
```

**Benefits:**
- ✅ Deep validation before pushing
- ✅ Useful for complex changes
- ✅ Catches integration issues

## Recommended Workflow

### For Regular Development

1. **Write code** with editor integration (auto-checking)
2. **Stage changes** `git add`
3. **Commit** - pre-commit hook validates automatically
4. **Push** - CI validates before merge

### For Large Refactors

1. **Write code** with editor integration
2. **Run manual checks** `nix flake check`
3. **Stage and commit** - pre-commit validates
4. **Test examples** `nix build .#examples.basic`
5. **Push** - CI validates

## Quick Setup (New Contributors)

```bash
# 1. Enter development environment
nix develop

# 2. Configure git hooks
git config core.hooksPath .githooks

# 3. Verify hooks work
.githooks/pre-commit

# 4. Start coding!
# Your editor should now provide real-time feedback
```

## Bypassing Validation (Emergency Only)

```bash
# Skip pre-commit hook (not recommended)
git commit --no-verify -m "emergency fix"

# Skip CI checks (requires admin, very not recommended)
# Don't do this - fix the issue instead
```

## Tools Summary

| Tool | When | Speed | Catches |
|------|------|-------|---------|
| Editor LSP | While typing | Instant | Syntax, basic errors |
| Pre-commit hook | Before commit | <1s | Syntax, parse errors |
| CI - Format | Before merge | ~30s | Formatting, style |
| CI - Flake check | Before merge | ~2m | Evaluation, build |
| CI - Tests | Before merge | ~5m | Logic, integration |

## Troubleshooting

### Editor not showing errors

**Check LSP is running:**
```bash
# In editor, check for language server status
# VS Code: Click "Nix" in status bar
# Helix: :lsp-status
# Neovim: :LspInfo
```

**Fix:**
```bash
# Ensure nil is available
nix develop
which nil
# Should output: /nix/store/.../bin/nil
```

### Pre-commit hook not running

**Check configuration:**
```bash
git config core.hooksPath
# Should output: .githooks

# Verify hook is executable
ls -la .githooks/pre-commit
# Should show: -rwxr-xr-x

# Make executable if needed
chmod +x .githooks/pre-commit
```

### CI failing but local checks pass

**Possible causes:**
1. Platform-specific issue (test on different system)
2. Flake inputs changed (run `nix flake update`)
3. Cached evaluation (clear with `nix-collect-garbage`)

**Debug:**
```bash
# Run exact CI command locally
nix flake check --all-systems --show-trace

# Check specific platform
nix flake check --system x86_64-linux
```

## Best Practices

1. **Don't skip hooks** - They exist for a reason
2. **Fix errors immediately** - Don't let them accumulate
3. **Test locally first** - Don't rely solely on CI
4. **Read error messages** - They usually tell you exactly what's wrong
5. **Use format on save** - Prevents formatting CI failures

## Cost Analysis

**Without tooling:**
- Developer makes typo
- Pushes to GitHub
- CI fails after 5 minutes
- Fixes typo, pushes again
- CI runs again, 5 more minutes
- **Total time wasted: 10+ minutes + context switching**

**With tooling:**
- Developer makes typo
- Pre-commit hook catches it in <1 second
- Developer fixes immediately
- Commits successfully
- **Total time: <10 seconds, no context switch**

**For a team:**
- Saves hours per week
- Reduces CI costs
- Improves code quality
- Faster feedback loop

## References

- [Pre-commit hooks documentation](.githooks/README.md)
- [Contributing guide](../CONTRIBUTING.md)
- [CI/CD workflows](../.github/workflows/)
- [Editor integration](../.vscode/settings.json)
