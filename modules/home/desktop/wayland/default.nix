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

        services = {
            hypridle = {
                enable = true;
                settings = {
                    general = {
                        before_sleep_cmd = "loginctl lock-session";
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

            hyprpaper = {
                enable = true;
                settings = {
                    preload =
                        [ "$NIXOS_CONFIG_DIR/wallpapers/..." ];

                    wallpaper = [
                        ",$NIXOS_CONFIG_DIR/wallpapers/..."
                    ];
                };
            };
        };

        programs = {
            hyprlock = {
                enable = true;
                settings = {
                    general = {
                        disable_loading_bar = true;
                        hide_cursor = true;
                        no_fade_in = false;
                    };

                    background = [{
                        path = ""; # Path to image
                        blur_passes = 3;
                        blur_size = 8;
                    }];

                    input-field = [{
                        size = "200, 50";
                        position = "0, -80";
                        monitor = "";
                        dots_center = true;
                        fade_on_empty = false;
                        font_color = "rgb(202, 211, 245)";
                        inner_color = "rgb(91, 96, 120)";
                        outer_color = "rgb(24, 25, 38)";
                        outline_thickness = 5;
                        placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
                        shadow_passes = 2;
                    }];

                    label = [{
                        text = "cmd[update:1000] echo \"$(date '+%R')\"";
                        color = "rgba(255, 255, 255, 1.0)";
                        font_size = 55;
                        font_family = "JetBrainsMono NF";
                        position = "0, 80";
                        halign = "center";
                        valign = "center";
                    }];
                };
            };

            waybar = {
                enable = true;
                settings.mainBar = {
                    position = "top";
                    layer = "top";
                    height = 5;
                    margin-top = 0;
                    margin-bottom = 0;
                    margin-left = 0;
                    margin-right = 0;
                    modules-left = [
                        "custom/launcher"
                        "hyprland/workspaces"
                    ];
                    modules-center = [
                        "clock"
                    ];
                    modules-right = [
                        "cpu"
                        "memory"
                        "disk"
                        "pulseaudio"
                        "battery"
                        "network"
                    ];
                    "custom/launcher" = {
                        format = "";
                        on-click = "wlogout";
                        tooltip = false;
                    };
                    "hyprland/workspaces" = {
                        active-only = false;
                        disable-scroll = true;
                        all-outputs = true;
                        show-special = false;
                        format = "{icon}";
                        on-click = "activate";
                        persistent-workspaces = {
                            "1" = [];
                            "2" = [];
                            "3" = [];
                            "4" = [];
                            "5" = [];
                        };
                        format-icons = {
                            "1" = "一";
                            "2" = "二";
                            "3" = "三";
                            "4" = "四";
                            "5" = "五";
                            "6" = "六";
                            "7" = "七";
                            "8" = "八";
                            "9" = "九";
                            "10" = "十";
                        };
                    };
                    clock= {
                        calendar = {
                        format = { today = "<span color='#b4befe'><b><u>{}</u></b></span>"; };
                        };
                        format = " {:%H:%M}";
                        tooltip = "true";
                        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                        format-alt = " {:%d/%m}";
                    };
                    cpu = {
                        format = "󰍛 {usage}%";
                        format-alt = "󰍛 {avg_frequency} GHz";
                        interval = 2;
                    };
                    memory = {
                        format = "󰾆 {percentage}% ";
                        format-alt = "󰾆 {used} GiB";
                        interval = 2;
                    };
                    disk = {
                        format = "󰋊 {percentage_used}%";
                        interval = 60;
                    };
                    pulseaudio = {
                        format = "{icon} {volume}%";
                        format-muted = "󰖁 {volume}%";
                        format-icons = {
                            default = [" "];
                        };
                        scroll-step = 5;
                        on-click = "amixer -q set Master toggle";
                    };
                    network = {
                        format-wifi = "  {signalStrength}%";
                        format-ethernet = "󰀂";
                        tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
                        format-linked = "{ifname} (No IP)";
                        format-disconnected = "󰖪";
                        on-click = "nm-connection-editor"; # not working ?
                    };
                    battery = {
                        format = "{icon} {capacity}%";
                        format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
                        format-charging = " {capacity}%";
                        format-plugged = "󱘖 {capacity}%";
                        format-warning = " {capacity}%";
                        interval = 5;
                        states = {
                            warning = 20;
                        };
                        format-time = "{H}h{M}m";
                        tooltip = true;
                        tooltip-format = "{time}";
                    };
                };
                style = ''
                    * {
                        border: none;
                        font-family: ${custom.font};
                        font-weight: ${custom.font_weight};
                        opacity: ${custom.opacity};
                    }
                    window#waybar {
                        background: none;
                    }
                    #custom-launcher {
                        font-size: 20px;
                        color: #b4befe;
                        font-weight: ${custom.font_weight};
                        padding-left: 16px;
                        padding-right: 16px;
                    }
                    #workspaces {
                        font-size: 20px;
                    }
                    #workspaces button {
                        color: ${custom.text_color};
                        padding-right: 6px;
                    }
                    #workspaces button:hover {
                        box-shadow: inherit;
                        text-shadow: inherit;
                    }
                    #workspaces button.empty {
                        color: #6c7086;
                    }
                    #workspaces button.active {
                        color: #b4befe;
                    }
                    #clock {
                        font-size: 20px;
                        color: ${custom.text_color};
                    }
                    #cpu, #memory, #disk, #pulseaudio, #battery, #network {
                        font-size: 20px;
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
                        padding-right: 20px;
                    }
                '';
            };

            wlogout = {
                enable = true;
                style = ''
                    * {
                        background: none;
                    }
                    window {
                        background-color: rgba(0, 0, 0, .5);
                    }
                    button {
                        background: rgba(0, 0, 0, .05);
                        border-radius: 8px;
                        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .1), 0 0 rgba(0, 0, 0, .5);
                        margin: 1rem;
                        background-repeat: no-repeat;
                        background-position: center;
                        background-size: 25%;
                    }
                    button:focus, button:active, button:hover {
                        background-color: rgba(255, 255, 255, 0.2);
                        outline-style: none;
                    }
                '';
            };
        };
    };
}