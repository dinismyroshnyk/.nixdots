{ lib, config, ... }:

with lib;

let
    cfg = config.modules.hyprland;
in {
    options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
    config = mkIf cfg.enable {
        wayland.windowManager.hyprland = {
            enable = true;
            # enableNvidiaPatches = true; no longer needed
            xwayland.enable = true;
	        extraConfig = lib.readFile ./hyprland.conf;
            systemd.enable = true;
        };
        home.sessionVariables = {
            NIXOS_OZONE_WL = "1";
            OZONE_PLATFORM = "wayland";
            # NIXOS_XDG_OPEN_USE_PORTAL = "1";
            # GTK_USE_PORTAL = "1";
        };
    };
}
