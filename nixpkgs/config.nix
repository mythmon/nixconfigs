{ pkgs ? import <nixpkgs>, ... }:

rec {
  allowUnfree = true;

  allowBroken = false;

  chromium = {
    enablePepperFlash = true;
    enablePepperPDF = true;
  };

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  pulseaudio = true;
}
