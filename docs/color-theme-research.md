# Color Theme Configuration Research

This document catalogs how to configure color themes for various applications, noting whether NixOS, nix-darwin, or Home Manager provides native options.

## Legend
- ✅ **HM Option**: Home Manager has a direct option for color theming
- ✅ **NixOS Option**: NixOS has a direct option for color theming
- ⚙️ **Config File**: Theme configured via application config file (can be managed by HM)
- 📖 **External**: Requires external theme files or manual configuration

---

## Terminal Emulators & Shells

### Ghostty

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.ghostty.settings.palette` |

**Home Manager Configuration:**
```nix
programs.ghostty = {
  enable = true;
  settings = {
    # Base colors
    background = "1a1a2e";
    foreground = "e8e8e8";
    cursor-color = "3b82f6";
    selection-background = "3b82f6";
    selection-foreground = "ffffff";

    # 16-color palette (0-15)
    palette = [
      "0=#1a1a2e"   # black
      "1=#f87171"   # red
      "2=#4ade80"   # green
      "3=#fbbf24"   # yellow
      "4=#3b82f6"   # blue
      "5=#c084fc"   # magenta
      "6=#22d3ee"   # cyan
      "7=#e8e8e8"   # white
      "8=#6b7280"   # bright black
      "9=#fca5a5"   # bright red
      "10=#86efac"  # bright green
      "11=#fcd34d"  # bright yellow
      "12=#60a5fa"  # bright blue
      "13=#d8b4fe"  # bright magenta
      "14=#67e8f9"  # bright cyan
      "15=#ffffff"  # bright white
    ];
  };
};
```

**Official Documentation:** https://ghostty.org/docs/config

---

### Zsh

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ No direct theme option, but `programs.zsh.initExtra` for custom styling |

Zsh itself doesn't have built-in color themes - colors come from:
1. Prompt themes (like Powerlevel10k, Starship)
2. Syntax highlighting plugins
3. Terminal emulator colors

**Home Manager Configuration:**
```nix
programs.zsh = {
  enable = true;
  syntaxHighlighting = {
    enable = true;
    highlighters = [ "main" "brackets" ];
    styles = {
      # Custom syntax highlighting colors
      "alias" = "fg=magenta,bold";
      "builtin" = "fg=green,bold";
      "command" = "fg=green";
      "function" = "fg=magenta";
    };
  };
};
```

**Official Documentation:**
- Zsh: https://zsh.sourceforge.io/Doc/Release/
- zsh-syntax-highlighting: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md

---

### Powerlevel10k

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via `programs.zsh.plugins` + config file |

Powerlevel10k uses its own configuration file (`~/.p10k.zsh`) for theming.

**Home Manager Configuration:**
```nix
programs.zsh = {
  enable = true;
  plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
  ];
  initExtra = ''
    [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
  '';
};

# Or manage the config file directly
home.file.".p10k.zsh".source = ./p10k.zsh;
```

**Color Configuration in .p10k.zsh:**
```zsh
# Directory colors
typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
typeset -g POWERLEVEL9K_DIR_BACKGROUND=236

# Git status colors
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
```

**Official Documentation:** https://github.com/romkatv/powerlevel10k#configuration

---

## Code Editors

### VS Code / Cursor

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.vscode.userSettings` for theme selection |

VS Code uses extension-based themes. Home Manager can set the active theme but not create custom themes.

**Home Manager Configuration:**
```nix
programs.vscode = {
  enable = true;
  userSettings = {
    "workbench.colorTheme" = "One Dark Pro";

    # Custom color overrides
    "workbench.colorCustomizations" = {
      "editor.background" = "#1a1a2e";
      "editor.foreground" = "#e8e8e8";
      "activityBar.background" = "#16162a";
      "sideBar.background" = "#1e1e3a";
    };

    # Token color customizations
    "editor.tokenColorCustomizations" = {
      "textMateRules" = [
        {
          "scope" = "comment";
          "settings" = {
            "foreground" = "#6b7280";
            "fontStyle" = "italic";
          };
        }
      ];
    };
  };
};
```

**Official Documentation:**
- Theme reference: https://code.visualstudio.com/api/references/theme-color
- Color customization: https://code.visualstudio.com/docs/getstarted/themes#_customizing-a-color-theme

---

### Zed Editor

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via `xdg.configFile` for settings.json |

**Home Manager Configuration:**
```nix
xdg.configFile."zed/settings.json".text = builtins.toJSON {
  theme = {
    mode = "dark";
    dark = "One Dark";
    light = "One Light";
  };

  # Custom theme overrides (experimental)
  experimental.theme_overrides = {
    background = "#1a1a2e";
    "editor.background" = "#1a1a2e";
  };
};
```

**Custom Theme Creation:**
Zed themes are JSON files placed in `~/.config/zed/themes/`

**Official Documentation:** https://zed.dev/docs/themes

---

## CLI Tools

### Git Delta

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.git.delta.options` |

**Home Manager Configuration:**
```nix
programs.git = {
  enable = true;
  delta = {
    enable = true;
    options = {
      features = "decorations";
      syntax-theme = "Dracula";

      # Custom colors
      minus-style = "syntax #3a1f1f";
      minus-emph-style = "syntax #5c2626";
      plus-style = "syntax #1f3a1f";
      plus-emph-style = "syntax #265c26";

      line-numbers-minus-style = "#f87171";
      line-numbers-plus-style = "#4ade80";
      line-numbers-left-style = "#6b7280";
      line-numbers-right-style = "#6b7280";

      hunk-header-style = "file line-number syntax";
      hunk-header-decoration-style = "blue box";
    };
  };
};
```

**Official Documentation:** https://dandavison.github.io/delta/configuration.html

---

### Tig

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.tig.settings` |

**Home Manager Configuration:**
```nix
programs.tig = {
  enable = true;
  settings = {
    # Color settings
    "color.cursor" = "black green bold";
    "color.status" = "green default";
    "color.title-focus" = "white blue bold";
    "color.title-blur" = "white default";
    "color.diff-header" = "yellow default";
    "color.diff-index" = "blue default";
    "color.diff-chunk" = "magenta default";
    "color.diff-add" = "green default";
    "color.diff-del" = "red default";
    "color.graph-commit" = "blue default";
  };
};
```

**Official Documentation:** https://jonas.github.io/tig/doc/tigrc.5.html

---

### Ripgrep

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via `programs.ripgrep` and config file |

**Home Manager Configuration:**
```nix
programs.ripgrep = {
  enable = true;
  arguments = [
    "--colors=line:fg:yellow"
    "--colors=line:style:bold"
    "--colors=path:fg:green"
    "--colors=path:style:bold"
    "--colors=match:fg:red"
    "--colors=match:style:bold"
  ];
};
```

**Official Documentation:** `rg --help` or https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md

---

### Eza

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.eza` + theme file |

**Home Manager Configuration:**
```nix
programs.eza = {
  enable = true;
  colors = "auto";
  extraOptions = [ "--color=always" ];
};

# Custom theme via EZA_COLORS or theme file
xdg.configFile."eza/theme.yml".text = ''
  filekinds:
    normal: {foreground: white}
    directory: {foreground: blue, bold: true}
    symlink: {foreground: cyan}
    executable: {foreground: green, bold: true}

  perms:
    user_read: {foreground: yellow}
    user_write: {foreground: red}
    user_execute: {foreground: green}
'';
```

**Official Documentation:** https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md

---

### Atuin

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.atuin.settings` |

**Home Manager Configuration:**
```nix
programs.atuin = {
  enable = true;
  settings = {
    style = "compact";

    # UI colors (limited customization)
    # Atuin uses terminal colors primarily
  };
};
```

Note: Atuin primarily inherits colors from the terminal emulator.

**Official Documentation:** https://docs.atuin.sh/configuration/config/

---

### Tealdeer

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.tealdeer.settings` |

**Home Manager Configuration:**
```nix
programs.tealdeer = {
  enable = true;
  settings = {
    style = {
      description = { foreground = "white"; };
      command_name = { foreground = "green"; bold = true; };
      example_text = { foreground = "cyan"; };
      example_code = { foreground = "blue"; };
      example_variable = { foreground = "yellow"; underline = true; };
    };
  };
};
```

**Official Documentation:** https://dbrgn.github.io/tealdeer/config.html

---

### Less

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via environment variables |

**Home Manager Configuration:**
```nix
programs.zsh.sessionVariables = {
  # Less colors for man pages
  LESS_TERMCAP_mb = "$(tput bold; tput setaf 2)";  # begin blink
  LESS_TERMCAP_md = "$(tput bold; tput setaf 6)";  # begin bold
  LESS_TERMCAP_me = "$(tput sgr0)";                # end mode
  LESS_TERMCAP_se = "$(tput sgr0)";                # end standout
  LESS_TERMCAP_so = "$(tput bold; tput setaf 3; tput setab 4)"; # standout
  LESS_TERMCAP_ue = "$(tput sgr0)";                # end underline
  LESS_TERMCAP_us = "$(tput smul; tput setaf 2)";  # begin underline
};
```

**Official Documentation:** `man less` - PROMPTS section

---

### Glow

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via config file |

**Home Manager Configuration:**
```nix
xdg.configFile."glow/glow.yml".text = ''
  style: "dark"
  local: false
  mouse: false
  pager: false
'';

# Custom style file
xdg.configFile."glow/styles/custom.json".text = builtins.toJSON {
  document = {
    block_prefix = "\n";
    block_suffix = "\n";
    color = "#e8e8e8";
  };
  heading = {
    block_suffix = "\n";
    color = "#3b82f6";
    bold = true;
  };
  # ... more style definitions
};
```

**Official Documentation:** https://github.com/charmbracelet/glow#styles

---

### Dust

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Limited - uses terminal colors |

Dust (du-dust) primarily uses terminal colors and has limited theme configuration.

```nix
# Can only be configured via command-line flags
home.packages = [ pkgs.dust ];
```

**Official Documentation:** https://github.com/bootandy/dust

---

### Procs

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via config file |

**Home Manager Configuration:**
```nix
xdg.configFile."procs/config.toml".text = ''
  [style]
  header = "BrightWhite|Bold"
  unit = "BrightWhite"

  [style.by_percentage]
  color_000 = "BrightBlue"
  color_025 = "BrightGreen"
  color_050 = "BrightYellow"
  color_075 = "BrightRed"
  color_100 = "BrightRed|Bold"

  [style.by_state]
  color_d = "BrightRed|Bold"
  color_r = "BrightGreen|Bold"
  color_s = "BrightBlue|Bold"
  color_t = "BrightCyan|Bold"
  color_z = "BrightMagenta|Bold"
'';
```

**Official Documentation:** https://github.com/dalance/procs#configuration

---

## System Monitors

### Htop

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.htop.settings` |

**Home Manager Configuration:**
```nix
programs.htop = {
  enable = true;
  settings = {
    color_scheme = 6;  # 0-6 preset schemes

    # Individual color settings
    cpu_count_from_one = 0;
    delay = 15;
    highlight_base_name = 1;
    highlight_megabytes = 1;
    highlight_threads = 1;
  };
};
```

Note: Htop has limited color customization - mainly preset schemes (0-6).

**Official Documentation:** `man htop`

---

### Btop++

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via config file |

**Home Manager Configuration:**
```nix
xdg.configFile."btop/btop.conf".text = ''
  color_theme = "custom"
  theme_background = False
'';

# Custom theme file
xdg.configFile."btop/themes/custom.theme".text = ''
  # Main background
  theme[main_bg]="#1a1a2e"
  theme[main_fg]="#e8e8e8"

  # Title
  theme[title]="#e8e8e8"

  # Highlight
  theme[hi_fg]="#3b82f6"

  # Selected
  theme[selected_bg]="#3b82f6"
  theme[selected_fg]="#ffffff"

  # Graph colors
  theme[proc_misc]="#6b7280"
  theme[cpu_box]="#3b82f6"
  theme[mem_box]="#22d3ee"
  theme[net_box]="#4ade80"
  theme[proc_box]="#c084fc"

  # CPU graph colors
  theme[cpu_start]="#4ade80"
  theme[cpu_mid]="#fbbf24"
  theme[cpu_end]="#f87171"

  # Memory graph
  theme[free_start]="#3b82f6"
  theme[free_mid]="#22d3ee"
  theme[free_end]="#4ade80"

  theme[cached_start]="#c084fc"
  theme[cached_mid]="#d8b4fe"
  theme[cached_end]="#e9d5ff"

  theme[available_start]="#fbbf24"
  theme[available_mid]="#fcd34d"
  theme[available_end]="#fef08a"

  theme[used_start]="#f87171"
  theme[used_mid]="#fca5a5"
  theme[used_end]="#fecaca"
'';
```

**Official Documentation:** https://github.com/aristocratos/btop#themes

---

## File Managers

### Thunar

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ GTK theme based |

Thunar uses GTK theming - colors come from the GTK theme.

**Home Manager Configuration:**
```nix
gtk = {
  enable = true;
  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };

  # Or custom GTK CSS
  gtk3.extraCss = ''
    .thunar .sidebar {
      background-color: #1a1a2e;
    }
  '';
};
```

**Official Documentation:** https://docs.xfce.org/xfce/thunar/start

---

### Nautilus

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ GTK theme based |

Nautilus uses GTK/libadwaita theming.

**Home Manager Configuration:**
```nix
gtk = {
  enable = true;
  theme = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };
};

dconf.settings = {
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };
};
```

**Official Documentation:** https://wiki.gnome.org/Apps/Files

---

## Window Managers & Desktop Components

### Niri

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.niri.settings` (if available) or config file |

**Home Manager Configuration:**
```nix
xdg.configFile."niri/config.kdl".text = ''
  layout {
    border {
      width 2
      active-color "#3b82f6"
      inactive-color "#6b7280"
    }

    focus-ring {
      width 2
      active-color "#3b82f6"
      inactive-color "#6b7280"
    }
  }

  window-rule {
    opacity 0.95
  }
'';
```

**Official Documentation:** https://github.com/YaLTeR/niri/wiki/Configuration:-Layout

---

### Polkit-gnome

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ GTK theme based |

Polkit-gnome uses GTK theming - no separate color configuration.

```nix
gtk = {
  enable = true;
  theme.name = "Adwaita-dark";
};
```

---

### Swaylock

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.swaylock.settings` |

**Home Manager Configuration:**
```nix
programs.swaylock = {
  enable = true;
  settings = {
    color = "1a1a2e";

    inside-color = "1a1a2e";
    inside-clear-color = "fbbf24";
    inside-ver-color = "3b82f6";
    inside-wrong-color = "f87171";

    ring-color = "3b82f6";
    ring-clear-color = "fbbf24";
    ring-ver-color = "3b82f6";
    ring-wrong-color = "f87171";

    key-hl-color = "4ade80";
    bs-hl-color = "f87171";

    text-color = "e8e8e8";
    text-clear-color = "1a1a2e";
    text-ver-color = "1a1a2e";
    text-wrong-color = "1a1a2e";

    separator-color = "00000000";

    line-color = "00000000";
    line-clear-color = "00000000";
    line-ver-color = "00000000";
    line-wrong-color = "00000000";
  };
};
```

**Official Documentation:** `man swaylock`

---

### Swayimg

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via config file |

**Home Manager Configuration:**
```nix
xdg.configFile."swayimg/config".text = ''
  [general]
  background = #1a1a2e

  [font]
  color = #e8e8e8
  shadow = #000000
'';
```

**Official Documentation:** https://github.com/artemsen/swayimg

---

## Media Applications

### MPV

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.mpv.config` and `programs.mpv.scripts` |

**Home Manager Configuration:**
```nix
programs.mpv = {
  enable = true;
  config = {
    osd-color = "#e8e8e8";
    osd-border-color = "#1a1a2e";
    osd-back-color = "#1a1a2e80";

    sub-color = "#e8e8e8";
    sub-border-color = "#1a1a2e";
    sub-back-color = "#1a1a2e80";
  };
};

# For OSC (on-screen controller) theming
xdg.configFile."mpv/script-opts/osc.conf".text = ''
  seekbarstyle=bar
  boxalpha=80
'';
```

**Official Documentation:** https://mpv.io/manual/stable/

---

### OBS Studio

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Themes via plugin/file system |

OBS Studio uses Qt theming. Custom themes are placed in config directory.

**Home Manager Configuration:**
```nix
home.packages = [ pkgs.obs-studio ];

# OBS themes go in ~/.config/obs-studio/themes/
xdg.configFile."obs-studio/themes/Custom.qss".source = ./obs-custom-theme.qss;
```

**Official Documentation:** https://obsproject.com/wiki/Themes

---

### Satty

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via config file |

**Home Manager Configuration:**
```nix
xdg.configFile."satty/config.toml".text = ''
  [general]
  early-exit = true
  copy-command = "wl-copy"

  [color]
  # Drawing colors
  default = "#f87171"

  [font]
  family = "monospace"
'';
```

**Official Documentation:** https://github.com/gabm/Satty

---

## Browsers & Communication

### Chromium

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via extensions or flags |

**Home Manager Configuration:**
```nix
programs.chromium = {
  enable = true;
  extensions = [
    # Dark Reader extension ID
    { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
  ];
  commandLineArgs = [
    "--force-dark-mode"
    "--enable-features=WebUIDarkMode"
  ];
};
```

Chrome themes are installed as extensions or through settings.

**Official Documentation:** https://developer.chrome.com/docs/extensions/mv3/themes/

---

### Discord

| Platform | Option Available |
|----------|-----------------|
| Home Manager | 📖 Requires BetterDiscord/Vencord |

Discord doesn't support native theming. Use client mods:

**Home Manager Configuration (with Vencord):**
```nix
# Using Vesktop (Vencord desktop app)
home.packages = [ pkgs.vesktop ];

# Vencord themes go in config
xdg.configFile."vesktop/themes/custom.css".text = ''
  :root {
    --background-primary: #1a1a2e;
    --background-secondary: #16162a;
    --background-tertiary: #121220;
    --text-normal: #e8e8e8;
    --header-primary: #e8e8e8;
    --interactive-normal: #b4b4b4;
    --brand-experiment: #3b82f6;
  }
'';
```

**Official Documentation:**
- Vencord: https://vencord.dev/
- BetterDiscord: https://betterdiscord.app/

---

### Telegram Desktop

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via theme file |

**Home Manager Configuration:**
```nix
home.packages = [ pkgs.telegram-desktop ];

# Telegram themes are .tdesktop-theme files
# Can be created at https://themes.telegram.org/
xdg.configFile."telegram-desktop/tdata/tsetup/custom.tdesktop-theme".source = ./telegram-theme.tdesktop-theme;
```

**Official Documentation:** https://core.telegram.org/themes

---

### Obsidian

| Platform | Option Available |
|----------|-----------------|
| Home Manager | 📖 Via CSS snippets and themes |

**Home Manager Configuration:**
```nix
home.packages = [ pkgs.obsidian ];

# CSS snippets go in vault's .obsidian/snippets/ folder
# This would need to be per-vault configuration
```

**Theme Creation:**
CSS files in `.obsidian/snippets/` or install community themes.

**Official Documentation:** https://docs.obsidian.md/Reference/CSS+variables/CSS+variables

---

## Developer Tools

### GitHub CLI

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Limited - uses terminal colors |

GitHub CLI primarily uses terminal colors. Some pager/glamour settings available.

**Home Manager Configuration:**
```nix
programs.gh = {
  enable = true;
  settings = {
    # Glamour style for markdown rendering
    pager = "less -R";
  };
};

# Set GLAMOUR_STYLE environment variable
home.sessionVariables = {
  GLAMOUR_STYLE = "dark";
};
```

**Official Documentation:** https://cli.github.com/manual/

---

### Claude Code

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via settings.json |

**Home Manager Configuration:**
```nix
xdg.configFile."claude-code/settings.json".text = builtins.toJSON {
  theme = "dark";
  # Limited theme customization available
};
```

Claude Code uses terminal colors primarily.

**Official Documentation:** https://docs.anthropic.com/en/docs/claude-code

---

### Gemini CLI

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Uses terminal colors |

Gemini CLI primarily uses terminal colors with limited configuration.

**Official Documentation:** https://github.com/google-gemini/gemini-cli

---

## Graphics & Utilities

### GIMP

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via theme files |

**Home Manager Configuration:**
```nix
home.packages = [ pkgs.gimp ];

# GIMP themes go in ~/.config/GIMP/2.10/themes/
xdg.configFile."GIMP/2.10/themes/Custom" = {
  source = ./gimp-custom-theme;
  recursive = true;
};
```

**Official Documentation:** https://docs.gimp.org/en/gimp-prefs-theme.html

---

### Aseprite

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Via extension themes |

**Home Manager Configuration:**
```nix
home.packages = [ pkgs.aseprite ];

# Aseprite themes are extensions
xdg.configFile."aseprite/extensions/custom-theme" = {
  source = ./aseprite-theme;
  recursive = true;
};
```

**Official Documentation:** https://www.aseprite.org/docs/extensions/

---

### Cliphist

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Uses terminal/picker colors |

Cliphist uses external pickers (like wofi, rofi, dmenu) for display - theme those instead.

```nix
services.cliphist.enable = true;

# Theme your picker instead
programs.wofi = {
  enable = true;
  style = ''
    * {
      background-color: #1a1a2e;
      color: #e8e8e8;
    }
  '';
};
```

**Official Documentation:** https://github.com/sentriz/cliphist

---

### Network Manager Applet

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ GTK theme based |

Uses GTK theming - no separate configuration.

```nix
gtk = {
  enable = true;
  theme.name = "Adwaita-dark";
};

services.network-manager-applet.enable = true;
```

---

### File Roller

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ GTK theme based |

File Roller uses GTK/libadwaita theming.

```nix
gtk = {
  enable = true;
  theme.name = "adw-gtk3-dark";
};
```

---

## Gaming

### Steam

| Platform | Option Available |
|----------|-----------------|
| Home Manager | 📖 Via skin files |

**Home Manager Configuration:**
```nix
programs.steam = {
  enable = true;
};

# Steam skins go in ~/.steam/steam/skins/
# Use Adwaita-for-Steam or similar
home.file.".steam/steam/skins/Custom" = {
  source = pkgs.fetchFromGitHub {
    owner = "tkashkin";
    repo = "Adwaita-for-Steam";
    rev = "...";
    sha256 = "...";
  };
  recursive = true;
};
```

**Official Documentation:**
- Adwaita-for-Steam: https://github.com/tkashkin/Adwaita-for-Steam
- SteamUI-OldGlory: https://github.com/nicholol/SteamUI-OldGlory

---

### MangoHud

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ✅ `programs.mangohud.settings` |

**Home Manager Configuration:**
```nix
programs.mangohud = {
  enable = true;
  settings = {
    # Background and text colors
    background_alpha = 0.8;
    background_color = "1a1a2e";
    text_color = "e8e8e8";

    # Component colors
    gpu_color = "3b82f6";
    cpu_color = "f87171";
    vram_color = "c084fc";
    ram_color = "22d3ee";
    engine_color = "fbbf24";
    frametime_color = "4ade80";

    # Border
    round_corners = 5;
  };
};
```

**Official Documentation:** https://github.com/flightlessmango/MangoHud#configuration

---

### ALVR

| Platform | Option Available |
|----------|-----------------|
| Home Manager | ⚙️ Web dashboard theming |

ALVR's dashboard is web-based with limited theming.

**Home Manager Configuration:**
```nix
home.packages = [ pkgs.alvr ];

# Session settings in ~/.config/alvr/session.json
```

**Official Documentation:** https://github.com/alvr-org/ALVR/wiki

---

## Summary Table

| Application | HM Option | Config Method | Notes |
|------------|-----------|---------------|-------|
| Ghostty | ✅ | `programs.ghostty.settings` | Full palette support |
| Zsh | ⚙️ | `syntaxHighlighting.styles` | Plugin-based |
| Powerlevel10k | ⚙️ | Config file | `.p10k.zsh` |
| VS Code/Cursor | ✅ | `userSettings` | Extension themes |
| Zed | ⚙️ | Config file | JSON themes |
| Git Delta | ✅ | `delta.options` | Full color support |
| Tig | ✅ | `settings` | Color scheme |
| Ripgrep | ⚙️ | Arguments | `--colors` flag |
| Eza | ✅ | Theme file | YAML themes |
| Atuin | ⚙️ | Terminal colors | Limited |
| Tealdeer | ✅ | `settings.style` | Full support |
| Less | ⚙️ | Environment vars | LESS_TERMCAP_* |
| Glow | ⚙️ | Style files | JSON styles |
| Dust | ⚙️ | Terminal colors | No config |
| Procs | ⚙️ | Config file | TOML |
| Htop | ✅ | `settings` | Preset schemes |
| Btop++ | ⚙️ | Theme file | Full theming |
| Thunar | ⚙️ | GTK theme | |
| Nautilus | ⚙️ | GTK/libadwaita | |
| Niri | ⚙️ | Config file | KDL |
| Polkit-gnome | ⚙️ | GTK theme | |
| Swaylock | ✅ | `settings` | Full support |
| Swayimg | ⚙️ | Config file | |
| MPV | ✅ | `config` | OSD colors |
| OBS Studio | ⚙️ | Theme files | Qt themes |
| Satty | ⚙️ | Config file | TOML |
| Chromium | ⚙️ | Extensions | Dark Reader |
| Discord | 📖 | Client mods | Vencord/BD |
| Telegram | ⚙️ | Theme files | .tdesktop-theme |
| Obsidian | 📖 | CSS snippets | Per-vault |
| GitHub CLI | ⚙️ | Terminal colors | Glamour |
| Claude Code | ⚙️ | Terminal colors | Limited |
| Gemini CLI | ⚙️ | Terminal colors | Limited |
| GIMP | ⚙️ | Theme files | |
| Aseprite | ⚙️ | Extensions | |
| Cliphist | ⚙️ | Picker theme | |
| NM Applet | ⚙️ | GTK theme | |
| File Roller | ⚙️ | GTK theme | |
| Steam | 📖 | Skin files | |
| MangoHud | ✅ | `settings` | Full support |
| ALVR | ⚙️ | Web dashboard | Limited |
