{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.PROGRAM_NAME;
in {
    options.modules.PROGRAM_NAME = { enable = mkEnableOption "PROGRAM_NAME"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ PROGRAM_NAME ];
        programs.PROGRAM_NAME = {
            enable = true;
            # Home manager configuration
        };
    };
}