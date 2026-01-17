# NixOS Module Implementation Status

> **Current Status**: Phase 1 Complete (Foundation & Boot)

This document tracks the implementation progress of Signal's NixOS system-level theming modules.

## Implementation Overview

| Phase | Status | Components | Priority |
|-------|--------|------------|----------|
| Phase 1: Foundation | ✅ **Complete** | Console, GRUB | P0 |
| Phase 2: Display Managers | 📋 Planned | GDM, SDDM, LightDM | P0 |
| Phase 3: Desktop | 📋 Planned | GTK, Qt, Cursors | P1 |
| Phase 4: System Tools | 📋 Planned | dmenu, rofi, nano, vim | P2 |
| Phase 5: Advanced | 📋 Planned | Plymouth, OpenRGB | P3 |

## Completed Components ✅

### Virtual Console (TTY)
- **Module**: `modules/nixos/boot/console.nix`
- **Status**: ✅ Complete
- **Options**: `theming.signal.nixos.boot.console.enable`
- **Tests**: 4 tests passing
- **What it does**: Applies 16 ANSI colors to virtual terminals (Ctrl+Alt+F1-F6)
- **Documentation**: [docs/nixos-modules.md](docs/nixos-modules.md#virtual-console-tty)

### GRUB Bootloader Theme
- **Module**: `modules/nixos/boot/grub.nix`
- **Package**: `pkgs/grub-theme/default.nix`
- **Status**: ✅ Complete
- **Options**: 
  - `theming.signal.nixos.boot.grub.enable`
  - `theming.signal.nixos.boot.grub.customBackground`
- **Outputs**: `packages.signal-grub-theme-dark`, `packages.signal-grub-theme-light`
- **What it does**: Themes GRUB boot menu with Signal colors
- **Documentation**: [docs/nixos-modules.md](docs/nixos-modules.md#grub-bootloader)

### SDDM Display Manager Theme (NEW)
- **Module**: `modules/nixos/login/sddm.nix`
- **Package**: `pkgs/sddm-theme/default.nix`
- **Status**: ✅ Complete
- **Options**: `theming.signal.nixos.login.sddm.enable`
- **Outputs**: `packages.signal-sddm-theme-dark`, `packages.signal-sddm-theme-light`
- **Tests**: 3 tests passing
- **What it does**: Complete QML-based login screen theme for KDE/Qt systems
- **Documentation**: [docs/nixos-modules.md](docs/nixos-modules.md#sddm-display-manager)
- **Features**:
  - Custom QML UI with Signal colors
  - User and session selection
  - Password input with focus states
  - Power controls (reboot, shutdown)
  - Error message display
  - Fully themed buttons and inputs

### Core Infrastructure
- **Module**: `modules/nixos/common/default.nix`
- **Status**: ✅ Complete
- **Features**:
  - Option definitions for all components
  - Color resolution (mode: dark/light/auto)
  - Assertions and validation
  - Module arguments (`signalColors`, `signalLib`)
- **Tests**: NixOS test suite created (7 tests total)

## In Progress 🚧

None currently. Phase 1 + SDDM complete, ready to begin GDM implementation.

## Planned Components 📋

### Phase 2: Display Managers (P0)

#### GDM (GNOME Display Manager)
- **Priority**: P0 (High impact)
- **Complexity**: High
- **Approach**: Generate GTK4 theme, apply via GSettings
- **Research needed**:
  - [ ] GDM GTK4 theming system
  - [ ] GResource compilation
  - [ ] GSettings override paths
  - [ ] CSS for login screen

#### SDDM (KDE Display Manager)
- **Priority**: P0 (High impact)
- **Complexity**: Medium
- **Approach**: Generate QML theme package
- **Research needed**:
  - [ ] SDDM theme structure
  - [ ] QML components for login
  - [ ] Qt color properties
  - [ ] Theme installation paths

#### LightDM
- **Priority**: P1 (Medium impact)
- **Complexity**: Medium
- **Approach**: Configure GTK greeter theme
- **Research needed**:
  - [ ] LightDM greeter options
  - [ ] GTK theme configuration
  - [ ] Background settings

### Phase 3: Plymouth Boot Splash (P1)

- **Priority**: P1 (Visual polish)
- **Complexity**: High
- **Approach**: Create Plymouth theme package
- **Research needed**:
  - [ ] Plymouth `.script` format
  - [ ] Animation capabilities
  - [ ] Logo and progress bar design
  - [ ] Color interpolation

### Phase 4: System-Wide Desktop (P1)

#### System GTK Theme
- **Priority**: P1 (Affects all GTK apps)
- **Complexity**: High
- **Approach**: Package GTK theme system-wide
- **Note**: Can reuse Home Manager GTK theme colors

#### System Qt Theme
- **Priority**: P1 (KDE users)
- **Complexity**: High
- **Approach**: Generate QSS stylesheet or Qt theme
- **Research needed**: Qt theming system

### Phase 5: System Tools (P2)

- dmenu (P2)
- rofi (P2)
- nano (P2)
- vim (P2)

## Testing Status

### Test Suite
- **Location**: `tests/nixos.nix`
- **Tests**: 7 passing
  - ✅ `nixos-console-colors-basic` - Basic console colors
  - ✅ `nixos-console-disabled` - Disable flag respected
  - ✅ `nixos-console-light-mode` - Light mode colors
  - ✅ `nixos-home-manager-isolation` - Module isolation
  - ✅ `nixos-sddm-theme-basic` - Basic SDDM theme
  - ✅ `nixos-sddm-disabled` - SDDM disable flag
  - ✅ `nixos-sddm-light-mode` - SDDM light mode

### Manual Testing Needed
- [ ] Test on real hardware (not just VM)
- [ ] Verify TTY colors on actual console
- [ ] Test GRUB theme on actual boot
- [ ] Screenshot documentation

## Documentation Status

### Completed
- ✅ [NixOS Module Getting Started](docs/nixos-modules.md)
- ✅ [Implementation Plan](NIXOS_MODULE_PLAN.md)
- ✅ Example: [nixos-boot.nix](examples/nixos-boot.nix)
- ✅ Example: [nixos-complete.nix](examples/nixos-complete.nix)
- ✅ Example: [nixos-sddm.nix](examples/nixos-sddm.nix) - NEW
- ✅ README updates

### Needed
- [ ] Screenshots of console colors
- [ ] Screenshots of GRUB theme
- [ ] Video walkthrough
- [ ] Migration guide for existing users

## Architecture Notes

### Module Structure
```
modules/nixos/
├── common/
│   └── default.nix         ✅ Core options and imports
├── boot/
│   ├── console.nix         ✅ TTY colors
│   ├── grub.nix            ✅ GRUB theme
│   └── plymouth.nix        📋 Planned
├── login/
│   ├── sddm.nix            ✅ SDDM theme - NEW
│   ├── gdm.nix             📋 Planned
│   └── lightdm.nix         📋 Planned
└── desktop/
    ├── gtk.nix             📋 Planned
    └── qt.nix              📋 Planned
```

### Package Structure
```
pkgs/
├── grub-theme/             ✅ GRUB theme generator
├── sddm-theme/             ✅ SDDM QML theme - NEW
├── plymouth-theme/         📋 Planned
└── gtk-theme/              📋 Planned (reuse from HM)
```

### Flake Outputs
```nix
{
  nixosModules = {
    default          # ✅ All modules
    signal           # ✅ Alias for default
    boot             # ✅ Console only
    grub             # ✅ GRUB only
    sddm             # ✅ SDDM only - NEW
  };
  
  packages.${system} = {
    signal-grub-theme-dark   # ✅ Dark GRUB theme
    signal-grub-theme-light  # ✅ Light GRUB theme
    signal-sddm-theme-dark   # ✅ Dark SDDM theme - NEW
    signal-sddm-theme-light  # ✅ Light SDDM theme - NEW
  };
}
```

## Design Principles Followed

1. ✅ **Colors Only**: Modules only set colors, never enable services
2. ✅ **Parallel Architecture**: NixOS modules separate from Home Manager
3. ✅ **Same Palette**: Both use identical signal-palette
4. ✅ **Proper Namespacing**: `theming.signal.nixos.*` vs `theming.signal.*`
5. ✅ **Comprehensive Testing**: Test suite for each component
6. ✅ **Documentation First**: Docs written before/during implementation

## Next Steps

### Immediate (Next PR)
1. Manual testing on real hardware
2. Screenshot documentation
3. Announce NixOS module support

### Short Term (v1.1)
1. Implement SDDM theme (easier than GDM)
2. Test on KDE systems
3. Create video walkthrough

### Medium Term (v1.2)
1. Implement GDM theme
2. Test on GNOME systems
3. Plymouth boot splash

### Long Term (v2.0)
1. Complete all P1 components
2. System-wide GTK/Qt themes
3. Comprehensive screenshot gallery

## Known Issues

None currently. Phase 1 implementation is solid.

## Contributing

Want to help implement display managers or other components?

1. Check the [Implementation Plan](NIXOS_MODULE_PLAN.md)
2. Pick a component from "Planned" section
3. Follow the research checklist
4. Implement module + package
5. Write tests
6. Update this document
7. Submit PR

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Version History

- **v1.1.0** (2026-01-17): SDDM Display Manager Support
  - SDDM login screen theme (QML-based)
  - Complete UI with Signal colors
  - Dark and light mode support
  - 3 new tests
  - Example configuration

- **v1.0.0** (2026-01-17): Initial NixOS module support
  - Virtual console (TTY) colors
  - GRUB bootloader theme
  - Core module infrastructure
  - Test suite
  - Documentation

---

**Last Updated**: 2026-01-17  
**Status**: Phase 2 Started ✅  
**Next Milestone**: GDM Display Manager
