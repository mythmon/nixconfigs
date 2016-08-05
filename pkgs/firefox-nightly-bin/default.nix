{ pkgs }:

let
  baseUrl = "https://archive.mozilla.org/pub/firefox/nightly/latest-mozilla-central";

  firefox-nightly-bin-unwrapped = pkgs.callPackage <nixpkgs/pkgs/applications/networking/browsers/firefox-bin> {
    generated = rec {
      version = "51.0a1";
      sources = [
        rec {
          locale = "en-US";
          arch = "linux-x86_64";
          url = "${baseUrl}/firefox-${version}.${locale}.${arch}.tar.bz2";
          sha512 = "e85da53c6ea4bd1e5a088bf1dc137d02288d607738486c2d45dd2db0ac9a5817b2d6492a08abf47eed4d9c65bb63fce87dd9bd7356ec0ade6e6aac30e916acd2";
        }
      ];
    };
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
