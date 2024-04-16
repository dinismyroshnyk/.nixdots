{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.nushell;
in {
    options.modules.nushell = { enable = mkEnableOption "nushell"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ nushell ];
        programs.nushell = {
            enable = true;
            extraConfig = '''';
            shellAliases = {
                rebuild = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_DIR#$HOSTNAME";
                update = "nix flake update $NIXOS_CONFIG_DIR";
                upgrade = "update; rebuild";
                cls = "clear";
            };
            carapace.enable = true;
            carapace.enableNushellIntegration = true;
            starship = { enable = true;
                settings = {
                    add_newline = true;
                    character = {
                        success_symbol = "[➜](bold green)";
                        error_symbol = "[➜](bold red)";
                    };
                };
            };
        };
    };
}