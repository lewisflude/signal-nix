# Signal-nix TODO & Future Tasks

This file tracks ongoing tasks and future improvements for Signal Design System.

## Active Tasks

### High Priority

- [ ] Monitor and respond to user feedback in Discussions and Issues
- [ ] Review and merge community contributions
- [ ] Keep dependencies up to date (run `nix flake update` periodically)

### Medium Priority

- [ ] Consider submitting to nixpkgs after community validation
- [ ] Create demo videos if requested by community:
  - Desktop tour (1-2 min)
  - Application showcases (30-60s each)
  - OKLCH color space explanation
- [ ] Build community showcase gallery with user screenshots
- [ ] Post to additional communities if interest grows:
  - r/unixporn (with high-quality screenshots)
  - Hacker News (if appropriate timing/interest)

### Low Priority

- [ ] Write blog post about design decisions and lessons learned
- [ ] Create tutorial series for advanced customization
- [ ] Consider automated CI checks for design principle violations
- [ ] Explore additional application integrations based on user requests

## Maintenance

### Regular Tasks

- [ ] Weekly: Check for new issues and discussions
- [ ] Monthly: Update dependencies with `nix flake update`
- [ ] Quarterly: Review and update documentation
- [ ] As needed: Create patch releases for critical bugs

### Release Process

When creating a new release:

1. Update `CHANGELOG.md` with changes
2. Create release tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
3. Push tag: `git push origin vX.Y.Z`
4. GitHub Actions will create the release automatically
5. Use `.github/RELEASE_TEMPLATE.md` as a guide for release notes
6. Announce in Discussions

## Future Enhancements

### Potential Features

- Additional application integrations (community-driven)
- Enhanced brand governance policies
- More ironbar widget customization options
- Improved light mode refinements based on feedback
- Performance optimizations for module evaluation

### Community Building

- Feature user configurations in a showcase
- Create contributor recognition system
- Develop beginner-friendly "good first issue" tasks
- Write guide for contributing new application modules

## Completed

✅ Launch v1.0  
✅ Comprehensive documentation overhaul  
✅ Testing suite with 30+ tests  
✅ Example configurations for common use cases  
✅ GitHub Issues templates and workflows  
✅ Troubleshooting guide with diagnostics  
✅ Design principles documentation  

---

**Note**: This file replaces the temporary launch tracking files which have been removed after successful launch.

Last updated: 2026-01-17
