# Signal Integration Roadmap

> **Comprehensive program coverage for Signal theming**

This document tracks all programs that should be themed by Signal, organized by category and priority.

**Related Documents:**
- `.github/TODO.md` - High-level project roadmap and architecture improvements
- `COLOR_THEME_TODO.md` - Detailed color theme implementation tracking with technical context
- `docs/color-theme-research.md` - Application theming research and examples (1260 lines)
- `.claude/todo-enhancement-summary.md` - Summary of recent TODO documentation enhancements

## Current Status

**Supported Programs**: 42 modules across 12 categories (+14 new!)  
**Priority 0 Complete**: All critical desktop, editor, and shell integrations ✅  
**Latest Update**: 2026-01-18

---

## Completed Integrations

### ✅ Terminals (4/5 major)
- Alacritty (Tier 2) ✅
- Ghostty (Tier 3) ✅ - See `.claude/ghostty-implementation-research.md` for implementation details
- Kitty (Tier 3) ✅
- WezTerm (Tier 4) ✅
- **TODO**: Foot - Native HM option, straightforward (see `COLOR_THEME_TODO.md`)

### ✅ Editors (5/6 major) 🎉 NEW
- Helix (Tier 1) ✅
- Neovim (Tier 4) ✅
- Vim (Tier 4) ✅ NEW
- VS Code/VSCodium (Tier 2) ✅ NEW
- Emacs (Tier 4) ✅ NEW
- **TODO**: Zed - JSON theme generation (Medium priority in `COLOR_THEME_TODO.md`)

### ✅ Terminal Multiplexers (2/2)
- tmux (Tier 4) ✅
- Zellij (Tier 3) ✅

### ✅ Shell Prompts (1/4)
- Starship (Tier 3) ✅
- **TODO**: fish prompt, bash PS1, nushell

### ✅ Shells (3/4) 🎉 NEW
- zsh syntax highlighting (Tier 4) ✅
- fish (Tier 4) ✅ NEW
- bash (Tier 4) ✅ NEW
- **TODO**: nushell

### ✅ CLI Tools (8/15+) 🎉 NEW
- bat (Tier 1) ✅
- delta (Tier 3) ✅ - **High priority** enhancement in `COLOR_THEME_TODO.md`
- eza (Tier 4) ✅
- fzf (Tier 4) ✅
- lazygit (Tier 3) ✅
- yazi (Tier 3) ✅
- less (Tier 5) ✅ NEW
- ripgrep (Tier 5) ✅ NEW
- **TODO**: See `COLOR_THEME_TODO.md` for detailed list:
  - **High Priority**: Tig (git TUI), Tealdeer (tldr), MangoHud (gaming overlay)
  - **Medium Priority**: Glow (markdown), Procs (ps replacement), bottom (system monitor)

### ✅ Desktop Apps (9/20+) 🎉 NEW
- GTK 3/4 (Tier 4) ✅
- Ironbar (custom) ✅
- Fuzzel (Tier 3) ✅
- Hyprland (Tier 3) ✅ NEW
- Sway (Tier 2) ✅ NEW
- i3 (Tier 2) ✅ NEW
- rofi (Tier 1) ✅ NEW
- waybar (Tier 1) ✅ NEW
- dunst (Tier 3) ✅ NEW
- **TODO**: More compositors, bars, launchers

### ✅ System Monitors (2/3) 🎉 NEW
- btop (Tier 4) ✅
- htop (Tier 3) ✅ NEW
- **TODO**: bottom

### ✅ NixOS System (8 components)
- Console/TTY ✅
- GRUB ✅
- Plymouth ✅
- SDDM ✅
- GDM ✅
- LightDM ✅
- GTK Theme package ✅ - See `.claude/gtk-theming-docs-research.md` for complete GTK theming reference
- **TODO**: 
  - Qt theme (qt5ct/qt6ct, Kvantum) - Detailed in `COLOR_THEME_TODO.md`
  - systemd-boot (alternative to GRUB)

---

## Priority 0: Critical (Most Impact) ✅ COMPLETE

### Desktop/WM (Home Manager)
- [x] **Hyprland** - Most popular Wayland compositor ✅
- [x] **Sway** - i3-compatible Wayland compositor ✅
- [x] **i3** - Most popular X11 WM ✅
- [x] **rofi** - Universal application launcher ✅
- [x] **waybar** - Most popular Wayland status bar ✅
- [x] **dunst** - Most popular notification daemon ✅

### Editors (Home Manager)
- [x] **VS Code / VSCodium** - Most popular GUI editor ✅
- [x] **Vim** - Classic editor (both user and system-wide) ✅
- [x] **Emacs** - Major editor ecosystem ✅

### Shells (Home Manager)
- [x] **fish** - Popular friendly shell ✅
- [x] **bash** - Default shell on most systems ✅

### Core CLI (Home Manager)
- [x] **htop** - Classic system monitor ✅
- [x] **less** - Universal pager ✅
- [x] **ripgrep (rg)** - Modern grep alternative ✅

---

## Priority 1: High Demand

**Note**: For detailed implementation context, format requirements, and upstream documentation for each application, see `COLOR_THEME_TODO.md`.

### Desktop/WM (Home Manager)
- [ ] **bspwm** - Binary space partitioning WM
- [ ] **awesome** - Lua-based window manager
- [ ] **mako** - Wayland notification daemon (Native HM option available)
- [ ] **wofi** - Wayland launcher alternative (Native HM option available)
- [ ] **polybar** - Popular X11 status bar
- [ ] **picom** - X11 compositor

### Terminals (Home Manager)
- [ ] **foot** - Minimal Wayland terminal (Native HM option, straightforward implementation)
- [ ] **Rio** - GPU-accelerated terminal
- [ ] **st** - Suckless simple terminal (requires patching)

### File Managers (Home Manager)
- [ ] **ranger** - Vim-like file manager (Config file based)
- [ ] **lf** - Fast lightweight file manager (Config file based)
- [ ] **nnn** - Blazing fast file manager (Environment variables)
- [ ] **Thunar** - XFCE file manager (GTK theme + extra CSS)
- [ ] **Nautilus** - GNOME file manager (GTK/libadwaita theme)
- [ ] **Dolphin** - KDE file manager (Qt theme dependency)

### System Monitors (Home Manager)
- [ ] **bottom (btm)** - Modern resource monitor (Config file, medium priority in `COLOR_THEME_TODO.md`)
- [ ] **glances** - Cross-platform system monitor

### Development (Home Manager)
- [x] **lazydocker** - Docker TUI (like lazygit) ✅ RE-ENABLED
- [x] **glow** - Markdown viewer ✅
- [ ] **gdb** - GNU debugger with colors (Limited theming)
- [ ] **jq** - JSON processor with colors (Limited theming)

### Browsers (Home Manager)
- [ ] **Firefox** - userChrome.css + userContent.css
- [ ] **Qutebrowser** - Keyboard-driven browser

---

## Priority 2: Nice to Have

### Desktop Extras (Home Manager)
- [ ] **swaync** - Notification center for Sway
- [ ] **tofi** - Minimal Wayland launcher
- [ ] **dmenu** - Classic X11 launcher
- [ ] **eww** - Widget system
- [ ] **ags** - Another widget system

### Shells & Prompts (Home Manager)
- [ ] **nushell** - Structured data shell
- [ ] **bash PS1** - Bash prompt customization
- [ ] **fish prompt** - Fish built-in prompt

### Media (Home Manager)
- [ ] **mpv** - Video player OSD (**High priority** in `COLOR_THEME_TODO.md` - Native HM option with alpha support)
- [ ] **ncmpcpp** - Music player
- [ ] **cava** - Audio visualizer
- [ ] **musikcube** - Terminal music player

### Communication (Home Manager)
- [ ] **weechat** - IRC client
- [ ] **irssi** - IRC client
- [ ] **Discord** - Custom CSS via BetterDiscord
- [ ] **Slack** - Custom CSS

### Editors (Home Manager)
- [ ] **Zed** - Modern collaborative editor
- [ ] **nano** - Simple terminal editor

### Terminal Utils (Home Manager)
- [ ] **direnv** - Environment switcher (No theming needed)
- [ ] **atuin** - Shell history manager (Uses terminal colors)
- [ ] **tealdeer (tldr)** - Man page alternative (**High priority** in `COLOR_THEME_TODO.md` - Native HM option)
- [ ] **procs** - Modern ps replacement (Medium priority in `COLOR_THEME_TODO.md` - Config file)
- [ ] **duf** - Modern df replacement (Limited/no theming)
- [ ] **dust** - Modern du replacement (Uses terminal colors only)

### Git Tools (Home Manager)
- [ ] **tig** - Text-mode git interface (**High priority** in `COLOR_THEME_TODO.md` - Native HM option)
- [ ] **gitui** - Git TUI (like lazygit)
- [ ] **gh** - GitHub CLI (Limited theming, uses terminal colors + GLAMOUR_STYLE env var)

---

## Priority 3: Advanced/Niche

### Desktop Advanced (Home Manager)
- [ ] **River** - Wayland compositor
- [ ] **dwm** - Suckless WM (requires patching)
- [ ] **xmonad** - Haskell-based WM
- [ ] **qtile** - Python-based WM
- [ ] **conky** - System info display

### System Editors (NixOS)
- [ ] **nano** - System-wide configuration
- [ ] **vim** - System-wide configuration

### System Tools (NixOS)
- [ ] **systemd-boot** - Alternative to GRUB
- [ ] **Qt theme** - System-wide Qt theming
- [ ] **Cursor theme** - Mouse cursor colors
- [ ] **dmenu** - System-wide launcher

### Advanced System (NixOS)
- [ ] **OpenRGB** - RGB lighting control
- [ ] **journalctl** - Log colors (if possible)
- [ ] **greetd** - Display manager with gtkgreet

### Terminal Emulators (Home Manager)
- [ ] **Terminator** - Multi-pane terminal
- [ ] **Contour** - Modern terminal emulator
- [ ] **xterm** - Classic X11 terminal

### Specialized (Home Manager)
- [ ] **Taskwarrior** - Task management
- [ ] **Newsboat** - RSS feed reader
- [ ] **Mutt/Neomutt** - Email client
- [ ] **Aerc** - Email client
- [ ] **w3m** - Terminal web browser

---

## Integration Workflow

When adding a new program to Signal:

### 1. Research Phase
- [ ] Check program's theming capabilities (colors, themes, config format)
- [ ] Find Home-Manager module and available options
- [ ] Determine appropriate tier (1-4) - see [Tier System](tier-system.md)
- [ ] Locate upstream schema documentation

### 2. Implementation Phase
- [ ] Create module in appropriate category: `modules/<category>/<program>.nix`
- [ ] Add **required metadata comment** (see below)
- [ ] Use `signalLib.shouldThemeApp` for conditional theming
- [ ] Map Signal semantic colors appropriately
- [ ] Support both light and dark modes

**Required Metadata Format**:
```nix
# CONFIGURATION METHOD: <tier-name>
# HOME-MANAGER MODULE: <module-path>
# UPSTREAM SCHEMA: <schema-url>
# SCHEMA VERSION: <version>
# LAST VALIDATED: <YYYY-MM-DD>
# NOTES: <additional-context>
```

### 3. Testing Phase
- [ ] Add test to `tests/comprehensive-test-suite.nix`
- [ ] Test with `autoEnable = true`
- [ ] Test manual enable/disable
- [ ] Verify colors in both light and dark modes
- [ ] Run `nix flake check`

### 4. Documentation Phase
- [ ] Add module import to `modules/common/default.nix`
- [ ] Update README.md supported applications list
- [ ] Update roadmap (move from TODO to completed)
- [ ] Add example configuration if needed

---

## Module Organization

```
modules/
├── cli/              # Command-line tools (bat, fzf, etc.)
├── desktop/          # Desktop apps & WM
│   ├── compositors/  # Wayland compositors (future)
│   ├── launchers/    # App launchers (fuzzel, rofi, etc.)
│   ├── notifications/# Notification daemons (future)
│   ├── bars/         # Status bars (future)
│   └── wm/           # X11 window managers (future)
├── editors/          # Text editors (helix, neovim, etc.)
├── terminals/        # Terminal emulators (kitty, alacritty, etc.)
├── multiplexers/     # Terminal multiplexers (tmux, zellij)
├── prompts/          # Shell prompts (starship, etc.)
├── shells/           # Shell integrations (zsh, fish, etc.)
├── monitors/         # System monitors (btop, htop, etc.)
├── browsers/         # Web browsers (future)
├── media/            # Media players (future)
├── communication/    # Chat/IRC clients (future)
├── gtk/              # GTK theming
└── nixos/            # NixOS system-level theming
    ├── boot/         # Boot loaders (GRUB, Plymouth)
    └── login/        # Display managers (SDDM, GDM, etc.)
```

---

## Difficult Cases

### Programs That Are Hard/Impossible to Theme
- **Electron apps** without custom CSS injection
- **Flatpak apps** (sandboxed, limited access)
- **Proprietary apps** without theming APIs
- **GTK4 apps** using libadwaita (heavily restricted)

### Alternative Approaches
- **GTK/Qt system themes** - Covers many GUI apps automatically
- **Terminal color schemes** - Many TUI apps respect terminal colors
- **XResources** - For legacy X11 applications

---

**Last Updated**: 2026-01-18  
**Total Programs Planned**: ~100+  
**Currently Supported**: 42+

## Additional Resources

### Documentation
- **Color Theme Research**: `docs/color-theme-research.md` (1260 lines)
  - Complete reference for how to theme every application
  - Configuration examples and format requirements
  - Organized by category with upstream documentation links

- **TODO Tracking**:
  - `.github/TODO.md` - Project roadmap and architecture improvements
  - `COLOR_THEME_TODO.md` - Detailed color theme implementation tracking
  - `.claude/todo-enhancement-summary.md` - Summary of recent enhancements

- **Implementation Research**:
  - `.claude/ghostty-implementation-research.md` - Terminal implementation case study
  - `.claude/gtk-theming-docs-research.md` - Complete GTK theming reference
  - `.claude/stylix-targets-research.md` - Stylix architecture analysis

### Architecture Inspiration
- **Stylix**: https://github.com/danth/stylix - Targets-based module architecture
- **nix-colors**: https://github.com/Misterio77/nix-colors - Ports library pattern for color mappings

### Testing & Development
- **nix-unit**: https://github.com/nix-community/nix-unit - Unit testing framework for Nix
- **nix-output-monitor**: https://github.com/maralorn/nix-output-monitor - Better build output visualization

### Color Theory & Accessibility
- **OKLCH**: https://evilmartians.com/chronicles/oklch-in-css-why-quit-rgb-hsl - Perceptually uniform color space
- **WCAG 2.1**: Contrast requirements (4.5:1 for text, 3:1 for UI)
- **Contrast Checker**: https://webaim.org/resources/contrastchecker/
- **Colorblind Simulator**: https://www.color-blindness.com/coblis-color-blindness-simulator/
