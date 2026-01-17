{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: json-config (Tier 2)
# HOME-MANAGER MODULE: xdg.configFile
# UPSTREAM SCHEMA: https://github.com/charmbracelet/glow
# SCHEMA VERSION: 1.5.1
# LAST VALIDATED: 2026-01-17
# NOTES: glow uses JSON config for custom styles. We create a glamour theme.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-raised = signalColors.tonal."surface-Lc10";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-dim = signalColors.tonal."text-Lc45";
    divider = signalColors.tonal."divider-Lc15";
  };

  inherit (signalColors) accent;

  # Glow uses glamour JSON theme format
  glowTheme = builtins.toJSON {
    document = {
      background_color = colors.surface-base.hex;
      color = colors.text-primary.hex;
    };

    heading = {
      color = accent.focus.Lc75.hex;
      bold = true;
    };

    h1 = {
      prefix = "# ";
      color = accent.focus.Lc75.hex;
      bold = true;
    };

    h2 = {
      prefix = "## ";
      color = accent.focus.Lc75.hex;
    };

    h3 = {
      prefix = "### ";
      color = accent.info.Lc75.hex;
    };

    h4 = {
      prefix = "#### ";
      color = accent.info.Lc75.hex;
    };

    h5 = {
      prefix = "##### ";
      color = colors.text-secondary.hex;
    };

    h6 = {
      prefix = "###### ";
      color = colors.text-secondary.hex;
    };

    text = {
      color = colors.text-primary.hex;
    };

    paragraph = {
      color = colors.text-primary.hex;
    };

    code = {
      color = accent.special.Lc75.hex;
      background_color = colors.surface-raised.hex;
    };

    code_block = {
      color = accent.special.Lc75.hex;
      background_color = colors.surface-raised.hex;
    };

    emph = {
      color = colors.text-primary.hex;
      italic = true;
    };

    strong = {
      color = colors.text-primary.hex;
      bold = true;
    };

    strikethrough = {
      color = colors.text-dim.hex;
      crossed_out = true;
    };

    link = {
      color = accent.info.Lc75.hex;
      underline = true;
    };

    link_text = {
      color = accent.focus.Lc75.hex;
    };

    image = {
      color = accent.special.Lc75.hex;
    };

    list = {
      color = colors.text-primary.hex;
    };

    enumeration = {
      color = colors.text-primary.hex;
    };

    item = {
      color = colors.text-primary.hex;
    };

    task = {
      ticked = "[✓] ";
      unticked = "[ ] ";
    };

    table = {
      color = colors.text-primary.hex;
    };

    table_header = {
      color = accent.focus.Lc75.hex;
      bold = true;
    };

    table_row = {
      color = colors.text-primary.hex;
    };

    quote = {
      color = colors.text-secondary.hex;
      italic = true;
    };

    quote_block = {
      color = colors.text-secondary.hex;
      indent = 2;
    };

    hr = {
      color = colors.divider.hex;
    };
  };

  # Check if glow should be themed
  shouldTheme = cfg.cli.glow.enable or false || cfg.autoEnable;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    xdg.configFile."glow/signal.json".text = glowTheme;

    # Set glow to use Signal theme by default
    home.sessionVariables = mkIf shouldTheme {
      GLOW_STYLE = "$HOME/.config/glow/signal.json";
    };
  };
}
