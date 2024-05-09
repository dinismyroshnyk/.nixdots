{ pkgs, lib, config, ... }:

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
        };

        xdg.configFile."hypr/hyprlock.conf".text = ''
            input-field {
                monitor =
                size = 300, 50
                hide_input = false
            }

            label {
                monitor =
                text = cmd[update:1000] echo "$(date '+%R')"
                color = rgba(255, 255, 255, 1.0)
                font_size = 55
                font_family = JetBrainsMono NF

                position = 0, 80
                halign = center
                valign = center
            }
        '';

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
                    timeout = 15;
                    on-timeout = "hyprlock";
                    }
                    {
                    timeout = 30;
                    on-timeout = "hyprctl dispatch dpms off";
                    on-resume = "hyprctl dispatch dpms on";
                    }
                ];
            };
        };
    };
}
