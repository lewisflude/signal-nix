# Signal Helix Theme Module
#
# This module ONLY applies Signal colors to helix.
# It assumes you have already enabled helix with:
#   programs.helix.enable = true;
#
# The module will not install helix or configure its functional behavior.
{
  config,
  lib,
  signalPalette,
  nix-colorizer,
  ...
}:
# CONFIGURATION METHOD: native-theme (Tier 1)
# HOME-MANAGER MODULE: programs.helix.themes
# UPSTREAM SCHEMA: https://docs.helix-editor.com/themes.html
# SCHEMA VERSION: 23.10
# LAST VALIDATED: 2026-01-17
# NOTES: Helix provides native theme support with palette structure. Home-Manager
#        handles theme installation. This is the optimal integration method.
let
  # Import signalLib directly to avoid circular dependencies with _module.args
  signalLib = import ../../lib {
    inherit lib;
    palette = signalPalette;
    inherit nix-colorizer;
  };

  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  # Compute signalColors from mode (can't be provided via _module.args)
  signalColors = signalLib.getColors themeMode;

  # Map signal colors to theme structure
  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-emphasis = signalColors.tonal."surface-hover";
    surface-subtle = signalColors.tonal."divider-primary";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-tertiary = signalColors.tonal."text-tertiary";
    divider-primary = signalColors.tonal."divider-primary";
    divider-secondary = signalColors.tonal."divider-strong";
  };

  inherit (signalColors) accent categorical;

  # Generate Helix theme with palette structure
  helixTheme = {
    # Syntax highlighting - using palette colors
    "attribute" = "type";
    "type" = "type";
    "type.enum.variant" = "string";

    "constructor" = "function";

    "constant" = "constant";
    "constant.character" = "string";
    "constant.character.escape" = "escape";

    "string" = "string";
    "string.regexp" = "escape";
    "string.special" = "function";
    "string.special.symbol" = "danger";

    "comment" = {
      fg = "comment";
      modifiers = [ "italic" ];
    };

    "variable" = "text-primary";
    "variable.parameter" = {
      fg = "variable-param";
      modifiers = [ "italic" ];
    };
    "variable.builtin" = "danger";
    "variable.other.member" = "function";

    "label" = "function";

    "punctuation" = "comment";
    "punctuation.special" = "info";

    "keyword" = "keyword";
    "keyword.control.conditional" = {
      fg = "keyword";
      modifiers = [ "italic" ];
    };

    "operator" = "info";

    "function" = "function";
    "function.macro" = "escape";

    "tag" = "function";

    "namespace" = {
      fg = "type";
      modifiers = [ "italic" ];
    };

    "special" = "function";

    # Markup
    "markup.heading.1" = "danger";
    "markup.heading.2" = "type";
    "markup.heading.3" = "type";
    "markup.heading.4" = "string";
    "markup.heading.5" = "function";
    "markup.heading.6" = "keyword";
    "markup.list" = "string";
    "markup.list.unchecked" = "comment";
    "markup.list.checked" = "string";
    "markup.bold" = {
      fg = "danger";
      modifiers = [ "bold" ];
    };
    "markup.italic" = {
      fg = "danger";
      modifiers = [ "italic" ];
    };
    "markup.link.url" = {
      fg = "function";
      modifiers = [
        "italic"
        "underlined"
      ];
    };
    "markup.link.text" = "keyword";
    "markup.link.label" = "function";
    "markup.raw" = "string";
    "markup.quote" = "escape";

    # Diff
    "diff.plus" = "string";
    "diff.minus" = "danger";
    "diff.delta" = "function";

    # User Interface
    "ui.background" = {
      fg = "text-primary";
      bg = "surface-base";
    };

    "ui.linenr" = "divider-secondary";
    "ui.linenr.selected" = "keyword";

    "ui.statusline" = {
      fg = "text-secondary";
      bg = "surface-emphasis";
    };
    "ui.statusline.inactive" = {
      fg = "divider-secondary";
      bg = "surface-emphasis";
    };
    "ui.statusline.normal" = {
      fg = "surface-base";
      bg = "escape";
      modifiers = [ "bold" ];
    };
    "ui.statusline.insert" = {
      fg = "surface-base";
      bg = "string";
      modifiers = [ "bold" ];
    };
    "ui.statusline.select" = {
      fg = "surface-base";
      bg = "keyword";
      modifiers = [ "bold" ];
    };

    "ui.popup" = {
      fg = "text-primary";
      bg = "surface-subtle";
    };
    "ui.window" = "surface-base";
    "ui.help" = {
      fg = "comment";
      bg = "surface-subtle";
    };

    "ui.bufferline" = {
      fg = "text-secondary";
      bg = "surface-emphasis";
    };
    "ui.bufferline.active" = {
      fg = "keyword";
      bg = "surface-base";
      underline = {
        color = "keyword";
        style = "line";
      };
    };
    "ui.bufferline.background" = {
      bg = "surface-base";
    };

    "ui.text" = "text-primary";
    "ui.text.focus" = {
      fg = "text-primary";
      bg = "surface-subtle";
      modifiers = [ "bold" ];
    };
    "ui.text.inactive" = "comment";
    "ui.text.directory" = "function";

    "ui.virtual" = "comment";
    "ui.virtual.ruler" = {
      bg = "surface-subtle";
    };
    "ui.virtual.indent-guide" = "surface-subtle";
    "ui.virtual.inlay-hint" = {
      fg = "divider-secondary";
      bg = "surface-emphasis";
    };
    "ui.virtual.jump-label" = {
      fg = "escape";
      modifiers = [ "bold" ];
    };

    "ui.selection" = {
      bg = "divider-secondary";
    };

    "ui.cursor" = {
      fg = "surface-base";
      bg = "comment";
    };
    "ui.cursor.primary" = {
      fg = "surface-base";
      bg = "escape";
    };
    "ui.cursor.match" = {
      fg = "type";
      modifiers = [ "bold" ];
    };

    "ui.cursor.primary.normal" = {
      fg = "surface-base";
      bg = "escape";
    };
    "ui.cursor.primary.insert" = {
      fg = "surface-base";
      bg = "string";
    };
    "ui.cursor.primary.select" = {
      fg = "surface-base";
      bg = "keyword";
    };

    "ui.cursor.normal" = {
      fg = "surface-base";
      bg = "comment";
    };
    "ui.cursor.insert" = {
      fg = "surface-base";
      bg = "string";
    };
    "ui.cursor.select" = {
      fg = "surface-base";
      bg = "keyword";
    };

    "ui.cursorline.primary" = {
      bg = "surface-subtle";
    };

    "ui.highlight" = {
      bg = "divider-secondary";
      modifiers = [ "bold" ];
    };

    "ui.menu" = {
      fg = "comment";
      bg = "surface-subtle";
    };
    "ui.menu.selected" = {
      fg = "text-primary";
      bg = "divider-secondary";
      modifiers = [ "bold" ];
    };

    "diagnostic.error" = {
      underline = {
        color = "danger";
        style = "curl";
      };
    };
    "diagnostic.warning" = {
      underline = {
        color = "type";
        style = "curl";
      };
    };
    "diagnostic.info" = {
      underline = {
        color = "info";
        style = "curl";
      };
    };
    "diagnostic.hint" = {
      underline = {
        color = "string";
        style = "curl";
      };
    };
    "diagnostic.unnecessary" = {
      modifiers = [ "dim" ];
    };

    error = "danger";
    warning = "type";
    info = "info";
    hint = "string";

    rainbow = [
      "danger"
      "type"
      "type"
      "string"
      "function"
      "keyword"
    ];

    # Palette - Define all colors used in the theme
    palette = {
      # Surface colors
      surface-base = colors.surface-base.hex;
      surface-emphasis = colors.surface-emphasis.hex;
      surface-subtle = colors.surface-subtle.hex;

      # Text colors
      text-primary = colors.text-primary.hex;
      text-secondary = colors.text-secondary.hex;
      comment = colors.text-tertiary.hex;

      # Divider colors
      divider-primary = colors.divider-primary.hex;
      divider-secondary = colors.divider-secondary.hex;

      # Accent colors (semantic)
      function = accent.secondary.Lc75.hex;
      danger = accent.danger.Lc75.hex;
      info = accent.secondary.Lc75.hex;
      keyword = accent.tertiary.Lc75.hex;

      # Categorical colors (syntax)
      string = categorical."data-viz-02".hex;
      type = categorical."data-viz-06".hex;
      escape = categorical."data-viz-08".hex;
      constant = categorical."data-viz-06".hex;
      variable-param = accent.danger.Lc60.hex;
    };
  };
  # Check if helix should be themed
  # Check if helix should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "helix" [
    "editors"
    "helix"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.helix = {
      settings = {
        theme = "signal-${themeMode}";
      };

      themes."signal-${themeMode}" = helixTheme;
    };
  };
}
