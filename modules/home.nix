{ inputs, pkgs, config, ... }:

{
    imports = [
        # Desktop
        ./desktop/browser/firefox/default.nix
        ./desktop/term/foot/default.nix
        ./desktop/wayland/hyprland/default.nix
        # Dev
        # Editors
        ./editors/nvim/default.nix
        ./editors/vscode/default.nix
        # Secrets
        # Shell
        ./shell/git/default.nix
        ./shell/lf/default.nix
        ./shell/zsh/default.nix
    ];

    # Fonts
    fonts.fontconfig.enable = true;
    home.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    home.stateVersion = "24.05";
}