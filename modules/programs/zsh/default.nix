{ pkgs, lib, config, ... }:

with lib;

let 
    cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ zsh ];
        programs.zsh = {
            enable = true;
            enableCompletion = true;
            enableAutosuggestions = true;
            syntaxHighlighting.enable = true;

            shellAliases = {
                rebuild = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_DIR#$HOSTNAME --impure";
            };
        };
    };
}