{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: theme-file (Tier 1)
# HOME-MANAGER MODULE: programs.rofi.theme
# UPSTREAM SCHEMA: https://github.com/davatorium/rofi/blob/next/doc/rofi-theme.5.markdown
# SCHEMA VERSION: 1.7.5
# LAST VALIDATED: 2026-01-17
# NOTES: Rofi uses its own CSS-like theme format with @theme directive.
#        Home Manager accepts an attrset that gets serialized to .rasi format.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-raised = signalColors.tonal."surface-hover";
    surface-hover = signalColors.tonal."surface-Lc15";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    divider-primary = signalColors.tonal."divider-primary";
  };

  inherit (signalColors) accent;

  # Check if rofi should be themed
  shouldTheme = signalLib.shouldThemeApp "rofi" [
    "desktop"
    "launchers"
    "rofi"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.rofi.theme = {
      "*" = {
        background = lib.mkDefault colors.surface-base.hex;
        background-alt = lib.mkDefault colors.surface-raised.hex;
        foreground = lib.mkDefault colors.text-primary.hex;
        foreground-alt = lib.mkDefault colors.text-secondary.hex;
        selected = lib.mkDefault accent.secondary.Lc75.hex;
        active = lib.mkDefault accent.primary.Lc75.hex;
        urgent = lib.mkDefault accent.danger.Lc75.hex;
        border-color = lib.mkDefault colors.divider-primary.hex;
      };

      window = {
        background-color = lib.mkDefault "@background";
        border = lib.mkDefault "2px";
        border-color = lib.mkDefault "@border-color";
      };

      mainbox = {
        background-color = lib.mkDefault "@background";
        children = lib.mkDefault [
          "inputbar"
          "message"
          "listview"
        ];
      };

      inputbar = {
        background-color = lib.mkDefault "@background-alt";
        text-color = lib.mkDefault "@foreground";
        border = lib.mkDefault "0 0 2px 0";
        border-color = lib.mkDefault "@selected";
        children = lib.mkDefault [
          "prompt"
          "entry"
        ];
      };

      prompt = {
        background-color = lib.mkDefault "inherit";
        text-color = lib.mkDefault "@selected";
      };

      entry = {
        background-color = lib.mkDefault "inherit";
        text-color = lib.mkDefault "@foreground";
        placeholder = lib.mkDefault "Search...";
        placeholder-color = lib.mkDefault "@foreground-alt";
      };

      message = {
        background-color = lib.mkDefault "@background-alt";
        border = lib.mkDefault "2px 0 0 0";
        border-color = lib.mkDefault "@border-color";
      };

      textbox = {
        background-color = lib.mkDefault "inherit";
        text-color = lib.mkDefault "@foreground";
      };

      listview = {
        background-color = lib.mkDefault "@background";
        border = lib.mkDefault "2px 0 0 0";
        border-color = lib.mkDefault "@border-color";
        lines = lib.mkDefault 8;
        scrollbar = lib.mkDefault true;
      };

      element = {
        background-color = lib.mkDefault "@background";
        text-color = lib.mkDefault "@foreground";
      };

      "element selected normal" = {
        background-color = lib.mkDefault "@selected";
        text-color = lib.mkDefault "@background";
      };

      "element selected active" = {
        background-color = lib.mkDefault "@active";
        text-color = lib.mkDefault "@background";
      };

      "element selected urgent" = {
        background-color = lib.mkDefault "@urgent";
        text-color = lib.mkDefault "@background";
      };

      "element normal active" = {
        text-color = lib.mkDefault "@active";
      };

      "element normal urgent" = {
        text-color = lib.mkDefault "@urgent";
      };

      "element alternate normal" = {
        background-color = lib.mkDefault "@background";
      };

      "element alternate active" = {
        background-color = lib.mkDefault "@background";
        text-color = lib.mkDefault "@active";
      };

      "element alternate urgent" = {
        background-color = lib.mkDefault "@background";
        text-color = lib.mkDefault "@urgent";
      };

      scrollbar = {
        background-color = lib.mkDefault "@background-alt";
        handle-color = lib.mkDefault "@selected";
        border = lib.mkDefault "0 0 0 2px";
        border-color = lib.mkDefault "@border-color";
      };
    };
  };
}
