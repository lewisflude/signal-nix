# Color Theme Implementation TODO

Based on research in `docs/color-theme-research.md`, this document tracks implementation of theming support for additional applications.

## High Priority - Applications with Native HM Options

### Terminal Emulators
- [x] **Ghostty** - ✅ Module implemented at `modules/terminals/ghostty.nix`
  - Full 16-color palette support
  - Background, foreground, cursor colors
  - Selection, split divider colors
  - Research: `.claude/ghostty-implementation-research.md`

### CLI Developer Tools
- [ ] **Git Delta** - Add module for `programs.git.delta.options`
  - Syntax theme selection
  - Diff colors (minus/plus styles)
  - Line number colors
  - Hunk header styling

- [ ] **Tig** - Add module for `programs.tig.settings`
  - Status colors
  - Diff colors
  - Graph colors
  - Title/cursor colors

- [ ] **Tealdeer** - Add module for `programs.tealdeer.settings.style`
  - Description colors
  - Command name styling
  - Example text colors
  - Example variable colors

### System Tools
- [ ] **MangoHud** - Add module for `programs.mangohud.settings`
  - Background color/alpha
  - Text color
  - Component colors (GPU, CPU, VRAM, RAM)
  - Frametime colors

### Lock Screen
- [ ] **Swaylock** - Add module for `programs.swaylock.settings`
  - Ring colors (normal, clear, verify, wrong)
  - Inside colors
  - Text colors
  - Key highlight colors

### Media
- [ ] **MPV** - Add module for `programs.mpv.config`
  - OSD colors
  - Subtitle colors
  - Border colors
  - OSC theme support via script-opts

### System Monitors
- [ ] **Htop** - Add module for `programs.htop.settings`
  - Color scheme selection (0-6 presets)
  - Limited but useful

## Medium Priority - Config File Based Theming

### Code Editors
- [ ] **Zed Editor** - Add module with `xdg.configFile` for settings.json
  - Theme selection
  - Experimental theme overrides
  - Custom theme file support

### CLI Tools
- [ ] **Zsh Syntax Highlighting** - Add to existing zsh module
  - Highlighter styles
  - Command/builtin colors
  - Alias/function colors

- [ ] **Powerlevel10k** - Add p10k theme generation
  - Directory colors
  - Git status colors
  - Prompt segment colors
  - Generate `.p10k.zsh` file

- [ ] **Ripgrep** - Add module with color arguments
  - Line colors
  - Path colors
  - Match colors

- [ ] **Eza** - Add module for `programs.eza` + theme file
  - File kind colors
  - Permission colors
  - YAML theme file generation

- [ ] **Glow** - Add module with config/style files
  - Style selection
  - Custom style JSON generation

- [ ] **Procs** - Add module with config.toml
  - Header styling
  - Percentage-based colors
  - State-based colors

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
  - Define semantic color roles
  - Map brand colors to roles
  - Generate app-specific color formats

- [ ] Add color format converters
  - Hex to RGB
  - RGB to terminal ANSI
  - Hex with alpha to separate alpha value

### Module System
- [ ] Create application category hierarchy
  - Terminal emulators
  - CLI tools
  - System monitors
  - Media players
  - Communication apps
  - Development tools

- [ ] Standardize module structure
  - Consistent option naming
  - Common color options
  - Enable/disable per-app

### Documentation
- [ ] Update theming reference guide
  - Document all supported applications
  - Show example configurations
  - Migration guide from manual configs

- [ ] Create application compatibility matrix
  - What works on NixOS vs Home Manager
  - Platform-specific limitations
  - Required dependencies

### Testing
- [ ] Add tests for new modules
  - Color value validation
  - Config file generation
  - Integration tests

- [ ] Create visual regression tests
  - Screenshot comparison
  - Theme consistency checks

## GTK/Qt Integration

- [ ] **Qt Theming** - Add Qt color scheme support
  - qt5ct/qt6ct configuration
  - Kvantum theme support
  - Coordinate with GTK themes

- [ ] **GTK Extra CSS** - Enhance existing support
  - Per-app CSS customization
  - Thunar sidebar styling
  - File manager customizations

## Research & Design

- [ ] Define color role mapping
  - Primary/secondary/accent
  - Success/warning/error
  - Background hierarchy
  - Text contrast levels

- [ ] Create default color palettes
  - Light theme palette
  - Dark theme palette
  - High contrast variants
  - Colorblind-friendly options

- [ ] Application grouping strategy
  - Which apps should share exact colors
  - Which need unique adaptations
  - Consistency vs. optimization

## Notes

### Priority Criteria
- **High**: Native HM options, widely used, straightforward implementation
- **Medium**: Config file based, good documentation, clear benefit
- **Lower**: External dependencies, complex setup, niche use cases

### Implementation Order
1. Start with high-priority applications with native HM options
2. Create color system infrastructure
3. Implement medium-priority config-based apps
4. Add environment variable support
5. Handle complex/external theming cases

### Considerations
- Some apps (GTK-based) automatically inherit from GTK theme
- Terminal emulator colors affect many CLI tools
- Environment variables can be grouped in shell modules
- Qt theming is separate concern from GTK
- Some apps (Discord, Obsidian) may need external tools
