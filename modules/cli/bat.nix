{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.theming.signal;
in {
  config = mkIf (cfg.enable && cfg.cli.bat.enable) {
    programs.bat = {
      config = {
        # Bat uses predefined themes
        # We'll use close matches until we can generate custom themes
        theme = if cfg.mode == "light" then "GitHub" else "Monokai Extended";
        italic-text = "always";
        style = "numbers,changes,header";
      };
    };
  };
}
