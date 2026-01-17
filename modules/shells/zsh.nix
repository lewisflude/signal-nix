{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: programs.zsh.initExtra
# UPSTREAM SCHEMA: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
# SCHEMA VERSION: 0.8.0 (zsh-syntax-highlighting)
# LAST VALIDATED: 2026-01-17
# NOTES: Zsh syntax highlighting colors must be set via shell variables in initExtra.
#        No structured Home-Manager options exist for zsh-syntax-highlighting plugin.
#        Colors use ZSH_HIGHLIGHT_STYLES array with specific key names.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-tertiary = signalColors.tonal."text-Lc45";
  };

  inherit (signalColors) accent categorical;

  # Check if zsh should be themed
  # Check if zsh should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "zsh" [
    "shells"
    "zsh"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.zsh = {
      # Syntax highlighting colors for zsh-syntax-highlighting plugin
      initExtra = ''
        # Signal Theme for zsh-syntax-highlighting
        # These colors are used by the zsh-syntax-highlighting plugin

        # Default command
        ZSH_HIGHLIGHT_STYLES[default]='fg=${colors.text-primary.hex}'

        # Unknown tokens / errors
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=${accent.danger.Lc75.hex}'

        # Reserved words (if, then, else, fi, etc.)
        ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=${accent.special.Lc75.hex},bold'

        # Aliases
        ZSH_HIGHLIGHT_STYLES[alias]='fg=${accent.focus.Lc75.hex}'

        # Shell builtin commands
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=${accent.focus.Lc75.hex}'

        # Functions
        ZSH_HIGHLIGHT_STYLES[function]='fg=${accent.focus.Lc75.hex}'

        # External commands
        ZSH_HIGHLIGHT_STYLES[command]='fg=${accent.focus.Lc75.hex}'

        # Command separators (;, &&, ||)
        ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=${accent.info.Lc75.hex}'

        # Redirection operators
        ZSH_HIGHLIGHT_STYLES[redirection]='fg=${accent.info.Lc75.hex}'

        # Arguments
        ZSH_HIGHLIGHT_STYLES[arg0]='fg=${accent.focus.Lc75.hex}'

        # Single quoted strings
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=${categorical.GA02.hex}'

        # Double quoted strings
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=${categorical.GA02.hex}'

        # Backticks
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=${categorical.GA08.hex}'

        # Globbing
        ZSH_HIGHLIGHT_STYLES[globbing]='fg=${accent.warning.Lc75.hex}'

        # History expansion (!!, !$, etc.)
        ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=${accent.special.Lc75.hex}'

        # Command substitution
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=${accent.info.Lc75.hex}'

        # Process substitution
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=${accent.info.Lc75.hex}'

        # Arithmetic expansion
        ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=${categorical.GA06.hex}'

        # Comments
        ZSH_HIGHLIGHT_STYLES[comment]='fg=${colors.text-tertiary.hex},italic'

        # Paths
        ZSH_HIGHLIGHT_STYLES[path]='fg=${colors.text-primary.hex}'
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=${colors.text-secondary.hex}'

        # Options (like -la in ls -la)
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=${accent.warning.Lc75.hex}'
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=${accent.warning.Lc75.hex}'

        # Assign
        ZSH_HIGHLIGHT_STYLES[assign]='fg=${accent.info.Lc75.hex}'

        # Additional autocomplete/menu colors
        # These work with zsh's completion system
        zstyle ':completion:*' list-colors \
          "di=${accent.focus.Lc75.hex}:ln=${accent.info.Lc75.hex}:so=${accent.special.Lc75.hex}:pi=${accent.warning.Lc75.hex}:ex=${accent.success.Lc75.hex}:bd=${accent.danger.Lc75.hex}:cd=${accent.danger.Lc75.hex}"
      '';
    };
  };
}
