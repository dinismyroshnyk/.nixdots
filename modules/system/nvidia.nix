{ config, pkgs, ... }:

{
    hardware.nvidia.modesetting.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    # Enable OpenGL
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };
}