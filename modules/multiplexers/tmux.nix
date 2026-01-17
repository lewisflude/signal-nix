{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: programs.tmux.extraConfig
# UPSTREAM SCHEMA: https://man.openbsd.org/tmux.1#STYLES
# SCHEMA VERSION: 3.3a
# LAST VALIDATED: 2026-01-17
# NOTES: Tmux requires raw config commands in tmux.conf format. Home-Manager
#        provides extraConfig for custom config. No structured theme options exist.
#        Must use set-option commands with exact tmux syntax.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-subtle";
    surface-emphasis = signalColors.tonal."surface-hover";
    surface-subtle = signalColors.tonal."divider-primary";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-tertiary = signalColors.tonal."text-tertiary";
  };

  inherit (signalColors) accent;

  # Check if tmux should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "tmux" [
    "multiplexers"
    "tmux"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    programs.tmux = {
      extraConfig = ''
        # Signal Theme for tmux

        # Status bar styling
        set-option -g status-style "bg=${colors.surface-base.hex},fg=${colors.text-primary.hex}"

        # Status left (session name)
        set-option -g status-left-length 40
        set-option -g status-left "#[bg=${accent.secondary.Lc75.hex},fg=${colors.surface-base.hex},bold] #S #[bg=${colors.surface-base.hex}] "

        # Status right (date/time)
        set-option -g status-right-length 80
        set-option -g status-right "#[fg=${colors.text-secondary.hex}]%Y-%m-%d #[fg=${colors.text-primary.hex}]%H:%M #[bg=${accent.secondary.Lc75.hex},fg=${colors.surface-base.hex},bold] #h "

        # Window status
        set-option -g window-status-format " #I:#W#{?window_flags,#{window_flags}, } "
        set-option -g window-status-style "bg=${colors.surface-base.hex},fg=${colors.text-secondary.hex}"

        # Current window status
        set-option -g window-status-current-format " #I:#W#{?window_flags,#{window_flags}, } "
        set-option -g window-status-current-style "bg=${colors.surface-subtle.hex},fg=${colors.text-primary.hex},bold"

        # Window activity status
        set-option -g window-status-activity-style "bg=${colors.surface-base.hex},fg=${accent.warning.Lc75.hex}"

        # Window bell status
        set-option -g window-status-bell-style "bg=${accent.danger.Lc75.hex},fg=${colors.surface-base.hex},bold"

        # Pane borders
        set-option -g pane-border-style "fg=${colors.surface-subtle.hex}"
        set-option -g pane-active-border-style "fg=${accent.secondary.Lc75.hex}"

        # Message styling
        set-option -g message-style "bg=${accent.secondary.Lc75.hex},fg=${colors.surface-base.hex},bold"
        set-option -g message-command-style "bg=${accent.secondary.Lc75.hex},fg=${colors.surface-base.hex}"

        # Mode styling (copy mode, etc.)
        set-option -g mode-style "bg=${accent.secondary.Lc75.hex},fg=${colors.surface-base.hex},bold"

        # Clock mode colors
        set-option -g clock-mode-colour "${accent.secondary.Lc75.hex}"
        set-option -g clock-mode-style 24
      '';
    };
  };
}
