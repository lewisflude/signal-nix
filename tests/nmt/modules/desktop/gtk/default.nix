# Signal Design System - GTK Theming NMT Tests
{
  lib,
  pkgs,
  self,
}:
{
  nmt-gtk-basic-dark = {
    name = "gtk-basic-dark";
    modules = [
      {
        gtk.enable = true;
        signal = {
          enable = true;
          mode = "dark";
          gtk.enable = true;
        };
        nmt.script = ''
          assertFileExists home-files/.config/gtk-3.0/gtk.css
          assertFileRegex home-files/.config/gtk-3.0/gtk.css '@define-color theme_bg_color'
        '';
      }
    ];
  };

  nmt-gtk-basic-light = {
    name = "gtk-basic-light";
    modules = [
      {
        gtk.enable = true;
        signal = {
          enable = true;
          mode = "light";
          gtk.enable = true;
        };
        nmt.script = ''
          assertFileExists home-files/.config/gtk-3.0/gtk.css
        '';
      }
    ];
  };

  nmt-gtk-adwaita-palette = {
    name = "gtk-adwaita-palette";
    modules = [
      {
        gtk.enable = true;
        signal = {
          enable = true;
          mode = "dark";
          gtk.enable = true;
        };
        nmt.script = ''
          CONFIG="home-files/.config/gtk-3.0/gtk.css"
          
          # Verify Adwaita palette colors are defined
          for color in blue_1 green_2 yellow_3 orange_4 red_5 purple_1 brown_2 light_3 dark_4; do
            grep -q "@define-color $color" "$CONFIG" || {
              echo "ERROR: Missing Adwaita palette color: $color"
              exit 1
            }
          done
          
          echo "✓ All Adwaita palette colors present"
        '';
      }
    ];
  };
}
