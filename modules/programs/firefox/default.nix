{ pkgs, lib, config, inputs, ... }:

with lib;

let 
    cfg = config.modules.firefox;
in {
    options.modules.firefox = { enable = mkEnableOption "firefox"; };
    config = mkIf cfg.enable {
        programs.firefox = {
            enable = true;
            extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
                ublock-origin
                sponsorblock
            ]
        }
    };
}