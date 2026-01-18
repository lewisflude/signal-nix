# Getting Started with Signal

This guide helps you adopt the Signal color theme in your Nix environment, whether you're using NixOS, nix-darwin (macOS), or standalone Home Manager.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Choose Your Setup](#choose-your-setup)
- [New Configuration](#new-configuration-greenfield)
- [Existing Configuration](#existing-configuration-migration)
- [Standalone Home Manager](#standalone-home-manager)
- [NixOS with Home Manager](#nixos-with-home-manager)
- [Nix-darwin (macOS)](#nix-darwin-macos)
- [Without Flakes (Legacy)](#without-flakes-legacy)
- [Verification](#verification)
- [Next Steps](#next-steps)

## Prerequisites

- **Nix** with flakes enabled - [Install Nix with flakes](https://github.com/DeterminateSystems/nix-installer)
- **Home Manager** configured - [Home Manager setup guide](https://nix-community.github.io/home-manager/)

> **New to Nix?** Nix is a package manager that lets you declare your entire system configuration. Home Manager extends this to user-level configurations (dotfiles, programs, themes). 

## Choose Your Setup

Pick the scenario that matches your situation:

| Scenario | Description | Jump to |
|----------|-------------|---------|
| **Starting fresh** | Creating a new Nix config from scratch | [New Configuration](#new-configuration-greenfield) |
| **Have existing config** | Adding Signal to your current setup | [Existing Configuration](#existing-configuration-migration) |
| **Home Manager only** | Not using NixOS or nix-darwin | [Standalone Home Manager](#standalone-home-manager) |
| **NixOS user** | Using NixOS with Home Manager | [NixOS with Home Manager](#nixos-with-home-manager) |
| **macOS user** | Using nix-darwin | [Nix-darwin](#nix-darwin-macos) |
| **No flakes** | Using channels (not recommended) | [Without Flakes](#without-flakes-legacy) |

## New Configuration (Greenfield)

Starting from scratch? Use this minimal template.

### Step 1: Create your flake.nix

```nix
{
  description = "My Home Manager configuration with Signal theme";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs = { nixpkgs, home-manager, signal, ... }: {
    homeConfigurations.yourname = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;  # or aarch64-linux, x86_64-darwin, etc.
      
      modules = [
        signal.homeManagerModules.default
        {
          home = {
            username = "yourname";
            homeDirectory = "/home/yourname";
            stateVersion = "24.11";
          };

          # Enable the programs you want to use
          programs = {
            helix.enable = true;
            kitty.enable = true;
            bat.enable = true;
            fzf.enable = true;
            starship.enable = true;
          };

          # Signal automatically themes them with its colors
          theming.signal = {
            enable = true;
            autoEnable = true;  # Automatically theme all enabled programs
            mode = "dark";      # or "light"
          };
        }
      ];
    };
  };
}
```

### Step 2: Build and activate

```bash
# Build the configuration
nix build .#homeConfigurations.yourname.activationPackage

# Activate it
./result/activate

# Or use home-manager command (if installed)
home-manager switch --flake .
```

**Done!** Your programs are now themed with Signal colors.

## Existing Configuration (Migration)

Already have Home Manager? Here's how to add Signal to your existing setup.

### Step 1: Add Signal to your flake inputs

In your existing `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "github:lewisflude/signal-nix";  # ← Add this line
  };

  outputs = { nixpkgs, home-manager, signal, ... }: {
    # Your existing configuration...
  };
}
```

### Step 2: Import Signal module

Add Signal to your Home Manager modules:

```nix
{
  outputs = { nixpkgs, home-manager, signal, ... }: {
    homeConfigurations.yourname = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      
      modules = [
        signal.homeManagerModules.default  # ← Add this
        ./home.nix                          # Your existing config
        # ... other modules
      ];
    };
  };
}
```

### Step 3: Enable Signal

In your `home.nix` or create a new `theming.nix` file:

```nix
{ config, ... }:

{
  theming.signal = {
    enable = true;
    autoEnable = true;  # Automatically theme all your enabled programs
    mode = "dark";
  };
}
```

If you create a separate file, import it in your modules list:

```nix
modules = [
  signal.homeManagerModules.default
  ./home.nix
  ./theming.nix  # ← Add your Signal config
];
```

### Step 4: Update and rebuild

```bash
# Update flake.lock to include Signal
nix flake update

# Rebuild your configuration
home-manager switch --flake .
```

**That's it!** Signal is now theming all your programs.

## Standalone Home Manager

If you're using Home Manager without NixOS:

```nix
{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs = { nixpkgs, home-manager, signal, ... }: {
    homeConfigurations."yourname@yourhostname" = 
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        
        modules = [
          signal.homeManagerModules.default
          {
            home.username = "yourname";
            home.homeDirectory = "/home/yourname";
            home.stateVersion = "24.11";
            
            programs.home-manager.enable = true;
            
            # Your program configuration
            programs.helix.enable = true;
            programs.kitty.enable = true;
            
            # Signal theming
            theming.signal = {
              enable = true;
              autoEnable = true;
              mode = "dark";
            };
          }
        ];
      };
  };
}
```

Rebuild with:

```bash
home-manager switch --flake .#yourname@yourhostname
```

## NixOS with Home Manager

Using Home Manager as a NixOS module:

### In your system flake.nix

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs = { nixpkgs, home-manager, signal, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      modules = [
        ./configuration.nix
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          home-manager.users.yourname = {
            imports = [ signal.homeManagerModules.default ];
            
            # Your home configuration
            programs.helix.enable = true;
            programs.kitty.enable = true;
            
            theming.signal = {
              enable = true;
              autoEnable = true;
              mode = "dark";
            };
          };
        }
      ];
    };
  };
}
```

Rebuild with:

```bash
sudo nixos-rebuild switch --flake .#yourhostname
```

## Nix-darwin (macOS)

Signal works on macOS via nix-darwin:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    signal.url = "github:lewisflude/signal-nix";
  };

  outputs = { nixpkgs, darwin, home-manager, signal, ... }: {
    darwinConfigurations.yourhostname = darwin.lib.darwinSystem {
      system = "aarch64-darwin";  # or x86_64-darwin
      
      modules = [
        ./configuration.nix
        
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          home-manager.users.yourname = {
            imports = [ signal.homeManagerModules.default ];
            
            programs.helix.enable = true;
            programs.kitty.enable = true;
            
            theming.signal = {
              enable = true;
              autoEnable = true;
              mode = "dark";
            };
          };
        }
      ];
    };
  };
}
```

Rebuild with:

```bash
darwin-rebuild switch --flake .#yourhostname
```

## Without Flakes (Legacy)

If you're not using flakes, you can use flake-compat:

### Step 1: Add to channels

```bash
nix-channel --add https://github.com/lewisflude/signal-nix/archive/main.tar.gz signal
nix-channel --update
```

### Step 2: Import in configuration

```nix
{ config, pkgs, ... }:

let
  signal = import <signal> {};
in
{
  imports = [ signal.homeManagerModules.default ];
  
  programs.helix.enable = true;
  programs.kitty.enable = true;
  
  theming.signal = {
    enable = true;
    autoEnable = true;
    mode = "dark";
  };
}
```

> **Note**: Channel-based installation is not officially supported and may have delays receiving updates. Flakes are strongly recommended.

## Verification

After rebuilding, verify Signal is working:

### Check configuration files

Signal generates themed config files for your programs:

```bash
# Check Helix theme
cat ~/.config/helix/config.toml | grep theme

# Check Kitty colors
cat ~/.config/kitty/kitty.conf | grep "# Signal"

# Check bat theme
bat --list-themes | grep signal
```

### Test visually

Open your programs and verify the colors look right:

```bash
# Test terminal colors
kitty

# Test editor theme
helix

# Test syntax highlighting
bat ~/.config/home-manager/flake.nix

# Test fuzzy finder
fzf
```

### Verify theme mode

Try switching between light and dark:

```nix
# In your config
theming.signal.mode = "light";
```

```bash
# Rebuild
home-manager switch --flake .
```

Programs should now use light mode colors.

## Next Steps

Now that Signal is installed:

1. **Explore configuration options** - See [Configuration Guide](configuration-guide.md)
2. **Add more programs** - Enable more programs and Signal will theme them automatically
3. **Try light mode** - Change `mode = "light"` and rebuild
4. **Customize if needed** - See [Advanced Usage](advanced-usage.md) for brand colors and overrides
5. **Browse examples** - Check out [examples/](../examples/) for inspiration

## Troubleshooting

### Program not themed

**Check program is enabled:**

```nix
programs.helix.enable = true;  # Must be true
```

**Check Signal is enabled:**

```nix
theming.signal.enable = true;
theming.signal.autoEnable = true;
```

**Check Signal supports the program:**

See [Supported Applications](../README.md#supported-applications) in the README.

### Colors look wrong

**Check theme mode matches your preference:**

```nix
theming.signal.mode = "dark";  # or "light"
```

**Rebuild to apply changes:**

```bash
home-manager switch --flake .
```

**Some programs may need a restart:**

Close and reopen the application after rebuilding.

### Conflicts with existing theme

If you have another theme manager (like Stylix or Catppuccin):

**Option 1: Disable the other theme**

```nix
# Disable other theme
stylix.enable = false;

# Use only Signal
theming.signal.enable = true;
```

**Option 2: Use both selectively**

```nix
# Theme some apps with Stylix
stylix.targets.helix.enable = true;

# Theme others with Signal
theming.signal = {
  enable = true;
  autoEnable = false;  # Manual mode
  terminals.kitty.enable = true;
  cli.bat.enable = true;
};
```

For more help, see the [Troubleshooting Guide](troubleshooting.md).
