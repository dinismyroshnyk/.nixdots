{ pkgs, lib, config, ... }:

with lib;

let 
    cfg = config.modules.firefox;
in {
    options.modules.firefox = { enable = mkEnableOption "firefox"; };
    config = mkIf cfg.enable {
        programs.firefox = {
            enable = true;
            profiles.dinis = {
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
                };
                bookmarks = [
                    {
                        name = "wikipedia";
                        tags = [ "wiki" ];
                        keyword = "wiki";
                        url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
                    }
                    {
                        name = "kernel.org";
                        url = "https://www.kernel.org";
                    }
                    {
                        name = "Nix sites";
                        toolbar = true;
                        bookmarks = [
                        {
                            name = "homepage";
                            url = "https://nixos.org/";
                        }
                        {
                            name = "wiki";
                            tags = [ "wiki" "nix" ];
                            url = "https://nixos.wiki/";
                        }
                        ];
                    }
                ];
                userChrome = "";
            };
        };
    };
}