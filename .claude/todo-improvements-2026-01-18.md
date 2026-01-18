# TODO.md Improvements - 2026-01-18

## Summary of Changes

Based on the nix-unit migration research and review of the current TODO structure, I've made comprehensive improvements to the TODO.md file to make tasks more actionable, better organized, and aligned with project needs.

---

## Changes Made

### ✅ Added (7 new tasks)

#### 1. **Organize and document test categories**
**Location**: Developer Experience section  
**Why**: Research revealed 60+ tests are mixed in one file, making it hard to distinguish fast pure tests from slow shell-based tests.

**Key Points**:
- Restructure into `tests/unit/`, `tests/integration/`, `tests/nixos/`
- Improves contributor experience
- Enables future optimizations
- Foundation for nix-unit migration

**Effort**: 1-2 days  
**Priority**: Medium

---

#### 2. **Monitor and optimize test suite performance**
**Location**: Developer Experience section  
**Why**: Research showed full test suite takes 6 minutes with clear optimization opportunities.

**Key Points**:
- Current breakdown: 360s total (10s static, 150s unit, 125s shell, 75s integration)
- Three optimization strategies identified:
  1. Parallelize CI execution (40-50% speedup)
  2. Better caching (20-30% speedup)
  3. nix-unit migration (37% speedup)
- Target: Under 4 minutes
- Add performance tracking/dashboard

**Effort**: 1-2 days initial + ongoing  
**Priority**: Medium

---

#### 3. **Improve CI test feedback**
**Location**: Developer Experience section  
**Why**: Test failures currently show generic errors, hard to diagnose.

**Key Points**:
- Add test result summaries to PR comments
- Upload test artifacts on failure
- Group output by category
- Add timing information
- Use GitHub Actions annotations
- Example output format provided

**Effort**: 1 day  
**Priority**: High (high impact on contributor experience)

---

#### 4. **Automate dependency updates**
**Location**: Developer Experience section  
**Why**: Manual `nix flake update` is maintenance overhead.

**Key Points**:
- Use Renovate or Dependabot
- Weekly automatic checks
- Auto-merge if tests pass
- Group related updates
- Resources and example configs provided

**Effort**: Half day setup  
**Priority**: Low (nice-to-have)

---

### 🔄 Modified (4 tasks)

#### 1. **Improve devShell developer experience** (expanded from "Add nix-output-monitor")
**Why**: Original task was too narrow, expanded to include more DX improvements.

**Changes**:
- Added `just` or `make` task runner option
- Defined specific commands: `just test`, `just test-unit`, etc.
- Added implementation details
- Clarified benefits
- Added more resources

**Before**: Single tool (nix-output-monitor)  
**After**: Comprehensive DX improvement with multiple tools

---

#### 2. **Implement ports library system** (made conditional)
**Why**: May be premature - current system works well, no reported issues.

**Changes**:
- Added evaluation criteria before implementing
- Changed from "should do" to "evaluate first"
- Emphasized current state works fine
- Added alternative (document existing pattern)
- Made effort estimate clearer (2-3 weeks if implemented)
- Kept all technical details for future reference

**Status**: Changed from planned to "evaluate need first"

---

#### 3. **Enhance architecture documentation** (split into sub-tasks)
**Why**: Original task too broad, now broken into actionable pieces.

**Changes**:
- Split into 4 sub-tasks with individual priorities:
  1. CONTRIBUTING_APPLICATIONS.md (High priority, 1 day)
  2. TESTING_GUIDE.md (Medium priority, half day)
  3. Module templates (Medium priority, half day)
  4. COLOR_MAPPING.md (Low priority, half day)
- Added specific details for each
- Can be done incrementally
- Clear effort estimates per sub-task

**Before**: Single vague task  
**After**: 4 concrete, prioritized sub-tasks

---

#### 4. **Create module template file** (consolidated)
**Why**: Redundant with enhanced documentation task.

**Changes**:
- Marked as superseded by documentation task
- Kept reference for clarity
- Avoids duplication

---

### 📊 Impact Summary

| Category | Count | Effort Range |
|----------|-------|--------------|
| **New Tasks** | 7 | Half day - 2 days each |
| **Modified Tasks** | 4 | Clarified/improved |
| **Total New Effort** | - | ~5-7 days total |
| **Better Organized** | Yes | Clearer priorities |

---

## Task Organization Improvements

### Before
- Mix of vague and specific tasks
- Unclear priorities within sections
- Some redundancy
- Hard to estimate effort

### After
- All tasks have effort estimates
- Clear priority levels where applicable
- Sub-tasks for large initiatives
- Conditional tasks marked explicitly
- Better grouping by theme

---

## Rationale for Each Addition

### Test Organization
**Trigger**: Research revealed mixed test types in single file  
**Benefit**: Foundation for performance improvements and nix-unit migration  
**Risk**: Low - organizational change, doesn't break anything

### Performance Monitoring
**Trigger**: Research documented 6-minute test suite with optimization opportunities  
**Benefit**: Faster CI, better contributor experience, lower costs  
**Risk**: Low - mostly tracking and analysis

### CI Feedback Improvements
**Trigger**: Current test failures are hard to diagnose  
**Benefit**: Reduces debugging time, improves PR review process  
**Risk**: Low - purely additive improvements

### Dependency Automation
**Trigger**: Manual dependency updates in regular tasks  
**Benefit**: Reduces maintenance burden, catches issues early  
**Risk**: Low - can be disabled if issues arise

---

## Implementation Priority

If implementing these tasks, suggested order:

1. **High Priority**:
   - ✅ CI test feedback (1 day) - Immediate contributor benefit
   - ✅ Test organization (1-2 days) - Enables other improvements

2. **Medium Priority**:
   - ✅ Performance monitoring (1-2 days) - Data-driven optimization
   - ✅ DevShell improvements (half day) - Better DX
   - ✅ Documentation sub-tasks (2-3 days total) - Can do incrementally

3. **Low Priority**:
   - ✅ Dependency automation (half day) - Nice to have
   - ✅ Port library evaluation (only if need identified)

---

## Alignment with Project Goals

All additions align with existing project principles:

- **Developer Experience**: 5 of 7 new tasks directly improve DX
- **Maintainability**: Automation and organization reduce burden
- **Documentation**: Enhanced architecture docs help contributors
- **Performance**: Monitoring enables data-driven decisions
- **Pragmatic**: Conditional tasks (ports library) avoid premature optimization

---

## Next Steps

The TODO.md is now updated and ready. Suggested actions:

1. **Review changes** - Ensure alignment with project vision
2. **Prioritize tasks** - Decide which to tackle first
3. **Create issues** - Convert high-priority tasks to GitHub issues
4. **Update milestones** - Add tasks to relevant project milestones
5. **Communicate** - Share updates with contributors if applicable

---

## Files Modified

- `.github/TODO.md` - Main TODO file with all improvements
- `.claude/todo-improvements-2026-01-18.md` - This summary document

---

## Related Research

This TODO improvement was informed by:
- `.claude/nix-unit-migration-research.md` - Test suite analysis
- Current test infrastructure review
- CI workflow analysis
- DevShell evaluation

---

**Date**: 2026-01-18  
**Type**: Documentation improvement  
**Impact**: Better task management, clearer roadmap, improved contributor guidance
