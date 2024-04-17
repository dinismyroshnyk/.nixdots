{ pkgs, ... }:

{
    imports = [
        # Desktop
        ./home/desktop/browser/firefox/default.nix
        ./home/desktop/term/foot/default.nix
        ./home/desktop/apps/hyprland/default.nix
        ./home/desktop/apps/waybar/default.nix
        ./home/desktop/apps/rofi/default.nix
        # Dev
        # Editors
        ./home/editors/nvim/default.nix
        ./home/editors/vscode/default.nix
        # Secrets
        # Shell
        ./home/shell/git/default.nix
        ./home/shell/lf/default.nix
        ./home/shell/zsh/default.nix
    ];

    # Fonts
    fonts.fontconfig.enable = true;
    home.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    home.stateVersion = "24.05";
}