{ lib, ... }:

{
	wayland.windowManager.hyprland = {
		enable = true;
		# enableNvidiaPatches = true; no longer needed
		xwayland.enable = true;
		extraConfig = lib.readFile ./hyprland.conf;
		systemd.enable = true;
	};
}