# TODO Documentation Enhancement Summary

**Date:** 2026-01-18  
**Task:** Flesh out TODO docs with additional context using web research and MCP tools

## What Was Done

Enhanced two major TODO documents with comprehensive context, implementation details, and web-researched information:

### 1. `.github/TODO.md` - Main Project TODO
Enhanced sections:
- **Architecture Improvements**: Added detailed context for Stylix targets system, nix-colors ports library, nix-unit testing migration, and documentation needs
- **Demo Videos**: Added OKLCH color space explanation with resources and key talking points
- **Developer Experience**: Expanded nix-output-monitor, module templates, and helper function descriptions

### 2. `COLOR_THEME_TODO.md` - Color Theme Implementation TODO
Enhanced sections:
- **High Priority Applications**: Added configuration tiers, upstream docs, format requirements, platform notes for all apps
- **Medium Priority Applications**: Added comprehensive implementation details for CLI tools, code editors
- **Infrastructure Improvements**: Expanded color system, module system, documentation, and testing requirements
- **GTK/Qt Integration**: Added detailed Qt theming approaches and GTK enhancement strategies
- **Research & Design**: Added semantic color roles, WCAG contrast requirements, colorblind considerations
- **Notes Section**: Added comprehensive notes on priorities, tiers, color formats, testing, and future considerations

## Key Information Added

### Architecture Context
- **Stylix**: Targets-based architecture for modular theming
- **nix-colors**: Ports library pattern for pure color mapping functions
- **nix-unit**: Modern testing framework for Nix code
- Benefits and implementation approaches for each

### Application Integration Details
Each application entry now includes:
- Configuration tier classification
- Upstream documentation links
- Color format requirements
- Platform compatibility notes
- Implementation complexity assessment
- Integration strategies

### Color System Improvements
- Semantic color role definitions (Primary, Secondary, Surface, Text, etc.)
- WCAG 2.1 contrast requirements (4.5:1 for text, 3:1 for UI)
- Colorblind-friendly palette considerations
- Color format converters needed (hex, RGB, ANSI)

### Testing Strategy
- Per-module tests (validation, structure, activation)
- Integration tests (full builds, no conflicts)
- Visual tests (screenshots, consistency)
- Accessibility tests (contrast, colorblind simulation)

### Configuration Tiers Explained
- **Tier 1**: Preset selection only
- **Tier 2**: Structured color options
- **Tier 3**: Freeform key-value settings
- **Tier 4**: Full config file generation

## Resources Referenced

### GitHub Projects
- **Stylix**: https://github.com/danth/stylix - Modular NixOS theming system
- **nix-colors**: https://github.com/Misterio77/nix-colors - Color scheme library with ports
- **nix-unit**: https://github.com/nix-community/nix-unit - Unit testing for Nix
- **nix-output-monitor**: https://github.com/maralorn/nix-output-monitor - Better build output

### Color Theory
- **OKLCH Color Space**: https://evilmartians.com/chronicles/oklch-in-css-why-quit-rgb-hsl
  - Perceptually uniform color space
  - Better than RGB/HSL for design systems
  - Equal numerical differences = equal perceived differences
- **MDN OKLCH Reference**: https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/oklch

### Accessibility
- **WCAG 2.1 Guidelines**: Contrast ratios for text and UI components
- **Colorblind Considerations**: Protanopia, Deuteranopia, Tritanopia accommodations
- **Contrast Checker**: https://webaim.org/resources/contrastchecker/
- **Colorblind Simulator**: https://www.color-blindness.com/coblis-color-blindness-simulator/

### Existing Research
- `docs/color-theme-research.md` - Complete application theming reference (1260 lines)
- `.claude/ghostty-implementation-research.md` - Ghostty implementation case study
- `.claude/gtk-theming-docs-research.md` - GTK theming comprehensive guide

## Implementation Priorities

### Immediate (High Value, Low Complexity)
1. **Git Delta** - Already has HM module, just needs color mapping
2. **Tealdeer** - Simple structured config, clear benefit for `tldr` users
3. **MangoHud** - Gaming overlay, high user demand
4. **Swaylock** - Security critical, Wayland standard

### Next Phase (Infrastructure)
1. **Color role mapping** - Define semantic colors (Primary, Surface, Text, etc.)
2. **Format converters** - Hex to RGB, RGB to ANSI, alpha separation
3. **Module template** - Standard structure for new applications
4. **Testing framework** - Migrate to nix-unit or enhance current tests

### Later (Medium Priority)
1. **Btop++** - Full theme file generation
2. **Zed Editor** - JSON theme generation
3. **Powerlevel10k** - Complex config with 100+ color variables
4. **Qt theming** - Separate system from GTK

### Future Considerations
1. **OKLCH support** - Better perceptual uniformity
2. **Dynamic themes** - Runtime switching, system detection
3. **Community themes** - Import/export, sharing system
4. **Light mode** - Currently dark-focused, need light variant

## Documentation Needs

### New Documents to Create
1. `docs/CONTRIBUTING_APPLICATIONS.md` - Step-by-step guide for adding apps
2. `docs/PORT_DEVELOPMENT.md` - How to write color mapping ports
3. `docs/MODULE_TEMPLATES.md` - Templates for each tier
4. `docs/TESTING_GUIDE.md` - How to test new modules
5. `docs/COLOR_SEMANTICS.md` - Semantic color role definitions
6. `docs/COLOR_GROUPING.md` - Application color consistency strategy
7. `docs/COMPATIBILITY.md` - Platform support matrix
8. `docs/MODULE_STRUCTURE.md` - Standard module structure

### Documents to Enhance
1. `docs/theming-reference.md` - Add all new applications
2. `docs/architecture.md` - Add ports library and targets system
3. `docs/configuration-guide.md` - Add per-app examples

## Next Steps

### For Maintainers
1. Review enhanced TODO documents
2. Prioritize which applications to implement next
3. Decide on infrastructure improvements (ports library vs. current approach)
4. Consider nix-unit migration timeline

### For Contributors
1. Use enhanced TODO as implementation guide
2. Reference application-specific notes when adding modules
3. Follow configuration tier guidelines
4. Include tests with new modules

### For Users
1. Check application compatibility notes before requesting features
2. Understand which apps are platform-specific (Linux, Wayland, etc.)
3. Use application grouping strategy for consistent theming

## Benefits of This Enhancement

### Better Planning
- Clear implementation priorities based on complexity and value
- Detailed context prevents wasted effort on wrong approaches
- Dependencies and requirements identified upfront

### Improved Contributor Experience
- New contributors have detailed guides for each application
- Configuration tiers help choose right implementation method
- Testing requirements are explicit

### Informed Architecture Decisions
- Comparison with Stylix and nix-colors informs design choices
- Understanding of trade-offs between approaches
- Clear migration paths for improvements

### Comprehensive Coverage
- Every application has context on complexity, format, platform
- Nothing is assumed - all details documented
- Links to upstream docs for reference

## Maintenance

This enhancement should be kept up-to-date as:
- New applications are added to the roadmap
- Applications are completed (mark with ✅ and implementation location)
- Architecture improvements are implemented
- New testing approaches are adopted
- Community feedback reveals better approaches

## Acknowledgments

Information sources:
- GitHub repositories: Stylix, nix-colors, nix-unit, nix-output-monitor
- Application documentation: Linked throughout TODO documents
- Color theory resources: Evil Martians OKLCH article, MDN
- Existing signal-nix research: color-theme-research.md, Ghostty and GTK research docs
- Home Manager documentation and source code

---

**Note**: This summary document is for reference. The actual enhanced content is in:
- `.github/TODO.md`
- `COLOR_THEME_TODO.md`
