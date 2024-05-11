{ ... }:

{
    imports = [ ../../modules/home.nix ];

    config.modules = {
        git.enable = true;
        zsh.enable = true;
        nvim.enable = true;
        lf.enable = true;
        wayland.enable = true;
        waybar.enable = true;
        foot.enable = true;
        firefox.enable = true;
        vscode.enable = true;
        rofi.enable = true;
        tmux.enable = true;
        starship.enable = true;
    };
}