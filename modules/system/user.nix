# SEARCH WITH CTRL+F FOR MODULES YOU WANT TO TURN OFF.

{ pkgs, ... }:

let 
    username = "dinis";
    hostname = "vm-test";
in {
    # Define a user account.
    users.users.${username} = {
        shell = pkgs.zsh; # (COMMENT IF ZSH.ENABLE = FALSE)
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
        NIXOS_CONFIG_DIR = "$HOME/.nixdots/";
        HOSTNAME = "${hostname}";
        EDITOR = "nvim"; # (COMMENT IF NVIM.ENABLE = FALSE)
    };

    # Disable prompt for sudo password.
    security.sudo.wheelNeedsPassword = false;

    # System wide packages.
    programs.zsh.enable = true; # (COMMENT IF ZSH.ENABLE = FALSE)

    # Include the variables in the set block returned by the file.
    username= username;
    hostname = hostname;
}