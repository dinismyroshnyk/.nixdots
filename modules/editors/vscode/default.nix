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
        phind.phind
        alefragnani.project-manager
        akhail.save-typing
        shardulm94.trailing-spaces
        tomoki1207.pdf
        drcika.apc-extension
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
                "window.zoomLevel" = -1;

                "workbench.colorTheme" = "Ocean High Contrast";
                "workbench.iconTheme" = "material-icon-theme";

                "editor.fontFamily" = "'JetBrainsMono NF', 'monospace', monospace";
                "editor.fontLigatures" = true;
                "editor.fontSize" = 12;
                "editor.cursorSurroundingLines" = 15;
                "editor.cursorBlinking" = "phase";
                "editor.cursorStyle" = "underline";
                "editor.cursorSmoothCaretAnimation" = true;
                "editor.bracketPairColorization.enabled" = true;
                "editor.guides.bracketPairs" = "active";
                "editor.minimap.enabled" = true;
                "editor.minimap.renderCharacters" = false;
                "editor.wordWrap" = "on";

                "terminal.integrated.cursorBlinking" = true;
                "terminal.integrated.cursorStyle" = "underline";
                "terminal.integrated.fontSize" = 12;

                "github.copilot.enable" = {
                    "*" = true;
                    "plaintext" = true;
                    "markdown" = true;
                    "scminput" = false;
                };

                "nix.enableLanguageServer" = true;
                "nix.serverPath" = "nil";

                "security.workspace.trust.untrustedFiles" = "open";
                "telemetry.telemetryLevel" = "off";
            };
            languageSnippets = {};
        };
    };
}
