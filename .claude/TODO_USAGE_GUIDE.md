# TODO Documentation Usage Guide

**Audience:** Contributors, maintainers, and anyone working with signal-nix TODO tracking  
**Last Updated:** 2026-01-18

## Overview

The signal-nix project has comprehensive TODO tracking across multiple documents. This guide helps you navigate and use them effectively.

## Document Structure

```
signal-nix/
├── .github/
│   └── TODO.md                    # Main project roadmap
├── COLOR_THEME_TODO.md            # Color theme implementation tracking
├── docs/
│   ├── integration-standards.md   # Application integration roadmap
│   └── color-theme-research.md    # Complete theming reference (1260 lines)
└── .claude/
    ├── todo-enhancement-summary.md           # Enhancement summary
    ├── TODO_USAGE_GUIDE.md                   # This file
    ├── ghostty-implementation-research.md    # Implementation case study
    └── gtk-theming-docs-research.md          # GTK theming reference
```

## When to Use Each Document

### `.github/TODO.md` - Main Project Roadmap
**Use when:**
- Planning project-wide improvements
- Tracking maintenance tasks (weekly, monthly, quarterly)
- Managing releases and community engagement
- Considering architecture improvements

**Contains:**
- Active tasks (high/medium/low priority)
- Maintenance schedule
- Release process
- Architecture improvements (Stylix targets, ports library, nix-unit)
- Developer experience enhancements
- Community building initiatives

**Best for:**
- Project maintainers
- Long-term planning
- Architecture decisions

### `COLOR_THEME_TODO.md` - Detailed Color Implementation Tracking
**Use when:**
- Adding a new application module
- Looking up color configuration details
- Understanding configuration tiers
- Researching color format requirements

**Contains:**
- Application-by-application breakdown
- Configuration tier classifications
- Upstream documentation links
- Format requirements (hex, RGB, ANSI, etc.)
- Platform compatibility notes
- Implementation complexity assessments
- Infrastructure improvements needed
- Color system design decisions

**Best for:**
- Module implementers
- Color system developers
- Contributors adding new apps

**Priority Levels:**
- **High**: Native HM options, widely used, straightforward
- **Medium**: Config file based, good docs, clear benefit
- **Lower**: External dependencies, complex setup, niche

### `docs/integration-standards.md` - Application Roadmap
**Use when:**
- Checking what's already implemented
- Understanding module organization
- Following the integration workflow
- Seeing the big picture of coverage

**Contains:**
- Completed integrations by category
- Priority classification (0-3)
- Module organization structure
- Integration workflow (research, implement, test, document)
- Metadata requirements for new modules

**Best for:**
- Understanding current state
- Finding gaps in coverage
- Planning next implementations

### `docs/color-theme-research.md` - Complete Theming Reference
**Use when:**
- Implementing a specific application
- Looking for configuration examples
- Understanding upstream options
- Checking format requirements

**Contains:**
- 1260 lines of detailed application theming info
- Configuration examples for 40+ applications
- Upstream documentation links
- Format specifications
- Platform notes
- Summary table of all applications

**Best for:**
- Implementation reference
- Copy-paste examples
- Upstream doc lookup

### `.claude/` Research Documents
**Use when:**
- Deep-diving into specific topics
- Understanding implementation patterns
- Learning from case studies

**Contains:**
- `ghostty-implementation-research.md`: Complete case study of terminal implementation
- `gtk-theming-docs-research.md`: Comprehensive GTK theming guide (45 Adwaita colors)
- `stylix-targets-research.md`: Analysis of Stylix architecture
- `todo-enhancement-summary.md`: Summary of recent TODO enhancements

**Best for:**
- Learning implementation patterns
- Understanding design decisions
- Reference material

## Quick Reference: Finding What You Need

### "How do I implement app X?"

1. Check `COLOR_THEME_TODO.md` for detailed implementation notes
2. Check `docs/color-theme-research.md` for configuration examples
3. Check `docs/integration-standards.md` for priority/status
4. Check `.claude/ghostty-implementation-research.md` for a complete case study

### "What should I work on next?"

1. Check `.github/TODO.md` for high-level priorities
2. Check `COLOR_THEME_TODO.md` High Priority section
3. Check `docs/integration-standards.md` Priority 0 and Priority 1 sections

### "How do I structure a new module?"

1. Read `docs/integration-standards.md` Integration Workflow section
2. Check required metadata format
3. Look at existing modules in `modules/` for examples
4. Reference tier system in `docs/tier-system.md`

### "What color should I use for X?"

1. Check existing modules for patterns
2. See semantic color guidance in `COLOR_THEME_TODO.md` Research & Design section
3. Reference GTK color mapping in `.claude/gtk-theming-docs-research.md`

### "How do I test my changes?"

1. Check `docs/integration-standards.md` Testing Phase section
2. Add test to `tests/comprehensive-test-suite.nix`
3. Run `nix flake check`
4. See testing strategy in `COLOR_THEME_TODO.md` Notes section

## Color Configuration Tiers

Quick reference (detailed in `COLOR_THEME_TODO.md`):

**Tier 1: Preset Selection** - Choose from predefined themes  
Example: htop (schemes 0-6)

**Tier 2: Structured Colors** - Dedicated color structure  
Example: Alacritty (`colors.primary.background`)

**Tier 3: Freeform Settings** - Key-value pairs  
Example: Ghostty, Kitty, Foot

**Tier 4: Config File Generation** - Full config file creation  
Example: Btop++, Zed, WezTerm

**Tier 5: Environment Variables** - Shell variables  
Example: Less (LESS_TERMCAP_*), GitHub CLI (GLAMOUR_STYLE)

## Priority Classification

### High Priority
- Native Home Manager options
- Widely used applications
- Straightforward implementation
- Good upstream documentation

**Examples:** Git Delta, Tig, Tealdeer, MangoHud, Swaylock, MPV

### Medium Priority
- Config file based
- Good documentation available
- Clear user benefit
- Moderate complexity

**Examples:** Btop++, Zed Editor, Glow, Procs, Powerlevel10k

### Lower Priority
- External dependencies required
- Complex setup/maintenance
- Niche use cases
- Limited theming capability

**Examples:** Discord (needs Vencord), Telegram (needs theme builder), Steam (skin files)

## Implementation Workflow

### 1. Research Phase
- [ ] Check `COLOR_THEME_TODO.md` for implementation notes
- [ ] Read `docs/color-theme-research.md` for examples
- [ ] Check upstream documentation
- [ ] Determine configuration tier
- [ ] Identify platform requirements

### 2. Implementation Phase
- [ ] Create module in appropriate category
- [ ] Add required metadata comment
- [ ] Implement color mapping
- [ ] Use `signalLib.shouldThemeApp`
- [ ] Test with example configuration

### 3. Testing Phase
- [ ] Add to `tests/comprehensive-test-suite.nix`
- [ ] Test enable/disable
- [ ] Run `nix flake check`
- [ ] Manual visual testing

### 4. Documentation Phase
- [ ] Update `docs/integration-standards.md` (mark complete)
- [ ] Update `README.md` supported apps list
- [ ] Update `COLOR_THEME_TODO.md` (mark complete)
- [ ] Add example if needed

## Common Patterns

### Finding Configuration Format

1. Check `COLOR_THEME_TODO.md` for the app
2. Look for "Format:" or "Configuration tier:" notes
3. Check upstream docs link provided
4. Reference `docs/color-theme-research.md` for examples

### Understanding Color Mappings

- **Surface colors**: backgrounds, cards, elevated surfaces
- **Text colors**: primary (high contrast), secondary, tertiary, disabled
- **Action colors**: primary, secondary, danger, warning, success
- **Border colors**: subtle, default, strong, focus

See detailed definitions in `COLOR_THEME_TODO.md` Research & Design section.

### Handling Different Platforms

- **Linux-only**: Wayland compositors, MangoHud, Swaylock
- **Cross-platform**: Most terminals, editors, CLI tools
- **NixOS vs HM**: System components vs user applications

Check platform notes in `COLOR_THEME_TODO.md` for each app.

## Updating TODOs

### When You Complete a Task

1. Mark it complete with ✅ emoji
2. Add implementation location: `modules/category/app.nix`
3. Add completion date if tracking
4. Update related documents:
   - `docs/integration-standards.md`
   - `README.md` supported apps list
   - Any relevant research documents

### When You Add a New Task

1. Choose appropriate document:
   - Architecture/infrastructure → `.github/TODO.md`
   - New application → `COLOR_THEME_TODO.md`
   - Roadmap item → `docs/integration-standards.md`

2. Include context:
   - Why is this needed?
   - What's the benefit?
   - Implementation complexity?
   - Upstream docs link?

3. Assign priority based on:
   - User demand
   - Implementation complexity
   - Dependencies
   - Strategic importance

## Tips for Contributors

### Do
✅ Read relevant TODO sections before starting  
✅ Reference existing modules for patterns  
✅ Add detailed notes to help future contributors  
✅ Link to upstream documentation  
✅ Test thoroughly before submitting  
✅ Update all relevant documentation

### Don't
❌ Assume format requirements (check docs)  
❌ Skip the research phase  
❌ Forget to add tests  
❌ Leave TODOs incomplete/unmarked  
❌ Ignore platform compatibility

## Getting Help

### Questions About Architecture
- Check `.github/TODO.md` Architecture Improvements section
- Read `.claude/stylix-targets-research.md`
- Review existing module structure

### Questions About Implementation
- Check `COLOR_THEME_TODO.md` for the specific app
- Read `docs/color-theme-research.md` for examples
- Look at similar existing modules
- Check `.claude/ghostty-implementation-research.md` for a complete case study

### Questions About Priorities
- Check `docs/integration-standards.md` for current roadmap
- See `.github/TODO.md` for strategic priorities
- Review priority criteria in `COLOR_THEME_TODO.md`

## Maintenance

This guide should be updated when:
- New TODO documents are added
- Document structure changes significantly
- New categories or patterns emerge
- Contributor feedback suggests improvements

---

**Remember:** These TODOs are living documents. They should grow and evolve with the project. Don't hesitate to improve them as you work!
