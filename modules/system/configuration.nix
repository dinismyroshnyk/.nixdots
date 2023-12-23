{ config, pkgs, ... }:

{
    # Import configurations.
    imports = [
        ./nvidia.nix
    ];

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
    networking.wireless.extraConfig = '' openssl_ciphers=DEFAULT@SECLEVEL=0 '';
    # incase i need this: nmcli con mod id eduroam 802-1x.phase1-auth-flags 32
    nixpkgs.config.packageOverrides = pkgs: rec {
        wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
            patches = attrs.patches ++ [ ./eduroam.patch ];
        });
    };

    # Define a user account.
    users.users.dinis = {
        shell = pkgs.zsh;
        isNormalUser = true;
        description = "Dinis Myroshnyk";
        extraGroups = [ "networkmanager" "wheel" ];
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

    # Set environment variables.
    environment.variables = {
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        # XDG_DATA_HOME = "$HOME/.local/share";
        EDITOR = "code";
    };

    # Enable xdg-portals.
    # xdg.portal = {
    #     enable = true;
    #     # wlr.enable = true;
	#     extraPortals = with pkgs; [
    #         # xdg-desktop-portal-wlr
    #         xdg-desktop-portal-gtk
    #     ];
    #     xdgOpenUsePortal = true;
    #     config.common.default = "gtk";
    # };
    # xdg.portal = {
    #     enable = true;
    #     wlr.enable = true;
    #     xdgOpenUsePortal = true;
    #     config.common.default = "*";
    # };

    # Disable prompt for sudo password.
    security.sudo.wheelNeedsPassword = false;

    # System wide packages.
    programs.zsh.enable = true;
    environment.systemPackages = with pkgs; [
        nil
        # xdg-utils
    ];

    # Enable flake support.
    nix.settings.experimental-features = [ "flakes" "nix-command" ];

    # System state version.
    system.stateVersion = "24.05";
}
