{ config, pkgs, fetchurl, lib, ... }:

rec {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_testing;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.luks.devices = [
      { device = "/dev/nvme0n1p3"; name = "cipher"; }
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
  ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      fira-code
      font-awesome-ttf
      inconsolata
      ubuntu_font_family
      unifont
    ];
  };

  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
  };

  networking = {
    hostName = "gallium";
    networkmanager.enable = true;
  };

  nix = {
    maxJobs = 4;
    buildCores = 4;
    extraOptions = "auto-optimize-store = true";
    gc = {
      automatic = true;
      dates = "13:15";
    };
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    locate.enable = true;
    pcscd.enable = true; # For yubikey
    postgresql.enable = true;
    printing.enable = true;
    syncthing.enable = true;
    tlp.enable = true; # For power management

    xserver = {
      enable = true;
      windowManager.herbstluftwm.enable = true;
      displayManager.slim = {
        enable = true;
        defaultUser = "mythmon";
        autoLogin = true;
      };

      libinput = {
        enable = true;
        middleEmulation = false;
        naturalScrolling = true;
        buttonMapping = "1 3 2";
        clickMethod = "clickfinger";
      };
    };

    udev = {
      extraRules = ''
        ACTION=="remove", ENV{ID_VENDOR_ID}="1050″, ENV{SUBSYSTEM}=="usb", \
          RUN+="${pkgs.procps}/bin/pkill scdaemon"
      '';
      packages = [
        pkgs.libu2f-host
        pkgs.yubikey-personalization
      ];
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system = {
    autoUpgrade.enable = true;
    copySystemConfiguration = true;
    stateVersion = "16.03";
  };

  time.timeZone = "America/Los_Angeles";

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users = {
    groups.money = { };

    users.mythmon = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "audio"
        "docker"
        "input"
        "money"
        "networkmanager"
        "video"
        "wheel"
      ];
      shell = "/run/current-system/sw/bin/zsh";
      createHome = true;
    };
  };
}
