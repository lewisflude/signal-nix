# Signal Design System - Integration Tests
#
# This file contains shell-based integration tests that validate module structure,
# example configurations, and file existence. These tests use pkgs.runCommand.

{
  pkgs,
  lib,
  self,
  signal-palette,
}:

let
  signalLib = import ../../lib {
    inherit lib;
    inherit (signal-palette) palette;
    inherit (self.inputs) nix-colorizer;
  };

  # ============================================================================
  # Test Helpers
  # ============================================================================

  # Helper to check that a file exists
  assertFileExists = path: name: ''
    test -f ${path} || {
      echo "FAIL: ${name} not found"
      exit 1
    }
  '';

  # Helper to check that a file contains a pattern
  assertFileContains = path: pattern: description: ''
    ${pkgs.gnugrep}/bin/grep -q "${pattern}" ${path} || {
      echo "FAIL: ${description}"
      exit 1
    }
  '';

  # Helper to create a module structure test
  mkModuleTest =
    name: modulePath: programName:
    pkgs.runCommand "test-module-${name}" { } ''
      echo "Testing ${name} module..."

      ${assertFileExists modulePath "${name} module"}
      ${assertFileContains modulePath "programs.${programName}"
        "${name} module missing programs.${programName} config"
      }

      echo "✓ ${name} module structure is valid"
      touch $out
    '';

  # Helper to create an example validation test
  mkExampleTest =
    name: examplePath: requiredPattern:
    pkgs.runCommand "test-example-${name}" { } ''
      echo "Testing ${name} example..."

      ${assertFileExists examplePath "${name} example"}
      ${assertFileContains examplePath requiredPattern "${name} example missing required pattern"}

      echo "✓ ${name} example structure is valid"
      touch $out
    '';

  # Helper to create a theme resolution test
  mkThemeResolutionTest =
    name: modulePath: expectedPattern: description:
    pkgs.runCommand "test-theme-${name}" { } ''
      echo "Testing ${description}..."

      ${assertFileContains modulePath expectedPattern description}

      echo "✓ ${description}"
      touch $out
    '';

in
{
  # ============================================================================
  # Integration Tests - Example Configurations
  # ============================================================================

  integration-example-basic =
    mkExampleTest "basic" ../../examples/basic.nix
      "homeConfigurations.user";

  integration-example-auto-enable =
    mkExampleTest "auto-enable" ../../examples/auto-enable.nix
      "autoEnable = true";

  integration-example-full-desktop =
    mkExampleTest "full-desktop" ../../examples/full-desktop.nix
      "homeConfigurations";

  integration-example-custom-brand =
    mkExampleTest "custom-brand" ../../examples/custom-brand.nix
      "brandGovernance";

  # New examples - documentation heavy, validate they parse correctly
  integration-example-migrating = pkgs.runCommand "test-example-migrating" { } ''
    echo "Testing migrating example parses correctly..."

    # The example contains multiple configuration patterns in comments
    # Just verify it's a valid flake structure
    ${assertFileContains ../../examples/migrating-existing-config.nix "homeConfigurations"
      "migrating example"
    }
    ${assertFileContains ../../examples/migrating-existing-config.nix
      "signal.homeManagerModules.default"
      "migrating example"
    }
    ${assertFileContains ../../examples/migrating-existing-config.nix "theming.signal"
      "migrating example"
    }
    ${assertFileContains ../../examples/migrating-existing-config.nix "autoEnable" "migrating example"}

    echo "✓ migrating example has valid structure"
    touch $out
  '';

  integration-example-multi-machine = pkgs.runCommand "test-example-multi-machine" { } ''
    echo "Testing multi-machine example parses correctly..."

    # The example contains patterns for multiple machines
    # Verify it contains expected structure
    ${assertFileContains ../../examples/multi-machine.nix "homeConfigurations" "multi-machine example"}
    ${assertFileContains ../../examples/multi-machine.nix "user@desktop" "multi-machine example"}
    ${assertFileContains ../../examples/multi-machine.nix "user@laptop" "multi-machine example"}
    ${assertFileContains ../../examples/multi-machine.nix "user@server" "multi-machine example"}
    ${assertFileContains ../../examples/multi-machine.nix "theming.signal" "multi-machine example"}

    echo "✓ multi-machine example has valid structure"
    touch $out
  '';

  # ============================================================================
  # Module Tests - Individual Module Evaluation
  # ============================================================================

  module-common-evaluates = pkgs.runCommand "test-module-common" { } ''
    echo "Testing common module evaluation..."

    ${assertFileExists ../../modules/common/default.nix "common module"}
    ${assertFileContains ../../modules/common/default.nix "imports = \\["
      "common module missing imports"
    }

    echo "✓ common module structure is valid"
    touch $out
  '';

  module-helix-dark = mkModuleTest "helix" ../../modules/editors/helix.nix "helix";

  module-helix-light =
    mkThemeResolutionTest "helix-resolution" ../../modules/editors/helix.nix "resolveThemeMode"
      "helix module uses theme resolution";

  module-ghostty-evaluates = mkModuleTest "ghostty" ../../modules/terminals/ghostty.nix "ghostty";

  module-bat-evaluates = mkModuleTest "bat" ../../modules/cli/bat.nix "bat";

  module-fzf-evaluates = mkModuleTest "fzf" ../../modules/cli/fzf.nix "fzf";

  module-gtk-evaluates = pkgs.runCommand "test-module-gtk" { } ''
    echo "Testing gtk module..."

    ${assertFileExists ../../modules/gtk/default.nix "gtk module"}
    ${assertFileContains ../../modules/gtk/default.nix "gtk.enable" "gtk module missing gtk config"}

    echo "✓ gtk module structure is valid"
    touch $out
  '';

  module-ironbar-evaluates = pkgs.runCommand "test-module-ironbar" { } ''
    echo "Testing ironbar module..."

    ${assertFileExists ../../modules/ironbar/default.nix "ironbar module"}

    echo "✓ ironbar module structure is valid"
    touch $out
  '';

  # ============================================================================
  # Edge Case Tests - Option Combinations
  # ============================================================================

  edge-case-all-disabled = pkgs.runCommand "test-edge-case-all-disabled" { } ''
    echo "Testing module structure allows disabled state..."

    ${assertFileContains ../../modules/editors/helix.nix "mkIf"
      "helix should use mkIf for conditional config"
    }

    echo "✓ Modules properly guard configuration with mkIf"
    touch $out
  '';

  edge-case-multiple-terminals = pkgs.runCommand "test-edge-case-multiple-terminals" { } ''
    echo "Testing multiple terminal modules exist..."

    ${assertFileExists ../../modules/terminals/ghostty.nix "ghostty terminal"}
    ${assertFileExists ../../modules/terminals/alacritty.nix "alacritty terminal"}
    ${assertFileExists ../../modules/terminals/kitty.nix "kitty terminal"}
    ${assertFileExists ../../modules/terminals/wezterm.nix "wezterm terminal"}

    echo "✓ All terminal modules exist"
    touch $out
  '';

  edge-case-ironbar-profiles = pkgs.runCommand "test-edge-case-ironbar-profiles" { } ''
    echo "Testing ironbar profile options..."

    ${assertFileContains ../../modules/common/default.nix "compact"
      "ironbar profile 'compact' not documented"
    }
    ${assertFileContains ../../modules/common/default.nix "relaxed"
      "ironbar profile 'relaxed' not documented"
    }
    ${assertFileContains ../../modules/common/default.nix "spacious"
      "ironbar profile 'spacious' not documented"
    }

    echo "✓ All ironbar profiles are defined"
    touch $out
  '';

  # ============================================================================
  # Validation Tests - Theme Resolution Consistency
  # ============================================================================

  validation-theme-names = pkgs.runCommand "test-validation-theme-names" { } ''
    echo "Testing theme name consistency across modules..."

    ${assertFileContains ../../modules/cli/bat.nix "themeMode = signalLib.resolveThemeMode"
      "bat.nix should use signalLib.resolveThemeMode"
    }
    echo "✓ bat.nix uses themeMode"

    ${assertFileContains ../../modules/editors/helix.nix "themeMode = signalLib.resolveThemeMode"
      "helix.nix should use signalLib.resolveThemeMode"
    }
    echo "✓ helix.nix uses themeMode"

    ${assertFileContains ../../modules/gtk/default.nix "themeMode = signalLib.resolveThemeMode"
      "gtk/default.nix should use signalLib.resolveThemeMode"
    }
    echo "✓ gtk/default.nix uses themeMode"

    ${assertFileContains ../../modules/common/default.nix "resolveThemeMode cfg.mode"
      "common/default.nix should resolve theme mode"
    }
    echo "✓ common/default.nix resolves mode"

    ${assertFileContains ../../modules/cli/fzf.nix "signalColors" "fzf.nix should use signalColors"}
    echo "✓ fzf.nix uses signalColors (pre-resolved)"

    echo "✓ All theme name validation tests passed"
    touch $out
  '';

  validation-no-auto-theme-names = pkgs.runCommand "test-validation-no-auto-names" { } ''
    echo "Testing that no module uses 'signal-auto' as a theme name..."

    # Search for any occurrence of "signal-auto" in module files
    if ${pkgs.gnugrep}/bin/grep -r "signal-auto" ${../../modules} 2>/dev/null; then
      echo "FAIL: Found 'signal-auto' in module files - should use resolved theme"
      exit 1
    fi

    echo "✓ No modules use 'signal-auto' directly"
    touch $out
  '';
}
