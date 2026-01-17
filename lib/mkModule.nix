# Module Generator Helper
# Reduces boilerplate when creating application theming modules
{
  lib,
  palette,
  nix-colorizer,
}:

let
  signalLib = import ./default.nix { inherit lib palette nix-colorizer; };
in
rec {
  # Create a standard application theming module
  # 
  # Usage:
  #   mkAppModule {
  #     appName = "alacritty";
  #     category = "terminals";
  #     configPath = ["settings" "colors"];
  #     configGenerator = colors: { ... };
  #   }
  mkAppModule =
    {
      appName, # Name of the Home Manager program (e.g., "alacritty")
      category, # Signal category path as list (e.g., ["terminals"])
      configPath ? [ ], # Optional: Path within programs.<app> to place config
      configGenerator, # Function: signalColors -> attrset
      extraOptions ? { }, # Optional: Additional module-specific options
      programCheck ? (config: config.programs.${appName}.enable or false), # Custom program check
    }:
    {
      config,
      signalColors,
      signalLib,
      ...
    }:
    let
      inherit (lib) mkIf mkOption types;
      cfg = config.theming.signal;

      # Determine if this app should be themed
      shouldTheme =
        let
          appCfg = lib.getAttrFromPath (category ++ [ appName ]) cfg;
          signalEnable = appCfg.enable or false;
          programEnable = programCheck config;
        in
        signalEnable || (cfg.autoEnable && programEnable);

      # Generate the configuration
      generatedConfig = configGenerator signalColors;

      # Apply config at the correct path
      appConfig =
        if configPath == [ ] then
          generatedConfig
        else
          lib.setAttrByPath configPath generatedConfig;
    in
    {
      config = mkIf (cfg.enable && shouldTheme) { programs.${appName} = appConfig; };
    };

  # Simplified version for basic apps that just set programs.<app>.* directly
  mkSimpleAppModule =
    {
      appName,
      category,
      configGenerator,
    }:
    mkAppModule {
      inherit appName category configGenerator;
      configPath = [ ];
    };

  # For apps that need service configuration instead of program configuration
  mkServiceModule =
    {
      serviceName,
      category,
      configGenerator,
      serviceCheck ? (config: config.services.${serviceName}.enable or false),
    }:
    {
      config,
      signalColors,
      signalLib,
      ...
    }:
    let
      inherit (lib) mkIf;
      cfg = config.theming.signal;

      shouldTheme =
        let
          serviceCfg = lib.getAttrFromPath (category ++ [ serviceName ]) cfg;
          signalEnable = serviceCfg.enable or false;
          svcEnable = serviceCheck config;
        in
        signalEnable || (cfg.autoEnable && svcEnable);

      generatedConfig = configGenerator signalColors;
    in
    {
      config = mkIf (cfg.enable && shouldTheme) { services.${serviceName} = generatedConfig; };
    };
}
