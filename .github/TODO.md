# Signal-nix TODO & Future Tasks

This file tracks ongoing tasks and future improvements for Signal Design System.

## Active Tasks

### High Priority

- [ ] Monitor and respond to user feedback in Discussions and Issues
- [ ] Review and merge community contributions
- [ ] Keep dependencies up to date (run `nix flake update` periodically)

### Medium Priority

- [ ] Consider submitting to nixpkgs after community validation
  - **Requirements**: Stable API, positive community feedback, comprehensive documentation, passing CI
  - **Process**: Submit flake as package, ensure license compatibility, provide maintainer info
  - **Related**: https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md
- [ ] Create demo videos if requested by community:
  - **Desktop tour** (1-2 min): Show themed desktop with various applications, demonstrate consistency
  - **Application showcases** (30-60s each): Individual apps showing color usage, before/after comparisons
  - **OKLCH color space explanation**: Educational video explaining why OKLCH provides better perceptual uniformity than RGB/HSL
    - **Key points to cover**:
      - Perceptual uniformity: Equal numerical differences = equal perceived differences
      - Better than RGB: RGB's red appears brighter than blue at same values
      - Better than HSL: HSL's lightness doesn't match human perception
      - Practical benefits: Easier to create harmonious color schemes, better accessibility
      - Resources: https://evilmartians.com/chronicles/oklch-in-css-why-quit-rgb-hsl
  - **Tools**: OBS Studio (themed with Signal colors!), kdenlive for editing, mpv for playback testing
- [ ] Build community showcase gallery with user screenshots
- [ ] Post to additional communities if interest grows:
  - r/unixporn (with high-quality screenshots)
  - Hacker News (if appropriate timing/interest)

### Low Priority

- [ ] Write blog post about design decisions and lessons learned
- [ ] Create tutorial series for advanced customization
- [ ] Consider automated CI checks for design principle violations
- [ ] Explore additional application integrations based on user requests

## Maintenance

### Regular Tasks

- [ ] Weekly: Check for new issues and discussions
- [ ] Monthly: Update dependencies with `nix flake update`
- [ ] Quarterly: Review and update documentation
- [ ] As needed: Create patch releases for critical bugs

### Release Process

When creating a new release:

1. Update `CHANGELOG.md` with changes
2. Create release tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
3. Push tag: `git push origin vX.Y.Z`
4. GitHub Actions will create the release automatically
5. Use `.github/RELEASE_TEMPLATE.md` as a guide for release notes
6. Announce in Discussions

## Future Enhancements

### Architecture Improvements

- [x] **Research Stylix-style targets system** - Completed comprehensive analysis of [Stylix's module architecture](https://github.com/danth/stylix)
  - **Research document**: `.claude/stylix-targets-research.md`
  - **Key findings**:
    - Stylix uses `mkTarget` helper for consistent module structure
    - Separates concerns via function arguments (colors, fonts, opacity)
    - Automatic safeguarding prevents accessing disabled options
    - All modules follow same pattern (reduces cognitive load)
  - **Next steps**: Evaluate if targets system fits Signal's needs or if ports library is better approach

- [ ] **Evaluate targets vs ports approach** - Decide between Stylix targets system and nix-colors ports library
  - **Question**: Which architecture fits Signal better?
  - **Targets system** (Stylix):
    - Pros: Integrated with module system, automatic option generation, safeguarding
    - Cons: More complex, tightly coupled to Home Manager, harder to test in isolation
    - Best for: Full-featured theming systems with many configuration dimensions
  - **Ports library** (nix-colors):
    - Pros: Pure functions, easy to test, reusable outside Home Manager
    - Cons: More manual work for module integration, less automatic safeguarding
    - Best for: Simple color mapping with minimal configuration logic
  - **Signal's needs**:
    - OKLCH color system (not Base16) requires custom adaptation
    - Both color mapping AND spacing/typography configuration
    - Want easy testing but also want safety guarantees
  - **Decision criteria**:
    1. Do we need safeguarding? (accessing colors when disabled)
    2. Do we need automatic option generation?
    3. Do we want pure functions for testing?
    4. How much configuration complexity do we have?
  - **Recommendation**: Start with ports library for simplicity, can add targets wrapper later if needed

- [ ] **Implement ports library system** (evaluate need first)
  - **Current State**: Modules work well as-is, no reported issues from contributors
  - **Context**: nix-colors provides a library of "ports" - pure functions that convert a color scheme into application-specific configurations. This separates color logic from Home Manager integration.
  - **Evaluation Criteria** (assess before implementing):
    - Are contributors having trouble adding modules?
    - Do we need color mappings outside Home Manager?
    - Is testing modules too difficult currently?
    - Does module code feel too repetitive/boilerplate-heavy?
  - **Decision**: Only implement if evaluation shows clear need
  - **Alternative**: Document current pattern better in contributor guide
  - **Potential Benefits** (if implemented):
    - Pure functions are easier to test (no Home Manager evaluation needed)
    - Color mappings can be used outside of Home Manager (in standalone scripts, etc.)
    - Contributors can add applications without understanding Home Manager internals
    - Enables color preview/validation tools
  - **Implementation** (if approved): 
    - Create `lib/ports/alacritty.nix`, `lib/ports/kitty.nix`, etc.
    - Each port exports a function: `{ signal, brand, ... }: { /* app config */ }`
    - Modules in `modules/` become thin wrappers that call port functions
  - **Example Structure**:
    ```nix
    # lib/ports/alacritty.nix
    { colors }: {
      colors = {
        primary.background = colors.surface.base;
        primary.foreground = colors.text.primary;
        # ...
      };
    }
    
    # modules/terminals/alacritty.nix
    { config, lib, ... }:
    let
      alacrittyPort = import ../../lib/ports/alacritty.nix;
      alacrittyColors = alacrittyPort { colors = signalColors; };
    in {
      programs.alacritty.settings = alacrittyColors;
    }
    ```
  - **Effort if implemented**: 2-3 weeks
  - **Related Resources**:
    - nix-colors ports: https://github.com/Misterio77/nix-colors/tree/main/lib/contrib
    - Port contribution guide: https://github.com/Misterio77/nix-colors/blob/main/CONTRIBUTING.md

- [x] **Research nix-unit for testing** - Completed comprehensive analysis of migrating from `runCommand`-based tests to [nix-unit](https://github.com/nix-community/nix-unit)
  - **Research Document**: `.claude/nix-unit-migration-research.md`
  - **Key Findings**:
    - ✅ **Pure unit tests** (30 tests, 40% of suite): Excellent candidates for nix-unit
      - 10x faster execution (0.5s vs 5s per test)
      - Individual failure isolation
      - Better error messages with colored diffs
      - Compatible with existing `lib.runTests` format
    - ⚠️ **Shell-based tests** (25 tests, 35% of suite): Should remain as `runCommand`
      - Require file system access (`test -f`, `grep` patterns)
      - Validate module structure with shell commands
      - Not compatible with pure evaluation
    - ⚠️ **Integration tests** (15 tests): Keep as `runCommand`
      - Need Home Manager evaluation context
      - Some require NixOS module evaluation
  - **Recommendation**: **Hybrid approach** - Migrate pure tests to nix-unit, keep shell tests as `runCommand`
    - **Effort**: 1-2 weeks (vs 4-6 weeks for full migration)
    - **Risk**: Low (vs High for full migration)
    - **Benefit**: 37% faster test suite (6 min → 3.75 min)
    - **ROI**: High for pure tests, Low for shell tests
  - **Next Steps** (if approved):
    1. Add `nix-unit` to devShell.buildInputs
    2. Create `tests/unit/` directory for pure tests
    3. Migrate 30 pure unit tests (library functions, colors, accessibility)
    4. Update CI to run `nix-unit` for unit tests
    5. Document hybrid testing approach for contributors
  - **Related Resources**:
    - Research document: `.claude/nix-unit-migration-research.md`
    - nix-unit documentation: https://nix-community.github.io/nix-unit/
    - Current test suite: `tests/default.nix` (744 lines analyzed)

- [ ] **Implement nix-unit hybrid testing** (if research approved)
  - **Depends on**: Research review and approval
  - **Scope**: Migrate 30 pure unit tests to nix-unit while keeping shell tests as `runCommand`
  - **Estimated Effort**: 1-2 weeks
  - **Implementation Plan**:
    1. Phase 1: Setup (1-2 days)
       - Add `pkgs.nix-unit` to devShell
       - Create `tests/unit/` directory structure
       - Add nix-unit to CI workflow
    2. Phase 2: Migration (3-5 days)
       - Extract pure tests from `tests/default.nix`:
         - Library function tests (resolveThemeMode, getColors, etc.)
         - Color manipulation tests (adjustLightness, adjustChroma)
         - Accessibility tests (contrast estimation)
         - Brand governance tests
       - Create nix-unit test files:
         - `tests/unit/lib.nix`
         - `tests/unit/colors.nix`
         - `tests/unit/accessibility.nix`
         - `tests/unit/brand.nix`
       - Keep shell tests in `tests/integration/`:
         - Module validation tests
         - Pattern matching tests
         - File existence checks
    3. Phase 3: CI Integration (1 day)
       - Update `.github/workflows/test-suite.yml`
       - Add nix-unit test runs
       - Keep existing runCommand tests
       - Generate test coverage reports
    4. Phase 4: Documentation (1-2 days)
       - Update `docs/testing.md` with hybrid approach
       - Create `docs/TESTING_WITH_NIX_UNIT.md`
       - Add guidelines for when to use nix-unit vs runCommand
       - Provide examples and templates
  - **Success Criteria**:
    - All existing test coverage maintained
    - Test suite 30%+ faster
    - Clear documentation for contributors
    - CI passes consistently with both test types

- [ ] **Enhance architecture documentation** - Add detailed guides for contributors on how to add new applications
  - **Context**: Current module patterns work well but lack comprehensive contributor documentation
  - **Sub-tasks** (can be done incrementally):
    1. **Create CONTRIBUTING_APPLICATIONS.md** (Priority: High)
       - Step-by-step guide for adding new application modules
       - Target audience: First-time contributors
       - Include tier system explanation with examples
       - Provide decision tree for choosing tier
       - Add example PR checklist
       - Effort: 1 day
    2. **Document module testing requirements** (Priority: Medium)
       - Create `docs/TESTING_GUIDE.md`
       - Explain when to use unit vs integration tests
       - Provide test templates and examples
       - Show how to run tests locally
       - Include debugging tips for common issues
       - Effort: Half day
    3. **Create module templates** (Priority: Medium)
       - Add template files in `templates/` directory
       - Tier 1: Structured config template (e.g., Helix-style)
       - Tier 2: Color-settings template (e.g., Alacritty-style)
       - Tier 3: Freeform template (e.g., GTK-style)
       - Include inline documentation and comments
       - Effort: Half day
    4. **Document color mapping best practices** (Priority: Low)
       - Create `docs/COLOR_MAPPING.md`
       - Semantic color usage guidelines
       - OKLCH-specific considerations
       - Accessibility requirements
       - Common pitfalls and solutions
       - Effort: Half day
  - **Inspiration**: Stylix has excellent contributor documentation: https://danth.github.io/stylix/
  - **Total Effort**: 2-3 days (can be done incrementally)
  - **Benefits**: Lower barrier to entry for contributors, consistent module quality

### Potential Features

- Additional application integrations (community-driven)
- Enhanced brand governance policies
- More ironbar widget customization options
- Improved light mode refinements based on feedback
- Performance optimizations for module evaluation

### Developer Experience

- [x] **Organize and document test categories** - Restructure test suite to clearly separate pure tests from shell-based tests
  - **Status**: ✅ Completed (2026-01-18)
  - **Summary**: Successfully reorganized test suite into `tests/unit/` (9 pure tests) and `tests/integration/` (15 shell tests)
  - **Results**:
    - Created organized directory structure with clear separation
    - Moved all tests to appropriate categories (pure vs shell-based)
    - Updated documentation with structure explanation and guidelines
    - All tests passing with no breaking changes
    - Foundation laid for future nix-unit migration if approved
  - **Files Changed**:
    - NEW: `tests/unit/default.nix` (377 lines) - Pure Nix unit tests
    - NEW: `tests/integration/default.nix` (268 lines) - Shell-based validation
    - MODIFIED: `tests/default.nix` (simplified to 163 lines from 744)
    - MODIFIED: `docs/testing.md` - Added structure docs and guidelines
  - **Performance**:
    - Unit tests: ~0.5-1s each (9 tests = ~9s total)
    - Integration tests: ~2-5s each (15 tests = ~45s total)
    - Can now run fast unit tests during development
  - **Documentation**: See `.claude/test-organization-summary.md` for full details

- [ ] **Monitor and optimize test suite performance** - Track test execution time and identify optimization opportunities
  - **Context**: Full test suite currently takes ~6 minutes (360s) to complete
  - **Current Breakdown**:
    - Static checks: ~10s
    - Unit tests: ~150s (30 tests × 5s average)
    - Shell tests: ~125s (25 tests × 5s average)
    - Integration tests: ~75s (15 tests × 5s average)
  - **Optimization Opportunities**:
    1. **Parallelize test execution in CI** (currently mostly sequential)
       - Run test categories in parallel
       - Use matrix strategy more effectively
       - Potential: 40-50% speedup
    2. **Cache test dependencies better**
       - Improve Nix cache hit rates
       - Cache built test derivations
       - Potential: 20-30% speedup on cache hits
    3. **Consider nix-unit for pure tests** (see research task above)
       - Migrate 30 pure unit tests
       - Potential: 37% overall speedup
  - **Target**: Reduce full test suite to under 4 minutes
  - **Tracking**:
    - Add CI job duration to test report
    - Create performance dashboard/badge
    - Monitor trends over time
  - **Effort**: 1-2 days for initial setup, ongoing monitoring
  - **Priority**: Medium (improves contributor experience, reduces CI costs)

- [x] **Improve CI test feedback** - Make test failures easier to diagnose
  - **Status**: ✅ Completed (2026-01-18) - Enhanced further with PR comments and individual test tracking
  - **Improvements Implemented**:
    1. ✅ **Automated PR comments with comprehensive test summaries** (NEW - 2026-01-18)
       - Updates existing comment on each push (avoids comment spam)
       - Shows overall status, detailed category results, and performance metrics
       - Includes troubleshooting steps and helpful links to docs
       - Bot comment clearly identifies itself and updates automatically
    2. ✅ **Individual test tracking** (NEW - 2026-01-18)
       - Counts passed/failed tests within each category
       - Shows test counts in detailed results table
       - Aggregates total tests across all categories
       - Better granularity for debugging specific failures
    3. ✅ **Enhanced error extraction and reporting** (NEW - 2026-01-18)
       - Extracts specific error messages from nix build output
       - Shows first error in details column of results table
       - Includes last 30 lines of output for build failures
       - Collapsible sections for failed test details in step summary
    4. ✅ **Improved visual presentation** (NEW - 2026-01-18)
       - Better emoji usage for quick scanning (🧪, ⏱️, ❌, ✅)
       - Enhanced table formatting with more columns
       - Time formatted as "Xm Ys" for long durations
       - Tracks and displays slowest test category
    5. ✅ **GitHub Actions annotations for test failures** (ORIGINAL)
       - Error annotations point directly to failed test categories
       - Notice annotations for successful tests with timing
       - Grouped output for better log organization (::group::)
    6. ✅ **Enhanced test result summary** (ORIGINAL)
       - Comprehensive test report in GitHub Actions summary
       - Per-category status table with timing information
       - Overall test stage breakdown (Smoke, Suite, Full Check)
       - Performance metrics (total time, average per category)
    7. ✅ **Upload test artifacts on failure** (ORIGINAL)
       - Logs saved to artifacts for 7 days
       - Easy download from PR checks tab
       - Per-category log files for debugging
  - **Files Modified**:
    - `.github/workflows/test-suite.yml` - Major overhaul of reporting job with PR comments and better summaries
    - `run-tests.sh` - Added timing to individual tests and overall suite
  - **Example Output**:
    - ✅ Automated PR comment with full test report (updates on each push)
    - ✅ Individual test counts: "45/50 tests passed"
    - ✅ Error details extracted and shown inline
    - ✅ Performance metrics: "Total: 3m 45s, Slowest: integration (85s)"
  - **Benefits**:
    - 🎯 Contributors see test results without leaving PR page
    - ⚡ Faster debugging with extracted error messages
    - 📊 Better visibility into individual test failures
    - 🔍 Reduced time to diagnose failures from minutes to seconds

- [ ] **Automate dependency updates** - Set up automated PR creation for dependency updates
  - **Context**: Current process requires manual `nix flake update` and testing
  - **Tool Options**:
    - Renovate (recommended for Nix flakes)
    - Dependabot (GitHub native)
  - **Configuration**:
    - Weekly checks for `nix flake update`
    - Auto-merge if all tests pass
    - Group related updates (e.g., all inputs together)
    - Separate PRs for major version bumps
  - **Benefits**: 
    - Reduces manual maintenance burden
    - Catches breaking changes early
    - Keeps dependencies current
    - Automated testing of updates
  - **Implementation**:
    1. Add renovate.json or dependabot.yml
    2. Configure Nix flake update strategy
    3. Set up auto-merge rules
    4. Document in maintenance guide
  - **Effort**: Half day setup, ongoing automatic
  - **Priority**: Low (nice-to-have, manual process works)
  - **Resources**:
    - Renovate Nix support: https://docs.renovatebot.com/modules/manager/nix/
    - Example config: https://github.com/nix-community/renovate-nix-example

- [ ] **Improve devShell developer experience** - Add tools to improve build feedback and test running
  - **Tools to Add**:
    1. `nix-output-monitor` - Better build visualization
       - Real-time progress bars during builds
       - Cleaner output with collapsible steps
       - Usage: `nom build` instead of `nix build`
    2. `just` or `make` - Task runner for common commands
       - `just test` - Run all tests
       - `just test-unit` - Run only unit tests
       - `just test-integration` - Run integration tests
       - `just check` - Run formatting and linting
  - **Implementation**:
    - Add packages to `devShell.buildInputs`
    - Create `justfile` or `Makefile` with common tasks
    - Document in `docs/development.md`
  - **Benefits**: Faster contributor onboarding, consistent workflows
  - **Effort**: Half day
  - **Resources**:
    - nix-output-monitor: https://github.com/maralorn/nix-output-monitor
    - just: https://github.com/casey/just

- [x] **Create module template file** - Add `module-template.nix` with clear structure and comments showing how to implement a new application module
  - **Status**: ✅ Completed (2026-01-18)
  - **Location**: `templates/` directory (4 templates + comprehensive README)
  - **Templates Created**:
    - `tier-1-native-theme.nix` - For apps with native theme options (e.g., bat, helix)
    - `tier-2-structured-colors.nix` - For apps with structured color options (e.g., alacritty)
    - `tier-3-freeform-settings.nix` - For apps with freeform settings (e.g., kitty, ghostty)
    - `tier-4-raw-config.nix` - For apps requiring raw config generation (e.g., GTK, wezterm)
  - **Documentation**: `templates/README.md` with tier selection guide, usage instructions, best practices, and troubleshooting
  - **Contents** (each template):
    - Comprehensive header comments explaining tier and use cases
    - Complete metadata block structure
    - Color definition patterns with all available Signal colors
    - Theme activation check using `signalLib.shouldThemeApp`
    - Detailed implementation examples
    - Testing checklist (8-10 items per template)
    - Color format notes and tips
  - **Features**:
    - All templates have valid Nix syntax (verified)
    - Based on real working modules (bat, alacritty, kitty, gtk)
    - Includes ANSI color mappings for terminal apps
    - Comprehensive inline documentation
    - Clear placeholder system (UPPERCASE_PLACEHOLDER)
  - **Next Steps**: Templates ready for contributors to use when adding new applications

- [ ] **Add lib/mkAppModule helper** - Create helper function to reduce boilerplate when adding new applications
  - **Purpose**: Standardize common patterns across modules
  - **Functionality**:
    - Automatic theme activation logic
    - Standard option generation (enable, tier classification, color overrides)
    - Validation helpers (color format checking, required fields)
  - **Example Usage**:
    ```nix
    mkAppModule {
      name = "alacritty";
      category = "terminals";
      tier = 2;
      colorMapping = { colors }: { /* ... */ };
    }
    ```
  - **Benefits**: Less code duplication, enforced consistency, easier for new contributors

### Community Building

- Feature user configurations in a showcase
- Create contributor recognition system
- Develop beginner-friendly "good first issue" tasks
- Write guide for contributing new application modules (see Architecture Improvements above)

## Completed

✅ Launch v1.0  
✅ Comprehensive documentation overhaul  
✅ Testing suite with 30+ tests  
✅ Example configurations for common use cases  
✅ GitHub Issues templates and workflows  
✅ Troubleshooting guide with diagnostics  
✅ Design principles documentation  

---

**Note**: This file replaces the temporary launch tracking files which have been removed after successful launch.

Last updated: 2026-01-18 (added test organization, performance monitoring, CI improvements, and automation tasks)
