# Color Theme Implementation TODO

Based on research in `docs/color-theme-research.md`, this document tracks implementation of theming support for additional applications.

## Implementation Progress

### ✅ Completed Modules (50+)

**Terminals (5/5):** Alacritty, Foot, Ghostty, Kitty, WezTerm  
**CLI Tools (12):** Bat, Delta, Eza, Fzf, Glow, Lazydocker, Lazygit, Less, Ripgrep, Tealdeer, Tig, Yazi  
**Monitors (3):** Bottom, Btop++, Htop  
**File Managers (3):** Lf, Nnn, Ranger  
**Desktop Bars (3):** Ironbar, Polybar, Waybar  
**Launchers (4):** Dmenu, Fuzzel, Rofi, Tofi, Wofi  
**Notifications (3):** Dunst, Mako, SwayNC  
**Compositors (2):** Hyprland, Sway  
**Window Managers (3):** Awesome, Bspwm, i3  
**Editors (5):** Emacs, Helix, Neovim, Vim, VSCode  
**Multiplexers (2):** Tmux, Zellij  
**Shells (4):** Bash, Fish, Nushell, Zsh  
**Prompts (1):** Starship  
**Browsers (2):** Firefox, Qutebrowser  
**NixOS Boot (3):** Console, GRUB, Plymouth  
**NixOS Login (3):** GDM, LightDM, SDDM  
**System Theming (2):** GTK, Qt

**Total: ~57 applications with theming support!**

### 📋 Remaining High-Value TODOs

The following items from the original TODO remain unimplemented and would provide value:

**High Priority (Native HM Options):**
- MangoHud (gaming overlay)
- Swaylock (screen locker)
- MPV (media player OSD/subtitles)

**Medium Priority (Config Files):**
- Zed Editor (modern code editor)
- Zsh Syntax Highlighting
- Powerlevel10k (prompt theme)
- Procs (process monitor)
- Niri (window manager)
- Swayimg (image viewer)
- Satty (screenshot annotation)

**Lower Priority (Complex/External):**
- Chromium (via extensions)
- Discord/Vencord (client mod themes)
- Telegram Desktop (.tdesktop-theme files)
- Steam (skins)
- GIMP, Aseprite (custom themes)

## High Priority - Applications with Native HM Options

### Terminal Emulators  
✅ **All major terminals implemented!**
- [x] **Alacritty** - ✅ Module: `modules/terminals/alacritty.nix`
- [x] **Foot** - ✅ Module: `modules/terminals/foot.nix`
- [x] **Ghostty** - ✅ Module: `modules/terminals/ghostty.nix`
  - Research: `.claude/ghostty-implementation-research.md`
- [x] **Kitty** - ✅ Module: `modules/terminals/kitty.nix`
- [x] **WezTerm** - ✅ Module: `modules/terminals/wezterm.nix`

### CLI Developer Tools
- [x] **Git Delta** - ✅ Module: `modules/cli/delta.nix`
  - Syntax theme selection (supports many bat themes)
  - Diff colors: minus/plus styles with background colors
  - Line number colors (left/right margins)
  - Hunk header styling (decorations)

- [x] **Tig** - ✅ Module: `modules/cli/tig.nix`
  - Status colors (current item, title, etc.)
  - Diff colors (add/delete/chunk)
  - Graph colors (commit graph visualization)
  - Title/cursor colors for active selection

- [x] **Tealdeer** - ✅ Module: `modules/cli/tealdeer.nix`
  - Description colors (main content text)
  - Command name styling (bold, colors)
  - Example text colors (usage examples)
  - Example variable colors (placeholder text)
  - **Configuration tier**: 2 (Color Settings)
  - **Format**: Structured TOML with foreground/background/bold/underline
  - **Upstream docs**: https://dbrgn.github.io/tealdeer/config.html
  - **Use case**: Styled `tldr` pages for quick command help

### System Tools
- [ ] **MangoHud** - Add module for `programs.mangohud.settings`
  - Background color/alpha (overlay transparency)
  - Text color (stats labels)
  - Component colors: GPU, CPU, VRAM, RAM (individual metric colors)
  - Frametime colors (performance graph)
  - **Configuration tier**: 3 (Freeform Settings)
  - **Format**: Hex colors without `#` prefix, alpha as separate value (0.0-1.0)
  - **Upstream docs**: https://github.com/flightlessmango/MangoHud#configuration
  - **Platform**: Linux only, Vulkan/OpenGL overlays for gaming
  - **Integration**: Works with Steam, native games, Wine/Proton
  - **Example**: `background_color = "1a1a2e"`, `background_alpha = 0.8`

### Lock Screen
- [ ] **Swaylock** - Add module for `programs.swaylock.settings`
  - Ring colors: normal, clear, verify, wrong (authentication states)
  - Inside colors: fill color for each state
  - Text colors: text on buttons for each state
  - Key highlight colors: backspace and enter key highlighting
  - **Configuration tier**: 3 (Freeform Settings)
  - **Format**: Hex colors without `#` prefix (e.g., `"ring-color" = "3b82f6"`)
  - **Upstream docs**: `man swaylock`
  - **Security**: Wayland-only, works with Sway, Hyprland, other compositors
  - **States**: 
    - normal: idle/waiting for input
    - clear: clearing password input (shows while backspacing)
    - verify: checking authentication (shows during auth check)
    - wrong: failed authentication (shows on wrong password)
  - **Color strategy**: Use warning/danger accent colors for wrong state, primary for verify

### Media
- [ ] **MPV** - Add module for `programs.mpv.config`
  - OSD colors (on-screen display: play/pause, volume, time)
  - Subtitle colors (text, border, background)
  - Border colors (window borders in borderless mode)
  - OSC theme support via script-opts (modern UI skin)
  - **Configuration tier**: 3 (Freeform Settings)
  - **Format**: Hex with alpha: `#RRGGBBAA` for semi-transparency
  - **Upstream docs**: https://mpv.io/manual/stable/
  - **OSC theming**: Separate config file in `script-opts/osc.conf` for UI controls
  - **Cross-platform**: Works on Linux, macOS, Windows
  - **Example**: `osd-color = "#e8e8e8"`, `osd-back-color = "#1a1a2e80"` (50% opacity)

### System Monitors
- [x] **Htop** - ✅ Module: `modules/monitors/htop.nix`
  - Color scheme selection (0-6 presets only)
  - **Note**: Limited to presets, but implemented with best available option

- [x] **Btop++** - ✅ Module: `modules/monitors/btop.nix`
  - Complete theme file generation with all color options

- [x] **Bottom** - ✅ Module: `modules/monitors/bottom.nix`

## Medium Priority - Config File Based Theming

These applications don't have native Home Manager color options but can be themed via config files managed by `xdg.configFile` or similar mechanisms.

### Code Editors
- [ ] **Zed Editor** - Add module with `xdg.configFile` for settings.json
  - Theme selection (choose from built-in themes)
  - Experimental theme overrides (preview feature)
  - Custom theme file support (full theme creation)
  - **Configuration tier**: 3 (Config File)
  - **Format**: JSON configuration file
  - **Upstream docs**: https://zed.dev/docs/themes
  - **Theme location**: `~/.config/zed/themes/`
  - **Settings location**: `~/.config/zed/settings.json`
  - **Features**: Full syntax highlighting control, UI element colors, terminal colors
  - **Implementation approach**:
    - Generate custom theme JSON with Signal colors
    - Place in themes directory
    - Set theme name in settings.json
  - **Example theme structure**:
    ```json
    {
      "$schema": "https://zed.dev/schema/themes/v0.1.0.json",
      "name": "Signal Theme",
      "author": "Signal Design System",
      "themes": [{
        "name": "Signal Dark",
        "appearance": "dark",
        "style": {
          "background": "#1a1a2e",
          "foreground": "#e8e8e8",
          // ... more colors
        }
      }]
    }
    ```

### CLI Tools
- [x] **Ripgrep** - ✅ Module: `modules/cli/ripgrep.nix`
  - Environment variable-based (RIPGREP_COLORS)
  - Line, path, and match colors

- [x] **Eza** - ✅ Module: `modules/cli/eza.nix`
  - Environment variable-based (EZA_COLORS)
  - File kinds, permissions, extensions

- [x] **Glow** - ✅ Module: `modules/cli/glow.nix`
  - JSON style file generation
  - Markdown rendering colors

- [x] **Less** - ✅ Module: `modules/cli/less.nix`
  - Man page colors via LESS_TERMCAP_*
  - Bold, underline, standout colors

- [ ] **Zsh Syntax Highlighting** - Add to existing zsh module
  - Highlighter styles for different syntax elements
  - Command/builtin colors (distinguish between command types)
  - Alias/function colors (show custom vs built-in)
  - Path highlighting (existing vs non-existing paths)
  - **Configuration tier**: 3 (Module Extension)
  - **Format**: Zsh style definitions (e.g., `"alias" = "fg=magenta,bold"`)
  - **Upstream docs**: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
  - **Integration**: Add to existing `modules/shells/zsh.nix`
  - **Style categories**:
    - main: Commands, arguments, builtins, functions
    - brackets: Bracket and quote matching
    - pattern: Glob pattern highlighting
    - cursor: Cursor position highlighting
  - **Color format**: `fg=color,bg=color,bold,underline`
  - **Example**: `"command" = "fg=green,bold"`, `"alias" = "fg=magenta"`

- [ ] **Powerlevel10k** - Add p10k theme generation
  - Directory colors (current path display)
  - Git status colors (branch, dirty, ahead/behind)
  - Prompt segment colors (each info segment)
  - Generate `.p10k.zsh` file (full config file)
  - **Configuration tier**: 4 (Complex Config Generation)
  - **Format**: Zsh script with typeset variables
  - **Upstream docs**: https://github.com/romkatv/powerlevel10k#configuration
  - **Complexity**: High - full config wizard with many options
  - **Implementation approach**:
    - Generate p10k config with Signal colors
    - Keep user's segment choices, only replace colors
    - Use template-based generation
  - **Key color variables**:
    - `POWERLEVEL9K_DIR_*`: Directory segment colors
    - `POWERLEVEL9K_VCS_*`: Git/version control colors
    - `POWERLEVEL9K_STATUS_*`: Command exit status colors
    - `POWERLEVEL9K_TIME_*`: Time segment colors
  - **Color format**: 256-color codes (0-255) or RGB hex
  - **Challenge**: p10k has 100+ color variables, need smart defaults

- [ ] **Ripgrep** - Add module with color arguments
  - Line colors (line numbers in output)
  - Path colors (file paths in results)
  - Match colors (actual matched text)
  - Column colors (column numbers when enabled)
  - **Configuration tier**: 2 (CLI Arguments)
  - **Format**: `--colors=TYPE:SPEC` arguments
  - **Upstream docs**: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#colors
  - **Integration**: Use `programs.ripgrep.arguments` list
  - **Color types**: line, path, match, column
  - **Color specs**: `fg:color`, `bg:color`, `style:bold/underline/intense`
  - **Color values**: Named (red, blue, etc.) or RGB hex
  - **Example**: `"--colors=path:fg:green"`, `"--colors=match:fg:red"`
  - **Note**: Already has module in signal-nix, just needs color mapping

- [ ] **Eza** - Add module for `programs.eza` + theme file
  - File kind colors (directories, symlinks, executables, etc.)
  - Permission colors (read, write, execute indicators)
  - YAML theme file generation (structured color definitions)
  - **Configuration tier**: 3 (Config File + Module)
  - **Format**: YAML theme file + HM module options
  - **Upstream docs**: https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md
  - **Theme location**: `~/.config/eza/theme.yml`
  - **Categories**:
    - filekinds: normal, directory, symlink, pipe, socket, block_device, char_device, executable, special
    - perms: user_read, user_write, user_execute, group_read, etc.
    - size: size_numbers, major, minor
    - users: user_you, user_someone_else, group_yours, group_not_yours
    - links: links, links_multi
    - git: git_new, git_modified, git_deleted, git_renamed, git_ignored
  - **Color format**: Named colors or hex, plus bold/italic/underline
  - **Already in signal-nix**: Yes, but may need theme file generation

- [ ] **Glow** - Add module with config/style files
  - Style selection (dark, light, custom)
  - Custom style JSON generation (full theme creation)
  - **Configuration tier**: 3 (Config File)
  - **Format**: JSON style files
  - **Upstream docs**: https://github.com/charmbracelet/glow#styles
  - **Config location**: `~/.config/glow/glow.yml`
  - **Style location**: `~/.config/glow/styles/custom.json`
  - **Style elements**:
    - document: Base text and spacing
    - heading: H1-H6 headers
    - paragraph: Body text
    - code_block: Fenced code blocks
    - link: Hyperlinks
    - list: Bullet and numbered lists
    - table: Table formatting
    - quote: Blockquotes
  - **Properties per element**: color, background_color, bold, italic, underline, strikethrough
  - **Use case**: Beautiful markdown rendering in terminal

- [ ] **Procs** - Add module with config.toml
  - Header styling (column headers)
  - Percentage-based colors (CPU/memory usage indicators)
  - State-based colors (process state: running, sleeping, etc.)
  - **Configuration tier**: 3 (Config File)
  - **Format**: TOML configuration
  - **Upstream docs**: https://github.com/dalance/procs#configuration
  - **Config location**: `~/.config/procs/config.toml`
  - **Color sections**:
    - `[style]`: General text styling
    - `[style.by_percentage]`: Gradient for 0-100% values
    - `[style.by_state]`: Colors for process states (D/R/S/T/Z)
    - `[style.by_unit]`: Colors for different units (KB/MB/GB)
  - **Color format**: Terminal color names (BrightRed, BrightGreen, etc.) with attributes
  - **Example**: `color_000 = "BrightBlue"`, `color_100 = "BrightRed|Bold"`
  - **Percentage gradient**: Define colors for 0%, 25%, 50%, 75%, 100% thresholds

### System Monitors
- [ ] **Btop++** - Add module with theme file
  - Main background/foreground
  - Box colors (CPU, MEM, NET, PROC)
  - Graph colors (gradients)
  - Complete theme file generation

### Window Manager Components
- [ ] **Niri** - Add module with config.kdl
  - Border colors (active/inactive)
  - Focus ring colors
  - Window opacity

- [ ] **Swayimg** - Add module with config file
  - Background color
  - Font color
  - Shadow color

### Media
- [ ] **Satty** - Add module with config.toml
  - Drawing colors
  - Font configuration

## Lower Priority - Complex/External Theming

### Browsers
- [ ] **Chromium** - Add module for extensions/flags
  - Dark Reader extension support
  - Force dark mode flags
  - Consider declarative extension management

### Communication
- [ ] **Discord (Vencord)** - Add Vesktop theme support
  - CSS theme file generation
  - Background colors
  - Text colors
  - Brand colors

- [ ] **Telegram Desktop** - Add theme file support
  - Document .tdesktop-theme creation process
  - Consider using theme generator API
  - May need external tooling

### File Managers
- [ ] **Thunar** - Document GTK theme dependency
  - Ensure GTK3 extra CSS support
  - Sidebar customization

- [ ] **Nautilus** - Document libadwaita integration
  - Color scheme preference
  - Adw-gtk3 theme support

### Graphics Tools
- [ ] **GIMP** - Add theme directory support
  - Theme file structure
  - Installation process

- [ ] **Aseprite** - Add extension theme support
  - Extension structure
  - Theme installation

### Gaming
- [ ] **Steam** - Add skin support
  - Adwaita-for-Steam integration
  - Skin directory management
  - Fetchable skin sources

### Utilities
- [ ] **OBS Studio** - Add Qt theme support
  - QSS file generation
  - Theme directory setup

- [ ] **Obsidian** - Document CSS snippets approach
  - Per-vault configuration challenges
  - Snippet generation

## Environment Variables

- [ ] **Less** - Add to shell module
  - LESS_TERMCAP_* variables for man pages
  - Color escape sequences

- [ ] **GitHub CLI** - Add glamour style
  - GLAMOUR_STYLE environment variable
  - Markdown rendering style

## Infrastructure Improvements

### Color System
- [ ] Create centralized color palette system
  - Define semantic color roles (not just technical names)
  - Map brand colors to functional roles (primary, secondary, accent, surface, text)
  - Generate app-specific color formats (hex, RGB, HSL, terminal codes)
  - **Benefits**:
    - Consistent color meaning across all applications
    - Single source of truth for color decisions
    - Easy to adjust globally (change one color, updates everywhere)
    - Better accessibility (can ensure contrast ratios at palette level)
  - **Semantic roles needed**:
    - Surfaces: base, elevated, overlay, card
    - Text: primary, secondary, tertiary, disabled, on-accent
    - Actions: primary, secondary, tertiary, danger, warning, success
    - Borders: subtle, default, strong
    - States: hover, active, focus, disabled
  - **Implementation**: Extend existing `signalColors` system in `modules/common/default.nix`

- [ ] Add color format converters
  - Hex to RGB (for applications that need separate R, G, B values)
  - RGB to terminal ANSI (for applications using 256-color codes)
  - Hex with alpha to separate alpha value (many apps separate color and opacity)
  - OKLCH to RGB (if we add OKLCH support in future)
  - **Use cases**:
    - GTK: Needs RGB format `rgb(59, 130, 246)`
    - Terminal: Needs ANSI codes `38;2;59;130;246`
    - QSS: Needs separate alpha `rgba(59, 130, 246, 0.8)`
    - Some apps: Need decimal values `[0.23, 0.51, 0.96]`
  - **Implementation location**: `lib/colors.nix` with pure functions
  - **Example**:
    ```nix
    hexToRgb = hex: {
      r = toInt (substring 1 2 hex);
      g = toInt (substring 3 2 hex);
      b = toInt (substring 5 2 hex);
    };
    ```

### Module System
- [ ] Create application category hierarchy
  - Terminal emulators (alacritty, kitty, ghostty, foot, wezterm)
  - CLI tools (ripgrep, eza, fzf, bat, delta)
  - System monitors (htop, btop, bottom)
  - Media players (mpv, imv)
  - Communication apps (discord, telegram, slack)
  - Development tools (vscode, zed, neovim, emacs)
  - **Benefits**:
    - Enable/disable entire categories at once
    - Shared color mappings for related apps
    - Better organization for users ("I want all CLI tools themed")
  - **Implementation**:
    - Add `categories` attribute set to config
    - Each category can be enabled/disabled
    - Per-app settings override category defaults
  - **Example**:
    ```nix
    theming.signal = {
      enable = true;
      categories = {
        terminals.enable = true;  # Enable all terminal theming
        cli.enable = true;        # Enable all CLI tool theming
        gui.enable = false;       # Disable GUI app theming
      };
      # Per-app overrides
      programs.alacritty.enable = false;  # Disable just alacritty
    };
    ```

- [ ] Standardize module structure
  - Consistent option naming across all modules
  - Common color options (overrides, variants, custom mappings)
  - Enable/disable per-app granularity
  - **Goals**:
    - Every module follows same pattern
    - Easy to understand for contributors
    - Predictable API for users
  - **Standard structure**:
    1. Header comment with tier classification
    2. Options section (enable, colors, extras)
    3. Color mapping section (let-bindings)
    4. Config generation section (programs.*)
    5. Activation logic (shouldThemeApp)
  - **Common options every module should have**:
    - `enable`: Enable this specific app
    - `colors`: Override specific colors
    - `tier`: Read-only, shows configuration method
  - **Reference**: Create `docs/MODULE_STRUCTURE.md` documenting standard

### Documentation
- [ ] Update theming reference guide
  - Document all supported applications with examples
  - Show example configurations for each app
  - Migration guide from manual configs to Signal theming
  - **Contents needed**:
    - Application list with status (supported, planned, won't support)
    - Configuration examples for each tier
    - Before/after comparisons showing manual vs Signal config
    - Troubleshooting section for common issues
    - Color override examples
  - **Location**: `docs/theming-reference.md` (already exists, needs expansion)
  - **Format**: Organized by category, searchable, with TOC

- [ ] Create application compatibility matrix
  - What works on NixOS vs Home Manager vs nix-darwin
  - Platform-specific limitations (Linux-only, macOS-only, etc.)
  - Required dependencies for each application
  - **Matrix dimensions**:
    - Rows: Applications
    - Columns: NixOS, Home Manager, nix-darwin, Standalone
  - **Information per cell**: ✅ Full support, ⚠️ Partial support, ❌ Not supported, 🔧 Requires manual setup
  - **Additional columns**: Dependencies, Notes, Since Version
  - **Example**:
    | App | HM | NixOS | nix-darwin | Dependencies | Notes |
    |-----|-----|-------|------------|--------------|-------|
    | Alacritty | ✅ | ✅ | ✅ | - | Cross-platform |
    | Swaylock | ✅ | ✅ | ❌ | swaylock | Wayland only |
    | MangoHud | ✅ | ✅ | ❌ | mangohud | Linux only |
  - **Location**: `docs/COMPATIBILITY.md`

### Testing
- [ ] Add tests for new modules
  - Color value validation (hex format, bounds checking)
  - Config file generation (syntax, structure)
  - Integration tests (full configuration builds)
  - **Test types needed**:
    1. Unit tests: Color conversion functions
    2. Module tests: Each module generates valid config
    3. Integration tests: Full home-manager configuration
    4. Regression tests: No accidental changes to existing modules
  - **Test framework**: Use nix-unit when migrated, or runCommand for now
  - **Test location**: `tests/modules/` subdirectory
  - **Example test structure**:
    ```nix
    # tests/modules/alacritty.nix
    {
      testColorGeneration = # ...
      testConfigStructure = # ...
      testThemeActivation = # ...
    }
    ```

- [ ] Create visual regression tests
  - Screenshot comparison (detect visual changes)
  - Theme consistency checks (colors match across apps)
  - **Implementation challenges**:
    - Requires rendering applications
    - Need consistent test environment
    - Screenshots are platform-dependent
  - **Possible approaches**:
    1. VM-based testing with known resolution/fonts
    2. Terminal color testing with ANSI escape sequence capture
    3. Config file hash comparison (not visual, but detects changes)
  - **Priority**: Low - complex to implement, high maintenance
  - **Alternative**: Manual testing checklist with screenshots in docs

## GTK/Qt Integration

- [ ] **Qt Theming** - Add Qt color scheme support
  - qt5ct/qt6ct configuration (Qt settings tools)
  - Kvantum theme support (advanced Qt theme engine)
  - Coordinate with GTK themes for consistency
  - **Configuration methods**:
    1. **qt5ct/qt6ct**: Config-based Qt appearance tool
       - Location: `~/.config/qt5ct/qt5ct.conf`, `~/.config/qt6ct/qt6ct.conf`
       - Colors: Define palette for widgets (base, text, button, etc.)
       - Format: INI-style configuration
    2. **Kvantum**: SVG-based theme engine with advanced styling
       - Location: `~/.config/Kvantum/`
       - Requires: kvantum package
       - Features: Transparency, blur, animations
       - Complexity: High - requires SVG theme files
    3. **QSS (Qt Style Sheets)**: CSS-like styling for Qt
       - Per-application styling
       - Format: Similar to CSS but Qt-specific properties
  - **Implementation priority**: Start with qt5ct/qt6ct (simpler), add Kvantum later
  - **Upstream docs**: 
    - qt5ct: https://github.com/desktop-app/qt5ct
    - Kvantum: https://github.com/tsujan/Kvantum
  - **Color mapping strategy**:
    - Use same semantic colors as GTK for consistency
    - Map to Qt palette roles: Window, WindowText, Base, Text, Button, ButtonText, etc.
  - **Example palette roles**:
    - Window: Main window background
    - WindowText: Text on window background
    - Base: Input field background
    - AlternateBase: Alternating row background
    - Button: Button background
    - Highlight: Selected item background
    - HighlightedText: Text on selected items

- [ ] **GTK Extra CSS** - Enhance existing support
  - Per-app CSS customization (app-specific overrides)
  - Thunar sidebar styling (file manager sidebar colors)
  - File manager customizations (breadcrumbs, location bar, etc.)
  - **Current status**: Basic GTK theming implemented in `modules/gtk/default.nix`
  - **Enhancements needed**:
    1. Per-application CSS injection
       - Use GTK app-id selectors: `.thunar .sidebar`, `.nautilus .sidebar`
       - Add app-specific color overrides
    2. Component-specific styling
       - Sidebar backgrounds/text
       - Header bars (darker/lighter variants)
       - Popovers and tooltips
       - Context menus
    3. State styling
       - Hover states
       - Active/selected states
       - Focus indicators
  - **Implementation location**: Extend `modules/gtk/default.nix`
  - **Example customizations**:
    ```css
    /* Thunar sidebar */
    .thunar .sidebar {
      background-color: @surface-subtle;
      border-right: 1px solid @divider-primary;
    }
    
    /* Nautilus location bar */
    .nautilus .location-bar {
      background-color: @surface-elevated;
      border-radius: 8px;
    }
    ```
  - **Research resources**: `.claude/gtk-theming-docs-research.md` has full GTK color documentation

## Research & Design

- [ ] Define color role mapping
  - Primary/secondary/accent roles and their usage
  - Success/warning/error semantic colors for states
  - Background hierarchy (base, elevated, overlay levels)
  - Text contrast levels (primary, secondary, tertiary, disabled)
  - **Context**: Need clear rules for when to use which color
  - **Current state**: Have technical palette, need semantic layer
  - **Semantic roles to define**:
    - **Action colors**:
      - Primary: Main actions (submit, confirm, primary buttons)
      - Secondary: Alternative actions (cancel, back)
      - Tertiary: Subtle actions (edit, view details)
      - Danger: Destructive actions (delete, remove)
      - Warning: Caution actions (proceed with risk)
      - Success: Positive confirmation (saved, completed)
    - **Surface colors**:
      - Base: Default background
      - Elevated: Cards, modals, raised surfaces
      - Overlay: Tooltips, dropdowns
      - Sunken: Input fields, text areas
    - **Text colors**:
      - Primary: Body text (highest contrast)
      - Secondary: Supporting text (medium contrast)
      - Tertiary: Hint text (lower contrast)
      - Disabled: Inactive text (lowest contrast)
      - On-accent: Text on colored backgrounds
    - **Border colors**:
      - Subtle: Light dividers
      - Default: Standard borders
      - Strong: Emphasized borders
      - Focus: Keyboard focus indicators
  - **Contrast requirements**: Follow WCAG 2.1 AA guidelines
    - Normal text: 4.5:1 minimum
    - Large text: 3:1 minimum
    - UI components: 3:1 minimum
  - **Output**: Document in `docs/COLOR_SEMANTICS.md`

- [ ] Create default color palettes
  - Light theme palette (high-key, bright backgrounds)
  - Dark theme palette (low-key, dark backgrounds)
  - High contrast variants (enhanced contrast for accessibility)
  - Colorblind-friendly options (adjusted hues for common color blindness types)
  - **Light theme considerations**:
    - Higher lightness values (L > 90 for backgrounds)
    - Darker text (L < 40 for primary text)
    - Reduced saturation for backgrounds
    - Increased contrast ratios
  - **Dark theme considerations** (current focus):
    - Lower lightness values (L < 20 for backgrounds)
    - Lighter text (L > 80 for primary text)
    - Can use more saturated colors
    - Avoid pure black (use dark gray)
  - **High contrast variants**:
    - Maximum contrast ratios (7:1 or higher)
    - Reduced color variety (focus on contrast)
    - Simpler color schemes
    - Good for low vision users
  - **Colorblind-friendly palettes**:
    - Protanopia (red-blind): Avoid red-green distinctions
    - Deuteranopia (green-blind): Similar to protanopia
    - Tritanopia (blue-blind): Avoid blue-yellow distinctions
    - Use patterns/shapes in addition to color
    - Test with colorblind simulation tools
  - **Implementation**: Add palette variants to `modules/common/default.nix`
  - **Testing**: Use contrast checkers and colorblind simulators

- [ ] Application grouping strategy
  - Which apps should share exact colors (terminals need consistency)
  - Which need unique adaptations (media players may need different backgrounds)
  - Consistency vs. optimization trade-offs
  - **Categories for color treatment**:
    1. **Strict consistency**: Terminals, CLI tools
       - Need identical ANSI colors
       - Muscle memory for colors
       - Visual cues depend on exact colors
    2. **Semantic consistency**: GUI applications
       - Same meanings (error = red) but different shades OK
       - Can adapt to app's design language
       - More flexibility in implementation
    3. **Contextual adaptation**: Media players, image viewers
       - May need neutral backgrounds (avoid color cast)
       - Subtitles need maximum contrast
       - UI should not interfere with content
  - **Decision factors**:
    - User expectations (familiar patterns)
    - Application purpose (work vs. media)
    - Technical constraints (limited palette)
    - Brand recognition (maintain visual identity)
  - **Documentation**: Create decision tree in `docs/COLOR_GROUPING.md`

## Notes

### Priority Criteria
- **High**: Native HM options, widely used, straightforward implementation
  - Quick wins with immediate value
  - Well-documented upstream
  - Low risk of breakage
  - Examples: Git Delta, Tig, MangoHud
  
- **Medium**: Config file based, good documentation, clear benefit
  - Requires config file generation
  - More complex but still manageable
  - May need template systems
  - Examples: Btop++, Zed, Glow
  
- **Lower**: External dependencies, complex setup, niche use cases
  - May need external tools or packages
  - Complex implementation or maintenance
  - Smaller user base
  - Examples: Discord (needs Vencord), Telegram (needs theme builder)

### Implementation Order
1. **Start with high-priority applications with native HM options**
   - Fastest path to value
   - Build momentum with quick wins
   - Learn patterns that apply to other apps
   - Current focus: Delta, Tig, Tealdeer, MangoHud, Swaylock, MPV

2. **Create color system infrastructure**
   - Semantic color roles (what each color means)
   - Format converters (hex to RGB, etc.)
   - Validation helpers (contrast checking)
   - This investment pays off for all future apps

3. **Implement medium-priority config-based apps**
   - Apply infrastructure built in step 2
   - Focus on apps with highest user request
   - Build reusable config generation patterns

4. **Add environment variable support**
   - Group by shell (zsh, bash, fish)
   - Shared variables (LESS_TERMCAP_*, GLAMOUR_STYLE)
   - Per-app variables as needed

5. **Handle complex/external theming cases**
   - Requires most effort for least coverage
   - Wait for user requests and feedback
   - May need external tool integration

### Considerations
- **Some apps automatically inherit from GTK theme**
  - Thunar, Nautilus, File Roller, Polkit-gnome
  - Focus on GTK CSS instead of per-app modules
  - Single source of truth prevents inconsistency
  - Documented in `.claude/gtk-theming-docs-research.md`

- **Terminal emulator colors affect many CLI tools**
  - ANSI color palette is shared across all terminal apps
  - Consistency critical for user experience
  - Test CLI tools in all terminal emulators
  - Some tools (dust, atuin) only use terminal colors

- **Environment variables can be grouped in shell modules**
  - Less, Man, GitHub CLI (glamour) use env vars
  - Add to existing shell modules (zsh, bash, fish)
  - Single place to configure all shell colors
  - Example: `LESS_TERMCAP_*` for colored man pages

- **Qt theming is separate concern from GTK**
  - Different architecture and styling system
  - Need both qt5ct and qt6ct support
  - Kvantum adds complexity but more features
  - Not all Qt apps respect qt5ct/qt6ct
  - Some apps (OBS, Telegram) use own themes

- **Some apps need external tools**
  - Discord: Requires BetterDiscord or Vencord
  - Telegram: Needs .tdesktop-theme file (can use theme generator API)
  - Obsidian: Per-vault CSS snippets (complex to automate)
  - Steam: Skin files (can use existing skins like Adwaita-for-Steam)
  - Lower priority due to complexity and maintenance burden

### Configuration Tiers Explained

**Tier 1: Preset Selection** (Simplest)
- App only offers preset themes/color schemes
- Can only choose from predefined options
- Example: htop (schemes 0-6), some terminal themes
- Implementation: Map Signal theme to closest preset

**Tier 2: Structured Colors** (Medium complexity)
- App has dedicated color configuration structure
- Organized sections (primary, normal, bright)
- Type-safe, validated by Home Manager
- Example: Alacritty (`colors.primary.background`)
- Implementation: Direct mapping to structured options

**Tier 3: Freeform Settings** (Flexible)
- App accepts key-value pairs
- No strict structure enforced
- More freedom but less validation
- Example: Ghostty, Kitty, Foot
- Implementation: Generate flat key-value config

**Tier 4: Config File Generation** (Most complex)
- No Home Manager options, must generate full config
- May need templates or complex string building
- Examples: Btop++ theme files, Zed JSON themes
- Implementation: Template-based or programmatic generation

### Color Format Reference

**Hex** (most common)
- With hash: `#3b82f6`
- Without hash: `3b82f6`
- With alpha: `#3b82f680` (last 2 digits = alpha)

**RGB**
- Separate values: `r: 59, g: 130, b: 246`
- CSS format: `rgb(59, 130, 246)`
- With alpha: `rgba(59, 130, 246, 0.5)`

**Terminal Colors**
- Named: `red`, `green`, `blue`, `brightred`, etc.
- 256-color: `38;5;33` (foreground), `48;5;33` (background)
- True color: `38;2;59;130;246`

**Other Formats**
- ANSI escape: `\x1b[38;2;59;130;246m`
- Decimal array: `[0.23, 0.51, 0.96]` (0-1 range)
- Integer array: `[59, 130, 246]` (0-255 range)

### Testing Strategy

**Per-Module Tests**
1. Color value validation (format, bounds)
2. Config structure correctness
3. Activation logic (enable/disable)
4. Override behavior (custom colors)

**Integration Tests**
1. Full home-manager build
2. No evaluation errors
3. Files generated in correct locations
4. No conflicts between modules

**Visual Tests** (manual)
1. Screenshot each themed application
2. Verify colors match design system
3. Check consistency across apps
4. Test in both light and dark modes (when both supported)

**Accessibility Tests**
1. Contrast ratio checks (WCAG 2.1)
2. Colorblind simulation
3. High contrast mode
4. Screen reader compatibility (for GUI apps)

### Future Considerations

**OKLCH Color Space**
- Current: Using RGB/Hex colors
- Future: Could use OKLCH for better perceptual uniformity
- Benefits: Equal numerical differences = equal perceived differences
- Challenge: Need conversion functions, not all apps support
- Resources: 
  - https://evilmartians.com/chronicles/oklch-in-css-why-quit-rgb-hsl
  - https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/oklch

**Dynamic Theme Switching**
- Runtime theme changes without restart
- System theme detection (dark/light mode)
- Time-based themes (light during day, dark at night)
- Per-app theme overrides

**Theme Variants**
- Seasonal themes (spring, summer, fall, winter)
- Holiday themes (Halloween, Christmas, etc.)
- Event themes (conferences, product launches)
- Mood themes (focus, relax, energize)

**Community Themes**
- Allow users to share custom themes
- Theme gallery or marketplace
- Rating and review system
- Import/export functionality

### Related Documentation

- **Research files**:
  - `docs/color-theme-research.md` - Complete app theming reference
  - `.claude/ghostty-implementation-research.md` - Ghostty implementation details
  - `.claude/gtk-theming-docs-research.md` - GTK theming comprehensive guide
  
- **Architecture docs**:
  - `docs/architecture.md` - System architecture overview
  - `docs/design-principles.md` - Design philosophy and principles
  - `docs/tier-system.md` - Configuration tier explanation
  
- **Guides**:
  - `docs/configuration-guide.md` - User configuration guide
  - `docs/theming-reference.md` - Theming API reference
  - `docs/THEME_QUICK_REF.md` - Quick reference for theme options

### Useful Links

- **Nix/Home Manager**:
  - Home Manager options: https://nix-community.github.io/home-manager/options.xhtml
  - Nixpkgs manual: https://nixos.org/manual/nixpkgs/stable/
  - Nix language basics: https://nix.dev/tutorials/nix-language

- **Theming inspiration**:
  - Stylix: https://github.com/danth/stylix
  - nix-colors: https://github.com/Misterio77/nix-colors
  - base16: https://github.com/chriskempson/base16
  
- **Color tools**:
  - Contrast checker: https://webaim.org/resources/contrastchecker/
  - Colorblind simulator: https://www.color-blindness.com/coblis-color-blindness-simulator/
  - OKLCH picker: https://oklch.com/

- **Testing**:
  - nix-unit: https://github.com/nix-community/nix-unit
  - nix-output-monitor: https://github.com/maralorn/nix-output-monitor
