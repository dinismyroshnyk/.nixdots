{ username, hostname, config, pkgs, ... }:

{
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
    time.timeZone = "Europe/Lisbon";

    # Select internationalisation properties.
    i18n = {
        defaultLocale = "pt_PT.UTF-8";
        extraLocaleSettings = {
            LANG = "en_US.UTF-8";
        };
    };

    # Configure console font and keymap.
    console = {
        font = "Lat2-Terminus16";
        keyMap = "pt-latin1";
    };

    # Set environment variables.
    environment.variables = {
        NIXOS_CONFIG_DIR = "$HOME/.nixdots/";
        HOSTNAME = "${hostname}";
    };

    # Define a user account.
    users.users.${username} = {
        isNormalUser = true;
        description = "Dinis Myroshnyk";
        extraGroups = [ "networkmanager" "wheel" "vboxsf" ];
    };

    # Disable prompt for sudo password.
    security.sudo.wheelNeedsPassword = false;

    # Enable flake support.
    nix.settings.experimental-features = [ "flakes" "nix-command" ];

    # System state version.
    system.stateVersion = "23.11";
}