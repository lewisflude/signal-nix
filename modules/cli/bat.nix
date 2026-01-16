{
  config,
  lib,
  pkgs,
  signalColors,
  signalLib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  # Generate tmTheme XML for bat using Signal colors
  # This creates a Sublime Text theme file that bat can use
  generateTmTheme =
    mode:
    let
      colors =
        if mode == "dark" then
          {
            background = signalColors.tonal."surface-Lc05".hex;
            foreground = signalColors.tonal."text-Lc75".hex;
            caret = signalColors.accent.focus.Lc75.hex;
            lineHighlight = signalColors.tonal."surface-Lc10".hex;
            selection = signalColors.tonal."divider-Lc15".hex;
            comment = signalColors.tonal."text-Lc45".hex;
            string = signalColors.categorical.GA02.hex;
            number = signalColors.categorical.GA06.hex;
            keyword = signalColors.accent.special.Lc75.hex;
            operator = signalColors.accent.info.Lc75.hex;
            function = signalColors.accent.focus.Lc75.hex;
            type = signalColors.categorical.GA06.hex;
            variable = signalColors.tonal."text-Lc75".hex;
            constant = signalColors.categorical.GA06.hex;
            escape = signalColors.categorical.GA08.hex;
            heading = signalColors.accent.danger.Lc75.hex;
            link = signalColors.accent.focus.Lc75.hex;
            diffInserted = signalColors.categorical.GA02.hex;
            diffDeleted = signalColors.accent.danger.Lc75.hex;
            diffChanged = signalColors.accent.focus.Lc75.hex;
            punctuation = signalColors.tonal."text-Lc45".hex;
          }
        else
          {
            # Light mode colors (inverted lightness)
            background = "#f5f5f7";
            foreground = "#25262f";
            caret = "#3557a0";
            lineHighlight = "#ececee";
            selection = "#d8d8dc";
            comment = "#8e909f";
            string = "#2d7a5e";
            number = "#6b5896";
            keyword = "#7a5d8b";
            operator = "#3570a8";
            function = "#3557a0";
            type = "#6b5896";
            variable = "#25262f";
            constant = "#6b5896";
            escape = "#8a6d3b";
            heading = "#b83226";
            link = "#3557a0";
            diffInserted = "#2d7a5e";
            diffDeleted = "#b83226";
            diffChanged = "#3557a0";
            punctuation = "#8e909f";
          };
    in
    pkgs.writeText "signal-${mode}.tmTheme" ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>name</key>
        <string>Signal ${
          lib.toUpper (builtins.substring 0 1 mode)
        }${builtins.substring 1 (-1) mode}</string>
        <key>settings</key>
        <array>
          <dict>
            <key>settings</key>
            <dict>
              <key>background</key>
              <string>${colors.background}</string>
              <key>foreground</key>
              <string>${colors.foreground}</string>
              <key>caret</key>
              <string>${colors.caret}</string>
              <key>lineHighlight</key>
              <string>${colors.lineHighlight}</string>
              <key>selection</key>
              <string>${colors.selection}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Comment</string>
            <key>scope</key>
            <string>comment</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.comment}</string>
              <key>fontStyle</key>
              <string>italic</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>String</string>
            <key>scope</key>
            <string>string</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.string}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Number</string>
            <key>scope</key>
            <string>constant.numeric</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.number}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Keyword</string>
            <key>scope</key>
            <string>keyword, storage</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.keyword}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Operator</string>
            <key>scope</key>
            <string>keyword.operator</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.operator}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Function</string>
            <key>scope</key>
            <string>entity.name.function, meta.function-call</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.function}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Type</string>
            <key>scope</key>
            <string>entity.name.type, entity.name.class, support.type, support.class</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.type}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Variable</string>
            <key>scope</key>
            <string>variable</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.variable}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Constant</string>
            <key>scope</key>
            <string>constant</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.constant}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Tag</string>
            <key>scope</key>
            <string>entity.name.tag</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.function}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Attribute</string>
            <key>scope</key>
            <string>entity.other.attribute-name</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.type}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Punctuation</string>
            <key>scope</key>
            <string>punctuation</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.punctuation}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Escape</string>
            <key>scope</key>
            <string>constant.character.escape, string.regexp</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.escape}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markup Heading</string>
            <key>scope</key>
            <string>markup.heading</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.heading}</string>
              <key>fontStyle</key>
              <string>bold</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markup Bold</string>
            <key>scope</key>
            <string>markup.bold</string>
            <key>settings</key>
            <dict>
              <key>fontStyle</key>
              <string>bold</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markup Italic</string>
            <key>scope</key>
            <string>markup.italic</string>
            <key>settings</key>
            <dict>
              <key>fontStyle</key>
              <string>italic</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markup Link</string>
            <key>scope</key>
            <string>markup.underline.link</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.link}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Diff Inserted</string>
            <key>scope</key>
            <string>markup.inserted, diff.inserted</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.diffInserted}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Diff Deleted</string>
            <key>scope</key>
            <string>markup.deleted, diff.deleted</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.diffDeleted}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Diff Changed</string>
            <key>scope</key>
            <string>markup.changed, diff.changed</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${colors.diffChanged}</string>
            </dict>
          </dict>
        </array>
      </dict>
      </plist>
    '';

  # Generate both dark and light themes
  darkThemeFile = generateTmTheme "dark";
  lightThemeFile = generateTmTheme "light";

  # Package both theme files in a directory structure bat expects
  themePackage = pkgs.runCommand "bat-signal-themes" { } ''
    mkdir -p $out
    cp ${darkThemeFile} "$out/signal-dark.tmTheme"
    cp ${lightThemeFile} "$out/signal-light.tmTheme"
  '';

  # Resolved mode for static theme selection
  themeMode = signalLib.resolveThemeMode cfg.mode;

  # Check if bat should be themed
  shouldTheme = cfg.cli.bat.enable || (cfg.autoEnable && (config.programs.bat.enable or false));
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.bat = {
      themes = {
        signal-dark = {
          src = themePackage;
          file = "signal-dark.tmTheme";
        };
        signal-light = {
          src = themePackage;
          file = "signal-light.tmTheme";
        };
      };

      config = {
        # Use bat's auto-detection if mode is "auto", otherwise use resolved mode
        theme = if cfg.mode == "auto" then "auto" else "signal-${themeMode}";
        theme-dark = "signal-dark";
        theme-light = "signal-light";
        italic-text = "always";
        style = "numbers,changes,header";
        pager = "less -FR";
      };
    };
  };
}
