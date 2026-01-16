{ palette }:
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.theming.signal;
  signalLib = import ../../lib { inherit lib palette; };
in
{
  # Import all application modules unconditionally
  # Each module uses mkIf internally to control its effect based on enable flags
  imports = [
    # Desktop
    ../../modules/ironbar
    ../../modules/gtk
    ../../modules/desktop/fuzzel.nix

    # Editors
    ../../modules/editors/helix.nix
    ../../modules/editors/neovim.nix

    # Terminals
    ../../modules/terminals/ghostty.nix
    ../../modules/terminals/alacritty.nix
    ../../modules/terminals/kitty.nix
    ../../modules/terminals/wezterm.nix

    # Multiplexers
    ../../modules/multiplexers/tmux.nix
    ../../modules/multiplexers/zellij.nix

    # CLI Tools
    ../../modules/cli/bat.nix
    ../../modules/cli/delta.nix
    ../../modules/cli/eza.nix
    ../../modules/cli/fzf.nix
    ../../modules/cli/lazygit.nix
    ../../modules/cli/yazi.nix

    # Monitors
    ../../modules/monitors/btop.nix

    # Prompts
    ../../modules/prompts/starship.nix

    # Shells
    ../../modules/shells/zsh.nix
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

    editors = {
      helix.enable = mkEnableOption "Signal theme for Helix editor";
      neovim.enable = mkEnableOption "Signal theme for Neovim editor";
    };

    fuzzel.enable = mkEnableOption "Signal theme for Fuzzel launcher";

    terminals = {
      ghostty.enable = mkEnableOption "Signal theme for Ghostty terminal";
      alacritty.enable = mkEnableOption "Signal theme for Alacritty terminal";
      kitty.enable = mkEnableOption "Signal theme for Kitty terminal";
      wezterm.enable = mkEnableOption "Signal theme for WezTerm terminal";
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
      yazi.enable = mkEnableOption "Signal theme for yazi";
    };

    monitors = {
      btop.enable = mkEnableOption "Signal theme for btop";
    };

    prompts = {
      starship.enable = mkEnableOption "Signal theme for starship prompt";
    };

    shells = {
      zsh.enable = mkEnableOption "Signal theme for zsh syntax highlighting";
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
  };
}
