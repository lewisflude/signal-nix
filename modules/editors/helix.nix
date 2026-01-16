{
  config,
  lib,
  signalColors,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  # Map signal colors to theme structure
  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-emphasis = signalColors.tonal."surface-Lc10";
    surface-subtle = signalColors.tonal."divider-Lc15";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-tertiary = signalColors.tonal."text-Lc45";
    divider-primary = signalColors.tonal."divider-Lc15";
    divider-secondary = signalColors.tonal."divider-Lc30";
  };

  inherit (signalColors) accent categorical;

  # Generate Helix theme
  helixTheme = {
    # Syntax highlighting
    "attribute" = categorical.GA06.hex;
    "type" = categorical.GA06.hex;
    "type.enum.variant" = categorical.GA02.hex;

    "constructor" = accent.focus.Lc75.hex;

    "constant" = categorical.GA06.hex;
    "constant.character" = categorical.GA02.hex;
    "constant.character.escape" = categorical.GA08.hex;

    "string" = categorical.GA02.hex;
    "string.regexp" = categorical.GA08.hex;
    "string.special" = accent.focus.Lc75.hex;
    "string.special.symbol" = accent.danger.Lc75.hex;

    "comment" = {
      fg = colors.text-tertiary.hex;
      modifiers = [ "italic" ];
    };

    "variable" = colors.text-primary.hex;
    "variable.parameter" = {
      fg = accent.danger.Lc60.hex;
      modifiers = [ "italic" ];
    };
    "variable.builtin" = accent.danger.Lc75.hex;
    "variable.other.member" = accent.focus.Lc75.hex;

    "label" = accent.focus.Lc75.hex;

    "punctuation" = colors.text-tertiary.hex;
    "punctuation.special" = accent.info.Lc75.hex;

    "keyword" = accent.special.Lc75.hex;
    "keyword.control.conditional" = {
      fg = accent.special.Lc75.hex;
      modifiers = [ "italic" ];
    };

    "operator" = accent.info.Lc75.hex;

    "function" = accent.focus.Lc75.hex;
    "function.macro" = categorical.GA08.hex;

    "tag" = accent.focus.Lc75.hex;

    "namespace" = {
      fg = categorical.GA06.hex;
      modifiers = [ "italic" ];
    };

    "special" = accent.focus.Lc75.hex;

    # Markup
    "markup.heading.1" = accent.danger.Lc75.hex;
    "markup.heading.2" = categorical.GA06.hex;
    "markup.heading.3" = categorical.GA06.hex;
    "markup.heading.4" = categorical.GA02.hex;
    "markup.heading.5" = accent.focus.Lc75.hex;
    "markup.heading.6" = accent.special.Lc75.hex;
    "markup.list" = categorical.GA02.hex;
    "markup.list.unchecked" = colors.text-tertiary.hex;
    "markup.list.checked" = categorical.GA02.hex;
    "markup.bold" = {
      fg = accent.danger.Lc75.hex;
      modifiers = [ "bold" ];
    };
    "markup.italic" = {
      fg = accent.danger.Lc75.hex;
      modifiers = [ "italic" ];
    };
    "markup.link.url" = {
      fg = accent.focus.Lc75.hex;
      modifiers = [
        "italic"
        "underlined"
      ];
    };
    "markup.link.text" = accent.special.Lc75.hex;
    "markup.link.label" = accent.focus.Lc75.hex;
    "markup.raw" = categorical.GA02.hex;
    "markup.quote" = categorical.GA08.hex;

    # Diff
    "diff.plus" = categorical.GA02.hex;
    "diff.minus" = accent.danger.Lc75.hex;
    "diff.delta" = accent.focus.Lc75.hex;

    # User Interface
    "ui.background" = {
      fg = colors.text-primary.hex;
      bg = colors.surface-base.hex;
    };

    "ui.linenr" = {
      fg = colors.divider-secondary.hex;
    };
    "ui.linenr.selected" = {
      fg = accent.special.Lc75.hex;
    };

    "ui.statusline" = {
      fg = colors.text-secondary.hex;
      bg = colors.surface-emphasis.hex;
    };
    "ui.statusline.inactive" = {
      fg = colors.divider-secondary.hex;
      bg = colors.surface-emphasis.hex;
    };
    "ui.statusline.normal" = {
      fg = colors.surface-base.hex;
      bg = categorical.GA08.hex;
      modifiers = [ "bold" ];
    };
    "ui.statusline.insert" = {
      fg = colors.surface-base.hex;
      bg = categorical.GA02.hex;
      modifiers = [ "bold" ];
    };
    "ui.statusline.select" = {
      fg = colors.surface-base.hex;
      bg = accent.special.Lc75.hex;
      modifiers = [ "bold" ];
    };

    "ui.popup" = {
      fg = colors.text-primary.hex;
      bg = colors.surface-subtle.hex;
    };
    "ui.window" = {
      fg = colors.surface-base.hex;
    };
    "ui.help" = {
      fg = colors.text-tertiary.hex;
      bg = colors.surface-subtle.hex;
    };

    "ui.bufferline" = {
      fg = colors.text-secondary.hex;
      bg = colors.surface-emphasis.hex;
    };
    "ui.bufferline.active" = {
      fg = accent.special.Lc75.hex;
      bg = colors.surface-base.hex;
      underline = {
        color = accent.special.Lc75.hex;
        style = "line";
      };
    };
    "ui.bufferline.background" = {
      bg = colors.surface-base.hex;
    };

    "ui.text" = colors.text-primary.hex;
    "ui.text.focus" = {
      fg = colors.text-primary.hex;
      bg = colors.surface-subtle.hex;
      modifiers = [ "bold" ];
    };
    "ui.text.inactive" = colors.text-tertiary.hex;
    "ui.text.directory" = accent.focus.Lc75.hex;

    "ui.virtual" = colors.text-tertiary.hex;
    "ui.virtual.ruler" = {
      bg = colors.surface-subtle.hex;
    };
    "ui.virtual.indent-guide" = colors.surface-subtle.hex;
    "ui.virtual.inlay-hint" = {
      fg = colors.divider-secondary.hex;
      bg = colors.surface-emphasis.hex;
    };
    "ui.virtual.jump-label" = {
      fg = categorical.GA08.hex;
      modifiers = [ "bold" ];
    };

    "ui.selection" = {
      bg = colors.divider-secondary.hex;
    };

    "ui.cursor" = {
      fg = colors.surface-base.hex;
      bg = colors.text-tertiary.hex;
    };
    "ui.cursor.primary" = {
      fg = colors.surface-base.hex;
      bg = categorical.GA08.hex;
    };
    "ui.cursor.match" = {
      fg = categorical.GA06.hex;
      modifiers = [ "bold" ];
    };

    "ui.cursor.primary.normal" = {
      fg = colors.surface-base.hex;
      bg = categorical.GA08.hex;
    };
    "ui.cursor.primary.insert" = {
      fg = colors.surface-base.hex;
      bg = categorical.GA02.hex;
    };
    "ui.cursor.primary.select" = {
      fg = colors.surface-base.hex;
      bg = accent.special.Lc75.hex;
    };

    "ui.cursor.normal" = {
      fg = colors.surface-base.hex;
      bg = colors.text-tertiary.hex;
    };
    "ui.cursor.insert" = {
      fg = colors.surface-base.hex;
      bg = categorical.GA02.hex;
    };
    "ui.cursor.select" = {
      fg = colors.surface-base.hex;
      bg = accent.special.Lc75.hex;
    };

    "ui.cursorline.primary" = {
      bg = colors.surface-subtle.hex;
    };

    "ui.highlight" = {
      bg = colors.divider-secondary.hex;
      modifiers = [ "bold" ];
    };

    "ui.menu" = {
      fg = colors.text-tertiary.hex;
      bg = colors.surface-subtle.hex;
    };
    "ui.menu.selected" = {
      fg = colors.text-primary.hex;
      bg = colors.divider-secondary.hex;
      modifiers = [ "bold" ];
    };

    "diagnostic.error" = {
      underline = {
        color = accent.danger.Lc75.hex;
        style = "curl";
      };
    };
    "diagnostic.warning" = {
      underline = {
        color = categorical.GA06.hex;
        style = "curl";
      };
    };
    "diagnostic.info" = {
      underline = {
        color = accent.info.Lc75.hex;
        style = "curl";
      };
    };
    "diagnostic.hint" = {
      underline = {
        color = categorical.GA02.hex;
        style = "curl";
      };
    };
    "diagnostic.unnecessary" = {
      modifiers = [ "dim" ];
    };

    error = accent.danger.Lc75.hex;
    warning = categorical.GA06.hex;
    info = accent.info.Lc75.hex;
    hint = categorical.GA02.hex;

    rainbow = [
      accent.danger.Lc75.hex
      categorical.GA06.hex
      categorical.GA06.hex
      categorical.GA02.hex
      accent.focus.Lc75.hex
      accent.special.Lc75.hex
    ];
  };
in
{
  config = mkIf (cfg.enable && cfg.helix.enable) {
    programs.helix = {
      settings = {
        theme = "signal-${cfg.mode}";
      };

      themes."signal-${cfg.mode}" = helixTheme;
    };
  };
}
