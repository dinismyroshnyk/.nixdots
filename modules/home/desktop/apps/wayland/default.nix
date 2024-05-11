{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.wayland;
in {
    options.modules.wayland= { enable = mkEnableOption "wayland"; };
    config = mkIf cfg.enable {
        imports = [
            ./hyprland.nix
            ./hyprlock.nix
        ];
        xdg.configFile."hypr/hyprlock.conf" = lib.readFile ./hyprlock.conf;
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
    };
}
