{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.waybar;
in {
    options.modules.waybar = { enable = mkEnableOption "waybar"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ waybar ];
        programs.waybar = {
            enable = true;
        };
    };
}