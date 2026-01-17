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

#### ✅ SDDM Display Manager
- **What**: Login screen theme for KDE/Qt systems
- **Why**: Professional, consistent login experience
- **Option**: `theming.signal.nixos.login.sddm.enable`

```nix
theming.signal.nixos.login.sddm.enable = true;
```

**Result**: Complete SDDM theme with Signal colors, custom QML UI

#### ✅ Plymouth Boot Splash (NEW)
- **What**: Animated boot splash screen
- **Why**: Beautiful visual feedback during system startup
- **Option**: `theming.signal.nixos.boot.plymouth.enable`

```nix
theming.signal.nixos.boot.plymouth.enable = true;
# Also enable Plymouth in your boot config:
boot.plymouth.enable = true;
```

**Result**: Animated boot screen with Signal colors, progress bar, and spinner

#### ✅ GDM Display Manager (NEW)
- **What**: Login screen for GNOME desktop
- **Why**: Consistent theming for GNOME users
- **Option**: `theming.signal.nixos.login.gdm.enable`

```nix
theming.signal.nixos.login.gdm.enable = true;
# Also enable GDM:
services.xserver.displayManager.gdm.enable = true;
```

**Result**: GDM login screen themed with Signal GTK theme

#### ✅ LightDM Display Manager (NEW)
- **What**: Lightweight login screen with GTK greeter
- **Why**: Fast, minimal display manager with Signal colors
- **Option**: `theming.signal.nixos.login.lightdm.enable`

```nix
theming.signal.nixos.login.lightdm.enable = true;
# Also enable LightDM:
services.xserver.displayManager.lightdm.enable = true;
services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
```

**Result**: LightDM GTK greeter themed with Signal colors

### Coming Soon

See [NIXOS_MODULE_PLAN.md](../NIXOS_MODULE_PLAN.md) for the full roadmap:
- System-wide GTK/Qt themes
- System tools (dmenu, rofi, nano, vim)
- Advanced components (OpenRGB, journald colors)

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
      plymouth.enable = true;
    };
    
    login = {
      sddm.enable = true;     # KDE/Qt display manager
      # gdm.enable = true;    # Alternative: GNOME display manager
      # lightdm.enable = true; # Alternative: LightDM
    };
  };
  
  # Don't forget to also enable the services:
  boot.plymouth.enable = true;
  services.xserver.displayManager.sddm.enable = true;
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

### Plymouth Configuration

```nix
{
  theming.signal.nixos.boot.plymouth = {
    enable = true;
    # Optional: Custom logo image
    logo = ./logo.png;  # PNG, 256x256 recommended
  };
  
  # Required: Enable Plymouth service
  boot.plymouth.enable = true;
  
  # Optional: Boot parameters (Signal sets these automatically)
  # boot.kernelParams = [ "quiet" "splash" ];
}
```

### GDM Custom Background

```nix
{
  theming.signal.nixos.login.gdm = {
    enable = true;
    # Optional: Custom background for login screen
    backgroundImage = ./background.png;
  };
  
  # Required: Enable GDM
  services.xserver.displayManager.gdm.enable = true;
}
```

### LightDM Custom Background

```nix
{
  theming.signal.nixos.login.lightdm = {
    enable = true;
    # Optional: Custom background
    backgroundImage = ./background.jpg;
  };
  
  # Required: Enable LightDM with GTK greeter
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk.enable = true;
  };
}
```

## Component Details

### Plymouth Boot Splash

Signal's Plymouth theme features:
- **Animated Progress Bar**: Shows boot progress with Signal accent color
- **Spinner Animation**: Pulsing dots indicating activity
- **Text Branding**: "Signal" logo in text form
- **Password Prompts**: Themed unlock screens for encrypted drives
- **Status Messages**: Boot status updates in Signal colors

The theme is fully scriptable and generates all graphics programmatically, ensuring consistent colors without image files.

### GDM Theming

Signal themes GDM through:
- **System-wide GTK Theme**: Custom GTK3/GTK4 theme package
- **GSettings Overrides**: Applies theme to GDM user session
- **dconf Configuration**: Ensures theme persists across updates

Themed elements:
- Login screen background
- Input fields and buttons
- User selection UI
- Password prompts
- Power/session controls

### LightDM Theming

Signal themes LightDM's GTK greeter with:
- **GTK Theme**: Same Signal GTK theme as GDM
- **Greeter Configuration**: LightDM-specific color settings
- **Background**: Solid Signal colors or custom image

Themed elements:
- Login panel background
- Text input fields
- User list
- Session selector
- Clock and indicators

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

### Plymouth Not Showing

**Problem**: Boot splash doesn't appear

**Solution**:
1. Ensure both Signal module and Plymouth service are enabled:
   ```nix
   theming.signal.nixos.boot.plymouth.enable = true;
   boot.plymouth.enable = true;
   ```

2. Check kernel parameters include `quiet` and `splash`:
   ```bash
   cat /proc/cmdline
   ```

3. Rebuild and reboot:
   ```bash
   sudo nixos-rebuild switch
   sudo reboot
   ```

4. Verify theme is installed:
   ```bash
   ls /run/current-system/sw/share/plymouth/themes/
   ```

### GDM Not Themed

**Problem**: GDM login screen shows default theme

**Solution**:
1. Verify both GDM and Signal are enabled:
   ```nix
   services.xserver.displayManager.gdm.enable = true;
   theming.signal.nixos.login.gdm.enable = true;
   ```

2. Check GTK theme is installed:
   ```bash
   ls /run/current-system/sw/share/themes/ | grep Signal
   ```

3. Verify dconf settings:
   ```bash
   sudo dconf dump /org/gnome/desktop/interface/
   ```

4. Restart display manager:
   ```bash
   sudo systemctl restart display-manager
   ```

### LightDM Not Themed

**Problem**: LightDM shows default greeter theme

**Solution**:
1. Ensure LightDM and GTK greeter are both enabled:
   ```nix
   services.xserver.displayManager.lightdm.enable = true;
   services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
   theming.signal.nixos.login.lightdm.enable = true;
   ```

2. Check LightDM configuration:
   ```bash
   cat /etc/lightdm/lightdm-gtk-greeter.conf
   ```

3. Verify theme name:
   ```bash
   grep "theme-name" /etc/lightdm/lightdm-gtk-greeter.conf
   ```

4. Restart LightDM:
   ```bash
   sudo systemctl restart display-manager
   ```

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
