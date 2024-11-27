{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.vscode;
in {
    options.modules.vscode = { enable = mkEnableOption "vscode"; };
    config = mkIf cfg.enable {
        programs.vscode = {
            enable = true;
            package = pkgs.vscode-fhs;
            enableUpdateCheck = false;
            userSettings = {
                "window.titleBarStyle" = "custom";
                "window.menuBarVisibility" = "compact";
                "window.zoomLevel" = 1;

                "workbench.colorTheme" = "Ocean High Contrast";
                "workbench.iconTheme" = "material-icon-theme";
                "workbench.startupEditor" = "none";

                "editor.fontFamily" = "'JetBrainsMono NF', 'monospace'";
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
                "editor.tabSize" = 4;
                "editor.insertSpaces" = true;
                "editor.detectIndentation" = false;

                "terminal.integrated.cursorBlinking" = true;
                "terminal.integrated.cursorStyle" = "underline";
                "terminal.integrated.fontSize" = 12;

                # "github.copilot.enable" = {
                #     "*" = true;
                #     "plaintext" = true;
                #     "markdown" = true;
                #     "scminput" = false;
                # };
                "git.autofetch" = true;

                "nix.enableLanguageServer" = true;
                "nix.serverPath" = "nil";

                "security.workspace.trust.enabled" = false;
                "telemetry.telemetryLevel" = "all";

                "update.showReleaseNotes" = false;
                "update.mode" = "none";

                "typewriterAutoScroll.enable" = true;

                "sqltools.autoOpenSessionFiles" = false;

                "java.debug.settings.console" = "integratedTerminal";

                "terminal.external.linuxExec" = "foot";

                "zig.formattingProvider" = "off";
                "zig.path" = "/run/current-system/sw/bin/zig";
                "zig.zls.path" = "/run/current-system/sw/bin/zls";
                "zig.initialSetupDone" = true;

                "asciidoc.antora.showEnableAntoraPrompts" = false;

                "plantuml.commandArgs" = [
                    "-DGRAPHVIZ_DOT=/run/current-system/sw/bin/dot"
                ];
                "plantuml.server" = "http://localhost:8081/plantuml/png";
                "plantuml.render" = "PlantUMLServer";

                "[nix]" = {
                    "editor.tabSize" = 4;
                };

                "python.analysis.extraPaths" = [
                    "\${workspaceFolder}/.venv/lib/python3.*/site-packages"
                ];
                "python.defaultInterpreterPath" = "\${workspaceFolder}/.venv/bin/python";

                "files.exclude" = {
                    "**/.git" = true;
                    "**/.svn" = true;
                    "**/.hg" = true;
                    "**/CVS" = true;
                    "**/.DS_Store" = true;
                    "**/Thumbs.db" = true;
                    "**/__pycache__" = true;
                };

                "codescene.enableAutoRefactor" = false;
            };
            languageSnippets = {};
        };
        home.activation = {
            clearOldSettings = {
                after = [];
                before = [ "checkLinkTargets" ];
                data = "
                    userDir=$HOME/.config/Code/User
                    rm -rf $userDir/settings.json
                ";
            };
            regenerateSettings =
                let
                    inherit (config) programs;
                    userSettings = programs.vscode.userSettings;
                in {
                    after = [ "writeBoundary" ];
                    before = [];
                    data = ''
                        userDir=~/.config/Code/User
                        rm -rf $userDir/settings.json
                        cat ${pkgs.writeText "tmp_vscode_settings" (builtins.toJSON userSettings)} | jq --monochrome-output > $userDir/settings.json
                    '';
                };
        };
    };
}
