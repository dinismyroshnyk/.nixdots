{ config, pkgs, ... }:

let 
    userConfig = import ./user.nix { inherit pkgs; };
in {
    # Enable GRUB bootloader.
    boot = {
        kernelPackages = pkgs.linuxPackages;
        loader = {
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
            };
            grub = {
                enable = true;
                devices = ["nodev"];
                efiSupport = true;
                useOSProber = true;
                configurationLimit = 5;
            };
            timeout = 5;
        };
    };

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = userConfig.time.timeZone;

    # Select internationalisation properties.
    i18n = userConfig.i18n;

    # Configure console font and keymap.
    console = {
        font = "Lat2-Terminus16";
        keyMap = "pt-latin1";
    };

    # Set environment variables.
    environment.variables = userConfig.environment.variables;

    # Define a user account.
    users.users = userConfig.users.users;

    # Disable prompt for sudo password.
    security.sudo.wheelNeedsPassword = false;

    # System wide packages.
    programs = userConfig.programs;

    # Enable flake support.
    nix.settings.experimental-features = [ "flakes" "nix-command" ];

    # System state version.
    system.stateVersion = "23.11";
}