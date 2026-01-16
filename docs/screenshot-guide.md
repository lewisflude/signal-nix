# Screenshot & Video Guide

This guide helps you capture high-quality screenshots and videos for Signal's visual documentation.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Screenshot Requirements](#screenshot-requirements)
- [Screenshot Checklist](#screenshot-checklist)
- [Video Requirements](#video-requirements)
- [Video Checklist](#video-checklist)
- [Editing & Optimization](#editing--optimization)
- [Organization & Naming](#organization--naming)

## Prerequisites

### Tools

**Linux:**
- **Screenshots**: `flameshot`, `spectacle`, or `grim` + `slurp` (Wayland)
- **Screen Recording**: `OBS Studio`, `SimpleScreenRecorder`, or `wf-recorder` (Wayland)
- **Image Editing**: `GIMP`, `Inkscape` (for overlays)
- **Video Editing**: `Kdenlive`, `DaVinci Resolve`

**macOS:**
- **Screenshots**: Built-in (`Cmd+Shift+4/5`) or `CleanShot X`
- **Screen Recording**: QuickTime, `OBS Studio`, or `CleanShot X`
- **Image Editing**: `Pixelmator Pro`, `Affinity Photo`
- **Video Editing**: `Final Cut Pro`, `iMovie`, `DaVinci Resolve`

### Installation (NixOS/Home Manager)

```nix
home.packages = with pkgs; [
  # Screenshots
  flameshot       # Feature-rich screenshot tool
  grim            # Wayland screenshot
  slurp           # Wayland region selector
  
  # Screen recording
  obs-studio      # Professional recording
  wf-recorder     # Wayland recorder
  
  # Editing
  gimp            # Image editor
  inkscape        # Vector graphics
  kdenlive        # Video editor
  
  # Optimization
  optipng         # PNG optimization
  jpegoptim       # JPEG optimization
  ffmpeg          # Video processing
];
```

## Screenshot Requirements

### Technical Specifications

- **Resolution**: 2560x1440 (native) or 1920x1080 minimum
- **Format**: PNG (for UI elements, transparency)
- **Color Space**: sRGB
- **Compression**: Optimized but high quality (use optipng)
- **File Size**: <1MB per screenshot (aim for 200-500KB)

### Visual Requirements

- **Clean Desktop**: Remove personal information, clutter
- **Consistent Theme**: Signal dark mode for all screenshots
- **Good Lighting**: Ensure display brightness is comfortable
- **Focus**: Screenshot should tell a clear story
- **Context**: Include enough context to understand what's shown

## Screenshot Checklist

### Desktop Environment (Ironbar + Niri)

#### Full Desktop Overview
- [ ] All Ironbar widgets visible
- [ ] Multiple workspaces shown (in workspace switcher)
- [ ] Clean wallpaper (solid color or subtle pattern)
- [ ] No personal information visible
- [ ] Window titles representative (not "Untitled")
- [ ] Take in both 1080p and 1440p (show scaling)

**Example shot**: Full desktop with 2-3 windows, Ironbar at top showing all widgets

#### Ironbar Widgets - Individual

- [ ] **Workspace Switcher**: Show multiple workspaces, active + inactive states
- [ ] **Clock**: Show clear time display
- [ ] **System Tray**: 3-4 representative icons
- [ ] **Calendar Popup**: Show popup with current month
- [ ] **Volume Control**: Show volume slider in use
- [ ] **Battery**: Show different states (charging, 50%, 20%, critical)
- [ ] **Brightness**: Show brightness control
- [ ] **Window Title**: Show with different length titles
- [ ] **Notifications**: Show badge with count

**Tip**: Use Flameshot's "capture specific widget" feature

#### Ironbar Display Profiles

Capture the same view in all three profiles to show scaling:

- [ ] **Compact** (1080p) - 40px bar
- [ ] **Relaxed** (1440p) - 48px bar  
- [ ] **Spacious** (4K) - 56px bar

**Comparison shot**: Side-by-side or animated GIF showing differences

### GTK Applications

- [ ] **File Manager**: Nautilus or Thunar with Signal theme
  - Sidebar, toolbar, file list visible
  - Both light and dark mode
- [ ] **Text Editor**: Gedit or similar
  - Show syntax highlighting (if available)
  - Toolbar, line numbers visible
- [ ] **Settings**: GNOME Settings or similar
  - Show preferences panel
  - Ensure colors are clear
- [ ] **Dialogs**: File picker, save dialog
  - Show themed dialog boxes
- [ ] **Context Menus**: Right-click menu
  - Clear, well-lit
- [ ] **Light vs Dark Comparison**: Same app, both modes side-by-side

**Tip**: Arrange windows for split-screen comparison shots

### Terminal Applications

#### Ghostty
- [ ] Clean terminal with Signal theme
- [ ] Show prompt (starship or similar)
- [ ] Some typical output (ls, directory listing)
- [ ] No command history with sensitive data
- [ ] Both dark and light mode

#### Helix Editor
- [ ] Full editor view with syntax-highlighted code
- [ ] Show multiple file types (Rust, Python, JavaScript, Nix)
- [ ] Status line visible
- [ ] Line numbers visible
- [ ] Example: Signal's own Nix code (meta!)

#### Yazi File Manager
- [ ] File browser with Signal colors
- [ ] Show directory structure
- [ ] File preview pane (if available)
- [ ] Status line

#### Lazygit
- [ ] Git interface with Signal theme
- [ ] Show commit history, diff, or staging area
- [ ] Multiple panes visible

#### fzf
- [ ] Fuzzy finder in action
- [ ] Show search results with Signal colors
- [ ] Clear query text

#### bat
- [ ] Syntax-highlighted file with Signal theme
- [ ] Show line numbers and git indicators
- [ ] Multiple language examples

**Tip**: Use representative, non-sensitive code examples

### Comparison Shots

Create comparison images showing Signal vs other themes:

- [ ] **Before/After**: Stock theme → Signal theme (same app)
- [ ] **Side-by-side**: Signal vs Catppuccin vs Gruvbox
- [ ] **Light/Dark**: Same view in both modes

**Tool**: Use image editor to create split or grid layouts

### Color Palette Visualization

- [ ] **Swatch Grid**: Show all Signal colors organized
- [ ] **OKLCH Gradient**: Demonstrate perceptual uniformity
- [ ] **Contrast Examples**: Text on different backgrounds
- [ ] **Semantic Colors**: Show functional vs decorative colors

**Tool**: Use design tool or create with HTML/CSS, then screenshot

## Video Requirements

### Technical Specifications

- **Resolution**: 1920x1080 (1080p) or 2560x1440 (1440p)
- **Frame Rate**: 30fps or 60fps (prefer 60fps for smooth UI)
- **Format**: MP4 (H.264 codec for compatibility)
- **Bitrate**: 5-10 Mbps (good quality, reasonable size)
- **Audio**: Optional (narration or background music)
- **Length**: 
  - Demo videos: 30-90 seconds
  - Tutorial: 1-5 minutes
  - Deep dive: 5-10 minutes

### Recording Settings (OBS Studio)

```
Output Mode: Advanced
Encoder: x264 or Hardware (NVENC/QuickSync)
Rate Control: CBR
Bitrate: 8000 Kbps
Keyframe Interval: 2
Preset: Quality (or fast for real-time)
Profile: High
Tune: None

Audio:
Sample Rate: 48kHz
Bitrate: 160 Kbps
```

## Video Checklist

### Desktop Tour (1-2 minutes)

**Script outline:**
1. **Opening** (5s): Show full desktop, mention Signal
2. **Ironbar** (20s): Hover over widgets, show interactions
3. **Workspace Switching** (10s): Switch between workspaces
4. **Popups** (15s): Open calendar, volume, brightness
5. **Applications** (30s): Launch apps, show theming
6. **Window Management** (10s): Show themed window borders
7. **Closing** (5s): Final overview, fade out

**Recording tips:**
- Slow, deliberate mouse movements
- Pause briefly on each feature
- Clean, minimal desktop
- No sudden movements
- Practice run before recording

### Application Showcase (30-60s each)

**Per Application:**

#### Helix Editor
- Open Helix
- Show syntax highlighting (type some code)
- Navigate files (file picker)
- Show multiple splits
- Demonstrate theme cohesion

#### Terminal Workflow
- Open Ghostty
- Run some CLI commands (ls, cd, cat)
- Open yazi file manager
- Open lazygit
- Use fzf to find files
- Show bat syntax highlighting

#### GTK Applications
- Open file manager
- Navigate directories
- Show context menu
- Open settings
- Demonstrate theme consistency

**Recording tips:**
- Focus on the app, not the whole desktop
- Show practical usage, not contrived demos
- Include realistic content (not just "hello world")

### Technical Deep Dive (3-5 minutes)

**Topics:**

#### OKLCH Color Space (2 min)
1. Explain perceptual uniformity problem
2. Show HSL vs OKLCH comparison
3. Demonstrate gradient smoothness
4. Show practical benefits

**Visual aids:**
- Color swatches
- Gradient comparisons
- Side-by-side examples
- Annotated screenshots

#### Atomic Design System (2 min)
1. Explain token hierarchy
2. Show how tokens map to UI elements
3. Demonstrate consistency across apps
4. Show customization example

#### Brand Governance (1 min)
1. Explain the concept
2. Show three policies
3. Demonstrate with example
4. Explain accessibility benefits

**Recording tips:**
- Use screen annotations (arrows, highlights)
- Zoom in on relevant sections
- Pause between concepts
- Clear, concise narration

## Editing & Optimization

### Image Optimization

```bash
# Optimize PNG (lossless)
optipng -o7 screenshot.png

# Or use pngquant for lossy but smaller
pngquant --quality=80-95 screenshot.png

# JPEG optimization (if needed)
jpegoptim --max=90 screenshot.jpg

# Batch process
for img in *.png; do
  optipng -o7 "$img"
done
```

### Video Optimization

```bash
# Re-encode for web (good quality, smaller size)
ffmpeg -i input.mp4 -c:v libx264 -preset slow -crf 22 \
  -c:a aac -b:a 128k output.mp4

# Generate GIF from video (for demos)
ffmpeg -i input.mp4 -vf "fps=15,scale=1280:-1:flags=lanczos" \
  -c:v palgettefile -y palette.png
ffmpeg -i input.mp4 -i palette.png -filter_complex \
  "fps=15,scale=1280:-1:flags=lanczos[x];[x][1:v]paletteuse" \
  output.gif

# Create thumbnail
ffmpeg -i input.mp4 -ss 00:00:05 -vframes 1 thumbnail.png
```

### Video Editing Tips

1. **Cut dead space**: Remove pauses, mistakes, loading screens
2. **Add transitions**: Subtle fade in/out between sections
3. **Annotations**: Add text overlays, arrows, highlights
4. **Background music**: Subtle, non-distracting (if using audio)
5. **Captions**: Add for accessibility (YouTube auto-generates)
6. **Intro/Outro**: 2-3 second branded intro (optional)

## Organization & Naming

### Directory Structure

```
screenshots/
├── desktop/
│   ├── overview/
│   ├── ironbar/
│   └── workspaces/
├── applications/
│   ├── gtk/
│   ├── editors/
│   ├── terminals/
│   └── cli/
├── comparisons/
│   ├── before-after/
│   ├── themes/
│   └── light-dark/
└── palette/
    └── swatches/

videos/
├── demos/
│   ├── desktop-tour.mp4
│   ├── helix-showcase.mp4
│   └── terminal-workflow.mp4
├── tutorials/
│   ├── getting-started.mp4
│   └── customization.mp4
└── deep-dives/
    ├── oklch-explained.mp4
    └── atomic-design.mp4
```

### Naming Convention

**Screenshots:**
```
signal-<component>-<mode>-<state>-<detail>.png

Examples:
signal-ironbar-dark-overview.png
signal-ironbar-dark-workspace-active.png
signal-ironbar-light-calendar-open.png
signal-helix-dark-rust-syntax.png
signal-gtk-dark-nautilus.png
signal-comparison-before-after.png
```

**Videos:**
```
signal-<type>-<topic>-<version>.mp4

Examples:
signal-demo-desktop-tour-v1.mp4
signal-demo-helix-showcase-v1.mp4
signal-tutorial-getting-started-v1.mp4
signal-deepdive-oklch-explained-v1.mp4
```

### Metadata

Include metadata in commit/release:

```markdown
## Screenshots

- **Resolution**: 2560x1440
- **Format**: PNG, optimized
- **Theme**: Signal Dark v1.0
- **Display**: Dell U2723DE (1440p)
- **Date**: 2026-01-16

## Videos  

- **Resolution**: 1920x1080
- **Frame Rate**: 60fps
- **Format**: MP4 (H.264)
- **Duration**: 1:23
- **Audio**: None
- **Date**: 2026-01-16
```

## Quick Checklist

Before publishing screenshots/videos:

- [ ] No personal information visible
- [ ] Consistent theme (Signal dark mode)
- [ ] High quality, optimized file size
- [ ] Correct resolution (1080p or 1440p)
- [ ] Properly named and organized
- [ ] Metadata documented
- [ ] Tested on different displays (if possible)
- [ ] Accessible (captions for videos)

## Upload Locations

**GitHub:**
- Screenshots: `docs/images/` or GitHub releases
- Videos: GitHub releases (< 2GB) or link to YouTube

**YouTube:**
- Create "Signal Design System" playlist
- Tags: NixOS, Linux, Wayland, Design System, OKLCH, Theming
- Description: Link to GitHub, documentation
- Cards: Add end screen with links

**Social Media:**
- Twitter/X: Native upload (< 512MB)
- Mastodon: Native upload (< 40MB)
- Reddit: Native upload or imgur

## Example Schedule

**Week 1:**
- Day 1-2: Desktop environment screenshots
- Day 3-4: Application screenshots
- Day 5: Comparison shots
- Day 6-7: Optimization and organization

**Week 2:**
- Day 1-2: Record demo videos
- Day 3-4: Record tutorials
- Day 5: Record deep dives
- Day 6-7: Edit and optimize videos

**Week 3:**
- Day 1: Upload to GitHub/YouTube
- Day 2: Create social media posts
- Day 3-7: Launch and monitor feedback

## Resources

- **OBS Studio Guide**: https://obsproject.com/wiki/
- **Flameshot Documentation**: https://flameshot.org/docs/
- **FFmpeg Cheat Sheet**: https://gist.github.com/steven2358/ba153c642fe2bb1e47485962df07c730
- **Accessibility Guidelines**: https://www.w3.org/WAI/media/av/

## Tips from Experience

1. **Consistency is key**: Use same display, resolution, theme across all shots
2. **Tell a story**: Each screenshot should serve a purpose
3. **Less is more**: Don't overwhelm with too many screenshots
4. **Quality over quantity**: 10 great shots > 50 mediocre shots
5. **Get feedback**: Show drafts to friends/community before publishing
6. **Iterate**: First batch doesn't have to be perfect - improve over time

---

Good luck with your screenshot and video creation! 📸🎥
