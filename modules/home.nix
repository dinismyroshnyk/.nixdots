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

    home.stateVersion = "24.05";
}