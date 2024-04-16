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
                    $env.PATH = ($env.PATH |
                    split row (char esep) |
                    prepend /home/myuser/.apps |
                    append /usr/bin/env
                    )

                    # Shell custom definitions (complex aliases)
                    def update [] {
                        let nixos_config_dir = $env.NIXOS_CONFIG_DIR
                        nix flake update $nixos_config_dir
                    }
                    def rebuild [] {
                        let nixos_config_dir = $env.NIXOS_CONFIG_DIR
                        let hostname = $env.HOSTNAME
                        let flake = $nixos_config_dir + "#" + $hostname
                        sudo nixos-rebuild switch --flake $flake
                    }
                '';
                shellAliases = {
                    cls = "clear";
                    upgrade = "update;rebuild";
                };
            };
            carapace = {
                enable = true;
                enableNushellIntegration = true;
            };
        };
    };
}