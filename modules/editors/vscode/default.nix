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
        github.copilot-chat
        usernamehw.errorlens
        oderwat.indent-rainbow
        bbenoist.nix
        phind.phind
        alefragnani.project-manager
        akhail.save-typing
        shardulm94.trailing-spaces
        tomoki1207.pdf
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
                    cursorSurroundingLines = 15;
                    cursorBlinking = "phase";
                    cursorStyle = "underline";
                    cursorSmoothCaretAnimation = true;
                    bracketPairColorization.enabled = true;
                    guides.bracketPairs = "active";
                };
                terminal.integrated = {
                    cursorBlinking = true;
                    cursorStyle = "underline";
                };
                "security.workspace.trust.untrustedFiles" = "open";
                "nix.enableLanguageServer" = "true";
                "nix.serverPath" = "nil";
            };
            languageSnippets = {};
        };
    };
}