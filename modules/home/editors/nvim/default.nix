{ lib, config, ... }:

with lib;

let
    cfg = config.modules.nvim;
in {
    options.modules.nvim = { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {
        programs.nixvim = {
            enable = true;
            colorschemes.catppuccin.enable = true;
            plugins = {
                lualine.enable = true;
            };
        };
    };
}