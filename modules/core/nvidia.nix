{ config, ... }:

{
    # Enable NVIDIA drivers.
    hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        modesetting.enable = true;
        powerManagement = {
            enable = true;
            finegrained = true;
        };
        nvidiaPersistenced = true;
        prime = {
            amdgpuBusId = "PCI:7:0:0";
            nvidiaBusId = "PCI:1:0:0";
            offload = {
                enable = true;
                enableOffloadCmd = true;
            };
        };
        nvidiaSettings = true;
        open = false;
        gsp.enable = true;
        dynamicBoost.enable = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];

    # Enable OpenGL
    hardware.graphics.enable = true;
}