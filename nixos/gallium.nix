{ config, pkgs, fetchurl, lib, ... }:

rec {
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
    cleanTmpDir = true;

    initrd = {
      availableKernelModules = [
        "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"
      ];

      luks.devices = [
        { device = "/dev/nvme0n1p3"; name = "cipher"; }
      ];
    };

    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    tmpOnTmpfs = true;
  };

  environment.systemPackages = with pkgs; [
    steamcontroller-udev-rules
    vim
    wget
    zsh
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b6b47ef1-0272-4af5-89ba-df3b6251439e";
      fsType = "btrfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/D600-4F06";
      fsType = "vfat";
    };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      fira-code
      font-awesome-ttf
      inconsolata
      noto-fonts-emoji
      ubuntu_font_family
      unifont
    ];
  };

  hardware = {
    bluetooth.enable = true;
    opengl = {
      driSupport32Bit = true;
      extraPackages = [ pkgs.vaapiIntel ];
    };
    pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        8000 # Web stuff
        22000 # Syncthing
      ];
    };
    hostName = "gallium";
    networkmanager.enable = true;
  };

  nix = {
    maxJobs = 4;
    buildCores = 4;
    extraOptions = "auto-optimize-store = true";
    gc = {
      automatic = false;
      dates = "13:15";
    };
  };

  nixpkgs = {
    config = (import ./../nixpkgs/config.nix { pkgs = pkgs; });
  };

  programs = {
    zsh.enable = true;
  };

  services = {
    avahi.enable = true;

    chrony.enable = true;

    locate = {
      enable = true;
      extraFlags = [
        "--prunepaths='/nix/store /data/@oldlaptop-mut /.snapshot'"
      ];
      interval = "hourly";
    };

    pcscd.enable = true; # For yubikey

    postgresql.enable = true;

    printing = {
      drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
      enable = true;
    };

    ntp.enable = false;

    redshift = {
      enable = true;
      latitude = "45.5";
      longitude = "-122.5";
    };

    syncthing = {
      enable = true;
      useInotify = true;
    };

    tlp.enable = true; # For power management

    xserver = {
      enable = true;
      windowManager.herbstluftwm.enable = true;
      displayManager.slim = {
        enable = true;
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
        pkgs.steamcontroller-udev-rules
      ];
    };
  };

  system = {
    autoUpgrade.enable = true;
    copySystemConfiguration = true;
    # The NixOS release to be compatible with for stateful data such as databases.
    stateVersion = "16.03";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b44bc529-a5ab-46c9-917b-378471473327"; }
  ];

  time.timeZone = "America/Los_Angeles";

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    virtualbox.host.enable = false;
  };

  users = {
    groups.sync = { };

    users = {
      mythmon = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [
          "audio"
          "docker"
          "input"
          "sync"
          "networkmanager"
          "video"
          "wheel"
        ];
        shell = "/run/current-system/sw/bin/zsh";
        createHome = true;
      };

      syncthing = {
        extraGroups = ["sync"];
      };
    };
  };
}
