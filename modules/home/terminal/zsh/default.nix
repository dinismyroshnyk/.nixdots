{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ zsh ];
        programs = {
            zsh = {
                enable = true;
                enableCompletion = true;
                autosuggestion.enable = true;
                syntaxHighlighting.enable = true;
                autocd = true;
                shellAliases = {
                    cls = "clear";
                    rebuild = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_DIR#$HOSTNAME";
                    update = "cp $NIXOS_CONFIG_DIR/flake.lock $NIXOS_CONFIG_DIR/backup/flake.lock; nix flake update $NIXOS_CONFIG_DIR";
                    upgrade = "update; rebuild";
                    restore = "cp $NIXOS_CONFIG_DIR/backup/flake.lock $NIXOS_CONFIG_DIR/flake.lock; rebuild";
                };
            };
        };
    };
}