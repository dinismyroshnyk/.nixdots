{ lib, config, ... }:

with lib;

let
    cfg = config.modules.nvim;
in {
    options.modules.nvim = { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {
        programs.neovim = {
            enable = true;
            extraConfig = lib.fileContents ./init.lua;
        };
    };
}