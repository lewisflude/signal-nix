# Signal Integration Roadmap

> **Comprehensive program coverage for Signal theming**

This document tracks all programs that should be themed by Signal, organized by category and priority.

## Current Status

**Supported Programs**: 42 modules across 12 categories (+14 new!)  
**Priority 0 Complete**: All critical desktop, editor, and shell integrations ✅  
**Latest Update**: 2026-01-17

---

## Completed Integrations

### ✅ Terminals (4/5 major)
- Alacritty (Tier 2) ✅
- Ghostty (Tier 3) ✅
- Kitty (Tier 3) ✅
- WezTerm (Tier 4) ✅
- **TODO**: Foot

### ✅ Editors (5/6 major) 🎉 NEW
- Helix (Tier 1) ✅
- Neovim (Tier 4) ✅
- Vim (Tier 4) ✅ NEW
- VS Code/VSCodium (Tier 2) ✅ NEW
- Emacs (Tier 4) ✅ NEW
- **TODO**: Zed

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
- delta (Tier 3) ✅
- eza (Tier 4) ✅
- fzf (Tier 4) ✅
- lazygit (Tier 3) ✅
- yazi (Tier 3) ✅
- less (Tier 5) ✅ NEW
- ripgrep (Tier 5) ✅ NEW
- **TODO**: bottom, more...

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
- GTK Theme package ✅
- **TODO**: Qt theme, systemd-boot

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

### Desktop/WM (Home Manager)
- [ ] **bspwm** - Binary space partitioning WM
- [ ] **awesome** - Lua-based window manager
- [ ] **mako** - Wayland notification daemon
- [ ] **wofi** - Wayland launcher alternative
- [ ] **polybar** - Popular X11 status bar
- [ ] **picom** - X11 compositor

### Terminals (Home Manager)
- [ ] **foot** - Minimal Wayland terminal
- [ ] **Rio** - GPU-accelerated terminal
- [ ] **st** - Suckless simple terminal

### File Managers (Home Manager)
- [ ] **ranger** - Vim-like file manager
- [ ] **lf** - Fast lightweight file manager
- [ ] **nnn** - Blazing fast file manager
- [ ] **Thunar** - XFCE file manager (GTK)
- [ ] **Nautilus** - GNOME file manager (GTK)
- [ ] **Dolphin** - KDE file manager (Qt)

### System Monitors (Home Manager)
- [ ] **bottom (btm)** - Modern resource monitor
- [ ] **glances** - Cross-platform system monitor

### Development (Home Manager)
- [x] **lazydocker** - Docker TUI (like lazygit) ✅ RE-ENABLED
- [x] **glow** - Markdown viewer ✅
- [ ] **gdb** - GNU debugger with colors
- [ ] **jq** - JSON processor with colors

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
- [ ] **mpv** - Video player OSD
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
- [ ] **direnv** - Environment switcher
- [ ] **atuin** - Shell history manager
- [ ] **tealdeer (tldr)** - Man page alternative
- [ ] **procs** - Modern ps replacement
- [ ] **duf** - Modern df replacement
- [ ] **dust** - Modern du replacement

### Git Tools (Home Manager)
- [ ] **tig** - Text-mode git interface
- [ ] **gitui** - Git TUI (like lazygit)
- [ ] **gh** - GitHub CLI (may not be themeable)

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

**Last Updated**: 2026-01-17
**Total Programs Planned**: ~100+
**Currently Supported**: 20+
