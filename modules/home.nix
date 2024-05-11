{ pkgs, ... }:

{
    imports = [
        # Desktop
        ./home/desktop/browser/firefox/default.nix
        ./home/desktop/wayland/default.nix
        ./home/desktop/apps/rofi/default.nix
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
        ./home/terminal/tmux/default.nix
    ];

    # Fonts
    fonts.fontconfig.enable = true;
    home.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    home.stateVersion = "24.05";
}