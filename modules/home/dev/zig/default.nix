{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.zig;
in {
    options.modules.zig = { enable = mkEnableOption "zig"; };
    config = mkIf cfg.enable {
        programs.zig = {
            enable = true;
            package = pkgs.zig.master;
        };
    };
}