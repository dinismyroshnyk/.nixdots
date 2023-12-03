{ pkgs, lib, config, inputs, ... }:

with lib;

let 
    cfg = config.modules.firefox;
    nurpkgs = import inputs.nur { inherit pkgs; };
in {
    options.modules.firefox = { enable = mkEnableOption "firefox"; };
    config = mkIf cfg.enable {
        programs.firefox = {
            enable = true;
            profiles.dinis = {
                extensions = with nurpkgs.repos.rycee.firefox-addons; [
                    ublock-origin
                    sponsorblock
                ];
            };
        };
    };
}