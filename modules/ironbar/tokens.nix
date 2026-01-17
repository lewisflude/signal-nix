# Ironbar Color Tokens - Signal Theme
# Only contains color definitions for use in CSS
# Configure ironbar layout, widgets, and behavior in your own config
{ signalColors }:
{
  # Semantic Colors from Signal Theme
  colors = {
    text = {
      primary = signalColors.tonal."text-Lc75".hex;
      secondary = signalColors.tonal."text-Lc60".hex;
      tertiary = signalColors.tonal."text-Lc45".hex;
    };
    surface = {
      base = signalColors.tonal."surface-Lc05".hex;
      emphasis = signalColors.tonal."surface-Lc10".hex;
    };
    accent = {
      focus = signalColors.accent.focus.Lc75.hex;
      success = signalColors.accent.success.Lc75.hex;
      warning = signalColors.accent.warning.Lc75.hex;
      danger = signalColors.accent.danger.Lc75.hex;
    };
  };
}
