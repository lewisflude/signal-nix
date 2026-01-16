# Signal Design System - Launch Announcement Materials

This document contains ready-to-post announcement content for various platforms.

## Reddit - r/NixOS

### Title
[Show Nix] Signal - OKLCH-based Design System for NixOS/Home Manager

### Body

```markdown
Hey r/NixOS! 👋

I'm excited to share **Signal** - a scientific, OKLCH-based design system for NixOS and Home Manager that I've been working on.

## What is Signal?

Signal is a complete theming solution built on perceptually uniform colors (OKLCH color space) with strict accessibility standards (APCA contrast). It's designed to theme your entire environment with consistent, scientifically-chosen colors.

## Why OKLCH?

Traditional color spaces (RGB, HSL) aren't perceptually uniform - L=50% looks different for blue vs yellow. OKLCH fixes this, giving us:
- ✅ Consistent perceived lightness across all hues
- ✅ Accurate contrast predictions for accessibility
- ✅ Future-proof (CSS Color Level 4 standard)

## Features

- 🎨 **10+ Applications**: Ironbar, GTK, Helix, Ghostty, Fuzzel, bat, fzf, lazygit, yazi, and more
- 🌓 **Dual-Theme Support**: Light and dark modes with semantic color tokens
- 🎯 **Unified Configuration**: One flake input, one module, minimal setup
- 🔬 **Scientific Foundation**: Every color is a calculated solution to a functional problem
- 🏢 **Brand Governance**: Separate decorative and functional colors for accessibility
- ⚡ **Easy Integration**: Works with existing Home Manager configs

## Quick Start

```nix
{
  inputs.signal.url = "github:lewisflude/signal-nix";

  home-manager.users.yourname = {
    imports = [signal.homeManagerModules.default];
    
    theming.signal = {
      enable = true;
      mode = "dark";
      
      # Enable what you need
      ironbar.enable = true;
      gtk.enable = true;
      helix.enable = true;
    };
  };
}
```

## Architecture

Signal uses a two-repository architecture:
- **[signal-palette](https://github.com/lewisflude/signal-palette)**: Platform-agnostic color definitions (JSON, Nix, CSS, JS)
- **[signal-nix](https://github.com/lewisflude/signal-nix)**: Nix/Home Manager modules (this repo)

This separation allows stable color versioning and platform-agnostic palette exports.

## Supported Applications

**Desktop:** Ironbar (3 display profiles), GTK 3/4, Fuzzel  
**Editors:** Helix (full theme)  
**Terminals:** Ghostty  
**CLI Tools:** bat, fzf, lazygit, yazi

More coming soon! (Zellij, Mako, SwayNC, Zed, Cursor...)

## Philosophy

Signal is built on three principles:

1. **Scientific**: Every color choice has a functional justification
2. **Accessible**: APCA-compliant contrast for all interactive elements
3. **Perceptually Uniform**: OKLCH ensures consistent lightness across hues

Read more: [Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md) | [OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md)

## Links

- **GitHub**: https://github.com/lewisflude/signal-nix
- **Palette**: https://github.com/lewisflude/signal-palette
- **Examples**: https://github.com/lewisflude/signal-nix/tree/main/examples

## Comparison with Other Themes

| System | Approach | Philosophy |
|--------|----------|------------|
| **Signal** | Scientific, OKLCH | Calculated, accessible, professional |
| **Catppuccin** | Warm, pastel | Cute, cozy, friendly |
| **Gruvbox** | Retro, warm | Nostalgic, vintage |
| **Dracula** | High contrast, vivid | Bold, dramatic |

Signal isn't trying to replace these - it's a different approach focused on scientific color theory and accessibility.

## Contributing

Contributions welcome! Priority areas:
- Additional application integrations
- Light mode refinements
- Documentation enhancements

See [CONTRIBUTING.md](https://github.com/lewisflude/signal-nix/blob/main/CONTRIBUTING.md)

## Feedback

I'd love to hear your thoughts! This is v1.0 and I'm actively working on improvements based on community feedback.

Let me know if you have questions or suggestions! 🎨✨

---

**License**: MIT  
**Author**: Lewis Flude ([@lewisflude](https://twitter.com/lewisflude))
```

---

## Reddit - r/unixporn

### Title
[Niri/Ironbar] Signal Design System - Scientific OKLCH theming

### Body

```markdown
**Details**

- **OS**: NixOS (unstable)
- **WM**: Niri
- **Bar**: Ironbar (themed with Signal)
- **Launcher**: Fuzzel
- **Terminal**: Ghostty
- **Editor**: Helix
- **File Manager**: yazi
- **Theme**: Signal Design System (custom)
- **Font**: [Your font]

---

I'm excited to share **Signal** - a design system I built for NixOS/Home Manager based on the OKLCH color space.

## What makes Signal different?

Most themes are designed by choosing colors that "look good." Signal takes a scientific approach:

1. **OKLCH Color Space**: Perceptually uniform colors (L=50% actually looks consistent)
2. **APCA Contrast**: Uses modern contrast algorithms for accessibility
3. **Atomic Design**: Colors are semantic tokens, not arbitrary hex values
4. **Brand Governance**: Separates functional colors from decorative brand colors

## Setup

Signal themes 10+ applications from a single config:

```nix
theming.signal = {
  enable = true;
  mode = "dark";
  
  ironbar.enable = true;
  gtk.enable = true;
  helix.enable = true;
  terminals.ghostty.enable = true;
  cli = {
    bat.enable = true;
    fzf.enable = true;
    lazygit.enable = true;
    yazi.enable = true;
  };
};
```

## Resources

- **GitHub**: https://github.com/lewisflude/signal-nix
- **Palette**: https://github.com/lewisflude/signal-palette
- **Dotfiles**: [Your dotfiles repo]

The entire system is available as a Nix flake with Home Manager modules. Check it out if you want perceptually uniform, accessible theming! 🎨

---

[Include 2-3 high-quality screenshots showcasing your desktop]
```

---

## NixOS Discourse

### Title
Signal Design System - OKLCH-based theming for NixOS/Home Manager

### Category
Links

### Body

```markdown
Hello NixOS community! 👋

I'm pleased to announce **Signal**, a design system for NixOS and Home Manager built on scientific color theory.

## What is Signal?

Signal is a comprehensive theming solution that uses the OKLCH color space and APCA contrast standards to provide perceptually uniform, accessible colors across your entire system.

**Key Features:**
- 🎨 10+ application integrations (Ironbar, GTK, Helix, Ghostty, CLI tools)
- 🔬 Scientific foundation (OKLCH + APCA)
- 🌓 Light and dark mode support
- 🎯 Unified configuration through Home Manager
- 🏢 Brand governance system for professional use
- ⚡ Simple setup with flakes

## Architecture

Signal consists of two repositories:

1. **[signal-palette](https://github.com/lewisflude/signal-palette)**: Platform-agnostic color definitions
   - Exports: Nix, JSON, CSS, JavaScript, and more
   - Versioned and locked for stability
   
2. **[signal-nix](https://github.com/lewisflude/signal-nix)**: Nix/Home Manager integration
   - Home Manager modules for applications
   - Library functions for color manipulation
   - Example configurations

This separation allows the palette to be used outside of Nix (web development, design tools) while keeping the Nix integration clean and focused.

## Quick Start

Add to your flake inputs:

```nix
{
  inputs.signal.url = "github:lewisflude/signal-nix";
}
```

Enable in Home Manager:

```nix
{
  imports = [signal.homeManagerModules.default];
  
  theming.signal = {
    enable = true;
    mode = "dark"; # or "light"
    
    ironbar.enable = true;
    gtk.enable = true;
    helix.enable = true;
    # ... enable what you need
  };
}
```

## Supported Applications

**Current:**
- **Desktop**: Ironbar (with 3 display profiles), GTK 3/4, Fuzzel
- **Editors**: Helix (complete syntax theme)
- **Terminals**: Ghostty
- **CLI Tools**: bat, fzf, lazygit, yazi

**Planned:**
- Terminal multiplexers (Zellij)
- Notification daemons (Mako, SwayNC)
- Additional editors (Zed, Cursor)

## Design Philosophy

Signal is built on three core principles:

1. **Scientific**: Every color is a calculated solution, not an aesthetic choice
2. **Accessible**: APCA-compliant contrast ensures readability for all users
3. **Perceptually Uniform**: OKLCH color space provides consistent lightness across hues

Traditional color spaces (RGB, HSL) aren't perceptually uniform - the same lightness value looks different for different hues. OKLCH solves this, making it possible to create truly consistent color scales.

Read more:
- [Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md)
- [OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md)
- [Accessibility](https://github.com/lewisflude/signal-palette/blob/main/docs/accessibility.md)

## Brand Governance

A unique feature of Signal is its brand governance system, designed for professional use:

```nix
theming.signal.brandGovernance = {
  policy = "functional-override";  # Functional colors always win
  
  decorativeBrandColors = {
    brand-primary = "#5a7dcf";    # Your brand color
    brand-secondary = "#4a9b6f";
  };
};
```

Three policies available:
- `functional-override`: Safest - functional colors always win
- `separate-layer`: Brand colors exist alongside functional colors
- `integrated`: Brand colors can replace functional colors (must meet accessibility)

This prevents brand colors from compromising interface accessibility.

## Examples

See the [examples directory](https://github.com/lewisflude/signal-nix/tree/main/examples) for complete configurations:
- `basic.nix` - Minimal setup
- `full-desktop.nix` - All applications
- `custom-brand.nix` - Brand color customization

## Contributing

Contributions are welcome! Priority areas:
- Additional application integrations
- Light mode refinements
- Documentation improvements
- Testing on different configurations

See [CONTRIBUTING.md](https://github.com/lewisflude/signal-nix/blob/main/CONTRIBUTING.md) for guidelines.

## Technical Details

**Flake Structure:**
- Home Manager modules (primary interface)
- Library functions for color manipulation
- Development shell with formatters and linters
- Automated formatting checks

**CI/CD:**
- Flake checks on all platforms
- Format and lint validation
- Example configuration builds
- Automated releases

## Comparison

Signal takes a different approach compared to popular themes:

| Theme | Philosophy | Color Space |
|-------|-----------|-------------|
| Signal | Scientific, accessibility-first | OKLCH |
| Catppuccin | Warm, cozy aesthetic | HSL |
| Gruvbox | Retro, nostalgic | RGB |
| Dracula | High contrast, bold | RGB |

Each has its strengths - Signal prioritizes scientific accuracy and accessibility.

## Resources

- **Main Repository**: https://github.com/lewisflude/signal-nix
- **Color Palette**: https://github.com/lewisflude/signal-palette
- **Examples**: https://github.com/lewisflude/signal-nix/tree/main/examples
- **Documentation**: See README and docs/ directory

## Feedback

This is v1.0 and I'm actively gathering feedback. If you try Signal, I'd love to hear your experience!

Questions, suggestions, and contributions welcome. 🎨

---

**License**: MIT  
**Author**: Lewis Flude ([@lewisflude on Twitter/X](https://twitter.com/lewisflude))
```

---

## Hacker News

### Title
Signal – OKLCH-based design system for NixOS

### URL
https://github.com/lewisflude/signal-nix

### Text (optional comment)

```markdown
Author here! Signal is a design system I built for NixOS/Home Manager using the OKLCH color space and APCA contrast standards.

The key insight: traditional color spaces (RGB, HSL) aren't perceptually uniform. L=50% in HSL looks completely different for blue vs yellow. OKLCH solves this by being truly perceptually uniform - L=50% looks consistently "medium" across all hues.

This matters for theming because you can create color scales that actually look uniform, not just mathematically uniform. It also makes accessibility calculations more accurate.

Signal themes 10+ applications from a single config and includes a "brand governance" system that prevents decorative brand colors from compromising functional UI colors.

Two-repo architecture:
- signal-palette: Platform-agnostic colors (exports to JSON, CSS, JS, Nix)
- signal-nix: NixOS/Home Manager modules

Happy to answer questions about the design decisions, OKLCH, or the Nix implementation!
```

---

## Twitter/X Thread

### Thread Structure

**Tweet 1 (Introduction):**
```
🎨 Launching Signal - a design system for NixOS built on OKLCH color space + APCA accessibility standards

Unlike traditional themes, every color in Signal is a calculated solution to a functional problem

10+ apps themed from one config ✨

🧵 Let me show you what makes it different...

[Screenshot or demo video]

https://github.com/lewisflude/signal-nix
```

**Tweet 2 (Problem):**
```
Traditional color spaces aren't perceptually uniform

In HSL, L=50% looks different for each hue:
- Blue at 50%: dark
- Yellow at 50%: bright

This makes it impossible to create truly consistent color scales

[Visual comparison showing the problem]
```

**Tweet 3 (Solution):**
```
OKLCH fixes this

It's perceptually uniform - L=0.5 looks consistently "medium" across all hues

This is the same color space modern browsers are adopting (CSS Color Level 4)

Result: colors that actually look uniform, not just mathematically uniform

[Visual comparison showing OKLCH vs HSL]
```

**Tweet 4 (Accessibility):**
```
Signal uses APCA for contrast (not WCAG's flawed algorithm)

Every color combination is tested for accessibility:
- Text contrast
- Interactive elements
- Status indicators

Both light and dark modes meet accessibility standards

[Screenshot of themed interface]
```

**Tweet 5 (Setup):**
```
Setup is dead simple with Nix flakes:

inputs.signal.url = "github:lewisflude/signal-nix";

theming.signal = {
  enable = true;
  mode = "dark";
  ironbar.enable = true;
  gtk.enable = true;
  helix.enable = true;
};

That's it. Your entire desktop is themed consistently.
```

**Tweet 6 (Supported Apps):**
```
Currently supports:
✅ Ironbar (status bar)
✅ GTK 3/4
✅ Helix editor
✅ Ghostty terminal
✅ Fuzzel launcher
✅ bat, fzf, lazygit, yazi

Coming soon:
🔜 Zellij, Mako, SwayNC, Zed

[Screenshot montage]
```

**Tweet 7 (Brand Governance):**
```
Unique feature: Brand Governance

Separates decorative brand colors from functional UI colors

Prevents your blue brand from making error messages less visible

Three policies: functional-override, separate-layer, integrated

[Diagram or example]
```

**Tweet 8 (Philosophy):**
```
Signal's philosophy:

1. Scientific: Colors are calculated, not chosen aesthetically
2. Accessible: APCA-compliant contrast for all users
3. Perceptually Uniform: OKLCH ensures consistent lightness

Every design decision has a functional justification

[Link to philosophy doc]
```

**Tweet 9 (Architecture):**
```
Two-repo architecture:

📦 signal-palette: Platform-agnostic colors
- Exports: JSON, CSS, JS, Nix
- Versioned and stable

📦 signal-nix: NixOS/Home Manager modules
- One flake input
- Automatic dependency management

Use the palette outside Nix too!
```

**Tweet 10 (Call to Action):**
```
Signal v1.0 is out now!

⭐ Star: https://github.com/lewisflude/signal-nix
📖 Read: https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md
🤝 Contribute: Additional app integrations welcome!

Built something cool? Tag me - I'd love to see!

Perception, engineered. 🎨✨
```

---

## Mastodon Post

```markdown
🎨 Launching Signal - a design system for #NixOS built on OKLCH color space!

Unlike traditional themes that choose colors aesthetically, Signal uses scientific color theory:
- OKLCH color space (perceptually uniform)
- APCA accessibility standards
- Atomic design tokens
- Brand governance system

Quick setup with #Nix flakes:
```nix
theming.signal = {
  enable = true;
  mode = "dark";
  ironbar.enable = true;
  gtk.enable = true;
  helix.enable = true;
};
```

✨ 10+ applications themed from one config
🔬 Every color is a calculated solution
🌓 Light and dark modes
♿ Accessibility-first design

GitHub: https://github.com/lewisflude/signal-nix
Philosophy: https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md

#Linux #Wayland #DesignSystem #OKLCH #Accessibility
```

---

## GitHub Discussions Announcement

### Title
🎉 Signal v1.0 Released - OKLCH-based Design System

### Category
Announcements

### Body

```markdown
I'm thrilled to announce the release of **Signal v1.0** - a scientific, OKLCH-based design system for NixOS and Home Manager! 🎨✨

## What's Included

**Applications (10+):**
- Desktop: Ironbar, GTK 3/4, Fuzzel
- Editors: Helix (complete syntax theme)
- Terminals: Ghostty
- CLI Tools: bat, fzf, lazygit, yazi

**Features:**
- OKLCH color space (perceptually uniform)
- APCA accessibility standards
- Light and dark modes
- Brand governance system
- Atomic design tokens

## Get Started

Check out the [Quick Start guide](https://github.com/lewisflude/signal-nix#quick-start) to begin using Signal!

For a deeper dive into the philosophy, read:
- [Design Philosophy](https://github.com/lewisflude/signal-palette/blob/main/docs/philosophy.md)
- [OKLCH Explained](https://github.com/lewisflude/signal-palette/blob/main/docs/oklch-explained.md)
- [Accessibility](https://github.com/lewisflude/signal-palette/blob/main/docs/accessibility.md)

## What's Next

I'm actively working on:
- Additional application integrations (Zellij, Mako, SwayNC, Zed)
- Light mode refinements
- Community showcase gallery
- Tutorial content

## Share Your Setup

If you use Signal, I'd love to see your setup! Share screenshots in the [Show and Tell](https://github.com/lewisflude/signal-nix/discussions/categories/show-and-tell) category.

## Contributing

Contributions welcome! See [CONTRIBUTING.md](https://github.com/lewisflude/signal-nix/blob/main/CONTRIBUTING.md) for guidelines.

Priority areas:
- Application integrations
- Documentation improvements
- Light mode testing and feedback

## Feedback

Have thoughts, questions, or suggestions? Start a discussion or open an issue!

Thank you for checking out Signal! 🎉

---

**Perception, engineered.**
```

---

## Launch Checklist

Before posting announcements:

- [ ] Ensure all links work
- [ ] Take high-quality screenshots
- [ ] Record demo video (optional but recommended)
- [ ] Test quick start instructions
- [ ] Update README with any last-minute changes
- [ ] Push all changes to GitHub
- [ ] Create v1.0 tag and release
- [ ] Verify CI passes

**Posting Schedule:**

Day 1:
- [ ] Post to r/NixOS
- [ ] Post to NixOS Discourse
- [ ] Post GitHub Discussions announcement
- [ ] Tweet/X thread

Day 2-3:
- [ ] Post to r/unixporn (with screenshots)
- [ ] Post to Hacker News (if appropriate timing)
- [ ] Post to Mastodon
- [ ] Cross-post to other relevant subreddits

Day 4-7:
- [ ] Monitor feedback and respond
- [ ] Fix any urgent issues
- [ ] Update documentation based on questions

---

## Response Templates

### For Questions

```
Thanks for the question! [Answer]

For more details, check out:
- [Relevant documentation link]

Let me know if you need clarification!
```

### For Bug Reports

```
Thanks for reporting this! That's definitely a bug.

Could you provide:
- Your nixpkgs version
- Your configuration
- Any error messages

I'll investigate and fix this ASAP.
```

### For Feature Requests

```
Great idea! This would be a valuable addition.

I've opened an issue to track this: [link]

Would you be interested in contributing to this? I'd be happy to guide you through the process!
```

### For General Praise

```
Thank you! I'm glad you're finding Signal useful.

If you build something cool with it, I'd love to see screenshots - share in the Discussions!
```

---

## Notes

- Be responsive to early feedback (first 48 hours critical)
- Accept constructive criticism gracefully
- Fix urgent bugs immediately
- Document common questions in FAQ
- Thank contributors and early adopters
- Cross-promote between platforms
- Monitor multiple channels (GitHub, Reddit, Twitter, Discourse)

Good luck with the launch! 🚀
