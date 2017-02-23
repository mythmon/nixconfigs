{ pkgs }:

let
  firefox-unbranded-bin-unwrapped = pkgs.callPackage "${pkgs.path}/pkgs/applications/networking/browsers/firefox-bin" {
    generated = import ./sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  firefox-unbranded-bin = pkgs.wrapFirefox firefox-unbranded-bin-unwrapped {
    browserName = "firefox";
    name = "firefox-unbranded-bin-" +
      (builtins.parseDrvName firefox-unbranded-bin-unwrapped.name).version;
    desktopName = "Firefox (Unbranded)";
  };

in firefox-unbranded-bin
