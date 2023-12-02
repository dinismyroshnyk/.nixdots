{ pkgs, lib, config, ... }:

with lib;

let 
    cfg = config.modules.vscode;
    vscodeExtensions = with pkgs.nix-vscode-extensions.extensions; [
        codescene.codescene-vscode
        notyasho.ocean-high-contrast
    ];
in {
    options.modules.vscode = { enable = mkEnableOption "vscode"; };
    config = mkIf cfg.enable {
        programs.vscode = {
            enable = true;
            extensions = vscodeExtensions;
        };
    };
}