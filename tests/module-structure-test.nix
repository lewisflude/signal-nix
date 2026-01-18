# Test that verifies module structure is correct
# This catches issues like placing _module.args at the wrong level
{
  pkgs,
  lib,
  self,
  system,
  ...
}:

let
  # Helper to test Home Manager module structure
  testHMModule =
    name: extraConfig:
    pkgs.runCommand "test-hm-module-${name}" { } ''
      echo "Testing Home Manager module structure: ${name}"

      # Try to evaluate a minimal Home Manager config
      ${pkgs.nix}/bin/nix-instantiate --eval --strict --json \
        --expr '
          let
            pkgs = import ${pkgs.path} { inherit system; };
            hmModule = (import ${self}).homeManagerModules.signal;
            
            # Minimal config that loads the module
            config = {
              config = {
                theming.signal = {
                  enable = true;
                  ${extraConfig}
                };
              };
              options = {};
              _module.args = { inherit pkgs; };
            };
            
            # Evaluate the module with lib.evalModules
            evaluated = pkgs.lib.evalModules {
              modules = [ 
                hmModule 
                config
              ];
            };
          in
            # Try to access config to force evaluation
            evaluated.config.theming.signal.enable
        ' > /dev/null || {
          echo "ERROR: Module structure is invalid for ${name}"
          exit 1
        }

      echo "✓ Module structure is valid for ${name}"
      touch $out
    '';

  # Helper to test NixOS module structure
  testNixOSModule =
    name: extraConfig:
    pkgs.runCommand "test-nixos-module-${name}" { } ''
      echo "Testing NixOS module structure: ${name}"

      ${pkgs.nix}/bin/nix-instantiate --eval --strict --json \
        --expr '
          let
            pkgs = import ${pkgs.path} { inherit system; };
            nixosModule = (import ${self}).nixosModules.signal;
            
            config = {
              config = {
                theming.signal.nixos = {
                  enable = true;
                  ${extraConfig}
                };
              };
              options = {};
              _module.args = { inherit pkgs; };
            };
            
            evaluated = pkgs.lib.evalModules {
              modules = [ 
                nixosModule 
                config
              ];
            };
          in
            evaluated.config.theming.signal.nixos.enable
        ' > /dev/null || {
          echo "ERROR: NixOS module structure is invalid for ${name}"
          exit 1
        }

      echo "✓ NixOS module structure is valid for ${name}"
      touch $out
    '';

  # Test that _module.args is accessible
  testModuleArgs = pkgs.runCommand "test-module-args-accessible" { } ''
    echo "Testing that _module.args are accessible to child modules"

    # Test that signalLib, signalColors, etc. are available
    ${pkgs.nix}/bin/nix-instantiate --eval --strict \
      --expr '
        let
          pkgs = import ${pkgs.path} { system = "${system}"; };
          hmModule = (import ${self}).homeManagerModules.signal;
          
          # A test module that uses signalLib
          testModule = { config, signalLib, signalColors, ... }: {
            options = {};
            config = {
              assertions = [{
                assertion = signalLib != null;
                message = "signalLib should be available";
              }
              {
                assertion = signalColors != null;
                message = "signalColors should be available";
              }];
            };
          };
          
          evaluated = pkgs.lib.evalModules {
            modules = [ 
              hmModule
              testModule
              {
                config.theming.signal = {
                  enable = true;
                  editors.helix.enable = true;
                };
                _module.args = { inherit pkgs; };
              }
            ];
          };
        in
          # This will fail if signalLib is not accessible
          evaluated.config.assertions
      ' > /dev/null || {
        echo "ERROR: _module.args are not accessible"
        exit 1
      }

    echo "✓ _module.args are properly accessible"
    touch $out
  '';

in
{
  # Test basic module structure
  structure-hm-basic = testHMModule "basic" "editors.helix.enable = true;";
  structure-hm-gtk = testHMModule "gtk" "gtk.enable = true;";
  structure-hm-multiple = testHMModule "multiple" ''
    editors.helix.enable = true;
    terminals.kitty.enable = true;
    cli.bat.enable = true;
  '';

  structure-nixos-basic = testNixOSModule "basic" "boot.console.enable = true;";
  structure-nixos-login = testNixOSModule "login" "login.sddm.enable = true;";

  # Test that module args work
  structure-module-args = testModuleArgs;

  # Test that config merging works correctly
  structure-config-merge = pkgs.runCommand "test-config-merge" { } ''
    echo "Testing that lib.mkMerge works correctly"

    # Verify that both unconditional (_module.args) and conditional (enable-gated) 
    # config sections are properly merged
    ${pkgs.nix}/bin/nix-instantiate --eval --strict \
      --expr '
        let
          pkgs = import ${pkgs.path} { system = "${system}"; };
          hmModule = (import ${self}).homeManagerModules.signal;
          
          evaluated = pkgs.lib.evalModules {
            modules = [ 
              hmModule
              {
                config.theming.signal = {
                  enable = true;
                  editors.helix.enable = true;
                };
                _module.args = { inherit pkgs; };
              }
            ];
          };
        in
          # Both should be accessible
          evaluated.config.theming.signal.enable 
          && (builtins.hasAttr "signalLib" evaluated._module.args)
      ' > /dev/null || {
        echo "ERROR: Config merge is broken"
        exit 1
      }

    echo "✓ Config merge works correctly"
    touch $out
  '';
}
