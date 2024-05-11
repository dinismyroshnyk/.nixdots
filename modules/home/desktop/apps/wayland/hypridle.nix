{ ... }:

{
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
}