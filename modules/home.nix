{ inputs, pkgs, config, ... }:

{
    imports = [
        ./programs/git
        ./programs/zsh
    ];

    home.stateVersion = "23.11";
}