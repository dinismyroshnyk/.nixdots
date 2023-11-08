{ inputs, pkgs, config, ... }:

{
    imports = [
        ./programs/git
        ./programs/zsh
        ./nvim
    ];

    home.stateVersion = "23.11";
}