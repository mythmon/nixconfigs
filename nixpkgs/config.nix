{ pkgs ? import <nixpkgs> }:

rec {
  allowUnfreePredicate = pkg: (
    pkgs.lib.hasPrefix "firefox-" pkg.name ||
    pkgs.lib.hasPrefix "steam-" pkg.name ||
    pkgs.lib.hasPrefix "corefonts-" pkg.name ||
    pkgs.lib.hasPrefix "spotify-" pkg.name ||
    pkgs.lib.hasPrefix "flashplayer-" pkg.name ||
    pkgs.lib.hasPrefix "google-talk-plugin-" pkg.name ||
    pkgs.lib.hasPrefix "minecraft-" pkg.name
  );

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
