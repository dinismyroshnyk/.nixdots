{ pkgs, lib, config, ... }:

with lib;

let 
    cfg = config.modules.lf;
in {
    options.modules.lf = { enable = mkEnableOption "lf"; };
    config = mkIf cfg.enable {
        programs.lf = {
            enable = true;
        };
    };
}