# Getting Started with Signal

This guide walks you through setting up Signal in different scenarios.

## Table of Contents

- [Prerequisites](#prerequisites)
- [New Configuration (Greenfield)](#new-configuration-greenfield)
- [Existing Configuration (Migration)](#existing-configuration-migration)
- [Standalone Home Manager](#standalone-home-manager)
- [NixOS with Home Manager](#nixos-with-home-manager)
- [Nix-darwin (macOS)](#nix-darwin-macos)
- [Without Flakes](#without-flakes-legacy)
- [Verification](#verification)
- [Next Steps](#next-steps)

## Prerequisites

### Required

- **Nix** with flakes enabled ([installation guide](https://github.com/DeterminateSystems/nix-installer))
- **Home Manager** configured ([setup guide](https://nix-community.github.io/home-manager/))

### Helpful to Know

- Basic Nix syntax
- How to rebuild your configuration
- Where your config files are located

## New Configuration (Greenfield)

Starting from scratch? Use this minimal template.

### Step 1: Create flake.nix

```nix
{
  description = "My Home Manager configuration";

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
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      
      modules = [
        signal.homeManagerModules.default
        {
          home = {
            username = "yourname";
            homeDirectory = "/home/yourname";
            stateVersion = "24.11";
          };

          # Enable programs you want
          programs = {
            helix.enable = true;
            kitty.enable = true;
            bat.enable = true;
            fzf.enable = true;
            starship.enable = true;
          };

          # Signal automatically themes them
          theming.signal = {
            enable = true;
            autoEnable = true;  # ← Automatic theming
            mode = "dark";
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

# Or use home-manager directly
home-manager switch --flake .
```

## Existing Configuration (Migration)

Already have Home Manager set up? Here's how to add Signal.

### Your Current Structure

Your config might look like this:

```
~/.config/home-manager/
├── flake.nix
├── home.nix
├── programs/
│   ├── editors.nix
│   └── terminals.nix
└── ...
```

### Step 1: Add Signal to inputs

In your `flake.nix`, add Signal to inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    signal.url = "github:lewisflude/signal-nix";  # ← Add this
  };

  outputs = { nixpkgs, home-manager, signal, ... }: {
    # Pass signal to your configuration
    homeConfigurations.yourname = home-manager.lib.homeManagerConfiguration {
      # ... existing config ...
      modules = [
        ./home.nix
        # Add other modules here
      ];
    };
  };
}
```

### Step 2: Import Signal module

You have two options:

#### Option A: In your main module list (recommended)

```nix
{
  outputs = { nixpkgs, home-manager, signal, ... }: {
    homeConfigurations.yourname = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      
      modules = [
        signal.homeManagerModules.default  # ← Add this
        ./home.nix
        ./programs/editors.nix
        ./programs/terminals.nix
      ];
    };
  };
}
```

#### Option B: In your home.nix

```nix
{ config, pkgs, ... }:

{
  imports = [
    ./programs/editors.nix
    ./programs/terminals.nix
  ];

  # Your existing config
  home = {
    username = "yourname";
    homeDirectory = "/home/yourname";
    stateVersion = "24.11";
  };

  # ... rest of your config ...
}
```

Then modify `flake.nix` to pass signal:

```nix
{
  outputs = { nixpkgs, home-manager, signal, ... }: {
    homeConfigurations.yourname = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      
      modules = [
        signal.homeManagerModules.default  # Import Signal
        ./home.nix
      ];
    };
  };
}
```

### Step 3: Configure Signal

Create a new file `theming.nix` (optional but recommended):

```nix
{ config, ... }:

{
  theming.signal = {
    enable = true;
    autoEnable = true;  # Automatically theme all your enabled programs
    mode = "dark";
    
    # Optional: Disable theming for specific programs
    # cli.bat.enable = false;
  };
}
```

Import it in your module list:

```nix
modules = [
  signal.homeManagerModules.default
  ./home.nix
  ./theming.nix  # ← Add this
];
```

Or add directly to `home.nix`:

```nix
{
  # ... existing config ...
  
  theming.signal = {
    enable = true;
    autoEnable = true;
    mode = "dark";
  };
}
```

### Step 4: Update and rebuild

```bash
# Update flake.lock to get Signal
nix flake update

# Rebuild
home-manager switch --flake .
```

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

### Check program themes

```bash
# Check if helix uses Signal theme
cat ~/.config/helix/config.toml | grep signal

# Check kitty colors
cat ~/.config/kitty/kitty.conf | grep -A 5 "Signal"

# List all themed programs
home-manager generations | head -n 1
```

### Test visually

Open your themed applications and verify colors:

```bash
# Test terminal colors
kitty

# Test editor theme
helix

# Test CLI tool
bat --style=plain ~/.config/home-manager/flake.nix
```

## Next Steps

Now that Signal is installed:

1. **Customize your configuration** - See [Configuration Guide](configuration-guide.md)
2. **Switch between light/dark** - Change `mode = "light"` and rebuild
3. **Add more programs** - Enable more programs and Signal will theme them automatically
4. **Fine-tune specific apps** - See [Advanced Usage](advanced-usage.md)

## Troubleshooting

### Program not themed

**Check if the program is enabled:**

```nix
programs.helix.enable = true;  # Must be true
```

**Check if Signal is enabled:**

```nix
theming.signal.enable = true;
theming.signal.autoEnable = true;  # Or explicit enable
```

**Check if Signal supports the program:**

See [Supported Applications](../README.md#supported-applications)

### Theme not applying

**Rebuild your configuration:**

```bash
home-manager switch --flake .
```

**Check for errors:**

```bash
journalctl --user -u home-manager-$USER.service
```

### Conflicts with existing themes

Signal will override existing theme configurations. To revert:

```nix
theming.signal.enable = false;
```

Then rebuild.

For more help, see the [Troubleshooting Guide](troubleshooting.md).
