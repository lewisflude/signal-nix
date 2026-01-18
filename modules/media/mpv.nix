{
  config,
  lib,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: structured-settings (Tier 2)
# HOME-MANAGER MODULE: programs.mpv.config
# UPSTREAM SCHEMA: https://mpv.io/manual/stable/
# LAST VALIDATED: 2026-01-18
# NOTES: MPV uses hex colors with alpha: #RRGGBB or #AARRGGBB format.
#        OSD = On-Screen Display (play/pause, volume, timeline, etc.)
#        Subtitle colors include text, outline, and background.
#        Alpha channel: 00 = transparent, FF = opaque.
let
  inherit (lib) mkIf removePrefix;
  cfg = config.theming.signal;

  # =============================================================================
  # Color Definitions
  # =============================================================================
  #
  # MPV has distinct color domains:
  # - OSD: On-screen display elements (volume, time, status messages)
  # - Subtitles: Text rendering with outline and background
  # - Selected items: Highlighted playlist/menu items
  #
  # We use Signal's semantic colors to create a cohesive media viewing experience.
  # =============================================================================

  colors = {
    surface-base = signalColors.tonal."surface-base";
    surface-subtle = signalColors.tonal."surface-subtle";
    surface-hover = signalColors.tonal."surface-hover";
    text-primary = signalColors.tonal."text-primary";
    text-secondary = signalColors.tonal."text-secondary";
    text-tertiary = signalColors.tonal."text-tertiary";
    divider-primary = signalColors.tonal."divider-primary";
    black = signalColors.tonal."black";
  };

  inherit (signalColors) accent;

  # =============================================================================
  # Helper Functions
  # =============================================================================

  # Strip # prefix from hex colors
  stripHash = color: removePrefix "#" color.hex;

  # Add alpha channel to hex color
  # MPV format: #AARRGGBB (alpha first) or #RRGGBB (opaque)
  # Alpha values: 00 = transparent, FF = opaque, 80 = 50%, C0 = 75%
  hexWithAlpha =
    color: alpha:
    let
      hexColor = stripHash color;
    in
    "#${alpha}${hexColor}";

  # Check if mpv should be themed
  shouldTheme = signalLib.shouldThemeApp "mpv" [
    "media"
    "mpv"
  ] cfg config;
in
{
  # =============================================================================
  # Configuration
  # =============================================================================
  config = mkIf (cfg.enable && shouldTheme) {
    programs.mpv.config = {
      # =======================================================================
      # OSD Colors (On-Screen Display)
      # =======================================================================
      # The OSD shows play/pause status, volume, timeline, and other information.
      # We use semi-transparent backgrounds for subtle, non-intrusive display.

      # OSD text color - primary text for good readability
      osd-color = colors.text-primary.hex;

      # OSD background - semi-transparent surface (75% opacity)
      # Used behind OSD text for better contrast against video
      osd-back-color = hexWithAlpha colors.surface-base "C0";

      # OSD outline/border color - subtle divider (75% opacity)
      # Creates separation between OSD elements and video
      osd-border-color = hexWithAlpha colors.divider-primary "C0";

      # Selected item colors (for playlists and menus)
      # Selected text - accent color for highlighting
      osd-selected-color = accent.secondary.Lc75.hex;

      # Selected outline - slightly transparent accent
      osd-selected-outline-color = hexWithAlpha accent.secondary.Lc75 "E0";

      # =======================================================================
      # Subtitle Colors
      # =======================================================================
      # Subtitles need excellent readability in all lighting conditions.
      # We use strong contrast with outlines for visibility against any background.

      # Subtitle text color - primary text for maximum readability
      sub-color = colors.text-primary.hex;

      # Subtitle outline/border - semi-transparent black (90% opacity)
      # Creates strong contrast against light backgrounds in video
      sub-border-color = hexWithAlpha colors.black "E0";

      # Subtitle background - semi-transparent dark surface (80% opacity)
      # Used for background-box style or shadowing
      sub-back-color = hexWithAlpha colors.surface-base "CC";

      # =======================================================================
      # Additional Settings
      # =======================================================================
      # These improve the overall viewing experience with Signal theming

      # Use a reasonable OSD bar height
      osd-bar-h = 2;

      # Show OSD with a slight border for better definition
      osd-border-size = 1;

      # Subtitle outline for better readability
      sub-border-size = 2;

      # Subtitle font scale (can be adjusted by user preferences)
      sub-scale = 1.0;
    };
  };
}
