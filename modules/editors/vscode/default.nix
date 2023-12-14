{ pkgs, lib, config, inputs, ... }:

with lib;

let 
    cfg = config.modules.vscode;
    vscodeExtensions = with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
        codescene.codescene-vscode
        notyasho.ocean-high-contrast
        pkief.material-icon-theme
        jnoortheen.nix-ide
        github.vscode-pull-request-github
        github.copilot
    ];
in {
    options.modules.vscode = { enable = mkEnableOption "vscode"; };
    config = mkIf cfg.enable {
        programs.vscode = {
            enable = true;
            enableUpdateCheck = false;
            extensions = vscodeExtensions;
            userSettings = {
                window = {
                    titleBarStyle = "custom";
                    menuBarVisibility = "compact";
                };
                workbench = {
                    colorTheme = "Ocean High Contrast";
                    iconTheme = "material-icon-theme";
                };
                editor = {
                    fontFamily = "'JetBrainsMono NF', 'monospace', monospace";
                    fontSize = 10;
                };
                "security.workspace.trust.untrustedFiles" = "open";
                "nix.enableLanguageServer" = "true";
                "nix.serverPath" = "nil";
            };
            languageSnippets = {};
        };
    };
}