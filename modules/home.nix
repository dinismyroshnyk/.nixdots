{ inputs, pkgs, config, ... }:

{
    imports = [
        ./programs/git
        ./programs/zsh
        ./programs/nvim
        ./programs/lf
        ./programs/hyprland
        ./programs/foot
        ./programs/firefox
        ./programs/vscode
    ];

    home.stateVersion = "24.05";
}