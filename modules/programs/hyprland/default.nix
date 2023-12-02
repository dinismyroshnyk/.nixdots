{ pkgs, lib, config, ... }:

with lib;

let 
    cfg = config.modules.hyprland;
in {
    options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
    config = mkIf cfg.enable {
        wayland.windowManager.hyprland = {
            enable = true;
            #enableNvidiaPatches = true;
            extraConfig = lib.fileContents ./hyprland.conf;
        };
    };
}