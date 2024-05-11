{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.wayland;
in {
    options.modules.wayland= { enable = mkEnableOption "wayland"; };
    config = mkIf cfg.enable {
        wayland.windowManager.hyprland = {
            enable = true;
            # enableNvidiaPatches = true; no longer needed
            xwayland.enable = true;
	        extraConfig = lib.readFile ./hyprland.conf;
            systemd.enable = true;
        };

        home = {
            sessionVariables = {
                NIXOS_OZONE_WL = "1";
                OZONE_PLATFORM = "wayland";
                QT_QPA_PLATFORM = "wayland";
                SDL_VIDEODRIVER = "wayland";
                XDG_SESSION_TYPE = "wayland";
            };
            packages = with pkgs; [
                grim
                slurp
                wl-clipboard
                wl-screenrec
                wlr-randr
                hyprlock
            ];
            file."hyprland.conf".text = lib.readFile ./hyprlock.conf;
        };

        services.hypridle = {
            enable = true;
            settings = {
                general = {
                    after_sleep_cmd = "hyprctl dispatch dpms on";
                    ignore_dbus_inhibit = false;
                    lock_cmd = "hyprlock";
                };
                listener = [
                    {
                    timeout = 90;
                    on-timeout = "hyprlock";
                    }
                    {
                    timeout = 120;
                    on-timeout = "hyprctl dispatch dpms off";
                    on-resume = "hyprctl dispatch dpms on";
                    }
                ];
            };
        };

        programs.waybar = {
            enable = true;
        };
    };
}