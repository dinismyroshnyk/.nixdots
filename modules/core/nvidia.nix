{ ... }:

{
    # Enable NVIDIA drivers.
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement = {
            enable = true;
            finegrained = true;
        };
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
    };
    services.xserver.videoDrivers = [ "nvidia" ];

    # Enable OpenGL
    hardware.graphics.enable = true;
}