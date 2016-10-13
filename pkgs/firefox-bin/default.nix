{ lib, pkgs, browserName }:

let
  firefox-bin-unwrapped = pkgs.callPackage "${pkgs.path}/pkgs/applications/networking/browsers/firefox-bin" {
    generated = lib.getAttr browserName (import ./sources.nix);
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  firefox-bin = pkgs.wrapFirefox firefox-bin-unwrapped {
    browserName = "firefox";
    name = "firefox-${browserName}-bin-${(builtins.parseDrvName firefox-bin-unwrapped.name).version}";
    desktopName = lib.toUpper (lib.substring 0 1 browserName) + lib.substring 1 (-1) browserName;
  };

in
  firefox-bin
