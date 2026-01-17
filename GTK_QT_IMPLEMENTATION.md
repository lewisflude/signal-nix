# GTK and Qt/KDE Color Configuration Implementation

## Summary

Successfully implemented comprehensive GTK and Qt/KDE color theming for signal-nix, with both modules now properly applying Signal Design System colors.

## Changes Made

### 1. Added RGB Comma-Separated Conversion Helper
**File:** `lib/default.nix`

Added `hexToRgbCommaSeparated` function to convert hex colors to KDE's RGB format:
- Input: `#6b87c8` (hex color)
- Output: `"107,135,200"` (comma-separated RGB)
- Used by Qt/KDE color configuration

### 2. Created Qt/KDE Module
**File:** `modules/qt/default.nix` (NEW)

Comprehensive Qt theming module that configures:
- **Qt Style:** Uses Adwaita-qt (dark/light) to match GTK
- **Platform Theme:** Adwaita integration
- **KDE Color Scheme:** Full kdeglobals configuration with:
  - Colors:Window (main application areas)
  - Colors:View (content areas like editors, lists)
  - Colors:Button (button colors)
  - Colors:Selection (selected items)
  - Colors:Tooltip (tooltips)
  - Colors:Complementary (sidebars, headers)
  - Colors:Header (title bars)
  - Window Manager colors
  - Color effects for disabled/inactive states

All colors derived from Signal Design System using the signal color palette.

### 3. Updated Common Module
**File:** `modules/common/default.nix`

- Added `qt` module to imports list
- Added `theming.signal.qt.enable` option
- Updated assertion to include Qt in the check

### 4. Updated User Configuration
**File:** `/home/lewis/.config/nix/home/common/theme.nix`

- Removed manual Qt configuration (now handled by signal-nix)
- Simplified to just `qt.enable = true`
- Signal-nix automatically applies colors via `autoEnable`

### 5. Added Integration Test
**Files:** `tests/comprehensive-test-suite.nix`, `tests/default.nix`

Created `integration-gtk-qt-theming` test that verifies:
- GTK module has color definitions and extraCss configuration
- Qt module has KDE settings and window color configuration
- Qt module uses Adwaita style

### 6. Created Example Documentation
**File:** `examples/gtk-qt-theming.nix` (NEW)

Comprehensive example showing how to enable both GTK and Qt theming.

## How It Works

### GTK Theming
```nix
gtk.enable = true;  # User enables GTK

theming.signal = {
  enable = true;
  gtk.enable = true;  # or use autoEnable = true
};
```

Result:
- Sets Adwaita/Adwaita-dark base theme
- Applies Signal colors via CSS (`@define-color` directives)
- Configures GTK3 and GTK4

### Qt Theming
```nix
qt.enable = true;  # User enables Qt

theming.signal = {
  enable = true;
  qt.enable = true;  # or use autoEnable = true
};
```

Result:
- Sets Adwaita-qt style (matches GTK theme)
- Configures comprehensive KDE color scheme via kdeglobals
- Colors automatically match Signal Design System
- Works with Qt5 and Qt6 applications

## Color Mappings

Both GTK and Qt use the same Signal color tokens:

| Purpose | Signal Token | Example |
|---------|--------------|---------|
| Background | `surface-Lc05` | `#25262f` (dark) |
| Text | `text-Lc75` | `#c0c3d1` (dark) |
| Accent/Focus | `accent.focus.Lc75` | `#5a7dcf` |
| Selection BG | `accent.focus.Lc75` | `#5a7dcf` |
| Warning | `accent.warning.Lc75` | `#c9a93a` |
| Error | `accent.danger.Lc75` | `#d9574a` |
| Success | `accent.success.Lc75` | `#4db368` |

## Testing

Verified both modules work correctly:

1. **Build Test:** Created test configuration that successfully builds with both GTK and Qt enabled
2. **Color Output:** Verified GTK CSS and Qt KDE settings contain correct RGB values
3. **Integration Test:** Added automated test to check module structure

## Usage

With `autoEnable`:
```nix
{
  gtk.enable = true;
  qt.enable = true;

  theming.signal = {
    enable = true;
    autoEnable = true;
    mode = "dark";
  };
}
```

Both GTK and Qt will automatically use Signal colors. The user's existing configuration at `/home/lewis/.config/nix` will now properly theme both GTK and Qt applications.

## Technical Notes

### Avoiding Infinite Recursion
The Qt module uses `cfg.qt.enable` (Signal's option) rather than `config.qt.enable` (Home Manager's option) to avoid infinite recursion, since the module itself modifies `qt.*` options.

### Color Format Conversions
- **GTK:** Uses hex format (`#25262f`)
- **KDE:** Uses RGB comma-separated (`"37,38,47"`)
- Conversion handled by `hexToRgbCommaSeparated` using nix-colorizer

### Consistency with GTK
The Qt module deliberately uses the Adwaita style to maintain visual consistency with GTK applications, ensuring a unified appearance across the desktop.
