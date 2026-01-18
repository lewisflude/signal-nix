# Stylix Targets System Research

**Research Date:** 2026-01-18  
**Task:** Adopt Stylix-style targets system for Signal-nix architecture improvements  
**Reference:** [Stylix Repository](https://github.com/danth/stylix)

## Overview

Stylix uses a sophisticated **targets system** that separates template rendering from module logic. This provides:

1. **Cleaner separation of concerns** - configuration logic separate from option definitions
2. **Automatic safeguarding** - prevents accessing disabled options 
3. **Reduced boilerplate** - `mkTarget` helper function handles common patterns
4. **Better contributor experience** - consistent structure across all modules

## Key Components

### 1. `mkTarget` Function (`stylix/mk-target.nix`)

The core abstraction that creates a consistent target interface:

```nix
{ mkTarget, ... }:
mkTarget {
  config = [
    ({ colors }: {
      programs.example.theme.background = colors.base00;
    })
    
    ({ fonts }: {
      programs.example.font.name = fonts.monospace.name;
    })
  ];
}
```

**Key Features:**
- Accepts `config` as a list of functions or attribute sets
- Each function can request specific dependencies (`colors`, `fonts`, `opacity`, etc.)
- Automatically guards against accessing disabled options
- Creates `stylix.targets.${name}.enable` option automatically
- Supports `autoEnable` logic for smart defaults

### 2. Automatic Module Loading (`stylix/autoload.nix`)

Discovers and loads modules automatically:

- Scans `/modules/` directory for application targets
- Detects if a module uses `mkTarget` by checking function arguments
- Injects `mkTarget` as a special argument to modules that need it
- Handles both `nixos` and `hm` (home-manager) platforms

```nix
# Directory structure:
modules/
  alacritty/
    hm.nix       # Home Manager target
    nixos.nix    # NixOS target (if applicable)
  bat/
    hm.nix
  # ... etc
```

### 3. Target Options (`stylix/target.nix`)

Defines the core target system options:

- `stylix.enable` - Master switch for all theming
- `stylix.autoEnable` - Whether to enable targets by default
- `stylix.targets.${name}.enable` - Per-application enable option
- Helper functions like `mkEnableTarget`, `mkEnableTargetWith`

### 4. Safeguarded Access

The system automatically prevents accessing `config.stylix.*` directly in target modules, forcing you to request only what you need through function arguments:

```nix
# ❌ BAD - Direct access (throws error):
{ config, ... }: {
  programs.example.color = config.stylix.colors.base00;
}

# ✅ GOOD - Request specific dependencies:
{ colors }: {
  programs.example.color = colors.base00;
}
```

## Example: Alacritty Module

```nix
{ mkTarget, ... }:
mkTarget {
  config = [
    # Colors configuration
    ({ colors }: {
      programs.alacritty.settings.colors = with colors.withHashtag; {
        primary = {
          foreground = base05;
          background = base00;
        };
        # ... more color config
      };
    })
    
    # Fonts configuration (separate concern)
    ({ fonts }: {
      programs.alacritty.settings.font = {
        normal.family = fonts.monospace.name;
        size = fonts.sizes.terminal;
      };
    })
    
    # Opacity configuration (separate concern)
    ({ opacity }: {
      programs.alacritty.settings.window.opacity = opacity.terminal;
    })
  ];
}
```

## Benefits for Signal-nix

### Current State
Our modules currently mix concerns:

```nix
# modules/terminals/alacritty.nix (current approach)
{ config, lib, pkgs, ... }:
let
  cfg = config.signal;
in {
  options.signal.alacritty.enable = ...;
  
  config = lib.mkIf (cfg.enable && cfg.alacritty.enable) {
    # Colors, fonts, and other config all mixed together
    programs.alacritty.settings = {
      colors = { ... };
      font = { ... };
    };
  };
}
```

### With Targets System

```nix
# modules/terminals/alacritty.nix (with targets)
{ mkTarget, ... }:
mkTarget {
  config = [
    ({ colors }: { /* color config */ })
    ({ fonts }: { /* font config */ })
    ({ spacing }: { /* spacing config */ })
  ];
}
```

**Advantages:**
1. **Clarity** - Each configuration concern is isolated
2. **Safety** - Can't accidentally access undefined options
3. **Testability** - Each function can be tested independently
4. **Composability** - Easy to see what dependencies each target needs
5. **Consistency** - All modules follow the same pattern

## Implementation Recommendations

### Phase 1: Infrastructure Setup

1. **Create `lib/mkTarget.nix`**
   - Adapt Stylix's `mk-target.nix` for Signal's color system
   - Support `colors`, `fonts`, `spacing` arguments
   - Handle `signal.targets.${name}.enable` options
   - Implement auto-enable logic

2. **Create `lib/autoload.nix`**
   - Scan `modules/` directory
   - Detect and inject `mkTarget` function
   - Support both Home Manager and NixOS modules

3. **Update `lib/default.nix`**
   - Export target system helpers
   - Add `signal.targets` namespace
   - Add `signal.autoEnable` option

### Phase 2: Module Migration

Migrate modules in priority order:

1. **Terminals** (alacritty, foot, kitty, wezterm, warp)
2. **Editors** (neovim, helix, emacs, vim, vscode)
3. **CLI tools** (bat, delta, fzf, etc.)
4. **Desktop** (hyprland, sway, waybar, etc.)
5. **Browsers** (firefox, chromium)

### Phase 3: Testing & Documentation

1. Update test suite to verify target system
2. Add contributor guide for creating new targets
3. Update examples to use new targets
4. Create migration guide for users

## Technical Considerations

### Color System Differences

Stylix uses Base16 color scheme with `colors.base00` through `colors.base0F`.

Signal uses OKLCH with a more structured palette:
- `colors.brand.*` - Brand colors
- `colors.neutral.*` - Neutrals
- `colors.accent.*` - Accent colors
- `colors.semantic.*` - Semantic colors (success, warning, error)

**Adaptation needed:** Ensure `mkTarget` passes Signal's color structure, not Base16.

### Existing Patterns to Preserve

Signal has some unique features that should be maintained:

1. **Brand colors** - Primary/secondary/tertiary system
2. **Semantic colors** - Success/warning/error mapping
3. **Spacing system** - Base spacing multipliers
4. **Typography scales** - Font size scales

### Migration Strategy

**Option A: Big Bang**
- Rewrite all modules at once
- Requires feature freeze
- High risk, high coordination

**Option B: Incremental (Recommended)**
- Support both old and new systems temporarily
- Migrate module categories one at a time
- Test thoroughly between migrations
- Remove old system after all modules migrated

## Open Questions

1. **Backwards compatibility**: Should we maintain API compatibility during migration?
2. **Testing approach**: How to test targets in isolation?
3. **Documentation**: What level of detail for contributor docs?
4. **Timeline**: How aggressive should the migration be?

## Next Steps

1. ✅ Research Stylix architecture (completed)
2. ⬜ Create proof-of-concept `mkTarget` implementation
3. ⬜ Migrate one simple module (e.g., `bat`) as test case
4. ⬜ Evaluate ergonomics and adjust approach
5. ⬜ Create migration plan with timeline
6. ⬜ Write contributor documentation

## Related Files

- `.github/TODO.md` - Task tracking
- `docs/architecture.md` - Architecture documentation
- `lib/default.nix` - Library functions
- `lib/mkModule.nix` - Current module helper

## References

- [Stylix Repository](https://github.com/danth/stylix)
- [Stylix mk-target.nix](https://github.com/danth/stylix/blob/main/stylix/mk-target.nix)
- [nix-colors](https://github.com/Misterio77/nix-colors) - Simpler ports library approach
