{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: environment-variables (Tier 5)
# HOME-MANAGER MODULE: home.sessionVariables
# UPSTREAM SCHEMA: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#colors
# SCHEMA VERSION: 14.1.0
# LAST VALIDATED: 2026-01-17
# NOTES: Ripgrep uses RIPGREP_CONFIG_PATH or command-line flags for colors.
#        We use environment variables for color configuration via RIPGREP_COLORS.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-dim = signalColors.tonal."text-Lc45";
  };

  inherit (signalColors) accent;

  # Convert hex to RGB triplet for ripgrep (format: R,G,B)
  toRgbTriplet =
    color:
    let
      hex = lib.removePrefix "#" color.hex;
      r = lib.toInt "0x${builtins.substring 0 2 hex}";
      g = lib.toInt "0x${builtins.substring 2 2 hex}";
      b = lib.toInt "0x${builtins.substring 4 2 hex}";
    in
    "${toString r},${toString g},${toString b}";

  # Check if ripgrep should be themed
  shouldTheme = cfg.cli.ripgrep.enable or false || cfg.autoEnable;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    home.sessionVariables = {
      # Ripgrep color configuration
      # Format: type:style:foreground:background:intense
      # We use fg: for foreground RGB colors
      RIPGREP_COLORS = lib.concatStringsSep ":" [
        "match:fg:${toRgbTriplet accent.focus.Lc75}" # Matched text
        "match:style:bold" # Make matches bold
        "path:fg:${toRgbTriplet accent.info.Lc75}" # File paths
        "line:fg:${toRgbTriplet accent.success.Lc75}" # Line numbers
        "column:fg:${toRgbTriplet colors.text-secondary}" # Column numbers
      ];
    };

    # Also set ripgrep to use colors by default
    home.shellAliases = mkIf shouldTheme {
      rg = "rg --color=auto";
    };
  };
}
