{ ... }:

{
    imports = [ ../../modules/home.nix ];

    config.modules = {
        git.enable = true;
        zsh.enable = true;
        nvim.enable = true;
        lf.enable = true;
        hyprland.enable = true;
        waybar.enable = true;
        foot.enable = true;
        firefox.enable = true;
        vscode.enable = true;
        rofi.enable = true;
    };
}