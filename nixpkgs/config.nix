{ pkgs ? import <nixpkgs>, ... }:

rec {
  allowUnfree = true;

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
