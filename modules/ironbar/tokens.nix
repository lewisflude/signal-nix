# Ironbar Color Tokens - Signal Theme
# Only contains color definitions for use in CSS
# Configure ironbar layout, widgets, and behavior in your own config
{ signalColors }:
{
  # Semantic Colors from Signal Theme
  colors = {
    text = {
      primary = signalColors.tonal."text-primary".hex;
      secondary = signalColors.tonal."text-secondary".hex;
      tertiary = signalColors.tonal."text-tertiary".hex;
    };
    surface = {
      base = signalColors.tonal."surface-subtle".hex;
      emphasis = signalColors.tonal."surface-hover".hex;
    };
    accent = {
      focus = signalColors.accent.secondary.Lc75.hex;
      success = signalColors.accent.primary.Lc75.hex;
      warning = signalColors.accent.warning.Lc75.hex;
      danger = signalColors.accent.danger.Lc75.hex;
    };
  };
}
