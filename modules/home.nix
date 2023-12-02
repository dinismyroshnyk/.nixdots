{ inputs, pkgs, config, ... }:

{
    imports = [
        ./programs/git
        ./programs/zsh
        ./programs/nvim
        ./programs/lf
        ./programs/hyprland
        ./programs/kitty
    ];

    home.stateVersion = "24.05";
}