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
                    zoomLevel = -1;
                };
                workbench = {
                    colorTheme = "Ocean High Contrast";
                    iconTheme = "material-icon-theme";
                };
                editor = {
                    fontFamily = "'JetBrainsMono NF', 'monospace', monospace";
                    fontLigatures = true;
                    fontSize = 15;
                    cursorSurroundingLines = 15;
                    cursorBlinking = "phase";
                    cursorStyle = "underline";
                    cursorSmoothCaretAnimation = true;
                    bracketPairColorization.enabled = true;
                    guides.bracketPairs = "active";
                    minimap.enabled = true;
                    minimap.renderCharacters = false;
                    wordWrap = "on";
                };
                terminal.integrated = {
                    cursorBlinking = true;
                    cursorStyle = "underline";
                    fontSize = 15;
                };
                github.copilot.enable = {
                    "*" = true;
                    "plaintext" = true;
                    "markdown" = true;
                    "scminput" = false;
                };
                security.workspace.trust.untrustedFiles = "open";
                nix.enableLanguageServer = "true";
                nix.serverPath = "nil";
                telemetry.telemetryLevel = "off";
            };
            languageSnippets = {};
        };
    };
}