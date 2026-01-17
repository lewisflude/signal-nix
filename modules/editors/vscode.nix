{
  config,
  lib,
  pkgs,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: json-settings (Tier 2)
# HOME-MANAGER MODULE: programs.vscode.userSettings
# UPSTREAM SCHEMA: https://code.visualstudio.com/docs/getstarted/themes
# SCHEMA VERSION: 1.95.0
# LAST VALIDATED: 2026-01-17
# NOTES: VS Code uses a JSON settings file. Home-Manager provides userSettings
#        attrset. We define workbench colors and editor token colors.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-raised = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-dim = signalColors.tonal."text-tertiary";
    divider-primary = signalColors.tonal."divider-primary";
    divider-secondary = signalColors.tonal."divider-strong";
  };

  inherit (signalColors) accent;

  # Check if vscode should be themed
  # Only theme if the program is actually enabled
  vscodeEnabled = config.programs.vscode.enable or false;

  shouldTheme =
    vscodeEnabled
    && (signalLib.shouldThemeApp "vscode" [
      "editors"
      "vscode"
    ] cfg config);

  vscodeSettings = {
    "workbench.colorTheme" = "Signal";
    "workbench.colorCustomizations" = {
      # Editor colors
      "editor.background" = colors.surface-base.hex;
      "editor.foreground" = colors.text-primary.hex;
      "editor.lineHighlightBackground" = colors.surface-raised.hex;
      "editor.selectionBackground" = colors.divider-primary.hex;
      "editor.selectionHighlightBackground" = "${colors.divider-primary.hex}80";
      "editor.wordHighlightBackground" = "${colors.divider-primary.hex}60";
      "editor.wordHighlightStrongBackground" = "${colors.divider-primary.hex}80";
      "editor.findMatchBackground" = "${accent.warning.Lc75.hex}60";
      "editor.findMatchHighlightBackground" = "${accent.warning.Lc75.hex}40";
      "editor.hoverHighlightBackground" = colors.surface-raised.hex;
      "editor.lineHighlightBorder" = colors.divider-primary.hex;

      # Cursor
      "editorCursor.foreground" = accent.secondary.Lc75.hex;

      # Line numbers
      "editorLineNumber.foreground" = colors.text-dim.hex;
      "editorLineNumber.activeForeground" = colors.text-secondary.hex;

      # Gutter
      "editorGutter.background" = colors.surface-base.hex;
      "editorGutter.addedBackground" = accent.primary.Lc75.hex;
      "editorGutter.modifiedBackground" = accent.secondary.Lc75.hex;
      "editorGutter.deletedBackground" = accent.danger.Lc75.hex;

      # Sidebar
      "sideBar.background" = colors.surface-base.hex;
      "sideBar.foreground" = colors.text-secondary.hex;
      "sideBar.border" = colors.divider-primary.hex;
      "sideBarTitle.foreground" = colors.text-primary.hex;
      "sideBarSectionHeader.background" = colors.surface-raised.hex;

      # Activity bar
      "activityBar.background" = colors.surface-base.hex;
      "activityBar.foreground" = colors.text-primary.hex;
      "activityBar.inactiveForeground" = colors.text-dim.hex;
      "activityBar.border" = colors.divider-primary.hex;
      "activityBarBadge.background" = accent.secondary.Lc75.hex;
      "activityBarBadge.foreground" = colors.surface-base.hex;

      # Status bar
      "statusBar.background" = colors.surface-raised.hex;
      "statusBar.foreground" = colors.text-primary.hex;
      "statusBar.border" = colors.divider-primary.hex;
      "statusBar.debuggingBackground" = accent.warning.Lc75.hex;
      "statusBar.debuggingForeground" = colors.surface-base.hex;
      "statusBar.noFolderBackground" = colors.surface-raised.hex;

      # Title bar
      "titleBar.activeBackground" = colors.surface-base.hex;
      "titleBar.activeForeground" = colors.text-primary.hex;
      "titleBar.inactiveBackground" = colors.surface-base.hex;
      "titleBar.inactiveForeground" = colors.text-dim.hex;
      "titleBar.border" = colors.divider-primary.hex;

      # Tabs
      "tab.activeBackground" = colors.surface-raised.hex;
      "tab.activeForeground" = colors.text-primary.hex;
      "tab.inactiveBackground" = colors.surface-base.hex;
      "tab.inactiveForeground" = colors.text-secondary.hex;
      "tab.border" = colors.divider-primary.hex;
      "tab.activeBorder" = accent.secondary.Lc75.hex;

      # Panel
      "panel.background" = colors.surface-base.hex;
      "panel.border" = colors.divider-primary.hex;
      "panelTitle.activeBorder" = accent.secondary.Lc75.hex;
      "panelTitle.activeForeground" = colors.text-primary.hex;
      "panelTitle.inactiveForeground" = colors.text-secondary.hex;

      # Terminal
      "terminal.background" = colors.surface-base.hex;
      "terminal.foreground" = colors.text-primary.hex;
      "terminal.ansiBlack" = signalColors.tonal."base-L015".hex;
      "terminal.ansiRed" = accent.danger.Lc75.hex;
      "terminal.ansiGreen" = accent.primary.Lc75.hex;
      "terminal.ansiYellow" = accent.warning.Lc75.hex;
      "terminal.ansiBlue" = accent.secondary.Lc75.hex;
      "terminal.ansiMagenta" = accent.tertiary.Lc75.hex;
      "terminal.ansiCyan" = accent.secondary.Lc75.hex;
      "terminal.ansiWhite" = signalColors.tonal."text-secondary".hex;
      "terminal.ansiBrightBlack" = signalColors.tonal."text-tertiary".hex;
      "terminal.ansiBrightRed" = accent.danger.Lc75.hex;
      "terminal.ansiBrightGreen" = accent.primary.Lc75.hex;
      "terminal.ansiBrightYellow" = accent.warning.Lc75.hex;
      "terminal.ansiBrightBlue" = accent.secondary.Lc75.hex;
      "terminal.ansiBrightMagenta" = accent.tertiary.Lc75.hex;
      "terminal.ansiBrightCyan" = accent.secondary.Lc75.hex;
      "terminal.ansiBrightWhite" = signalColors.tonal."text-primary".hex;

      # Lists
      "list.activeSelectionBackground" = colors.divider-secondary.hex;
      "list.activeSelectionForeground" = colors.text-primary.hex;
      "list.inactiveSelectionBackground" = colors.divider-primary.hex;
      "list.inactiveSelectionForeground" = colors.text-primary.hex;
      "list.hoverBackground" = colors.surface-raised.hex;
      "list.hoverForeground" = colors.text-primary.hex;
      "list.focusBackground" = colors.divider-secondary.hex;
      "list.focusForeground" = colors.text-primary.hex;

      # Buttons
      "button.background" = accent.secondary.Lc75.hex;
      "button.foreground" = colors.surface-base.hex;
      "button.hoverBackground" = "${accent.secondary.Lc75.hex}e0";

      # Input
      "input.background" = colors.surface-raised.hex;
      "input.foreground" = colors.text-primary.hex;
      "input.border" = colors.divider-primary.hex;
      "input.placeholderForeground" = colors.text-dim.hex;

      # Notifications
      "notificationCenter.border" = colors.divider-primary.hex;
      "notifications.background" = colors.surface-raised.hex;
      "notifications.foreground" = colors.text-primary.hex;
      "notifications.border" = colors.divider-primary.hex;
    };

    "editor.tokenColorCustomizations" = {
      textMateRules = [
        {
          scope = [ "comment" ];
          settings = {
            foreground = colors.text-dim.hex;
            fontStyle = "italic";
          };
        }
        {
          scope = [ "string" ];
          settings = {
            foreground = signalColors.categorical."data-viz-02".hex;
          };
        }
        {
          scope = [ "constant.numeric" ];
          settings = {
            foreground = signalColors.categorical."data-viz-06".hex;
          };
        }
        {
          scope = [ "constant.language" ];
          settings = {
            foreground = accent.warning.Lc75.hex;
          };
        }
        {
          scope = [ "keyword" ];
          settings = {
            foreground = accent.tertiary.Lc75.hex;
          };
        }
        {
          scope = [ "storage" ];
          settings = {
            foreground = accent.tertiary.Lc75.hex;
          };
        }
        {
          scope = [ "entity.name.function" ];
          settings = {
            foreground = accent.secondary.Lc75.hex;
          };
        }
        {
          scope = [
            "entity.name.type"
            "entity.name.class"
          ];
          settings = {
            foreground = signalColors.categorical."data-viz-06".hex;
          };
        }
        {
          scope = [ "variable" ];
          settings = {
            foreground = colors.text-primary.hex;
          };
        }
        {
          scope = [
            "support.type"
            "support.class"
          ];
          settings = {
            foreground = signalColors.categorical."data-viz-06".hex;
          };
        }
        {
          scope = [ "support.function" ];
          settings = {
            foreground = accent.secondary.Lc75.hex;
          };
        }
        {
          scope = [ "punctuation" ];
          settings = {
            foreground = colors.text-secondary.hex;
          };
        }
        {
          scope = [ "markup.heading" ];
          settings = {
            foreground = accent.danger.Lc75.hex;
            fontStyle = "bold";
          };
        }
        {
          scope = [ "markup.italic" ];
          settings = {
            fontStyle = "italic";
          };
        }
        {
          scope = [ "markup.bold" ];
          settings = {
            fontStyle = "bold";
          };
        }
        {
          scope = [ "markup.underline" ];
          settings = {
            fontStyle = "underline";
          };
        }
        {
          scope = [ "markup.inline.raw" ];
          settings = {
            foreground = signalColors.categorical."data-viz-02".hex;
          };
        }
        {
          scope = [ "meta.link" ];
          settings = {
            foreground = accent.secondary.Lc75.hex;
          };
        }
      ];
    };
  };
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.vscode.userSettings = vscodeSettings;
  };
}
