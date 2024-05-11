{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.wayland;
    custom = {
        font = "JetBrainsMono Nerd Font";
        font_size = "15px";
        font_weight = "bold";
        text_color = "#cdd6f4";
        secondary_accent= "89b4fa";
        tertiary_accent = "f5f5f5";
        background = "11111B";
        opacity = "0.98";
    };
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
                __GL_GSYNC_ALLOWED = "0";
                __GL_VRR_ALLOWED = "0";
                _JAVA_AWT_WM_NONEREPARENTING = "1";
                SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
                DISABLE_QT5_COMPAT = "0";
                GDK_BACKEND = "wayland";
                ANKI_WAYLAND = "1";
                DIRENV_LOG_FORMAT = "";
                WLR_DRM_NO_ATOMIC = "1";
                QT_AUTO_SCREEN_SCALE_FACTOR = "1";
                QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
                QT_QPA_PLATFORM = "xcb";
                QT_QPA_PLATFORMTHEME = "qt5ct";
                QT_STYLE_OVERRIDE = "kvantum";
                MOZ_ENABLE_WAYLAND = "1";
                WLR_BACKEND = "vulkan";
                WLR_RENDERER = "vulkan";
                WLR_NO_HARDWARE_CURSORS = "1";
                XDG_SESSION_TYPE = "wayland";
                SDL_VIDEODRIVER = "wayland";
                CLUTTER_BACKEND = "wayland";
                GTK_THEME = "Catppuccin-Mocha-Compact-Lavender-Dark";
                OZONE_PLATFORM = "wayland";
            };
            packages = with pkgs; [
                grim
                slurp
                wl-clipboard
                wl-screenrec
                wlr-randr
            ];
        };

        programs.hyprlock = {
            enable = true;
            general = {
                disable_loading_bar = true;
                hide_cursor = false;
                no_fade_in = true;
            };
            input-fields = [{
                monitor = "";
                size = {
                width = 300;
                height = 50;
                };
                outline_thickness = 2;
                fade_on_empty = false;
                placeholder_text = ''<span font_family="${custom.font}">Password...</span>'';
                dots_spacing = 0.3;
                dots_center = true;
            }];
            labels = [{
                monitor = "";
                text = "$TIME";
                font_size = 50;
                position = {
                    x = 0;
                    y = 80;
                };
                valign = "center";
                halign = "center";
            }];
        };

        #xdg.configFile."hypr/hyprlock.conf".text = ''
        #    input-field {
        #        monitor =
        #        size = 300, 50
        #        hide_input = false
        #    }
        #    label {
        #        monitor =
        #        text = cmd[update:1000] echo "$(date '+%R')"
        #        color = rgba(255, 255, 255, 1.0)
        #        font_size = 55
        #        font_family = JetBrainsMono NF
        #        position = 0, 80
        #        halign = center
        #        valign = center
        #    }
        #'';

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
            settings.mainBar = {
                position= "top";
                layer= "top";
                height= 5;
                margin-top= 0;
                margin-bottom= 0;
                margin-left= 0;
                margin-right= 0;
                modules-left= [
                    "custom/launcher"
                    "hyprland/workspaces"
                ];
                modules-center= [
                    "clock"
                ];
                modules-right= [
                    "tray"
                    "cpu"
                    "memory"
                    "disk"
                    "pulseaudio"
                    "battery"
                    "network"
                ];
                clock= {
                    calendar = {
                    format = { today = "<span color='#b4befe'><b><u>{}</u></b></span>"; };
                    };
                    format = " {:%H:%M}";
                    tooltip= "true";
                    tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                    format-alt= " {:%d/%m}";
                };
                "hyprland/workspaces"= {
                    active-only= false;
                    disable-scroll= true;
                    format = "{icon}";
                    on-click= "activate";
                    format-icons= {
                        "1"= "󰈹";
                        "2"= "";
                        "3"= "󰘙";
                        "4"= "󰙯";
                        "5"= "";
                        "6"= "";
                        urgent= "";
                        default = "";
                        sort-by-number= true;
                    };
                    persistent-workspaces = {
                        "1"= [];
                        "2"= [];
                        "3"= [];
                        "4"= [];
                        "5"= [];
                    };
                };
                memory= {
                    format= "󰟜 {}%";
                    format-alt= "󰟜 {used} GiB"; # 
                    interval= 2;
                };
                cpu= {
                    format= "  {usage}%";
                    format-alt= "  {avg_frequency} GHz";
                    interval= 2;
                };
                disk = {
                    # path = "/";
                    format = "󰋊 {percentage_used}%";
                    interval= 60;
                };
                network = {
                    format-wifi = "  {signalStrength}%";
                    format-ethernet = "󰀂 ";
                    tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
                    format-linked = "{ifname} (No IP)";
                    format-disconnected = "󰖪 ";
                };
                tray= {
                    icon-size= 20;
                    spacing= 8;
                };
                pulseaudio= {
                    format= "{icon} {volume}%";
                    format-muted= "󰖁  {volume}%";
                    format-icons= {
                        default= [" "];
                    };
                    scroll-step= 5;
                    on-click= "pamixer -t";
                };
                battery = {
                    format = "{icon} {capacity}%";
                    format-icons = [" " " " " " " " " "];
                    format-charging = " {capacity}%";
                    format-full = " {capacity}%";
                    format-warning = " {capacity}%";
                    interval = 5;
                    states = {
                        warning = 20;
                    };
                    format-time = "{H}h{M}m";
                    tooltip = true;
                    tooltip-format = "{time}";
                };
                "custom/launcher"= {
                    format= "";
                    on-click= "pkill wofi || rofi --show drun";
                    on-click-right= "pkill rofi || wallpaper-picker";
                    tooltip= "false";
                };
            };
            style = ''
                * {
                    border: none;
                    border-radius: 0px;
                    padding: 0;
                    margin: 0;
                    min-height: 0px;
                    font-family: ${custom.font};
                    font-weight: ${custom.font_weight};
                    opacity: ${custom.opacity};
                }
                window#waybar {
                    background: none;
                }
                #workspaces {
                    font-size: 18px;
                    padding-left: 15px;
                }
                #workspaces button {
                    color: ${custom.text_color};
                    padding-left:  6px;
                    padding-right: 6px;
                }
                #workspaces button.empty {
                    color: #6c7086;
                }
                #workspaces button.active {
                    color: #b4befe;
                }
                #tray, #pulseaudio, #network, #cpu, #memory, #disk, #clock, #battery {
                    font-size: ${custom.font_size};
                    color: ${custom.text_color};
                }
                #cpu {
                    padding-left: 15px;
                    padding-right: 9px;
                    margin-left: 7px;
                }
                #memory {
                    padding-left: 9px;
                    padding-right: 9px;
                }
                #disk {
                    padding-left: 9px;
                    padding-right: 15px;
                }
                #tray {
                    padding: 0 20px;
                    margin-left: 7px;
                }
                #pulseaudio {
                    padding-left: 15px;
                    padding-right: 9px;
                    margin-left: 7px;
                }
                #battery {
                    padding-left: 9px;
                    padding-right: 9px;
                }
                #network {
                    padding-left: 9px;
                    padding-right: 15px;
                }
                #clock {
                    padding-left: 9px;
                    padding-right: 15px;
                }
                #custom-launcher {
                    font-size: 20px;
                    color: #b4befe;
                    font-weight: ${custom.font_weight};
                    padding-left: 10px;
                    padding-right: 15px;
                }
            '';
        };
    };
}