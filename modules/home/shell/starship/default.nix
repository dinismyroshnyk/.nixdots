{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.starship;
in {
    options.modules.starship = { enable = mkEnableOption "starship"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ starship ];
        programs.starship = {
            enable = true;
            enableZshIntegration = true;
            settings = {
                character = {
                    success_symbol = "[›](bold green)";
                    error_symbol = "[›](bold red)";
                };
                git_status = {
                    deleted = "✗";
                    modified = "✶";
                    staged = "✓";
                    stashed = "≡";
                };
                nix_shell = {
                    symbol = " ";
                    heuristic = true;
                };
            };
        };
    };
}