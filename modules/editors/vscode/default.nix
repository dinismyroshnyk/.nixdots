{ pkgs, lib, config, inputs, ... }:

with lib;

let 
    cfg = config.modules.vscode;
    vscodeExtensions = with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
        codescene.codescene-vscode
        notyasho.ocean-high-contrast
        pkief.material-icon-theme
        jnoortheen.nix-ide
    ];
in {
    options.modules.vscode = { enable = mkEnableOption "vscode"; };
    config = mkIf cfg.enable {
        programs.vscode = {
            enable = true;
            enableUpdateCheck = false;
            extensions = vscodeExtensions;
            userSettings = {
                "window.titleBarStyle" = "custom";
                "window.menuBarVisibility" = "compact";
                "security.workspace.trust.untrustedFiles" = "open";
                "workbench.colorTheme" = "Ocean High Contrast";
                "workbench.iconTheme" = "material-icon-theme";
                "nix.enableLanguageServer" = "true";
                "nix.serverPath" = "nil";
            };
            languageSnippets = {};
        };
    };
}