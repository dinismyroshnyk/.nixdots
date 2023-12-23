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
                    "reader.parse-on-load.enabled" = false;
                    "browser.tabs.firefox-view" = false;
                };
                userChrome = lib.readFile ./userChrome.css;
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