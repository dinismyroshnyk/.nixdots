{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.modules.firefox;
in {
    options.modules.firefox = { enable = mkEnableOption "firefox"; };
    config = mkIf cfg.enable {
        programs.firefox = {
            package = pkgs.firefox-devedition-bin;
            enable = true;
            policies = {};
            profiles.dinis = {
                isDefault = true;
                path = "$HOME/.mozila/firefox";
                extensions = with pkgs.nur.repos.rycee.firefox-addons; [
                    ublock-origin
                    sponsorblock
                    return-youtube-dislikes
                    youtube-nonstop
                    improved-tube
                ];
                settings = {
                    # Disable telemetry
                    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
                    "browser.ping-centre.telemetry" = false;
                    "browser.tabs.crashReporting.sendReport" = false;
                    "devtools.onboarding.telemetry.logged" = false;
                    "toolkit.telemetry.enabled" = false;
                    "toolkit.telemetry.unified" = false;
                    "toolkit.telemetry.server" = "";
                    # Disable Pocket
                    "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
                    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                    "browser.newtabpage.activity-stream.showSponsored" = false;
                    "extensions.pocket.enabled" = false;
                    # Theming
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                };
                bookmarks = [
                    {
                        name = "Toolbar";
                        toolbar = true;
                        bookmarks = [
                            {
                                name = "ESTGOH";
                                bookmarks = [
                                    { name = "Inforestudante"; url = "https://inforestudante.ipc.pt/nonio/security/login.do"; }
                                    { name = "SOGo"; url = "https://mailsecure.estgoh.ipc.pt/SOGo"; }
                                    { name = "Moodle"; url = "https://elearning2.estgoh.ipc.pt/login"; }
                                    { name = "Cisco Academy"; url = "https://id.cisco.com/signin"; }
                                ];
                            }
                            {
                                name = "NixOS";
                                bookmarks = [
                                    { name = "NixOS"; url = "https://nixos.org/"; }
                                    { name = "NixOS Wiki"; url = "https://nixos.wiki/"; }
                                    { name = "NixOS Discourse"; url = "https://discourse.nixos.org/"; }
                                    { name = "Home Manager Options"; url = "https://nix-community.github.io/home-manager/options.html"; }
                                    { name = "MyNixOS"; url = "https://mynixos.com/"; }
                                ];
                            }
                        ];
                    }
                ];
                userChrome = lib.readFile ./chrome/userChrome;
                userContent = ""; # user content css - web pages
                extraConfig = ""; # user.js
            };
        };
        home.sessionVariables = {
            MOZ_ENABLE_WAYLAND = "1";
            MOZ_USE_XINPUT2 = "1";
            BROWSER = "firefox-developer-edition";
        };
    };
}