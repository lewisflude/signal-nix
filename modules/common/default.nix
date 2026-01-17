{ palette, nix-colorizer }:
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.theming.signal;
  signalLib = import ../../lib {
    inherit lib palette nix-colorizer;
  };
in
{
  # Import all application modules unconditionally
  # Each module uses mkIf internally to control its effect based on enable flags
  imports = [
    # Desktop - Window Managers & Compositors
    ../../modules/desktop/compositors/hyprland.nix
    ../../modules/desktop/compositors/sway.nix
    ../../modules/desktop/wm/i3.nix
    ../../modules/desktop/wm/bspwm.nix
    ../../modules/desktop/wm/awesome.nix

    # Desktop - Launchers
    ../../modules/desktop/launchers/rofi.nix
    ../../modules/desktop/launchers/wofi.nix
    ../../modules/desktop/launchers/tofi.nix
    ../../modules/desktop/launchers/dmenu.nix
    ../../modules/desktop/fuzzel.nix

    # Desktop - Status Bars
    ../../modules/desktop/bars/waybar.nix
    ../../modules/desktop/bars/polybar.nix
    ../../modules/ironbar

    # Desktop - Notifications
    ../../modules/desktop/notifications/dunst.nix
    ../../modules/desktop/notifications/mako.nix

    # Desktop - Themes
    ../../modules/gtk
    ../../modules/qt

    # Editors
    ../../modules/editors/helix.nix
    ../../modules/editors/neovim.nix
    ../../modules/editors/vim.nix
    ../../modules/editors/vscode.nix
    ../../modules/editors/emacs.nix

    # Terminals
    ../../modules/terminals/ghostty.nix
    ../../modules/terminals/alacritty.nix
    ../../modules/terminals/kitty.nix
    ../../modules/terminals/wezterm.nix
    ../../modules/terminals/foot.nix

    # Multiplexers
    ../../modules/multiplexers/tmux.nix
    ../../modules/multiplexers/zellij.nix

    # CLI Tools
    ../../modules/cli/bat.nix
    ../../modules/cli/delta.nix
    ../../modules/cli/eza.nix
    ../../modules/cli/fzf.nix
    ../../modules/cli/lazygit.nix
    ../../modules/cli/lazydocker.nix
    ../../modules/cli/yazi.nix
    ../../modules/cli/less.nix
    ../../modules/cli/ripgrep.nix
    ../../modules/cli/glow.nix
    ../../modules/cli/tig.nix

    # File Managers
    ../../modules/fileManagers/ranger.nix
    ../../modules/fileManagers/lf.nix
    ../../modules/fileManagers/nnn.nix

    # Monitors
    ../../modules/monitors/btop.nix
    ../../modules/monitors/htop.nix
    ../../modules/monitors/bottom.nix

    # Browsers
    ../../modules/browsers/firefox.nix
    ../../modules/browsers/qutebrowser.nix

    # Prompts
    ../../modules/prompts/starship.nix

    # Shells
    ../../modules/shells/zsh.nix
    ../../modules/shells/fish.nix
    ../../modules/shells/bash.nix
    ../../modules/shells/nushell.nix
  ];

  options.theming.signal = {
    enable = mkEnableOption "Signal Design System";

    autoEnable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Automatically enable Signal theming for all programs/services
        that are already enabled in your configuration.

        When enabled, Signal will detect if a program is enabled
        (e.g., programs.helix.enable = true) and automatically apply
        Signal colors to it.

        You can still explicitly enable/disable theming for specific
        programs using the per-application enable options.
      '';
    };

    mode = mkOption {
      type = types.enum [
        "light"
        "dark"
        "auto"
      ];
      default = "dark";
      description = ''
        Color theme mode:
        - light: Use light mode colors
        - dark: Use dark mode colors
        - auto: Follow system preference (defaults to dark)
      '';
    };

    # Color exposure - submodules populate these
    colors = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = ''
        Exposed color definitions from Signal modules.
        Each application module can populate this with its color exports.
        
        For example, ironbar provides:
        - colors.ironbar.cssFile: Path to CSS file with color definitions
        - colors.ironbar.tokens: Raw color values as Nix attributes
      '';
    };

    # Per-application enables
    ironbar = {
      enable = mkEnableOption "Signal theme for Ironbar";
      profile = mkOption {
        type = types.enum [
          "compact"
          "relaxed"
          "spacious"
        ];
        default = "relaxed";
        description = ''
          Display profile:
          - compact: 1080p displays (smaller spacing, 40px bar)
          - relaxed: 1440p+ displays (comfortable spacing, 48px bar)
          - spacious: 4K displays (generous spacing, 56px bar)
        '';
      };
    };

    gtk = {
      enable = mkEnableOption "Signal theme for GTK";
      version = mkOption {
        type = types.enum [
          "gtk3"
          "gtk4"
          "both"
        ];
        default = "both";
      };
    };

    qt = {
      enable = mkEnableOption "Signal theme for Qt/KDE";
    };

    # Desktop options
    desktop = {
      compositors = {
        hyprland.enable = mkEnableOption "Signal theme for Hyprland compositor";
        sway.enable = mkEnableOption "Signal theme for Sway compositor";
      };

      wm = {
        i3.enable = mkEnableOption "Signal theme for i3 window manager";
        bspwm.enable = mkEnableOption "Signal theme for bspwm window manager";
        awesome.enable = mkEnableOption "Signal theme for awesome window manager";
      };

      launchers = {
        rofi.enable = mkEnableOption "Signal theme for rofi launcher";
        wofi.enable = mkEnableOption "Signal theme for wofi launcher";
        tofi.enable = mkEnableOption "Signal theme for tofi launcher";
        dmenu.enable = mkEnableOption "Signal theme for dmenu launcher";
      };

      bars = {
        waybar.enable = mkEnableOption "Signal theme for waybar status bar";
        polybar.enable = mkEnableOption "Signal theme for polybar status bar";
      };

      notifications = {
        dunst.enable = mkEnableOption "Signal theme for dunst notification daemon";
        mako.enable = mkEnableOption "Signal theme for mako notification daemon";
      };
    };

    fuzzel.enable = mkEnableOption "Signal theme for Fuzzel launcher";

    editors = {
      helix.enable = mkEnableOption "Signal theme for Helix editor";
      neovim.enable = mkEnableOption "Signal theme for Neovim editor";
      vim.enable = mkEnableOption "Signal theme for Vim editor";
      vscode.enable = mkEnableOption "Signal theme for VS Code/VSCodium";
      emacs.enable = mkEnableOption "Signal theme for Emacs";
    };

    terminals = {
      ghostty.enable = mkEnableOption "Signal theme for Ghostty terminal";
      alacritty.enable = mkEnableOption "Signal theme for Alacritty terminal";
      kitty.enable = mkEnableOption "Signal theme for Kitty terminal";
      wezterm.enable = mkEnableOption "Signal theme for WezTerm terminal";
      foot.enable = mkEnableOption "Signal theme for Foot terminal";
    };

    multiplexers = {
      tmux.enable = mkEnableOption "Signal theme for tmux";
      zellij.enable = mkEnableOption "Signal theme for zellij";
    };

    cli = {
      bat.enable = mkEnableOption "Signal theme for bat";
      delta.enable = mkEnableOption "Signal theme for delta git diff viewer";
      eza.enable = mkEnableOption "Signal theme for eza file lister";
      fzf.enable = mkEnableOption "Signal theme for fzf";
      lazygit.enable = mkEnableOption "Signal theme for lazygit";
      lazydocker.enable = mkEnableOption "Signal theme for lazydocker";
      yazi.enable = mkEnableOption "Signal theme for yazi";
      less.enable = mkEnableOption "Signal theme for less pager";
      ripgrep.enable = mkEnableOption "Signal theme for ripgrep";
      glow.enable = mkEnableOption "Signal theme for glow markdown viewer";
      tig.enable = mkEnableOption "Signal theme for tig git interface";
    };

    fileManagers = {
      ranger.enable = mkEnableOption "Signal theme for ranger file manager";
      lf.enable = mkEnableOption "Signal theme for lf file manager";
      nnn.enable = mkEnableOption "Signal theme for nnn file manager";
    };

    monitors = {
      btop.enable = mkEnableOption "Signal theme for btop";
      htop.enable = mkEnableOption "Signal theme for htop";
      bottom.enable = mkEnableOption "Signal theme for bottom";
    };

    browsers = {
      firefox.enable = mkEnableOption "Signal theme for Firefox (userChrome.css)";
      qutebrowser.enable = mkEnableOption "Signal theme for Qutebrowser";
    };

    prompts = {
      starship.enable = mkEnableOption "Signal theme for starship prompt";
    };

    shells = {
      zsh.enable = mkEnableOption "Signal theme for zsh syntax highlighting";
      fish.enable = mkEnableOption "Signal theme for fish shell";
      bash.enable = mkEnableOption "Signal theme for bash shell";
      nushell.enable = mkEnableOption "Signal theme for nushell";
    };

    # Brand governance
    brandGovernance = {
      policy = mkOption {
        type = types.enum [
          "functional-override"
          "separate-layer"
          "integrated"
        ];
        default = "functional-override";
        description = ''
          Brand governance policy:
          - functional-override: Functional colors override brand colors (brand is decorative only)
          - separate-layer: Brand colors exist as separate layer alongside functional colors
          - integrated: Brand colors can replace functional colors (must meet accessibility requirements)
        '';
      };

      decorativeBrandColors = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = ''
          Decorative brand colors (logos, headers, etc.)
          Example: { brand-primary = "#5a7dcf"; }
        '';
      };

      brandColors = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              l = mkOption {
                type = types.float;
                description = "Lightness (0.0-1.0)";
              };
              c = mkOption {
                type = types.float;
                description = "Chroma (0.0-0.4+)";
              };
              h = mkOption {
                type = types.float;
                description = "Hue (0-360 degrees)";
              };
              hex = mkOption {
                type = types.str;
                description = "Hex color code";
              };
            };
          }
        );
        default = { };
        description = ''
          Brand colors that can replace functional colors (integrated policy only)
          Must meet WCAG AA contrast requirements
        '';
      };
    };

    # Theme variant
    variant = mkOption {
      type = types.nullOr (
        types.enum [
          "default"
          "high-contrast"
          "reduced-motion"
          "color-blind-friendly"
        ]
      );
      default = null;
      description = ''
        Theme variant:
        - default: Standard theme
        - high-contrast: Increased contrast
        - reduced-motion: Reduced saturation
        - color-blind-friendly: Adjusted hues
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Make palette and lib available to all modules
    _module.args = {
      signalPalette = palette;
      inherit signalLib;
      signalColors = signalLib.getColors (signalLib.resolveThemeMode cfg.mode);
    };

    # Helpful assertions to catch common mistakes
    assertions = [
      # Warn if Signal is enabled but nothing is selected for theming
      {
        assertion =
          cfg.autoEnable
          || cfg.ironbar.enable
          || cfg.gtk.enable
          || cfg.qt.enable
          || cfg.fuzzel.enable
          || cfg.desktop.compositors.hyprland.enable
          || cfg.desktop.compositors.sway.enable
          || cfg.desktop.wm.i3.enable
          || cfg.desktop.launchers.rofi.enable
          || cfg.desktop.bars.waybar.enable
          || cfg.desktop.notifications.dunst.enable
          || cfg.editors.helix.enable
          || cfg.editors.neovim.enable
          || cfg.editors.vim.enable
          || cfg.editors.vscode.enable
          || cfg.editors.emacs.enable
          || cfg.terminals.ghostty.enable
          || cfg.terminals.alacritty.enable
          || cfg.terminals.kitty.enable
          || cfg.terminals.wezterm.enable
          || cfg.multiplexers.tmux.enable
          || cfg.multiplexers.zellij.enable
          || cfg.cli.bat.enable
          || cfg.cli.delta.enable
          || cfg.cli.eza.enable
          || cfg.cli.fzf.enable
          || cfg.cli.lazygit.enable
          || cfg.cli.yazi.enable
          || cfg.cli.less.enable
          || cfg.cli.ripgrep.enable
          || cfg.monitors.btop.enable
          || cfg.monitors.htop.enable
          || cfg.prompts.starship.enable
          || cfg.shells.zsh.enable
          || cfg.shells.fish.enable
          || cfg.shells.bash.enable;
        message = ''
          Signal is enabled but no applications are selected for theming.

          Either:
          1. Enable autoEnable to automatically theme all enabled programs:
             theming.signal.autoEnable = true;

          2. Or explicitly enable theming for specific applications:
             theming.signal.editors.helix.enable = true;
             theming.signal.terminals.kitty.enable = true;

          See: https://github.com/lewisflude/signal-nix#configuration
        '';
      }

      # Warn about common mode typo
      {
        assertion = lib.elem cfg.mode [
          "light"
          "dark"
          "auto"
        ];
        message = ''
          Invalid theme mode: "${cfg.mode}"

          Valid modes are:
          - "dark"  - Dark background, light text
          - "light" - Light background, dark text
          - "auto"  - Follow system preference (currently defaults to dark)
        '';
      }

      # Warn about integrated brand governance without colors
      {
        assertion =
          cfg.brandGovernance.policy != "integrated"
          || (cfg.brandGovernance.decorativeBrandColors != { } || cfg.brandGovernance.brandColors != { });
        message = ''
          Brand governance policy is set to "integrated" but no brand colors are defined.

          Either:
          1. Add decorative brand colors:
             theming.signal.brandGovernance.decorativeBrandColors = {
               brand-primary = "#5a7dcf";
             };

          2. Or use a different policy:
             theming.signal.brandGovernance.policy = "functional-override";
        '';
      }
    ];
  };
}
