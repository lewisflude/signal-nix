{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: css-stylesheet (Tier 1)
# HOME-MANAGER MODULE: programs.wofi.style
# UPSTREAM SCHEMA: https://hg.sr.ht/~scoopta/wofi
# SCHEMA VERSION: 1.3
# LAST VALIDATED: 2026-01-17
# NOTES: wofi uses CSS for styling. Home-Manager provides style attribute
#        that accepts CSS string. Very similar to rofi but CSS instead of rasi.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-raised = signalColors.tonal."surface-Lc10";
    surface-hover = signalColors.tonal."surface-Lc15";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-dim = signalColors.tonal."text-Lc45";
    divider = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # Generate wofi CSS theme
  wofiCSS = ''
    /* Signal theme for wofi */
    
    window {
      background-color: ${colors.surface-base.hex};
      border: 2px solid ${colors.divider.hex};
      border-radius: 8px;
      font-family: "Inter", sans-serif;
      font-size: 14px;
    }

    #input {
      background-color: ${colors.surface-raised.hex};
      color: ${colors.text-primary.hex};
      border: 1px solid ${colors.divider.hex};
      border-radius: 4px;
      padding: 8px 12px;
      margin: 8px;
    }

    #input:focus {
      border-color: ${accent.focus.Lc75.hex};
      outline: none;
    }

    #inner-box {
      background-color: ${colors.surface-base.hex};
      padding: 4px;
    }

    #outer-box {
      background-color: ${colors.surface-base.hex};
      padding: 4px;
    }

    #scroll {
      background-color: ${colors.surface-base.hex};
    }

    #text {
      color: ${colors.text-primary.hex};
      padding: 8px 12px;
    }

    #text:selected {
      color: ${colors.text-primary.hex};
    }

    #entry {
      background-color: transparent;
      padding: 4px;
      border-radius: 4px;
    }

    #entry:selected {
      background-color: ${colors.surface-hover.hex};
      outline: none;
    }

    #entry:hover {
      background-color: ${colors.surface-raised.hex};
    }

    /* Image (icon) styling */
    #img {
      margin-right: 8px;
    }

    /* No results message */
    #no-matches {
      color: ${colors.text-dim.hex};
      padding: 16px;
    }
  '';

  # Check if wofi should be themed
  shouldTheme = signalLib.shouldThemeApp "wofi" [
    "desktop"
    "launchers"
    "wofi"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.wofi.style = wofiCSS;
  };
}
