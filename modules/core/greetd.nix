{ inputs, pkgs, ... }:
let
    tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
    greeting = "'Access restricted to authorized personnel only'";
    sessions = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
    shutdown = "poweroff";
    reboot = "reboot";
in {
    # Enable greetd.
    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${tuigreet} -t -r -g ${greeting} -s ${sessions} --remember-session --power-shutdown ${shutdown} --power-reboot ${reboot} --asterisks";
                user = "greeter";
            };
        };
    };
    environment.etc."greetd/environments".text = ''
        Hyprland
    '';
    systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
    };
}