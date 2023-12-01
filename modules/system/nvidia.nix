{ config, pkgs, ... }:

{
    hardware.nvidia.modessetting.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
}