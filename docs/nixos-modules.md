# Signal NixOS Modules - Getting Started

> **System-level theming for NixOS components**

Signal now supports NixOS system-level theming in addition to Home Manager user-level theming. This allows you to theme boot screens, display managers, and other system components with Signal colors.

## Table of Contents

- [Quick Start](#quick-start)
- [What Gets Themed](#what-gets-themed)
- [Configuration](#configuration)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## Quick Start

### 1. Add Signal to your flake inputs

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    signal.url = "github:lewisflude/signal-nix";
  };
}
```

### 2. Import NixOS module

```nix
{
  outputs = { nixpkgs, signal, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        signal.nixosModules.default  # Add this
      ];
    };
  };
}
```

### 3. Enable Signal theming

```nix
# configuration.nix
{
  theming.signal.nixos = {
    enable = true;
    mode = "dark";  # or "light"
    
    # Enable components
    boot = {
      console.enable = true;  # TTY colors
      grub.enable = true;     # GRUB theme
    };
  };
}
```

### 4. Rebuild

```bash
sudo nixos-rebuild switch
```

That's it! Your system components now use Signal colors.

## What Gets Themed

### Current Implementation (v1.0)

#### ✅ Virtual Console (TTY)
- **What**: Text colors in virtual terminals (Ctrl+Alt+F1-F6)
- **Why**: Consistent colors in emergency/recovery mode
- **Option**: `theming.signal.nixos.boot.console.enable`

```nix
theming.signal.nixos.boot.console.enable = true;
```

**Result**: 16 ANSI colors matching your terminal emulators

#### ✅ GRUB Bootloader
- **What**: Boot menu theme with Signal colors
- **Why**: Beautiful first impression when booting
- **Option**: `theming.signal.nixos.boot.grub.enable`

```nix
theming.signal.nixos.boot.grub.enable = true;
```

**Result**: GRUB menu styled with Signal colors (background, text, selection)

#### ✅ SDDM Display Manager (NEW)
- **What**: Login screen theme for KDE/Qt systems
- **Why**: Professional, consistent login experience
- **Option**: `theming.signal.nixos.login.sddm.enable`

```nix
theming.signal.nixos.login.sddm.enable = true;
```

**Result**: Complete SDDM theme with Signal colors, custom QML UI

### Coming Soon

See [NIXOS_MODULE_PLAN.md](../NIXOS_MODULE_PLAN.md) for the full roadmap:
- GDM display manager (GNOME)
- LightDM display manager
- Plymouth boot splash
- System-wide GTK/Qt themes
- System tools (dmenu, rofi, nano, vim)

## Configuration

### Basic Configuration

```nix
{
  theming.signal.nixos = {
    enable = true;
    mode = "dark";  # "dark", "light", or "auto"
    
    boot = {
      console.enable = true;
      grub.enable = true;
    };
    
    login = {
      sddm.enable = true;  # KDE/Qt display manager
    };
  };
}
```

### With Home Manager

You can use both NixOS and Home Manager modules together:

```nix
{
  # System-level theming
  theming.signal.nixos = {
    enable = true;
    mode = "dark";
    boot.console.enable = true;
    boot.grub.enable = true;
  };

  # User-level theming (Home Manager)
  home-manager.users.alice = {
    imports = [ signal.homeManagerModules.default ];
    
    theming.signal = {
      enable = true;
      mode = "dark";  # Can be different from system!
      autoEnable = true;
    };
  };
}
```

### Granular Module Import

Import only specific components:

```nix
{
  # Import only console theming
  imports = [ signal.nixosModules.boot ];
  
  theming.signal.nixos = {
    enable = true;
    boot.console.enable = true;
  };
}
```

### Custom GRUB Background

Override the default background:

```nix
{
  theming.signal.nixos.boot.grub = {
    enable = true;
    customBackground = ./wallpaper.png;  # Your image
  };
}
```

## Examples

### Minimal Boot Theming

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs = { nixpkgs, signal, ... }: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        signal.nixosModules.default
        {
          theming.signal.nixos = {
            enable = true;
            mode = "dark";
            boot.console.enable = true;
            boot.grub.enable = true;
          };
          
          # Your existing NixOS config
          boot.loader.grub = {
            enable = true;
            device = "/dev/sda";
          };
        }
      ];
    };
  };
}
```

### Complete System + User Theming

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs = { nixpkgs, home-manager, signal, ... }: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        signal.nixosModules.default
        home-manager.nixosModules.home-manager
        
        {
          # System-level Signal theming
          theming.signal.nixos = {
            enable = true;
            mode = "dark";
            boot = {
              console.enable = true;
              grub.enable = true;
            };
          };

          # Home Manager configuration
          home-manager.users.alice = {
            imports = [ signal.homeManagerModules.default ];
            
            # User-level Signal theming
            theming.signal = {
              enable = true;
              mode = "dark";
              autoEnable = true;
            };
            
            # Enable programs (Signal will theme them)
            programs = {
              helix.enable = true;
              kitty.enable = true;
              bat.enable = true;
            };
          };
        }
      ];
    };
  };
}
```

### Different Modes for System vs User

```nix
{
  # Light mode for system (boot screens, login)
  theming.signal.nixos = {
    enable = true;
    mode = "light";
    boot.console.enable = true;
  };

  # Dark mode for user (terminals, editors)
  home-manager.users.alice = {
    theming.signal = {
      enable = true;
      mode = "dark";
      autoEnable = true;
    };
  };
}
```

## Troubleshooting

### Console Colors Not Showing

**Problem**: TTY still shows default colors

**Solution**:
1. Check that the module is enabled:
   ```nix
   theming.signal.nixos.boot.console.enable = true;
   ```

2. Verify configuration applied:
   ```bash
   sudo nixos-rebuild switch
   ```

3. Test in TTY (Ctrl+Alt+F2)

4. Check generated config:
   ```bash
   cat /etc/console.conf  # or similar
   ```

### GRUB Theme Not Applying

**Problem**: GRUB still uses default theme

**Solution**:
1. Ensure GRUB is enabled in your config:
   ```nix
   boot.loader.grub.enable = true;
   ```

2. Enable Signal theme:
   ```nix
   theming.signal.nixos.boot.grub.enable = true;
   ```

3. Rebuild and reboot:
   ```bash
   sudo nixos-rebuild switch
   sudo reboot
   ```

4. Check GRUB configuration:
   ```bash
   cat /boot/grub/grub.cfg | grep theme
   ```

### Module Conflicts

**Problem**: Error about duplicate options

**Solution**:
Signal NixOS modules use `theming.signal.nixos.*` namespace, separate from Home Manager's `theming.signal.*`. They should not conflict.

If you see conflicts:
- Check you're not importing the same module twice
- Ensure you're using `nixosModules.default` for NixOS and `homeManagerModules.default` for Home Manager

### Testing in VM

Test your configuration in a VM before applying:

```bash
# Build VM
nixos-rebuild build-vm --flake .#yourhostname

# Run VM
./result/bin/run-*-vm
```

This lets you verify boot screens and TTY colors without rebooting your main system.

## Design Philosophy

Signal NixOS modules follow the same "colors only" philosophy:

### ✅ Signal Does
- Set color values
- Apply Signal palette
- Generate themed config files

### ❌ Signal Does NOT
- Enable system services
- Install packages
- Configure behavior
- Set fonts or layouts

You enable services, Signal colors them.

## Next Steps

1. **Explore the plan**: See [NIXOS_MODULE_PLAN.md](../NIXOS_MODULE_PLAN.md) for upcoming features
2. **Contribute**: Help implement display managers or other components
3. **Report issues**: Found a bug? Open an issue on GitHub
4. **Request features**: Want a specific component themed? Let us know!

## Related Documentation

- [Home Manager Module Documentation](getting-started.md)
- [Architecture Overview](architecture.md)
- [NixOS Module Implementation Plan](../NIXOS_MODULE_PLAN.md)
- [Design Principles](design-principles.md)

---

**Status**: Early Access (v1.0)  
**Stability**: Experimental - API may change  
**Support**: NixOS 24.05+
