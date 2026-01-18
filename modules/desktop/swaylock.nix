{
  config,
  lib,

  signalLib,
  ...
}:
# CONFIGURATION METHOD: structured-settings (Tier 2)
# HOME-MANAGER MODULE: programs.swaylock.settings
# UPSTREAM SCHEMA: https://github.com/swaywm/swaylock/blob/master/swaylock.1.scd
# SCHEMA VERSION: 1.8.4
# LAST VALIDATED: 2026-01-18
# NOTES: Swaylock uses hex colors WITHOUT # prefix (e.g., "808080" not "#808080").
#        Colors are mapped to authentication states: normal, clear, verify, wrong.
#        The indicator ring provides visual feedback during password entry.
let
  inherit (lib) mkIf removePrefix;
  cfg = config.theming.signal;
  themeMode = signalLib.resolveThemeMode cfg.mode;
  signalColors = signalLib.getColors themeMode;

  # =============================================================================
  # Color Definitions
  # =============================================================================
  #
  # Swaylock has multiple states that need distinct colors:
  # - Normal: idle state, waiting for input
  # - Clear: after clearing input (backspace to empty)
  # - Verify: checking password with PAM
  # - Wrong: authentication failed
  # - Caps Lock: caps lock is active
  #
  # We use Signal's semantic colors to create good UX for these states.
  # =============================================================================

  colors = {
    surface-base = signalColors.tonal."surface-base";
    surface-subtle = signalColors.tonal."surface-subtle";
    surface-hover = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-tertiary = signalColors.tonal."text-tertiary";
    divider-primary = signalColors.tonal."divider-primary";
  };

  inherit (signalColors) accent;

  # Helper to strip # from hex colors since swaylock uses bare hex
  stripHash = color: removePrefix "#" color.hex;

  # Check if swaylock should be themed
  shouldTheme = signalLib.shouldThemeApp "swaylock" [
    "desktop"
    "swaylock"
  ] cfg config;
in
{
  # =============================================================================
  # Configuration
  # =============================================================================
  config = mkIf (cfg.enable && shouldTheme) {
    programs.swaylock.settings = {
      # Background color
      color = stripHash colors.surface-base;

      # Indicator appearance
      indicator-radius = 100;
      indicator-thickness = 10;

      # =======================================================================
      # Ring colors (outer circle of indicator)
      # =======================================================================
      # Normal: neutral blue when idle/typing
      ring-color = stripHash accent.secondary.Lc60;

      # Clear: subtle when input is cleared
      ring-clear-color = stripHash colors.divider-primary;

      # Caps Lock: warning yellow when caps lock is on
      ring-caps-lock-color = stripHash accent.warning.Lc75;

      # Verify: primary green when verifying password
      ring-ver-color = stripHash accent.primary.Lc75;

      # Wrong: danger red when password is incorrect
      ring-wrong-color = stripHash accent.danger.Lc75;

      # =======================================================================
      # Inside colors (inner circle of indicator)
      # =======================================================================
      # Normal: slightly raised surface
      inside-color = stripHash colors.surface-subtle;

      # Clear: same as normal (subtle feedback)
      inside-clear-color = stripHash colors.surface-subtle;

      # Caps Lock: subtle warning background
      inside-caps-lock-color = stripHash colors.surface-hover;

      # Verify: slight green tint using surface color
      inside-ver-color = stripHash colors.surface-hover;

      # Wrong: slight red tint using surface color
      inside-wrong-color = stripHash colors.surface-hover;

      # =======================================================================
      # Line colors (separator between inside and ring)
      # =======================================================================
      # Use ring colors for consistency
      line-uses-ring = true;

      # =======================================================================
      # Text colors (password dots and messages)
      # =======================================================================
      # Normal: primary text
      text-color = stripHash colors.text-primary;

      # Clear: secondary text
      text-clear-color = stripHash colors.text-secondary;

      # Caps Lock: warning text
      text-caps-lock-color = stripHash accent.warning.Lc75;

      # Verify: primary green text
      text-ver-color = stripHash accent.primary.Lc75;

      # Wrong: danger red text
      text-wrong-color = stripHash accent.danger.Lc75;

      # =======================================================================
      # Key highlight colors (visual feedback when typing)
      # =======================================================================
      # Normal key press: accent secondary
      key-hl-color = stripHash accent.secondary.Lc75;

      # Backspace highlight: subtle
      bs-hl-color = stripHash colors.divider-primary;

      # Caps lock key press: warning
      caps-lock-key-hl-color = stripHash accent.warning.Lc75;

      # Caps lock backspace: warning
      caps-lock-bs-hl-color = stripHash accent.warning.Lc60;

      # =======================================================================
      # Layout indicator colors (keyboard layout display)
      # =======================================================================
      layout-bg-color = stripHash colors.surface-hover;
      layout-border-color = stripHash colors.divider-primary;
      layout-text-color = stripHash colors.text-primary;

      # Separator between highlight segments
      separator-color = stripHash colors.divider-primary;

      # Show failed attempts for security feedback
      show-failed-attempts = true;

      # Show keyboard layout if configured
      show-keyboard-layout = true;
    };
  };
}
