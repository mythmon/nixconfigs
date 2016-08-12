{ pkgs }:

let
  baseUrl = "https://archive.mozilla.org/pub/firefox/nightly/latest-mozilla-central";

  firefox-nightly-bin-unwrapped = pkgs.callPackage <nixpkgs/pkgs/applications/networking/browsers/firefox-bin> {
    generated = import ./sources.nix;
    gconf = pkgs.gnome.GConf;
    inherit (pkgs.gnome) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  firefox-nightly-bin = pkgs.wrapFirefox firefox-nightly-bin-unwrapped {
    browserName = "firefox";
    name = "firefox-bin-nightly-" +
      (builtins.parseDrvName firefox-nightly-bin-unwrapped.name).version;
    desktopName = "Nightly";
  };

in firefox-nightly-bin
