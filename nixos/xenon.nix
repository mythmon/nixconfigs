{ pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ./xenon-networking.nix
  ];

  boot = {
    cleanTmpDir = true;

    loader.grub.device = "/dev/vda";

    tmpOnTmpfs = true;
  };

  environment.systemPackages = with pkgs; [
    git
    httpie
    tmux
    vim
    weechat
    zsh
  ];

  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };

  networking = {
    firewall = {
      allowPing = true;
      allowedTCPPorts = [
        22 # ssh
        80 # http
        443 # https
      ];
    };

    hostName = "xenon";
  };

  programs = {
    mosh.enable = true;
    zsh.enable = true;
  };

  services = {
    chrony.enable = true;

    locate = {
      enable = true;
      extraFlags = [
        "--prunepaths='/nix/store'"
      ];
      interval = "hourly";
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "mythmon.com" = {
          globalRedirect = "www.mythmon.com";
        };
      };
    };

    ntp.enable = false;

    openssh.enable = true;
  };

  system = {
    autoUpgrade.enable = true;
    copySystemConfiguration = true;
    # The NixOS release to be compatible with for stateful data such as databases.
    stateVersion = "16.03";
  };

  users = {
    users =
      let
        ssh_keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPUecQEOHC/X1qX9ErEbp040MDQwv9v1ODB4176r3bFRfTOWL/9jm6hYH8oENnmKRS4b+KlLZoUabwRPX/eOy+Oomns0+zUEd/UT2C4qFQ68rsmrjNnei7ZXMYiw9g80e+y+OaFhVIgh5dhg+TXyfqpmnQmSeox0dfyyXuc9ctAqeaFFKQ29WGlg3vwcK6K9DTwhl7GAI7tf9PW9xTQbIBU9lg9UD4MAW9MxsI69a8ohvT0pUBEiaFsY3JThfrcsoynqRkvYQhBuz+kSAD2s9Q5gIXY9p5F8O7Cdl7iyfYrErIJAv1GtCNw8vY1pASl5Dphd7NzkFIJlrQ4xn1ukS3 mythmon@gallium"
        ];
      in {
        root.openssh.authorizedKeys.keys = ssh_keys;

        mythmon = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
          ];
          shell = "/run/current-system/sw/bin/zsh";
          createHome = true;
        };
        mythmon.openssh.authorizedKeys.keys = ssh_keys;
      };
    };
}
