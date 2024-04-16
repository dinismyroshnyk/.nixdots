{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.nushell;
in {
    options.modules.nushell = { enable = mkEnableOption "nushell"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ nushell ];
        programs = {
            nushell = {
                enable = true;
                extraConfig = ''
                    let carapace_completer = {|spans|
                        carapace $spans.0 nushell $spans | from json
                    }
                    $env.config = {
                        show_banner: false,
                        completions: {
                            case_sensitive: false # case-sensitive completions
                            quick: true    # set to false to prevent auto-selecting completions
                            partial: true    # set to false to prevent partial filling of the prompt
                            algorithm: "fuzzy"    # prefix or fuzzy
                            external: {
                                # set to false to prevent nushell looking into $env.PATH to find more suggestions
                                enable: true
                                # set to lower can improve completion performance at the cost of omitting some options
                                max_results: 100
                                completer: $carapace_completer # check 'carapace_completer'
                            }
                        }
                    }
                    let home_apps = $env.HOME + ".apps";
                    $env.PATH = ($env.PATH |
                        split row (char esep) |
                        prepend $home_apps |
                        append /usr/bin/env
                    )

                    # Shell aliases (easier to configure here than in shellAliases option)
                    let nixos_config_dir = $env.NIXOS_CONFIG_DIR;
                    let hostname = $env.HOSTNAME;
                    let flake = $nixos_config_dir + "#" + $hostname;

                    alias cls = clear;
                    alias rebuild = sudo nixos-rebuild switch --flake $flake;
                    alias update = nix flake update $nixos_config_dir;
                    alias upgrade = update;rebuild;
                '';
            };
            carapace = {
                enable = true;
                enableNushellIntegration = true;
            };
        };
    };
}