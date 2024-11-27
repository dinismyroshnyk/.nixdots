{ pkgs, ... }:
let
    # Obtained through ´https://lazamar.co.uk/nix-versions/´
    # legacy-pkgs = import (builtins.fetchTarball {
    #     url = "https://github.com/NixOS/nixpkgs/archive/c407032be28ca2236f45c49cfb2b8b3885294f7f.tar.gz";
    #     sha256 = "sha256:1a95d5g5frzgbywpq7z0az8ap99fljqk3pkm296asrvns8qcv5bv";
    # }) { inherit (pkgs) system; };
    # graalvm21-ce = legacy-pkgs.graalvm-ce;

    # java_ver = graalvm21-ce;
    development_jdk = pkgs.graalvm-ce;
    service_jdk = pkgs.jdk23; # PlantUML doesn't work with GraalVM for some reason
in
{
    # Import configurations.
    imports = [
        ./nvidia.nix
        ./greetd.nix
    ];

    # Enable backlight control.
    programs.light.enable = true;

    # Ignore power key short press.
    services.logind.extraConfig = ''
        HandlePowerKey=ignore
    '';

    # Enable network-manager-applet.
    programs.nm-applet.enable = true;

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
        kernelPackages = pkgs.linuxPackages_latest; # At the current date, does not work with nvidia drivers.
        # kernelPackages = pkgs.linuxKernel.packages.linux_6_11;
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
    hardware.pulseaudio.enable = false;
    services.pipewire = {
        enable = true;
        audio.enable = true;
        alsa = {
            enable = true;
            support32Bit = true;
        };
        pulse.enable = true;
        wireplumber = {
            enable = true;
            configPackages = [(
                pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
                    bluez_monitor.properties = {
                        ["bluez5.enable-sbc-xq"] = true,
                        ["bluez5.enable-msbc"] = true,
                        ["bluez5.enable-hw-volume"] = true,
                        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
                    }
                ''
            )];
        };
    };

    # Enable rtkit.
    security.rtkit.enable = true;

    # Define a user account.
    users.users.dinis = {
        shell = pkgs.zsh;
        isNormalUser = true;
        description = "Dinis Myroshnyk";
        extraGroups = [ "networkmanager" "wheel" "video" "audio" "openrazer" "docker" ];
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
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
        config.common.default = ["gtk" "hyprland"];
    };

    # Disable prompt for sudo password.
    security.sudo.wheelNeedsPassword = false;

    # Enable OpenRazer daemon.
    hardware.openrazer.enable = true;

    # Enable Steam.
    programs.steam.enable = true;

    # Enable PlantUML service.
    services.plantuml-server = {
        enable = true;
        packages.jdk = service_jdk;
        listenPort = 8081;
        graphvizPackage = pkgs.graphviz; # does not install the package
    };

    # System wide packages.
    programs.zsh.enable = true;
    environment.systemPackages = with pkgs; [
        lutris
        openrazer-daemon
        razergenie
        nil
        xdg-utils
        alsa-utils
        graphviz # For PlantUML diagrams
        neofetch
        beekeeper-studio
        youtube-music
        xwaylandvideobridge
        whatsie
        ani-cli
        gimp
        inkscape
        libreoffice
        onlyoffice-bin_latest
        ghidra-bin
        nix-alien
        protonmail-desktop
        hyprshot
        doxygen_gui
        python3
        python312Packages.pygame
        zig
        zls
        tiled
        aseprite
        asciidoctor
        gcc
        rubyPackages_3_3.rouge
        postman
        minikube
        kubernetes
        prismlauncher
        path-of-building
        ladybird
        nbfc-linux
        docker-compose
        figma-linux
        (callPackage gradle-packages.gradle_8 { # Make Gradle follow the correct JDK
            java = development_jdk;
        })
        kotlin
        jetbrains.idea-community-bin
        glava
        zap
        sonar-scanner-cli
    ];

    # GraalVM derivation to fix misplaced release file. IDE's now recognize it as a valid JDK.
    nixpkgs.overlays = [
        (self: super: {
            graalvm-ce = super.graalvm-ce.overrideAttrs (oldAttrs: {
            postInstall = oldAttrs.postInstall + ''
                # Symlink release file for IDE compatibility
                ln -s $out/share/release $out/release
            '';
            });
        })
    ];

    # Enable Java and add JAVA_HOME to the global environment.
    programs.java = {
        enable = true;
        package = development_jdk;
    };

    # Enable nbfc.
    # systemd.services.nbfc_service = {
    #     enable = true;
    #     description = "NoteBook FanControl service";
    #     serviceConfig.Type = "simple";
    #     path = [pkgs.kmod];
    #     script = "${pkgs.nbfc-linux}/${"bin/nbfc_service --config-file '/home/dinis/.config/nixos/modules/core/nbfc.json'"}";
    #     wantedBy = ["multi-user.target"];
    # };

    # Enavle VirtualBox.
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "dinis" ];

    # Enable Docker.
    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };

    # Enable MySQL server.
    services.mysql = {
        # To add a root password, do the following:
        # As superuser, run `mysql -u root`
        # Inside the MySQL shell, run `ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';`
        # Then, run `FLUSH PRIVILEGES;`
        # The password is now set.
        enable = true;
        package = pkgs.mariadb;
    };

    # Enable PostgreSQL server
    services.postgresql = {
        # You can access the databases with the username postgres without a password.
        # To add a user and a password (optional), do the following:
        # Run `sudo -u postgres psql`
        # Inside the psql shell, run `CREATE USER username WITH PASSWORD 'password';`
        # The user and password are now set.
        # To grant privileges to a database run: `GRANT ALL PRIVILEGES ON DATABASE "database" TO "username";`
        settings.port = 5433;
        enable = true;
        ensureDatabases = [ "web-test" ]; # Creates this database
        authentication = pkgs.lib.mkOverride 10 ''
            #type  database   DBuser  auth-method
            local  all        all     trust
            host   all        all     127.0.0.1/32   trust
        '';
    };

    # Enable Hamachi VPN + Haguichi GUI
    services.logmein-hamachi.enable = true;
    programs.haguichi.enable = true;

    # Enable flake support.
    nix.settings.experimental-features = [ "flakes" "nix-command" ];

    # SSH config.
    programs.ssh.extraConfig = "
        Host estgoh.ipc.pt
            SetEnv TERM=xterm-256color
	        KexAlgorithms diffie-hellman-group1-sha1
            HostKeyAlgorithms +ssh-rsa
            Ciphers aes128-cbc
    ";

    # system.autoUpgrade.channel = "https://channels.nixos.org/nixos-unstable";
    # system.stateVersion = "unstable"

    # System state version.
    system.stateVersion = "24.11";
}
