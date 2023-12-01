{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/home.nix ];

    config.modules = {
        git.enable = true;
        zsh.enable = true;
        nvim.enable = true;
        lf.enable = true;
        hyprland.enable = false;
    };
}