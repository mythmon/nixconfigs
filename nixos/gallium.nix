{ pkgs, ... }:

let

  mypkgs = import ../pkgs/default.nix { };
  mozpkgs = import ../../nixpkgs-mozilla/default.nix { };
  secrets = import ./secrets.nix;

in rec {
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./base.nix
  ];

  boot = {
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
  };

  environment.systemPackages = with pkgs; [
    mypkgs.ripgrep

    mozpkgs.firefox-developer-bin

    acpi
    arandr
    ascii
    atom
    bc
    bind
    chromium
    compton
    cpufrequtils
    dmenu
    graphviz
    dzen2
    evince
    file
    gimp
    git
    gitAndTools.diff-so-fancy
    gitAndTools.hub
    gnome3.vinagre
    gnumeric
    gnupg1compat
    hsetroot
    htop
    httpie
    i3lock
    iftop
    inkscape
    iotop
    ipfs
    iw
    jq
    keybase
    keychain
    lftp
    lm_sensors
    lsof
    mercurial
    moreutils
    mosh
    mplayer
    mtr
    ncdu
    networkmanagerapplet
    nix-prefetch-scripts
    nix-zsh-completions
    nodejs
    nox
    openvpn
    p7zip
    pass
    patchelf
    pavucontrol
    pciutils
    playerctl
    powertop
    python3
    pwgen
    scrot
    sgtpuzzles
    skype
    sshfs-fuse
    stalonetray
    steam
    taskwarrior
    termite
    tig
    tree
    units
    unzip
    usbutils
    vim_configurable
    vlc
    watch
    watchman
    xclip
    xorg.xbacklight
    xorg.xev
    yabar
    zip
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
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [ pkgs.vaapiIntel ];
    };

    pulseaudio = {
      enable = true;
      support32Bit = true;
      systemWide = false;
      package = pkgs.pulseaudioFull;
      tcp = {
        anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
        enable = true;
      };
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
  };

  nixpkgs = {
    config = (import ../nixpkgs/config.nix { pkgs = pkgs; });
  };

  services = {
    avahi.enable = true;

    # Too much difficulty getting this to be performant
    # TODO: prunt git and hg directories?
    # locate.extraFlags = "--prunepaths='/nix/store /data/@oldlaptop-mut /.snapshot'"

    mopidy = {
      enable = true;

      extensionPackages = [
        pkgs.mopidy-moped
        pkgs.mopidy-gmusic
      ];

      configuration = ''
        [audio]
        output = pulsesink server=127.0.0.1

        [http]
        enabled = true
        hostname = 127.0.0.1
        port = 6680

        [mpd]
        enabled = true
        hostname = 127.0.0.1
        port = 6600

        [local]
        enabled = true
        media_dir = /data/music

        [file]
        enabled = true
        media_dirs =
          /data/music

        [gmusic]
        radio_tracks_count = 25
        all_access = true
        bitrate = 320
        username = mythmon@gmail.com
        password = ${secrets.google-mopidy-app-password}
        radio_stations_in_browse = true
        radio_stations_as_playlists = true
        radio_stations_count = 10
        deviceid = ${secrets.google-mopidy-device-id}
        refresh_library = 1440
        refresh_playlists = 60
      '';
    };

    pcscd.enable = true; # For yubikey

    postgresql.enable = true;

    printing = {
      drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
      enable = true;
    };

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
      ];
    };
  };

  systemd = let
    btrfs-snap-service = interval: count: {
      description = "Snapshot BTRFS root (${interval})";
      path = [
        mypkgs.btrfs-snap
        pkgs.utillinux
        pkgs.perl
        pkgs.btrfs-progs
      ];
      script = "btrfs-snap -r / ${interval} ${count}";
    };

    btrfs-snap-timer = interval: {
      description = "Timer for snapshot BTRFS root";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = interval;
        OnUnitActiveSec = interval;
        Unit = "btrfs-snap-${interval}.service";
      };
    };

  in {
    services = {
      btrfs-snap-5m = btrfs-snap-service "5m" "18";
      btrfs-snap-1h = btrfs-snap-service "1h" "36";
      btrfs-snap-1d = btrfs-snap-service "1d" "11";
      btrfs-snap-1w = btrfs-snap-service "1w" "52";
    };

    timers = {
      btrfs-snap-5m = btrfs-snap-timer "5m";
      btrfs-snap-1h = btrfs-snap-timer "1h";
      btrfs-snap-1d = btrfs-snap-timer "1d";
      btrfs-snap-1w = btrfs-snap-timer "1w";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b44bc529-a5ab-46c9-917b-378471473327"; }
  ];

  time.timeZone = "America/Los_Angeles";

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "devicemapper";
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
