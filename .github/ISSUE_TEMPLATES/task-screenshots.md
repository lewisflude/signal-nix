---
name: 📸 Task - Screenshots
about: Track screenshot creation for launch
title: "📸 Create launch screenshots"
labels: ["launch", "documentation", "high-priority"]
assignees: []
---

## 📸 Screenshot Creation Task

**Priority**: HIGH  
**Estimated Time**: 3-4 hours total  
**Depends On**: None

---

## Overview

Create comprehensive screenshots for Signal's launch. These will be used in:
- README.md
- Launch announcements (Reddit, Discourse, Twitter)
- Documentation
- GitHub social preview

---

## Checklist

### Desktop Environment (1-2 hours)

#### Full Desktop
- [ ] Full desktop overview (all Ironbar widgets visible)
- [ ] Multiple workspaces shown in workspace switcher
- [ ] Clean wallpaper (solid color or subtle pattern)
- [ ] No personal information visible
- [ ] Window titles are representative

#### Ironbar Widgets - Individual
- [ ] Workspace switcher (active + inactive states)
- [ ] Clock display
- [ ] System tray (3-4 icons)
- [ ] Calendar popup (open state)
- [ ] Volume control (in use)
- [ ] Battery (multiple states: charging, 50%, 20%)
- [ ] Window title widget

#### Display Profiles
- [ ] Compact profile (1080p, 40px bar)
- [ ] Relaxed profile (1440p, 48px bar)
- [ ] Spacious profile (4K, 56px bar)
- [ ] Side-by-side comparison of all three

### GTK Applications (30 min)

- [ ] File manager (Nautilus/Thunar) - dark mode
- [ ] File manager - light mode
- [ ] Text editor (Gedit or similar)
- [ ] Settings application
- [ ] Dialog boxes (file picker)
- [ ] Context menu
- [ ] Light vs Dark comparison (side-by-side)

### Terminal Applications (1 hour)

#### Ghostty
- [ ] Clean terminal with Signal theme
- [ ] Show prompt and typical output
- [ ] Dark mode
- [ ] Light mode

#### Helix Editor
- [ ] Rust syntax highlighting
- [ ] Python syntax highlighting
- [ ] JavaScript syntax highlighting
- [ ] Nix syntax highlighting
- [ ] Full editor view with status line and line numbers

#### CLI Tools
- [ ] yazi file manager
- [ ] lazygit interface (commit history or diff view)
- [ ] fzf fuzzy finder (searching)
- [ ] bat syntax highlighting (multiple languages)

### Comparisons (30 min)

- [ ] Before/After: Stock theme → Signal theme
- [ ] Side-by-side: Signal vs Catppuccin (or other theme)
- [ ] Light/Dark: Same application in both modes

---

## Technical Requirements

**Resolution**: 2560x1440 (preferred) or 1920x1080 minimum  
**Format**: PNG  
**Color Space**: sRGB  
**Optimization**: Use optipng after capture  
**File Size**: Target <500KB per image

---

## Organization

Create directory structure:
```
screenshots/
├── desktop/
│   ├── signal-desktop-overview-dark.png
│   ├── signal-ironbar-widgets-dark.png
│   └── signal-ironbar-profiles-comparison.png
├── applications/
│   ├── gtk/
│   ├── editors/
│   ├── terminals/
│   └── cli/
├── comparisons/
│   ├── signal-vs-stock-theme.png
│   ├── signal-vs-catppuccin.png
│   └── signal-light-vs-dark.png
└── README.md  # List all screenshots with descriptions
```

---

## Tools

**Linux:**
```nix
home.packages = with pkgs; [
  flameshot    # Screenshot tool
  grim         # Wayland screenshot
  slurp        # Region selector
  optipng      # PNG optimization
];
```

**Capture:**
```bash
# Full screen
flameshot full -p ~/screenshots/

# Region
flameshot gui -p ~/screenshots/

# Optimize after
for img in ~/screenshots/*.png; do
  optipng -o7 "$img"
done
```

---

## Guide Reference

See **`docs/screenshot-guide.md`** for:
- Complete checklist
- Technical specifications
- Editing tips
- Naming conventions

---

## Acceptance Criteria

- [ ] All essential screenshots captured
- [ ] Images optimized (<1MB each)
- [ ] Properly organized and named
- [ ] No personal information visible
- [ ] Consistent theme (Signal dark mode)
- [ ] High quality, clear, well-lit

---

## Related

- Documentation: `docs/screenshot-guide.md`
- Tracking: #LAUNCH_TRACKING_ISSUE_NUMBER
- Next: Post-processing and upload

---

**Once complete, update the main launch tracking issue!**
