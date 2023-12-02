{ config, pkgs, ... }:

{
    # Import configurations.
    imports = [
        ./nvidia.nix
    ];

    # Allow unfree packages.
    nixpkgs.config.allowUnfree = true;

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

    # Define a user account.
    users.users.dinis = {
        shell = pkgs.zsh;
        isNormalUser = true;
        description = "Dinis Myroshnyk";
        extraGroups = [ "networkmanager" "wheel" "vboxsf" ];
    };

    # Set your time zone.
    time.timeZone = "Europe/Lisbon";

    # Select internationalisation properties.
    i18n = {
        defaultLocale = "pt_PT.UTF-8";
        extraLocaleSettings = {
            LANG = "en_US.UTF-8";
        };
    };

    # Configure keymap.
    console.keyMap = "pt-latin1";

    # Configure fonts.
    fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # Set environment variables.
    environment.variables = {
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        EDITOR = "nvim";
        WLR_NO_HARDWARE_CURSORS = "1"; # VirtualBox fix.
        WLR_RENDERER_ALLOW_SOFTWARE = "1"; # VirtualBox fix.
    };

    # Disable prompt for sudo password.
    security.sudo.wheelNeedsPassword = false;

    # System wide packages.
    programs.zsh.enable = true;

    # Enable flake support.
    nix.settings.experimental-features = [ "flakes" "nix-command" ];

    # System state version.
    system.stateVersion = "24.05";
}
