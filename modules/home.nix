{ inputs, pkgs, config, ... }:

{
    imports = [
        /home/dinis/.nixdots/modules/programs/git
        /home/dinis/.nixdots/modules/programs/zsh
    ];

    home.stateVersion = "23.11";
}