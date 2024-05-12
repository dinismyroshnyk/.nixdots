{ pkgs, ... }:

{
    # Import configurations.
    imports = [
        ./nvidia.nix
        ./greetd.nix
    ];

    # Enable backlight control.
    programs.light.enable = true;

    # Disable unnecessary packages.
    programs.nano.enable = false;
    services.xserver.excludePackages = with pkgs; [ xterm ];

    # Power management.
    powerManagement.enable = true;
    services.tlp.enable = true;

    # Enable dconf and gnupg.
    programs.dconf.enable = true;
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };

    # Configure PAM to work with hyprlock and greetd.
    security.pam.services.hyprlock.text = "auth include login";

    # Enable GRUB bootloader.
    boot = {
        kernelPackages = pkgs.linuxPackages_testing;
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

    # Enable gnome keyring.
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;

    # Enable networking.
    networking.networkmanager.enable = true;
    nixpkgs.config.packageOverrides = pkgs: {
        wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
            patches = attrs.patches ++ [ ./eduroam.patch ];
        });
    };

    # Enable pulseaudio.
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    # Define a user account.
    users.users.dinis = {
        shell = pkgs.zsh;
        isNormalUser = true;
        description = "Dinis Myroshnyk";
        extraGroups = [ "networkmanager" "wheel" "video" ];
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
        EDITOR = "code";
    };

    # Enable xdg-portals.
    xdg.portal = {
        enable = true;
        wlr.enable = true;
	    extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
        config.common.default = ["gtk" "wlr"];
    };

    # Disable prompt for sudo password.
    security.sudo.wheelNeedsPassword = false;

    # System wide packages.
    programs.zsh.enable = true;
    environment.systemPackages = with pkgs; [
        nil
        xdg-utils
        alsa-utils
        jdk21
        zig
        zls
        btop
        neofetch
        discord
        steam
        beekeeper-studio
        youtube-music
        networkmanagerapplet
    ];

    # Enable MySQL server.
    services.mysql = {
        # To add a root password, do the following:
        # As superuser, run `mysql -u root`
        # Inside the MySQL shell, run `ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';`
        # Then, run `FLUSH PRIVILEGES;`
        # The password is now set.
        enable = true;
        package = pkgs.mysql;
    };

    # Enable flake support.
    nix.settings.experimental-features = [ "flakes" "nix-command" ];

    # SSH config.
    programs.ssh.extraConfig = "
        Host estgoh.ipc.pt
            SetEnv TERM=xterm-256color
	        KexAlgorithms diffie-hellman-group1-sha1
            HostKeyAlgorithms ssh-rsa,ssh-dss
            Ciphers aes128-cbc
    ";

    # System state version.
    system.stateVersion = "24.05";
}
