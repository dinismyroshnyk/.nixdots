{ inputs, pkgs, config, ... }:

{
    imports = [
        ./programs/git
        ./programs/zsh
        ./programs/nvim
        ./programs/lf
        ./programs/hyprland
        ./programs/kitty
        ./programs/firefox
        ./programs/vscode { inherit inputs; }
    ];

    home.stateVersion = "24.05";
}