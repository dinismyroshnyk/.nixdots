{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.tmux;
in {
    options.modules.tmux = { enable = mkEnableOption "tmux"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ tmux ];
        programs.tmux = {
            enable = true;
            clock24 = true;
            shell = "${pkgs.zsh}/bin/zsh";
            terminal = "tmux-256color";
            prefix = "C-b";
        };
    };
}