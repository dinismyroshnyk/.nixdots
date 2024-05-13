{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.cava;
in {
    options.modules.cava = { enable = mkEnableOption "cava"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ cava ];
        programs.cava = {
            enable = true;
            settings = {
                general.framerate = 60;
                input.method = "alsa";
                smoothing.noise_reduction = 88;
                color = {
                    background = "'#000000'";
                    foreground = "'#FFFFFF'";
                };
            };
        };
    };
}