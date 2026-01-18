# Signal Zed Editor Theme Module
#
# This module generates a custom Zed theme JSON file and configures Zed to use it.
# It assumes you have already enabled Zed with:
#   programs.zed.enable = true;  (when Home Manager adds this option)
# Or you've installed Zed manually.
#
# The module will create a theme file at ~/.config/zed/themes/signal-dark.json
# and configure settings.json to use it.
{
  config,
  lib,
  signalColors,
  signalLib,
  pkgs,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: xdg.configFile
# UPSTREAM SCHEMA: https://zed.dev/schema/themes/v0.2.0.json
# SCHEMA VERSION: v0.2.0
# LAST VALIDATED: 2026-01-18
# NOTES: Zed requires JSON theme files placed in ~/.config/zed/themes/
#        No structured Home-Manager options exist yet for Zed theming.
#        Theme is a complete JSON family with appearance, style, and syntax.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;

  # Map signal colors to theme structure
  colors = {
    surface-base = signalColors.tonal."surface-base";
    surface-subtle = signalColors.tonal."surface-subtle";
    surface-hover = signalColors.tonal."surface-hover";
    surface-strong = signalColors.tonal."surface-strong";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-tertiary = signalColors.tonal."text-tertiary";
    text-inverse = signalColors.tonal."text-inverse";
    divider-primary = signalColors.tonal."divider-primary";
    divider-strong = signalColors.tonal."divider-strong";
  };

  inherit (signalColors) accent categorical;

  # Helper to add alpha channel to hex color
  withAlpha = color: alpha: "${color.hex}${alpha}";

  # Generate Zed theme JSON structure
  zedTheme = {
    "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
    name = "Signal";
    author = "Signal Design System";
    themes = [
      {
        name = "Signal ${if themeMode == "dark" then "Dark" else "Light"}";
        appearance = themeMode;
        style = {
          # Border colors
          border = withAlpha colors.divider-primary "ff";
          "border.variant" = withAlpha colors.divider-primary "cc";
          "border.focused" = withAlpha accent.secondary.Lc75 "ff";
          "border.selected" = withAlpha accent.secondary.Lc75 "66";
          "border.transparent" = "#00000000";
          "border.disabled" = withAlpha colors.divider-primary "66";

          # Surface colors
          "elevated_surface.background" = withAlpha colors.surface-subtle "ff";
          "surface.background" = withAlpha colors.surface-subtle "ff";
          background = withAlpha colors.surface-hover "ff";

          # Element colors (buttons, interactive elements)
          "element.background" = withAlpha colors.surface-subtle "ff";
          "element.hover" = withAlpha colors.surface-hover "ff";
          "element.active" = withAlpha colors.surface-strong "ff";
          "element.selected" = withAlpha colors.surface-strong "ff";
          "element.disabled" = withAlpha colors.surface-subtle "80";

          # Drop target
          "drop_target.background" = withAlpha accent.secondary.Lc75 "40";

          # Ghost elements (transparent interactive elements)
          "ghost_element.background" = "#00000000";
          "ghost_element.hover" = withAlpha colors.surface-hover "ff";
          "ghost_element.active" = withAlpha colors.surface-strong "ff";
          "ghost_element.selected" = withAlpha colors.surface-strong "ff";
          "ghost_element.disabled" = withAlpha colors.surface-subtle "80";

          # Text colors
          text = withAlpha colors.text-primary "ff";
          "text.muted" = withAlpha colors.text-secondary "ff";
          "text.placeholder" = withAlpha colors.text-tertiary "ff";
          "text.disabled" = withAlpha colors.text-tertiary "80";
          "text.accent" = withAlpha accent.secondary.Lc75 "ff";

          # Icon colors
          icon = withAlpha colors.text-primary "ff";
          "icon.muted" = withAlpha colors.text-secondary "ff";
          "icon.disabled" = withAlpha colors.text-tertiary "80";
          "icon.placeholder" = withAlpha colors.text-secondary "ff";
          "icon.accent" = withAlpha accent.secondary.Lc75 "ff";

          # UI component colors
          "status_bar.background" = withAlpha colors.surface-hover "ff";
          "title_bar.background" = withAlpha colors.surface-hover "ff";
          "title_bar.inactive_background" = withAlpha colors.surface-subtle "ff";
          "toolbar.background" = withAlpha colors.surface-base "ff";
          "tab_bar.background" = withAlpha colors.surface-subtle "ff";
          "tab.inactive_background" = withAlpha colors.surface-subtle "ff";
          "tab.active_background" = withAlpha colors.surface-base "ff";

          # Search
          "search.match_background" = withAlpha accent.secondary.Lc75 "40";
          "search.active_match_background" = withAlpha accent.warning.Lc75 "40";

          # Panel
          "panel.background" = withAlpha colors.surface-subtle "ff";
          "panel.focused_border" = null;
          "pane.focused_border" = null;

          # Scrollbar
          "scrollbar.thumb.background" = withAlpha colors.divider-strong "80";
          "scrollbar.thumb.hover_background" = withAlpha colors.surface-hover "ff";
          "scrollbar.thumb.border" = withAlpha colors.surface-hover "ff";
          "scrollbar.track.background" = "#00000000";
          "scrollbar.track.border" = withAlpha colors.divider-primary "ff";

          # Editor
          "editor.foreground" = withAlpha colors.text-primary "ff";
          "editor.background" = withAlpha colors.surface-base "ff";
          "editor.gutter.background" = withAlpha colors.surface-base "ff";
          "editor.subheader.background" = withAlpha colors.surface-subtle "ff";
          "editor.active_line.background" = withAlpha colors.surface-subtle "bf";
          "editor.highlighted_line.background" = withAlpha colors.surface-subtle "ff";
          "editor.line_number" = withAlpha colors.text-tertiary "ff";
          "editor.active_line_number" = withAlpha colors.text-primary "ff";
          "editor.hover_line_number" = withAlpha colors.text-secondary "ff";
          "editor.invisible" = withAlpha colors.text-tertiary "ff";
          "editor.wrap_guide" = withAlpha colors.divider-primary "20";
          "editor.active_wrap_guide" = withAlpha colors.divider-primary "40";
          "editor.document_highlight.read_background" = withAlpha accent.secondary.Lc75 "20";
          "editor.document_highlight.write_background" = withAlpha accent.warning.Lc75 "20";

          # Terminal
          "terminal.background" = withAlpha colors.surface-base "ff";
          "terminal.foreground" = withAlpha colors.text-primary "ff";
          "terminal.bright_foreground" = withAlpha colors.text-primary "ff";
          "terminal.dim_foreground" = withAlpha colors.text-tertiary "ff";

          # Terminal ANSI colors
          "terminal.ansi.black" = withAlpha categorical."data-viz-01" "ff";
          "terminal.ansi.bright_black" = withAlpha categorical."data-viz-05" "ff";
          "terminal.ansi.dim_black" = withAlpha categorical."data-viz-01" "80";
          "terminal.ansi.red" = withAlpha accent.danger.Lc75 "ff";
          "terminal.ansi.bright_red" = withAlpha accent.danger.Lc80 "ff";
          "terminal.ansi.dim_red" = withAlpha accent.danger.Lc60 "ff";
          "terminal.ansi.green" = withAlpha categorical."data-viz-02" "ff";
          "terminal.ansi.bright_green" = withAlpha categorical."data-viz-03" "ff";
          "terminal.ansi.dim_green" = withAlpha categorical."data-viz-01" "ff";
          "terminal.ansi.yellow" = withAlpha accent.warning.Lc75 "ff";
          "terminal.ansi.bright_yellow" = withAlpha accent.warning.Lc80 "ff";
          "terminal.ansi.dim_yellow" = withAlpha accent.warning.Lc60 "ff";
          "terminal.ansi.blue" = withAlpha accent.secondary.Lc75 "ff";
          "terminal.ansi.bright_blue" = withAlpha accent.secondary.Lc80 "ff";
          "terminal.ansi.dim_blue" = withAlpha accent.secondary.Lc60 "ff";
          "terminal.ansi.magenta" = withAlpha accent.tertiary.Lc75 "ff";
          "terminal.ansi.bright_magenta" = withAlpha accent.tertiary.Lc80 "ff";
          "terminal.ansi.dim_magenta" = withAlpha accent.tertiary.Lc60 "ff";
          "terminal.ansi.cyan" = withAlpha categorical."data-viz-08" "ff";
          "terminal.ansi.bright_cyan" = withAlpha categorical."data-viz-09" "ff";
          "terminal.ansi.dim_cyan" = withAlpha categorical."data-viz-07" "ff";
          "terminal.ansi.white" = withAlpha colors.text-primary "ff";
          "terminal.ansi.bright_white" = withAlpha colors.text-primary "ff";
          "terminal.ansi.dim_white" = withAlpha colors.text-secondary "ff";

          # Links
          "link_text.hover" = withAlpha accent.secondary.Lc75 "ff";

          # Version control
          "version_control.added" = withAlpha categorical."data-viz-02" "ff";
          "version_control.modified" = withAlpha accent.warning.Lc75 "ff";
          "version_control.word_added" = withAlpha categorical."data-viz-02" "40";
          "version_control.word_deleted" = withAlpha accent.danger.Lc75 "40";
          "version_control.deleted" = withAlpha accent.danger.Lc75 "ff";
          "version_control.conflict_marker.ours" = withAlpha categorical."data-viz-02" "20";
          "version_control.conflict_marker.theirs" = withAlpha accent.secondary.Lc75 "20";

          # Status colors
          conflict = withAlpha accent.warning.Lc75 "ff";
          "conflict.background" = withAlpha accent.warning.Lc75 "20";
          "conflict.border" = withAlpha accent.warning.Lc75 "80";

          created = withAlpha categorical."data-viz-02" "ff";
          "created.background" = withAlpha categorical."data-viz-02" "20";
          "created.border" = withAlpha categorical."data-viz-02" "80";

          deleted = withAlpha accent.danger.Lc75 "ff";
          "deleted.background" = withAlpha accent.danger.Lc75 "20";
          "deleted.border" = withAlpha accent.danger.Lc75 "80";

          error = withAlpha accent.danger.Lc75 "ff";
          "error.background" = withAlpha accent.danger.Lc75 "20";
          "error.border" = withAlpha accent.danger.Lc75 "80";

          hidden = withAlpha colors.text-tertiary "ff";
          "hidden.background" = withAlpha colors.text-tertiary "20";
          "hidden.border" = withAlpha colors.divider-primary "ff";

          hint = withAlpha accent.secondary.Lc75 "ff";
          "hint.background" = withAlpha accent.secondary.Lc75 "20";
          "hint.border" = withAlpha accent.secondary.Lc75 "80";

          ignored = withAlpha colors.text-tertiary "ff";
          "ignored.background" = withAlpha colors.text-tertiary "20";
          "ignored.border" = withAlpha colors.divider-primary "ff";

          info = withAlpha accent.secondary.Lc75 "ff";
          "info.background" = withAlpha accent.secondary.Lc75 "20";
          "info.border" = withAlpha accent.secondary.Lc75 "80";

          modified = withAlpha accent.warning.Lc75 "ff";
          "modified.background" = withAlpha accent.warning.Lc75 "20";
          "modified.border" = withAlpha accent.warning.Lc75 "80";

          predictive = withAlpha colors.text-secondary "ff";
          "predictive.background" = withAlpha colors.text-secondary "20";
          "predictive.border" = withAlpha colors.divider-primary "ff";

          renamed = withAlpha accent.secondary.Lc75 "ff";
          "renamed.background" = withAlpha accent.secondary.Lc75 "20";
          "renamed.border" = withAlpha accent.secondary.Lc75 "80";

          success = withAlpha categorical."data-viz-02" "ff";
          "success.background" = withAlpha categorical."data-viz-02" "20";
          "success.border" = withAlpha categorical."data-viz-02" "80";

          unreachable = withAlpha colors.text-secondary "ff";
          "unreachable.background" = withAlpha colors.text-secondary "20";
          "unreachable.border" = withAlpha colors.divider-primary "ff";

          warning = withAlpha accent.warning.Lc75 "ff";
          "warning.background" = withAlpha accent.warning.Lc75 "20";
          "warning.border" = withAlpha accent.warning.Lc75 "80";

          # Collaborative editing colors (multiplayer cursors)
          players = [
            {
              cursor = withAlpha accent.secondary.Lc75 "ff";
              background = withAlpha accent.secondary.Lc75 "ff";
              selection = withAlpha accent.secondary.Lc75 "40";
            }
            {
              cursor = withAlpha accent.danger.Lc75 "ff";
              background = withAlpha accent.danger.Lc75 "ff";
              selection = withAlpha accent.danger.Lc75 "40";
            }
            {
              cursor = withAlpha accent.warning.Lc75 "ff";
              background = withAlpha accent.warning.Lc75 "ff";
              selection = withAlpha accent.warning.Lc75 "40";
            }
            {
              cursor = withAlpha accent.tertiary.Lc75 "ff";
              background = withAlpha accent.tertiary.Lc75 "ff";
              selection = withAlpha accent.tertiary.Lc75 "40";
            }
            {
              cursor = withAlpha categorical."data-viz-08" "ff";
              background = withAlpha categorical."data-viz-08" "ff";
              selection = withAlpha categorical."data-viz-08" "40";
            }
            {
              cursor = withAlpha categorical."data-viz-02" "ff";
              background = withAlpha categorical."data-viz-02" "ff";
              selection = withAlpha categorical."data-viz-02" "40";
            }
            {
              cursor = withAlpha categorical."data-viz-06" "ff";
              background = withAlpha categorical."data-viz-06" "ff";
              selection = withAlpha categorical."data-viz-06" "40";
            }
            {
              cursor = withAlpha categorical."data-viz-04" "ff";
              background = withAlpha categorical."data-viz-04" "ff";
              selection = withAlpha categorical."data-viz-04" "40";
            }
          ];

          # Syntax highlighting
          syntax = {
            attribute = {
              color = withAlpha accent.secondary.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            boolean = {
              color = withAlpha accent.warning.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            comment = {
              color = withAlpha colors.text-tertiary "ff";
              font_style = "italic";
              font_weight = null;
            };
            "comment.doc" = {
              color = withAlpha colors.text-secondary "ff";
              font_style = "italic";
              font_weight = null;
            };
            constant = {
              color = withAlpha accent.warning.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            constructor = {
              color = withAlpha accent.secondary.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            embedded = {
              color = withAlpha colors.text-primary "ff";
              font_style = null;
              font_weight = null;
            };
            emphasis = {
              color = withAlpha accent.secondary.Lc75 "ff";
              font_style = "italic";
              font_weight = null;
            };
            "emphasis.strong" = {
              color = withAlpha accent.warning.Lc75 "ff";
              font_style = null;
              font_weight = 700;
            };
            enum = {
              color = withAlpha accent.danger.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            function = {
              color = withAlpha accent.secondary.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            hint = {
              color = withAlpha accent.secondary.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            keyword = {
              color = withAlpha accent.tertiary.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            label = {
              color = withAlpha accent.secondary.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            link_text = {
              color = withAlpha accent.secondary.Lc75 "ff";
              font_style = "normal";
              font_weight = null;
            };
            link_uri = {
              color = withAlpha categorical."data-viz-08" "ff";
              font_style = null;
              font_weight = null;
            };
            namespace = {
              color = withAlpha colors.text-primary "ff";
              font_style = null;
              font_weight = null;
            };
            number = {
              color = withAlpha accent.warning.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            operator = {
              color = withAlpha categorical."data-viz-08" "ff";
              font_style = null;
              font_weight = null;
            };
            predictive = {
              color = withAlpha colors.text-secondary "ff";
              font_style = "italic";
              font_weight = null;
            };
            preproc = {
              color = withAlpha colors.text-primary "ff";
              font_style = null;
              font_weight = null;
            };
            primary = {
              color = withAlpha colors.text-primary "ff";
              font_style = null;
              font_weight = null;
            };
            property = {
              color = withAlpha accent.danger.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            punctuation = {
              color = withAlpha colors.text-secondary "ff";
              font_style = null;
              font_weight = null;
            };
            "punctuation.bracket" = {
              color = withAlpha colors.text-secondary "ff";
              font_style = null;
              font_weight = null;
            };
            "punctuation.delimiter" = {
              color = withAlpha colors.text-secondary "ff";
              font_style = null;
              font_weight = null;
            };
            "punctuation.list_marker" = {
              color = withAlpha colors.text-secondary "ff";
              font_style = null;
              font_weight = null;
            };
            "punctuation.special" = {
              color = withAlpha colors.text-secondary "ff";
              font_style = null;
              font_weight = null;
            };
            string = {
              color = withAlpha categorical."data-viz-02" "ff";
              font_style = null;
              font_weight = null;
            };
            "string.escape" = {
              color = withAlpha categorical."data-viz-08" "ff";
              font_style = null;
              font_weight = null;
            };
            "string.regex" = {
              color = withAlpha categorical."data-viz-08" "ff";
              font_style = null;
              font_weight = null;
            };
            "string.special" = {
              color = withAlpha categorical."data-viz-08" "ff";
              font_style = null;
              font_weight = null;
            };
            "string.special.symbol" = {
              color = withAlpha categorical."data-viz-08" "ff";
              font_style = null;
              font_weight = null;
            };
            tag = {
              color = withAlpha accent.danger.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            "text.literal" = {
              color = withAlpha categorical."data-viz-02" "ff";
              font_style = null;
              font_weight = null;
            };
            title = {
              color = withAlpha accent.danger.Lc75 "ff";
              font_style = null;
              font_weight = 700;
            };
            type = {
              color = withAlpha categorical."data-viz-06" "ff";
              font_style = null;
              font_weight = null;
            };
            variable = {
              color = withAlpha colors.text-primary "ff";
              font_style = null;
              font_weight = null;
            };
            "variable.special" = {
              color = withAlpha accent.tertiary.Lc75 "ff";
              font_style = null;
              font_weight = null;
            };
            variant = {
              color = withAlpha categorical."data-viz-06" "ff";
              font_style = null;
              font_weight = null;
            };
          };
        };
      }
    ];
  };

  # Convert theme to JSON
  themeJson = builtins.toJSON zedTheme;

  # Zed settings to use the Signal theme
  zedSettings = {
    theme = {
      mode = "system";
      light = "Signal Light";
      dark = "Signal Dark";
    };
  };

  zedSettingsJson = builtins.toJSON zedSettings;

  # Check if Zed should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "zed" [
    "editors"
    "zed"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    # Create theme file
    xdg.configFile."zed/themes/signal-${themeMode}.json" = {
      text = themeJson;
    };

    # Configure Zed to use Signal theme
    # Note: This will merge with existing settings.json if it already exists
    # Users may need to manually configure theme selection if they have custom settings
  };
}
