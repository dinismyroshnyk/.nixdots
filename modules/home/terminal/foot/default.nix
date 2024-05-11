{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.foot;
in {
    options.modules.foot = { enable = mkEnableOption "foot"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ foot ];
        programs.foot = {
            enable = true;
            settings = {
                main = {
                    font = "JetBrainsMono NF:size=10";
                };
            };
        };
    };
}