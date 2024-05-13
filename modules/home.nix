{ pkgs, ... }:

{
    imports = [
        # Desktop
        ./home/desktop/browser/firefox/default.nix
        ./home/desktop/wayland/default.nix
        ./home/desktop/apps/rofi/default.nix
        ./home/desktop/apps/cava/default.nix
        ./home/desktop/apps/discord/default.nix
        # Dev
        # Editors
        ./home/editors/nvim/default.nix
        ./home/editors/vscode/default.nix
        # Secrets
        # Terminal
        ./home/terminal/foot/default.nix
        ./home/terminal/git/default.nix
        ./home/terminal/lf/default.nix
        ./home/terminal/zsh/default.nix
        ./home/terminal/starship/default.nix
        ./home/terminal/zellij/default.nix
    ];

    # Fonts
    fonts.fontconfig.enable = true;

    home.packages = [
        pkgs.nerdfonts
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        pkgs.twemoji-color-font
        pkgs.noto-fonts-emoji
    ];

    gtk = {
        enable = true;
        font = {
            name = "JetBrainsMono Nerd Font";
            size = 10;
        };
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.catppuccin-papirus-folders.override {
                flavor = "mocha";
                accent = "lavender";
            };
        };
        theme = {
            name = "Catppuccin-Mocha-Compact-Lavender-Dark";
            package = pkgs.catppuccin-gtk.override {
                accents = [ "lavender" ];
                size = "compact";
                variant = "mocha";
            };
        };
        cursorTheme = {
            name = "Nordzy-cursors";
            package = pkgs.nordzy-cursor-theme;
            size = 22;
        };
    };

    home.pointerCursor = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 22;
    };

    home.stateVersion = "24.05";
}