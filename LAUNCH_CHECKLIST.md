# 🚀 Signal Launch Checklist

Quick reference for launching Signal Design System v1.0.

---

## Pre-Launch (1-2 Days Before)

### Technical Preparation

- [ ] **Push all changes to GitHub**
  ```bash
  cd ~/Code/signal-nix
  git add .
  git commit -m "feat: complete launch preparation infrastructure"
  git push origin main
  ```

- [ ] **Verify CI passes**
  - Check Actions tab on GitHub
  - Ensure all workflows (flake-check, format-check, build-examples) pass
  - Fix any failures

- [ ] **Test quick start guide**
  ```bash
  # Try the quick start in a clean environment
  # Verify it works as documented
  ```

- [ ] **Proofread documentation**
  - README.md
  - CONTRIBUTING.md
  - docs/*.md
  - Check for typos, broken links

### Visual Assets

- [ ] **Take desktop screenshots** (2-3 hours)
  - Full desktop overview
  - Ironbar (all widgets)
  - GTK applications
  - Helix editor
  - Terminal applications
  - CLI tools
  - See: `docs/screenshot-guide.md`

- [ ] **Optimize images**
  ```bash
  for img in screenshots/*.png; do
    optipng -o7 "$img"
  done
  ```

- [ ] **Organize screenshots**
  ```bash
  mkdir -p screenshots/{desktop,applications,comparisons}
  # Move and rename per naming convention
  ```

### Repository Setup

- [ ] **Enable GitHub Discussions**
  - Go to Settings → Features
  - Enable Discussions
  - Create categories from `.github/DISCUSSION_CATEGORIES.yml`

- [ ] **Verify repository settings**
  - Description: "Signal Design System - NixOS and Home Manager integration"
  - Topics: nix, nixos, home-manager, theme, design-system, oklch, wayland
  - Website: (optional)

- [ ] **Update social links**
  - Twitter: @lewisflude (or update in templates)
  - Mastodon: (if applicable)

---

## Launch Day

### Morning (Create Release)

- [ ] **Create v1.0.0 tag**
  ```bash
  git tag -a v1.0.0 -m "Signal Design System v1.0.0"
  git push origin v1.0.0
  ```

- [ ] **Verify GitHub release created**
  - Check Releases page
  - Verify release notes look good
  - Verify assets uploaded (examples.tar.gz, modules.tar.gz, etc.)

- [ ] **Test installation from release**
  ```nix
  inputs.signal.url = "github:lewisflude/signal-nix/v1.0.0";
  ```

### Morning (Post to Communities)

- [ ] **Post to r/NixOS**
  - Copy post from `docs/launch-announcement.md` (r/NixOS section)
  - Include 1-2 screenshots
  - Add flair: "Show Nix" or "Projects"
  - Post link: https://reddit.com/r/NixOS/submit

- [ ] **Post to NixOS Discourse**
  - Copy post from `docs/launch-announcement.md` (Discourse section)
  - Category: Links
  - Tags: home-manager, theming, wayland
  - Post link: https://discourse.nixos.org/new-topic

- [ ] **GitHub Discussions announcement**
  - Copy post from `docs/launch-announcement.md` (Discussions section)
  - Category: Announcements
  - Pin the post

### Afternoon (Social Media)

- [ ] **Twitter/X thread**
  - Copy thread from `docs/launch-announcement.md` (Twitter section)
  - Add screenshots/GIFs to each tweet
  - Use hashtags: #NixOS #Linux #Wayland #DesignSystem
  - Schedule or post immediately

- [ ] **Mastodon**
  - Copy post from `docs/launch-announcement.md` (Mastodon section)
  - Add screenshots
  - Use hashtags
  - Post to relevant instances

### Evening (Monitor & Respond)

- [ ] **Monitor feedback channels**
  - Reddit comments
  - Discourse replies
  - Twitter mentions
  - GitHub Issues/Discussions

- [ ] **Respond to questions**
  - Use response templates from `docs/launch-announcement.md`
  - Be friendly and helpful
  - Thank people for feedback

- [ ] **Address urgent issues**
  - Fix critical bugs immediately
  - Document workarounds
  - Update documentation if needed

---

## Post-Launch (Days 2-7)

### Day 2-3

- [ ] **Post to r/unixporn** (with screenshots)
  - Copy post from `docs/launch-announcement.md` (unixporn section)
  - Include multiple high-quality screenshots
  - Flair: [Niri/Ironbar] or [OC]
  - Post link: https://reddit.com/r/unixporn/submit

- [ ] **Consider Hacker News** (if good timing)
  - Copy text from `docs/launch-announcement.md` (HN section)
  - Post link: https://news.ycombinator.com/submit
  - Title: "Signal – OKLCH-based design system for NixOS"
  - **Note**: Only post if you can engage in comments for several hours

### Day 4-7

- [ ] **Update FAQ** based on common questions

- [ ] **Fix reported bugs**
  - Prioritize user-facing issues
  - Create patch release if needed

- [ ] **Thank contributors**
  - Early adopters
  - Bug reporters
  - Feature requesters

- [ ] **Cross-post** to other communities (if relevant)
  - r/Wayland
  - r/Linux
  - r/commandline

---

## Success Metrics

Track these metrics to gauge launch success:

### GitHub (Week 1)
- [ ] 50+ stars on signal-nix
- [ ] 100+ stars on signal-palette
- [ ] 10+ forks combined
- [ ] 5+ meaningful issues/PRs

### Reddit (Week 1)
- [ ] 100+ upvotes on r/NixOS
- [ ] 50+ upvotes on r/unixporn
- [ ] Positive comments/feedback

### Community (Week 1)
- [ ] 20+ Discourse replies
- [ ] 10+ GitHub Discussions posts
- [ ] 1000+ Twitter impressions

---

## Emergency Procedures

### If CI Fails on v1.0.0 Tag

1. Don't panic - delete the tag
   ```bash
   git tag -d v1.0.0
   git push origin :refs/tags/v1.0.0
   ```

2. Fix the issue locally

3. Test thoroughly

4. Re-create the tag
   ```bash
   git tag -a v1.0.0 -m "Signal Design System v1.0.0"
   git push origin v1.0.0
   ```

### If Critical Bug Found

1. Acknowledge the issue immediately

2. Create hotfix branch
   ```bash
   git checkout -b hotfix/critical-bug
   ```

3. Fix and test

4. Create v1.0.1 release
   ```bash
   git tag -a v1.0.1 -m "Fix critical bug in..."
   git push origin v1.0.1
   ```

5. Announce the fix

### If Overwhelmed by Feedback

1. Triage issues by severity
   - P0: Blocks all users (fix immediately)
   - P1: Blocks some users (fix within 24h)
   - P2: Inconvenient but has workaround (fix within week)
   - P3: Enhancement/feature request (backlog)

2. Use response templates from launch materials

3. Ask community for help if needed

4. It's okay to say "I'll look into this tomorrow"

---

## Post-Launch Tasks (Week 2+)

### Optional Enhancements

- [ ] Create demo videos
  - Desktop tour (1-2 min)
  - Application showcases (30-60s each)
  - Upload to YouTube

- [ ] Build community showcase
  - Collect user screenshots
  - Create gallery page
  - Feature in README

- [ ] Write blog post (if you have a blog)
  - Technical deep dive
  - Design decisions
  - Lessons learned

- [ ] Create tutorial series
  - Getting started
  - Customization
  - Contributing

### Maintenance

- [ ] Regular dependency updates
  ```bash
  nix flake update
  ```

- [ ] Monitor for issues

- [ ] Review and merge PRs

- [ ] Update documentation as needed

- [ ] Consider nixpkgs submission (after community validation)

---

## Quick Commands Reference

```bash
# Check current status
git status
nix flake check

# Create release
git tag -a v1.0.0 -m "Signal Design System v1.0.0"
git push origin v1.0.0

# Update dependencies
nix flake update
nix flake update signal-palette

# Test locally
home-manager switch --flake .#

# Check workflows
gh workflow list
gh run list

# View discussions
gh api repos/lewisflude/signal-nix/discussions
```

---

## Resources

- **Launch Materials**: `docs/launch-announcement.md`
- **Screenshot Guide**: `docs/screenshot-guide.md`
- **Progress Report**: `LAUNCH_PROGRESS.md`
- **Contributing**: `CONTRIBUTING.md`
- **Troubleshooting**: `docs/troubleshooting.md`

---

## Final Pre-Launch Check

Before pressing "Launch":

- [ ] All files committed and pushed
- [ ] CI passing
- [ ] Screenshots ready
- [ ] Documentation reviewed
- [ ] GitHub Discussions enabled
- [ ] Release notes prepared
- [ ] Announcement posts drafted
- [ ] Energy drink ready ☕
- [ ] Ready to respond to feedback

---

## Remember

- **Be responsive**: First 48 hours are critical
- **Be kind**: Every question is valid
- **Be patient**: People are learning your system
- **Be thankful**: Contributors make it better
- **Be honest**: If something's broken, acknowledge it
- **Be proud**: You built something amazing! 🎨✨

---

**Good luck with the launch!** 🚀

You've got this. The infrastructure is solid, the documentation is comprehensive, and the project is ready. Now it's time to share it with the world.

**Perception, engineered.** 🎨
