{ palette }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.theming.signal;
  signalLib = import ../../lib { inherit lib palette; };
in
{
  # Conditional imports must be at top level, not inside config
  imports = lib.mkIf (config.theming.signal.enable or false) [
    (lib.mkIf cfg.ironbar.enable ../../modules/ironbar)
    (lib.mkIf cfg.gtk.enable ../../modules/gtk)
    (lib.mkIf cfg.helix.enable ../../modules/editors/helix.nix)
    (lib.mkIf cfg.fuzzel.enable ../../modules/desktop/fuzzel.nix)
    (lib.mkIf cfg.terminals.ghostty.enable ../../modules/terminals/ghostty.nix)
    (lib.mkIf cfg.terminals.zellij.enable ../../modules/terminals/zellij.nix)
    (lib.mkIf cfg.cli.bat.enable ../../modules/cli/bat.nix)
    (lib.mkIf cfg.cli.fzf.enable ../../modules/cli/fzf.nix)
    (lib.mkIf cfg.cli.lazygit.enable ../../modules/cli/lazygit.nix)
    (lib.mkIf cfg.cli.yazi.enable ../../modules/cli/yazi.nix)
  ];

  options.theming.signal = {
    enable = mkEnableOption "Signal Design System";

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

    helix.enable = mkEnableOption "Signal theme for Helix editor";
    fuzzel.enable = mkEnableOption "Signal theme for Fuzzel launcher";

    terminals = {
      ghostty.enable = mkEnableOption "Signal theme for Ghostty terminal";
      zellij.enable = mkEnableOption "Signal theme for Zellij";
    };

    cli = {
      bat.enable = mkEnableOption "Signal theme for bat";
      fzf.enable = mkEnableOption "Signal theme for fzf";
      lazygit.enable = mkEnableOption "Signal theme for lazygit";
      yazi.enable = mkEnableOption "Signal theme for yazi";
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
      signalLib = signalLib;
      signalColors = signalLib.getColors cfg.mode;
    };
  };
}
