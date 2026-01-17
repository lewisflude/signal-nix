# Advanced Usage

Power user features and advanced configuration patterns for Signal.

## Table of Contents

- [Multi-Machine Configuration](#multi-machine-configuration)
- [Brand Governance](#brand-governance)
- [Theme Conflicts and Precedence](#theme-conflicts-and-precedence)
- [Per-Application Overrides](#per-application-overrides)
- [Custom Color Mappings](#custom-color-mappings)
- [Integration with Other Themes](#integration-with-other-themes)
- [Performance Optimization](#performance-optimization)
- [Development Workflow](#development-workflow)

## Multi-Machine Configuration

### Shared Base with Machine-Specific Overrides

Use a common Signal config across machines with per-machine program selections.

**Structure:**

```
~/.config/home-manager/
├── flake.nix
├── common/
│   ├── signal.nix       # Shared Signal config
│   └── programs.nix     # Shared program config
└── hosts/
    ├── desktop.nix      # Desktop-specific
    ├── laptop.nix       # Laptop-specific
    └── server.nix       # Server-specific
```

**common/signal.nix:**

```nix
{ ... }:

{
  # Base Signal configuration shared across all machines
  theming.signal = {
    enable = true;
    autoEnable = true;
    mode = "dark";
    
    # Common settings
    brandGovernance = {
      policy = "functional-override";
      decorativeBrandColors = {
        brand-primary = "#5a7dcf";
      };
    };
  };
}
```

**hosts/desktop.nix:**

```nix
{ ... }:

{
  imports = [
    ../common/signal.nix
  ];
  
  # Desktop has full GUI setup
  programs = {
    helix.enable = true;
    kitty.enable = true;
    ironbar.enable = true;
    fuzzel.enable = true;
  };
  
  gtk.enable = true;
  
  # Desktop-specific overrides
  theming.signal.ironbar = {
    enable = true;
    profile = "spacious";  # 4K display
  };
}
```

**hosts/laptop.nix:**

```nix
{ ... }:

{
  imports = [
    ../common/signal.nix
  ];
  
  # Laptop has minimal GUI
  programs = {
    helix.enable = true;
    alacritty.enable = true;  # Lighter than kitty
  };
  
  # Laptop-specific overrides
  theming.signal = {
    ironbar = {
      enable = true;
      profile = "compact";  # 1080p laptop screen
    };
  };
}
```

**hosts/server.nix:**

```nix
{ ... }:

{
  imports = [
    ../common/signal.nix
  ];
  
  # Server has CLI-only setup
  programs = {
    helix.enable = true;
    tmux.enable = true;
    bat.enable = true;
    fzf.enable = true;
  };
  
  # No GUI applications, Signal only themes CLI
}
```

**flake.nix:**

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs = { nixpkgs, home-manager, signal, ... }: {
    homeConfigurations = {
      "user@desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          signal.homeManagerModules.default
          ./hosts/desktop.nix
        ];
      };
      
      "user@laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          signal.homeManagerModules.default
          ./hosts/laptop.nix
        ];
      };
      
      "user@server" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          signal.homeManagerModules.default
          ./hosts/server.nix
        ];
      };
    };
  };
}
```

**Rebuild specific machine:**

```bash
# Desktop
home-manager switch --flake .#user@desktop

# Laptop
home-manager switch --flake .#user@laptop

# Server
home-manager switch --flake .#user@server
```

### Environment-Based Configuration

Automatically adjust config based on environment variables or hostname:

```nix
{ config, pkgs, lib, ... }:

let
  hostname = config.networking.hostName or "unknown";
  isDesktop = hostname == "my-desktop";
  isLaptop = hostname == "my-laptop";
  
  # Detect screen resolution (requires xrandr)
  resolution = builtins.readFile (
    pkgs.runCommand "get-resolution" {} ''
      ${pkgs.xorg.xrandr}/bin/xrandr | grep primary | cut -d' ' -f4 | cut -d'+' -f1 > $out
    ''
  );
  
  ironbarProfile = 
    if lib.hasPrefix "3840" resolution then "spacious"
    else if lib.hasPrefix "2560" resolution then "relaxed"
    else "compact";
in
{
  theming.signal = {
    enable = true;
    autoEnable = true;
    mode = "dark";
    
    ironbar = lib.mkIf (isDesktop || isLaptop) {
      enable = true;
      profile = ironbarProfile;
    };
  };
}
```

## Brand Governance

### Custom Brand Colors with Accessibility Validation

When using `integrated` policy, ensure brand colors meet contrast requirements:

```nix
{ config, lib, ... }:

let
  # Your brand colors
  brandPrimary = "#5a7dcf";    # Brand blue
  brandSecondary = "#4a9b6f";  # Brand green
  brandDanger = "#e8615d";     # Brand red
  
  # Validate contrast (simplified example)
  # In practice, use proper APCA calculation
  hasGoodContrast = color: background:
    # Your validation logic here
    true;
in
{
  theming.signal = {
    enable = true;
    mode = "dark";
    
    brandGovernance = {
      # Only use integrated if colors pass validation
      policy = if hasGoodContrast brandPrimary "#000000"
               then "integrated"
               else "functional-override";
      
      decorativeBrandColors = {
        brand-primary = brandPrimary;
        brand-secondary = brandSecondary;
        brand-danger = brandDanger;
      };
    };
  };
}
```

### Separate Light and Dark Brand Colors

Different brand colors for light and dark modes:

```nix
{ config, ... }:

let
  isDark = config.theming.signal.mode == "dark";
  
  brandColors = if isDark then {
    brand-primary = "#6b8bd8";    # Lighter blue for dark bg
    brand-secondary = "#5aab7f";  # Lighter green for dark bg
  } else {
    brand-primary = "#4a6baf";    # Darker blue for light bg
    brand-secondary = "#3a8b5f";  # Darker green for light bg
  };
in
{
  theming.signal = {
    enable = true;
    mode = "dark";
    
    brandGovernance = {
      policy = "separate-layer";
      decorativeBrandColors = brandColors;
    };
  };
}
```

## Theme Conflicts and Precedence

### Understanding Theme Precedence

When multiple theme systems are active, understand the precedence:

**Signal's position in the module system:**

```nix
{
  # 1. Base configuration (lowest priority)
  programs.helix.settings.theme = "default";
  
  # 2. Signal theme (middle priority)
  theming.signal.editors.helix.enable = true;
  
  # 3. Manual override (highest priority)
  programs.helix.settings.theme = lib.mkForce "my-custom-theme";
}
```

Signal uses `lib.mkDefault` for most options, allowing easy override with `lib.mkForce`.

### Explicitly Disabling Signal for Specific Apps

To preserve custom themes for specific apps:

```nix
{
  # Enable custom theme for helix
  programs.helix = {
    enable = true;
    settings.theme = "gruvbox";
  };
  
  # Signal themes everything except helix
  theming.signal = {
    enable = true;
    autoEnable = true;
    
    editors.helix.enable = false;  # Preserve custom theme
  };
}
```

### Mixing Multiple Theme Systems

Use Signal alongside other theme managers:

```nix
{
  # Stylix for system-wide theming
  stylix.enable = true;
  stylix.image = ./wallpaper.jpg;
  
  # Signal for application-specific colors
  theming.signal = {
    enable = true;
    mode = "dark";
    
    # Manually select apps to avoid conflicts
    editors.helix.enable = true;
    terminals.kitty.enable = true;
    cli.bat.enable = true;
  };
}
```

## Per-Application Overrides

### Custom Color Overrides

Override Signal colors for specific applications:

```nix
{
  theming.signal = {
    enable = true;
    editors.helix.enable = true;
  };
  
  # Override specific helix colors
  programs.helix.themes.signal-dark = lib.mkForce {
    # Use Signal's theme as base
    inherit (config.programs.helix.themes.signal-dark) palette;
    
    # Override specific syntax colors
    "keyword" = "#ff0000";  # Custom red for keywords
  };
}
```

### Application-Specific Theme Mode

Use different modes for different applications (requires wrapper):

```nix
{ config, lib, ... }:

let
  # Helper to create themed wrapper
  makeThemedWrapper = { package, mode }:
    pkgs.writeShellScriptBin package.pname ''
      SIGNAL_MODE=${mode} ${package}/bin/${package.pname} "$@"
    '';
in
{
  theming.signal = {
    enable = true;
    mode = "dark";  # Default dark mode
  };
  
  # Override kitty to use light mode
  home.packages = [
    (makeThemedWrapper {
      package = pkgs.kitty;
      mode = "light";
    })
  ];
}
```

**Note**: This is an example pattern. Signal doesn't currently support per-app mode overrides natively.

## Custom Color Mappings

### Accessing Signal Colors Directly

Use Signal's color palette in your own configurations:

```nix
{ config, ... }:

let
  signalColors = config.theming.signal.colors.dark;  # or .light
in
{
  # Use Signal colors in custom application configs
  programs.custom-app.colors = {
    background = signalColors.tonal."surface-Lc05".hex;
    foreground = signalColors.tonal."text-Lc75".hex;
    accent = signalColors.accent.focus.Lc75.hex;
  };
}
```

### Creating Custom Application Themes

Extend Signal to theme unsupported applications:

```nix
{ config, lib, ... }:

let
  cfg = config.theming.signal;
  signalLib = config.signalLib;
  colors = signalLib.getColors (signalLib.resolveThemeMode cfg.mode);
in
{
  # Your custom application
  programs.my-app = lib.mkIf cfg.enable {
    theme = {
      background = colors.tonal."surface-Lc05".hex;
      foreground = colors.tonal."text-Lc75".hex;
      
      syntax = {
        keyword = colors.accent.special.Lc75.hex;
        string = colors.categorical.GA02.hex;
        function = colors.accent.focus.Lc75.hex;
      };
    };
  };
}
```

## Integration with Other Themes

### Gradual Migration from Another Theme

Migrate from another theme system incrementally:

**Step 1: Enable both themes**

```nix
{
  # Old theme (Catppuccin example)
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
  
  # Signal (disabled initially)
  theming.signal = {
    enable = false;
    mode = "dark";
  };
}
```

**Step 2: Test Signal on one app**

```nix
{
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
  
  theming.signal = {
    enable = true;
    # autoEnable = false
    
    # Test on just helix
    editors.helix.enable = true;
  };
  
  # Disable Catppuccin for helix
  catppuccin.helix.enable = false;
}
```

**Step 3: Gradually expand**

```nix
{
  catppuccin.enable = true;
  
  theming.signal = {
    enable = true;
    
    # Add more apps as you test
    editors.helix.enable = true;
    terminals.kitty.enable = true;
    cli.bat.enable = true;
  };
  
  # Disable Catppuccin for these
  catppuccin = {
    helix.enable = false;
    kitty.enable = false;
    bat.enable = false;
  };
}
```

**Step 4: Full migration**

```nix
{
  # Remove old theme
  catppuccin.enable = false;
  
  # Use Signal everywhere
  theming.signal = {
    enable = true;
    autoEnable = true;
    mode = "dark";
  };
}
```

### Hybrid Theme Setup

Use different themes for different application categories:

```nix
{
  # Gruvbox for editors
  programs.helix.settings.theme = "gruvbox";
  programs.neovim.colorscheme = "gruvbox";
  
  # Signal for everything else
  theming.signal = {
    enable = true;
    autoEnable = true;
    
    # Disable editors (using Gruvbox)
    editors = {
      helix.enable = false;
      neovim.enable = false;
    };
  };
}
```

## Performance Optimization

### Lazy Evaluation

Signal modules use `mkIf` guards to avoid unnecessary evaluation:

```nix
# Signal modules only evaluate when enabled
theming.signal.editors.helix.enable = false;
# ↑ The entire helix theme config is not evaluated
```

### Reducing Rebuild Times

If you frequently change Signal settings, separate them into their own file:

```nix
# theming.nix
{ ... }:

{
  theming.signal = {
    enable = true;
    autoEnable = true;
    mode = "dark";
  };
}
```

Changes to this file only rebuild Signal-related configuration.

### Caching Theme Evaluations

For large configurations, use `lib.mkDefault` to allow override without re-evaluation:

```nix
{
  theming.signal = {
    enable = lib.mkDefault true;
    mode = lib.mkDefault "dark";
  };
}
```

## Development Workflow

### Testing Theme Changes

When developing custom Signal themes or modifications:

```nix
{
  # Use local checkout of signal-nix
  inputs.signal.url = "path:/home/user/projects/signal-nix";
  
  # Or use a specific branch
  inputs.signal.url = "github:lewisflude/signal-nix/feature-branch";
}
```

### Quick Theme Switching

Create aliases for quick mode switching:

```bash
# ~/.bashrc or ~/.zshrc
alias theme-light='sed -i "s/mode = \"dark\"/mode = \"light\"/" ~/.config/home-manager/theming.nix && home-manager switch'
alias theme-dark='sed -i "s/mode = \"light\"/mode = \"dark\"/" ~/.config/home-manager/theming.nix && home-manager switch'
```

### Preview Changes Before Applying

Build without activating:

```bash
# Build configuration
home-manager build --flake .

# Inspect the result
ls -la result/

# Check specific program config
cat result/home-files/.config/helix/config.toml

# Activate if satisfied
./result/activate
```

## Tips and Tricks

### Environment-Based Mode Switching

Switch between light/dark based on time of day:

```nix
{ config, pkgs, lib, ... }:

let
  hour = builtins.substring 0 2 (builtins.readFile (
    pkgs.runCommand "get-hour" {} "${pkgs.coreutils}/bin/date +%H > $out"
  ));
  
  # Light mode 8am-8pm, dark otherwise
  isDaytime = hour >= "08" && hour < "20";
  themeMode = if isDaytime then "light" else "dark";
in
{
  theming.signal = {
    enable = true;
    mode = themeMode;
  };
}
```

**Note**: This evaluates at build time, not runtime. For runtime switching, use system theme detection.

### Conditional Theming by Program Version

Apply Signal only for compatible program versions:

```nix
{ config, pkgs, lib, ... }:

let
  helixVersion = pkgs.helix.version;
  supportsSignal = lib.versionAtLeast helixVersion "23.10";
in
{
  theming.signal.editors.helix.enable = lib.mkDefault supportsSignal;
}
```

## Next Steps

- **Troubleshooting** - See [Troubleshooting Guide](troubleshooting.md)
- **Contributing** - Add support for new applications ([CONTRIBUTING.md](../CONTRIBUTING.md))
- **Architecture** - Understand Signal internals ([Architecture](architecture.md))
