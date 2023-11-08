{ inputs, pkgs, config, ... }:

{
    imports = [
        ./programs/git
        ./programs/zsh
        ./programs/nvim
        ./programs/lf
        ./programs/hyprland
    ];

    home.stateVersion = "23.11";
}