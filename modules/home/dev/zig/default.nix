{ lib, config, ... }:

with lib;

let
    cfg = config.modules.zig;
in {
    options.modules.zig = { enable = mkEnableOption "zig"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs'; [
            zigpkgs.master
            zigpkgs.zls
        ];
    };
}