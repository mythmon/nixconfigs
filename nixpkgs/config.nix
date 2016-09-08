{ pkgs ? import <nixpkgs> }:

rec {
  allowUnfreePredicate = pkg: (
    pkgs.lib.hasPrefix "firefox-" pkg.name ||
    pkgs.lib.hasPrefix "steam-" pkg.name ||
    pkgs.lib.hasPrefix "corefonts-" pkg.name ||
    pkgs.lib.hasPrefix "spotify-" pkg.name ||
    pkgs.lib.hasPrefix "flashplayer-" pkg.name ||
    pkgs.lib.hasPrefix "google-talk-plugin-" pkg.name
  );

  packageOverrides = pkgs: rec {
    # Hold atom at 1.6.2, since it works.
    atom = pkgs.lib.overrideDerivation pkgs.atom (attrs: {
      name = "atom-1.6.2";
      src = pkgs.fetchurl {
        url = "https://github.com/atom/atom/releases/download/v1.6.2/atom-amd64.deb";
        sha256 = "1kl2pc0smacn4lgk5wwlaiw03rm8b0763vaisgp843p35zzsbc9n";
        name = "atom-1.6.2.deb";
      };
    });
  };

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  chromium = {
    enablePepperFlash = true;
    enablePepperPDF = true;
  };

  pulseaudio = true;
}
