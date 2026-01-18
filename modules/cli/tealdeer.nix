{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: structured-settings (Tier 2)
# HOME-MANAGER MODULE: programs.tealdeer.settings.style
# UPSTREAM SCHEMA: https://dbrgn.github.io/tealdeer/config.html
# SCHEMA VERSION: 1.7.1
# LAST VALIDATED: 2026-01-18
# NOTES: Tealdeer uses TOML config with style section for coloring tldr pages.
#        Supports foreground/background colors with bold/underline modifiers.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
  };

  inherit (signalColors) accent;

  # Check if tealdeer should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "tealdeer" [
    "cli"
    "tealdeer"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.tealdeer = {
      settings = {
        style = {
          # Command name - prominent, bold header
          command_name = {
            foreground = accent.secondary.Lc75.hex;
            bold = true;
          };

          # Description text - main content, clear and readable
          description = {
            foreground = colors.text-primary.hex;
          };

          # Example text - the command examples
          example_text = {
            foreground = colors.text-secondary.hex;
          };

          # Example variables - placeholders in examples like <file>
          example_variable = {
            foreground = accent.primary.Lc75.hex;
            bold = true;
          };

          # Example code - the actual command being shown
          example_code = {
            foreground = accent.tertiary.Lc75.hex;
          };
        };
      };
    };
  };
}
