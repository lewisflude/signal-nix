# Theming Reference Guide

> Comprehensive documentation for theming and styling all supported and potential Signal applications.

This reference organizes theming documentation by application category, making it easy to find styling information when implementing new modules or customizing existing ones.

## Table of Contents

- [Desktop Environment](#desktop-environment)
- [Terminals](#terminals)
- [Editors](#editors)
- [Shell Prompts](#shell-prompts)
- [Shells](#shells)
- [Terminal Multiplexers](#terminal-multiplexers)
- [File Managers](#file-managers)
- [System Monitors](#system-monitors)
- [CLI Tools](#cli-tools)
- [Version Control](#version-control)
- [Application Launchers](#application-launchers)
- [Notification Systems](#notification-systems)
- [Browsers](#browsers)
- [Document Viewers](#document-viewers)
- [Email Clients](#email-clients)
- [Media Players](#media-players)
- [Image Viewers](#image-viewers)
- [Communication](#communication)
- [Productivity](#productivity)
- [Lock & Idle](#lock--idle)

---

## Desktop Environment

### 🟢 Ironbar
**Status:** ✅ Implemented  
**Category:** Wayland status bar  
**Documentation:** [Ironbar Styling Guide](https://github.com/JakeStanger/ironbar/wiki/Styling-Guide)  
**Format:** CSS  
**Notes:** 
- CSS-based styling with GTK widgets
- Supports custom stylesheets
- Signal includes 3 display profiles (compact, relaxed, spacious)

### 🟢 GTK 3/4
**Status:** ✅ Implemented  
**Category:** Application framework theming  
**Documentation:** [GTK CSS Overview](https://docs.gtk.org/gtk3/css-overview.html)  
**Format:** CSS  
**Notes:**
- Core foundation for many Linux applications
- CSS selectors for widget styling
- Signal supports both GTK3 and GTK4

### 🔴 Waybar
**Status:** ❌ Not implemented  
**Category:** Wayland status bar  
**Documentation:** [Waybar Styling](https://github.com/Alexays/Waybar/wiki/Styling)  
**Format:** CSS  
**Notes:** Alternative to Ironbar, similar CSS-based styling

### 🔴 Hyprland
**Status:** ❌ Not implemented  
**Category:** Wayland compositor  
**Documentation:** [Hyprland Decoration Variables](https://wiki.hyprland.org/Configuring/Variables/#decoration)  
**Format:** Hyprland config  
**Notes:** Focus on decoration, blur, shadows, animations

### 🔴 Ags (Aylur's GTK Shell)
**Status:** ❌ Not implemented  
**Category:** Widget system  
**Documentation:** [Ags Styling](https://aylur.github.io/ags-docs/config/styling/)  
**Format:** SCSS/CSS  
**Notes:** GTK-based, uses SCSS for styling

### 🔴 Eww
**Status:** ❌ Not implemented  
**Category:** Widget system  
**Documentation:** [Eww Styling](https://elkowar.github.io/eww/configuration.html#styling)  
**Format:** CSS  
**Notes:** ElKowar's Wacky Widgets, CSS-based

---

## Terminals

### 🟢 Ghostty
**Status:** ✅ Implemented  
**Category:** Modern terminal emulator  
**Documentation:** [Ghostty Theme Documentation](https://ghostty.org/docs/features/theme)  
**Format:** Ghostty config  
**Notes:**
- Full ANSI color palette support
- 16-color + special colors (cursor, selection, etc.)
- Native theme support

### 🟢 Alacritty
**Status:** ✅ Implemented  
**Category:** GPU-accelerated terminal  
**Documentation:** [Alacritty Color Configuration](https://alacritty.org/config-alacritty.html)  
**Format:** TOML  
**Notes:**
- Complete color scheme configuration
- Primary colors + cursor + selection + normal/bright variants

### 🟢 Kitty
**Status:** ✅ Implemented  
**Category:** Feature-rich terminal  
**Documentation:** [Kitty Color Scheme](https://sw.kovidgoyal.net/kitty/conf/#color-scheme)  
**Format:** Kitty config  
**Notes:**
- 16 colors + tab bar customization
- Supports theme files

### 🟢 WezTerm
**Status:** ✅ Implemented  
**Category:** Lua-configured terminal  
**Documentation:** [WezTerm Appearance](https://wezfurlong.org/wezterm/config/appearance.html)  
**Format:** Lua  
**Notes:**
- Full theme configuration in Lua
- Tab bar and window styling
- Rich customization options

### 🔴 Foot
**Status:** ❌ Not implemented  
**Category:** Wayland terminal  
**Documentation:** [Foot Colors](https://man.archlinux.org/man/foot.ini.5#COLORS)  
**Format:** INI  
**Notes:** Fast, minimal Wayland terminal

### 🔴 Rio
**Status:** ❌ Not implemented  
**Category:** Hardware-accelerated terminal  
**Documentation:** [Rio Custom Themes](https://raphamorim.io/rio/docs/custom-themes)  
**Format:** TOML  
**Notes:** Built on GPU acceleration

---

## Editors

### 🟢 Helix
**Status:** ✅ Implemented  
**Category:** Modal editor  
**Documentation:** [Helix Themes](https://docs.helix-editor.com/themes.html)  
**Format:** TOML  
**Notes:**
- Comprehensive theme with palette structure
- Supports syntax highlighting, UI elements, diagnostics
- Modifiers for bold, italic, underline

### 🟢 Neovim
**Status:** ✅ Implemented  
**Category:** Vim-based editor  
**Documentation:** [Neovim Syntax](https://neovim.io/doc/user/syntax.html)  
**Format:** Vimscript/Lua  
**Notes:** 
- Full Lua colorscheme with Signal colors
- Comprehensive Treesitter support
- LSP semantic tokens
- Git integration (GitSigns)
- Diagnostics styling

### 🔴 Micro
**Status:** ❌ Not implemented  
**Category:** Modern terminal editor  
**Documentation:** [Micro Colors](https://github.com/zyedidia/micro/blob/master/runtime/help/colors.md)  
**Format:** YAML  
**Notes:** Simple, intuitive color configuration

### 🔴 Kakoune
**Status:** ❌ Not implemented  
**Category:** Modal editor  
**Documentation:** [Kakoune Faces](https://github.com/mawww/kakoune/blob/master/doc/pages/faces.asciidoc)  
**Format:** Kakoune config  
**Notes:** Selection-based editing, face system

### 🔴 Vis
**Status:** ❌ Not implemented  
**Category:** Vim-like editor  
**Documentation:** [Vis Themes](https://github.com/martanne/vis/wiki/Themes)  
**Format:** Lua  
**Notes:** Combines modal editing with structural regex

---

## Shell Prompts

### 🟢 Starship
**Status:** ✅ Implemented  
**Category:** Cross-shell prompt  
**Documentation:** [Starship Styling](https://starship.rs/config/#styling)  
**Format:** TOML  
**Notes:**
- Custom palette configuration
- Git integration and module styling
- Format string styling

---

## Shells

### 🟢 Zsh
**Status:** ✅ Implemented  
**Category:** Z Shell  
**Documentation:** [Zsh Prompt Expansion - Visual Effects](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Visual-effects)  
**Format:** Zsh config  
**Notes:**
- Syntax highlighting colors via zsh-syntax-highlighting
- Prompt colors via escape codes

### 🔴 Fish
**Status:** ❌ Not implemented  
**Category:** Friendly shell  
**Documentation:** [Fish Syntax Highlighting](https://fishshell.com/docs/current/interactive.html#syntax-highlighting)  
**Format:** Fish config  
**Notes:** Interactive features, built-in syntax highlighting

### 🔴 Nushell
**Status:** ❌ Not implemented  
**Category:** Structured shell  
**Documentation:** [Nushell Coloring and Theming](https://www.nushell.sh/book/coloring_and_theming.html)  
**Format:** Nu config  
**Notes:** Data-oriented shell with structured theming

---

## Terminal Multiplexers

### 🟢 tmux
**Status:** ✅ Implemented  
**Category:** Terminal multiplexer  
**Documentation:** [tmux Customization](https://github.com/tmux/tmux/wiki/Getting-Started#customizing-tmux)  
**Format:** tmux config  
**Notes:**
- Status bar styling
- Pane and window colors
- Message and command line styling

### 🟢 Zellij
**Status:** ✅ Implemented  
**Category:** Modern multiplexer  
**Documentation:** [Zellij Themes](https://zellij.dev/documentation/themes)  
**Format:** KDL  
**Notes:**
- Comprehensive theme in KDL format
- UI elements and tab styling

---

## File Managers

### 🟢 Yazi
**Status:** ✅ Implemented  
**Category:** Terminal file manager  
**Documentation:** [Yazi Theme Configuration](https://yazi-rs.github.io/docs/configuration/theme/)  
**Format:** TOML  
**Notes:**
- Complete theme covering manager, status, tabs, select
- File type styling

### 🔴 Ranger
**Status:** ❌ Not implemented  
**Category:** Vim-like file manager  
**Documentation:** [Ranger Colorschemes](https://github.com/ranger/ranger/blob/master/doc/colorschemes.md)  
**Format:** Python  
**Notes:** Python-based colorscheme system

### 🔴 LF
**Status:** ❌ Not implemented  
**Category:** Terminal file manager  
**Documentation:** [LF Colors](https://github.com/gokcehan/lf/blob/master/doc.md#colors)  
**Format:** LF config  
**Notes:** Fast, minimal file manager

### 🔴 Vifm
**Status:** ❌ Not implemented  
**Category:** Vi-like file manager  
**Documentation:** [Vifm Colorschemes](https://vifm.info/colorschemes.shtml)  
**Format:** Vifm config  
**Notes:** Two-pane file manager, Vi key bindings

---

## System Monitors

### 🟢 btop++
**Status:** ✅ Implemented  
**Category:** Resource monitor  
**Documentation:** [btop Theming](https://github.com/aristocratos/btop#theming)  
**Format:** btop theme file  
**Notes:**
- Complete theme with gradient support
- CPU, memory, network, process styling

### 🔴 Glances
**Status:** ❌ Not implemented  
**Category:** Cross-platform monitor  
**Documentation:** [Glances Config](https://glances.readthedocs.io/en/latest/config.html#syntax)  
**Format:** INI  
**Notes:** Python-based, web interface support

### 🔴 Nvtop
**Status:** ❌ Not implemented  
**Category:** GPU monitor  
**Documentation:** [Nvtop Colors](https://github.com/Syllo/nvtop#colors)  
**Format:** Nvtop config  
**Notes:** NVIDIA GPU monitoring

### 🔴 Bottom
**Status:** ❌ Not implemented  
**Category:** Process/system monitor  
**Documentation:** [Bottom Customization](https://github.com/ClementTsang/bottom#customization)  
**Format:** TOML  
**Notes:** Rust-based, customizable layout

### 🔴 Gdu
**Status:** ❌ Not implemented  
**Category:** Disk usage analyzer  
**Documentation:** [Gdu Styling](https://github.com/dundee/gdu?tab=readme-ov-file#styling)  
**Format:** Gdu config  
**Notes:** Fast disk usage with styling support

### 🔴 Dust
**Status:** ❌ Not implemented  
**Category:** Disk usage  
**Documentation:** [Dust Config](https://github.com/bootandy/dust?tab=readme-ov-file#config-file)  
**Format:** TOML  
**Notes:** Alternative to du, graphical output

### 🔴 Procs
**Status:** ❌ Not implemented  
**Category:** Process viewer  
**Documentation:** [Procs Configuration](https://github.com/dalance/procs?tab=readme-ov-file#configuration)  
**Format:** TOML  
**Notes:** Modern ps replacement

---

## CLI Tools

### 🟢 bat
**Status:** ✅ Implemented  
**Category:** Cat replacement  
**Documentation:** [bat Custom Themes](https://github.com/sharkdp/bat#customizing-the-theme)  
**Format:** tmTheme (XML)  
**Notes:**
- Syntax highlighting with custom themes
- TextMate theme format (.tmTheme)

### 🟢 fzf
**Status:** ✅ Implemented  
**Category:** Fuzzy finder  
**Documentation:** [fzf Color Scheme](https://github.com/junegunn/fzf#color-scheme)  
**Format:** Environment variables  
**Notes:**
- Complete color configuration via FZF_DEFAULT_OPTS
- Prompt, cursor, selection, match colors

### 🟢 Delta
**Status:** ✅ Implemented  
**Category:** Git diff viewer  
**Documentation:** [Delta Custom Themes](https://dandavison.github.io/delta/custom-themes.html)  
**Format:** Git config  
**Notes:** 
- Syntax-highlighted diffs with Signal theme
- Line numbers with Signal accent colors
- File and commit decorations
- Hunk headers with Signal styling
- Merge conflict visualization
- Blame palette with categorical colors

### 🔴 Ripgrep
**Status:** ❌ Not implemented  
**Category:** Search tool  
**Documentation:** [Ripgrep Colors Guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#colors)  
**Format:** Environment variables  
**Notes:** Fast search with color customization

### 🟢 Eza
**Status:** ✅ Implemented  
**Category:** Modern ls  
**Documentation:** [Eza Colors](https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md)  
**Format:** Environment variables  
**Notes:** 
- Comprehensive file type colors
- Permission colors (user/group/other)
- Git status indicators with Signal accent colors
- Git repo status (clean/dirty, branches)
- File categories with Signal categorical colors
- Size and date styling

### 🔴 Broot
**Status:** ❌ Not implemented  
**Category:** Directory navigator  
**Documentation:** [Broot Skins](https://dystroy.org/broot/skins/)  
**Format:** HJSON  
**Notes:** Tree view with fuzzy search

### 🔴 Glow
**Status:** ❌ Not implemented  
**Category:** Markdown renderer  
**Documentation:** [Glow Configuration](https://github.com/charmbracelet/glow#configuration)  
**Format:** JSON/YAML  
**Notes:** Glamorous terminal markdown

### 🔴 Slides
**Status:** ❌ Not implemented  
**Category:** Terminal presentations  
**Documentation:** [Slides Theme](https://github.com/maaslalani/slides#theme)  
**Format:** JSON  
**Notes:** Markdown-based presentations

### 🔴 Gum
**Status:** ❌ Not implemented  
**Category:** Shell script UI  
**Documentation:** [Gum Customization](https://github.com/charmbracelet/gum#customization)  
**Format:** Command flags/env  
**Notes:** Charmbracelet UI components

### 🔴 Tealdeer
**Status:** ❌ Not implemented  
**Category:** tldr client  
**Documentation:** [Tealdeer Style Config](https://dbrgn.github.io/tealdeer/config.html#style)  
**Format:** TOML  
**Notes:** Fast tldr implementation

### 🔴 Atuin
**Status:** ❌ Not implemented  
**Category:** Shell history  
**Documentation:** [Atuin Style](https://docs.atuin.sh/configuration/config/#style)  
**Format:** TOML  
**Notes:** Magical shell history with sync

### 🔴 Fastfetch
**Status:** ❌ Not implemented  
**Category:** System info  
**Documentation:** [Fastfetch Logo Customization](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration#customizing-logos)  
**Format:** JSON  
**Notes:** Fast neofetch alternative

---

## Version Control

### 🟢 lazygit
**Status:** ✅ Implemented  
**Category:** Git TUI  
**Documentation:** [lazygit Color Configuration](https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#color-configuration)  
**Format:** YAML  
**Notes:**
- Comprehensive theme configuration
- Panel, status, and text colors

### 🔴 GitUI
**Status:** ❌ Not implemented  
**Category:** Git TUI  
**Documentation:** [GitUI Theme](https://github.com/extrawurst/gitui/blob/master/THEME.md)  
**Format:** RON  
**Notes:** Fast, Rust-based Git interface

### 🔴 Tig
**Status:** ❌ Not implemented  
**Category:** Git repository browser  
**Documentation:** [Tig Colors](https://jonas.github.io/tig/doc/tigrc.5.html#_colors)  
**Format:** tigrc  
**Notes:** Text-mode interface for Git

### 🔴 Lazydocker
**Status:** ❌ Not implemented  
**Category:** Docker TUI  
**Documentation:** [Lazydocker Config](https://github.com/jesseduffield/lazydocker/blob/master/docs/Config.md)  
**Format:** YAML  
**Notes:** Similar to lazygit but for Docker

---

## Application Launchers

### 🟢 Fuzzel
**Status:** ✅ Implemented  
**Category:** Wayland application launcher  
**Documentation:** [Fuzzel Colors](https://codeberg.org/dnkl/fuzzel/src/branch/master/doc/fuzzel.ini.5.scd#colors)  
**Format:** INI  
**Notes:**
- Wayland-native launcher
- Background, text, selection, border colors

### 🔴 Rofi
**Status:** ❌ Not implemented  
**Category:** Application launcher  
**Documentation:** [Rofi Theme](https://github.com/davatorium/rofi/blob/next/doc/rofi-theme.5.markdown)  
**Format:** Rasi (custom CSS-like)  
**Notes:** Highly customizable launcher

### 🔴 Wofi
**Status:** ❌ Not implemented  
**Category:** Wayland launcher  
**Documentation:** [Wofi CSS Selectors](https://man.archlinux.org/man/wofi.5#CSS_SELECTORS)  
**Format:** CSS  
**Notes:** Wayland clone of Rofi

### 🔴 Bemenu
**Status:** ❌ Not implemented  
**Category:** Dynamic menu  
**Documentation:** [Bemenu Options](https://man.archlinux.org/man/bemenu.1#OPTIONS)  
**Format:** Command-line options  
**Notes:** dmenu clone for Wayland/X11

---

## Notification Systems

### 🔴 SwayNC
**Status:** ❌ Not implemented  
**Category:** Notification center  
**Documentation:** [SwayNC Styling](https://github.com/ErikReider/SwayNotificationCenter/blob/main/docs/styling.md)  
**Format:** CSS  
**Notes:** Notification center for Sway

### 🔴 Mako
**Status:** ❌ Not implemented  
**Category:** Notification daemon  
**Documentation:** [Mako Style](https://github.com/emersion/mako/blob/master/mako.5.scd#style)  
**Format:** Mako config  
**Notes:** Lightweight Wayland notifications

### 🔴 Dunst
**Status:** ❌ Not implemented  
**Category:** Notification daemon  
**Documentation:** [Dunst Styling](https://dunst-project.org/documentation/#styling)  
**Format:** Dunst config  
**Notes:** X11/Wayland notification daemon

### 🔴 SwayOSD
**Status:** ❌ Not implemented  
**Category:** On-screen display  
**Documentation:** [SwayOSD Styling](https://github.com/ErikReider/SwayOSD?tab=readme-ov-file#styling)  
**Format:** CSS  
**Notes:** OSD for brightness/volume

### 🔴 Wlogout
**Status:** ❌ Not implemented  
**Category:** Logout menu  
**Documentation:** [Wlogout Style](https://github.com/ArtsyMacaw/wlogout/blob/master/style.css)  
**Format:** CSS  
**Notes:** Wayland logout menu with styling

---

## Lock & Idle

### 🔴 Hyprlock
**Status:** ❌ Not implemented  
**Category:** Screen locker  
**Documentation:** [Hyprlock Styling](https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#styling)  
**Format:** Hyprlock config  
**Notes:** Screen locker for Hyprland

### 🔴 Hypridle
**Status:** ❌ Not implemented  
**Category:** Idle daemon  
**Documentation:** [Hypridle](https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/)  
**Format:** Hypridle config  
**Notes:** Idle management for Hyprland

---

## Browsers

### 🔴 Qutebrowser
**Status:** ❌ Not implemented  
**Category:** Keyboard-driven browser  
**Documentation:** [Qutebrowser Colors](https://qutebrowser.org/doc/help/configuring.html#colors)  
**Format:** Python config  
**Notes:** Vim-like browser with extensive theming

### 🔴 Nyxt
**Status:** ❌ Not implemented  
**Category:** Keyboard-driven browser  
**Documentation:** [Nyxt Theming](https://nyxt.atlas.engineer/documentation#theming)  
**Format:** Lisp  
**Notes:** Extensible browser in Common Lisp

---

## Document Viewers

### 🔴 Zathura
**Status:** ❌ Not implemented  
**Category:** PDF viewer  
**Documentation:** [Zathura Configuration](https://manpages.debian.org/unstable/zathura/zathurarc.5.en.html#CONFIGURATION)  
**Format:** zathurarc  
**Notes:** Vim-like PDF viewer

### 🔴 Sioyek
**Status:** ❌ Not implemented  
**Category:** PDF viewer  
**Documentation:** [Sioyek Visual Customization](https://sioyek-documentation.readthedocs.io/en/latest/configuration.html#visual-customization)  
**Format:** Sioyek config  
**Notes:** Academic PDF reader

---

## Email Clients

### 🔴 Aerc
**Status:** ❌ Not implemented  
**Category:** Email client  
**Documentation:** [Aerc UI Configuration](https://man.archlinux.org/man/aerc-config.5#UI_CONFIGURATION)  
**Format:** INI  
**Notes:** Terminal email client

### 🔴 NeoMutt
**Status:** ❌ Not implemented  
**Category:** Email client  
**Documentation:** [NeoMutt Color](https://neomutt.org/guide/configuration.html#color)  
**Format:** Muttrc  
**Notes:** Powerful email client with theming

---

## Media Players

### 🔴 Spotify-player
**Status:** ❌ Not implemented  
**Category:** Spotify TUI  
**Documentation:** [Spotify-player Theme Config](https://github.com/aome510/spotify-player/blob/master/docs/config.md#theme_config)  
**Format:** TOML  
**Notes:** Terminal Spotify client

### 🔴 Cmus
**Status:** ❌ Not implemented  
**Category:** Music player  
**Documentation:** [Cmus Theming](https://github.com/cmus/cmus/blob/master/Doc/cmus.txt#L560)  
**Format:** cmus commands  
**Notes:** Terminal music player

### 🔴 Ncmpcpp
**Status:** ❌ Not implemented  
**Category:** MPD client  
**Documentation:** [Ncmpcpp Config](https://github.com/ncmpcpp/ncmpcpp/blob/master/doc/config#L368)  
**Format:** ncmpcpp config  
**Notes:** Feature-rich MPD client

### 🔴 Mpv
**Status:** ❌ Not implemented  
**Category:** Media player  
**Documentation:** [Mpv OSC](https://mpv.io/manual/master/#on-screen-controller)  
**Format:** mpv.conf / Lua  
**Notes:** Powerful media player with OSD theming

### 🔴 Newsboat
**Status:** ❌ Not implemented  
**Category:** RSS reader  
**Documentation:** [Newsboat Colors](https://newsboat.org/releases/2.40/docs/newsboat.html#_configuring_colors)  
**Format:** newsboat config  
**Notes:** Terminal RSS reader

### 🔴 Cava
**Status:** ❌ Not implemented  
**Category:** Audio visualizer  
**Documentation:** [Cava Configuration](https://github.com/karlstav/cava#configuration)  
**Format:** Cava config  
**Notes:** Console audio visualizer

---

## Image Viewers

### 🔴 Imv
**Status:** ❌ Not implemented  
**Category:** Image viewer  
**Documentation:** [Imv Configuration](https://man.archlinux.org/man/imv.5#CONFIGURATION)  
**Format:** imv config  
**Notes:** Wayland/X11 image viewer

### 🔴 Nsxiv
**Status:** ❌ Not implemented  
**Category:** Image viewer  
**Documentation:** [Nsxiv X Resources](https://man.archlinux.org/man/nsxiv.1#X_RESOURCES)  
**Format:** X resources  
**Notes:** Neo Simple X Image Viewer

---

## Communication

### 🔴 WeeChat
**Status:** ❌ Not implemented  
**Category:** IRC client  
**Documentation:** [WeeChat Quickstart](https://weechat.org/files/doc/stable/weechat_quickstart.en.html#key_bindings_and_mouse)  
**Format:** WeeChat config  
**Notes:** Extensible chat client

### 🔴 Bluetuith
**Status:** ❌ Not implemented  
**Category:** Bluetooth manager  
**Documentation:** [Bluetuith Theme](https://github.com/darkhz/bluetuith?tab=readme-ov-file#theme-configuration)  
**Format:** TOML  
**Notes:** Bluetooth TUI manager

---

## Productivity

### 🔴 K9s
**Status:** ❌ Not implemented  
**Category:** Kubernetes TUI  
**Documentation:** [K9s Skins](https://k9scli.io/topics/skins/)  
**Format:** YAML  
**Notes:** Kubernetes cluster management

### 🔴 Taskwarrior-tui
**Status:** ❌ Not implemented  
**Category:** Task manager  
**Documentation:** [Taskwarrior-tui Config](https://github.com/kdheepak/taskwarrior-tui?tab=readme-ov-file#configuration)  
**Format:** TOML  
**Notes:** TUI for Taskwarrior

### 🔴 Calcurse
**Status:** ❌ Not implemented  
**Category:** Calendar  
**Documentation:** [Calcurse Config Files](https://calcurse.org/files/manual.html#_config_files)  
**Format:** calcurse config  
**Notes:** Terminal calendar and organizer

---

## Implementation Guide

### Priority Order for New Modules

When implementing new application modules, consider this priority based on Signal's current focus:

**High Priority** (Core desktop/development tools):
1. Waybar (Ironbar alternative)
2. Rofi/Wofi (Fuzzel alternatives)
3. Hyprland (Compositor integration)

**Medium Priority** (Extended tooling):
1. GitUI/Tig (Git workflow)
2. Ranger/LF (Alternative file managers)
3. Fish/Nushell (Alternative shells)
4. Qutebrowser (Browser theming)
5. Notification systems (Mako/Dunst/SwayNC)

**Low Priority** (Specialized tools):
1. Media players
2. Email clients
3. Document viewers
4. Specialized monitors

### Module Implementation Checklist

When adding a new application module:

- [ ] Read the official theming documentation
- [ ] Identify the configuration format (TOML, CSS, INI, etc.)
- [ ] Map Signal color tokens to application color slots
- [ ] Support both light and dark modes
- [ ] Add enable option under appropriate category
- [ ] Test color contrast and accessibility
- [ ] Add example configuration to examples/
- [ ] Update main README.md with new application
- [ ] Document any application-specific considerations

### Color Mapping Strategy

Signal uses OKLCH-based color tokens. When mapping to applications:

1. **Background hierarchy**: Use surface variants (surface, surface-container, surface-bright)
2. **Text hierarchy**: Use on-surface variants for proper contrast
3. **Interactive elements**: Use primary/secondary for actions
4. **Status colors**: Map error/warning/success to appropriate application concepts
5. **Syntax highlighting**: Use decorative colors for code elements
6. **Preserve accessibility**: Always maintain APCA-compliant contrast ratios

### Testing Recommendations

For each new module:
- Test light and dark mode switching
- Verify accessibility with APCA tools
- Check color consistency across similar elements
- Ensure proper contrast for all text
- Test with the 3 Ironbar profiles if relevant (different DPI scenarios)

---

## Contributing

When contributing new application integrations:

1. Follow the existing module structure in `/modules`
2. Use `signalLib.resolveThemeMode` for theme resolution
3. Test with both light and dark modes
4. Ensure accessibility compliance
5. Add comprehensive comments in the module
6. Update this reference document

For questions or suggestions, see [CONTRIBUTING.md](../CONTRIBUTING.md).

---

## Legend

- 🟢 **Implemented**: ✅ Full Signal integration available
- 🔴 **Not Implemented**: ❌ Planned or potential integration
- **Status**: Current implementation state
- **Category**: Application type/purpose
- **Documentation**: Official theming documentation link
- **Format**: Configuration file format
- **Notes**: Special considerations or features
