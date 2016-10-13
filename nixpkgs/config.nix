{ pkgs ? import <nixpkgs>, ... }:

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

  chromium = {
    enablePepperFlash = true;
    enablePepperPDF = true;
  };

  packageOverrides = pkgs: {
    steamcontroller-udev-rules = pkgs.writeTextFile {
      name = "steamcontroller-udev-rules";
      text = ''
        # This rule is needed for basic functionality of the controller in
        # Steam and keyboard/mouse emulation
        SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"

        # This rule is necessary for gamepad emulation
        KERNEL=="uinput", MODE="0660", GROUP="wheel", OPTIONS+="static_node=uinput"
        # systemd option not yet tested
        #KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", TAG+="udev-acl"
      '';
      destination = "/etc/udev/rules.d/99-steamcontroller.rules";
    };
  };

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  pulseaudio = true;
}
