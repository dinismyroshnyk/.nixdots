{ lib, config, ... }:

with lib;

let
    cfg = config.modules.lf;
in {
    options.modules.lf = { enable = mkEnableOption "lf"; };
    config = mkIf cfg.enable {
        xdg.configFile."lf/icons".source = ./icons;
        programs.lf = {
            enable = true;
            settings = {
                preview = true;
                hidden = true;
                drawbox = true;
                icons = true;
            };
        };
    };
}