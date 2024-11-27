{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [ zsh ];
        programs = {
            zsh = {
                enable = true;
                enableCompletion = true;
                autosuggestion.enable = true;
                syntaxHighlighting.enable = true;
                autocd = true;
                shellAliases = {
                    cls = "clear";
                    rebuild = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_DIR#$HOSTNAME";
                    update = "cp $NIXOS_CONFIG_DIR/flake.lock $NIXOS_CONFIG_DIR/backup/flake.lock; nix flake update --flake $NIXOS_CONFIG_DIR";
                    upgrade = "update; rebuild";
                    restore = "cp $NIXOS_CONFIG_DIR/backup/flake.lock $NIXOS_CONFIG_DIR/flake.lock; rebuild";
                    # build-vm = "rm vmtest.qcow2; sudo nixos-rebuild build-vm -I nixos-config=./configuration.nix";
                    build-vm = "rm vm-test.qcow2; sudo nix build .#nixosConfigurations.vm-test.config.system.build.vm";
                    run-vm-term = "QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-vm-test-vm -nographic; reset";
                    run-vm = "./result/bin/run-vm-test-vm";
                };
            };
        };
    };
}