{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  colors = {
    surface-base = signalColors.tonal."surface-Lc05";
    surface-emphasis = signalColors.tonal."surface-Lc10";
    surface-subtle = signalColors.tonal."divider-Lc15";
    text-primary = signalColors.tonal."text-Lc75";
    text-secondary = signalColors.tonal."text-Lc60";
    text-tertiary = signalColors.tonal."text-Lc45";
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
        set-option -g status-left "#[bg=${accent.focus.Lc75.hex},fg=${colors.surface-base.hex},bold] #S #[bg=${colors.surface-base.hex}] "

        # Status right (date/time)
        set-option -g status-right-length 80
        set-option -g status-right "#[fg=${colors.text-secondary.hex}]%Y-%m-%d #[fg=${colors.text-primary.hex}]%H:%M #[bg=${accent.focus.Lc75.hex},fg=${colors.surface-base.hex},bold] #h "

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
        set-option -g pane-active-border-style "fg=${accent.focus.Lc75.hex}"

        # Message styling
        set-option -g message-style "bg=${accent.focus.Lc75.hex},fg=${colors.surface-base.hex},bold"
        set-option -g message-command-style "bg=${accent.info.Lc75.hex},fg=${colors.surface-base.hex}"

        # Mode styling (copy mode, etc.)
        set-option -g mode-style "bg=${accent.focus.Lc75.hex},fg=${colors.surface-base.hex},bold"

        # Clock mode colors
        set-option -g clock-mode-colour "${accent.focus.Lc75.hex}"
        set-option -g clock-mode-style 24
      '';
    };
  };
}
