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
        keys = {
          mythmon_gallium = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPUecQEOHC/X1qX9ErEbp040MDQwv9v1ODB4176r3bFRfTOWL/9jm6hYH8oENnmKRS4b+KlLZoUabwRPX/eOy+Oomns0+zUEd/UT2C4qFQ68rsmrjNnei7ZXMYiw9g80e+y+OaFhVIgh5dhg+TXyfqpmnQmSeox0dfyyXuc9ctAqeaFFKQ29WGlg3vwcK6K9DTwhl7GAI7tf9PW9xTQbIBU9lg9UD4MAW9MxsI69a8ohvT0pUBEiaFsY3JThfrcsoynqRkvYQhBuz+kSAD2s9Q5gIXY9p5F8O7Cdl7iyfYrErIJAv1GtCNw8vY1pASl5Dphd7NzkFIJlrQ4xn1ukS3 mythmon@gallium";
          mythmon_gmail = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDb8mIhrDs4wX7bBEV+anf7Gh3m98lQ0MQbyfSClNjwPIF4BHwczOct6m2mr+V4ft5I8JGUDk2ke20v3+bR5NIsEtGh3fRd+KeLOVPiboIPWADAAqm4WSuW10ow3IPF6BLWv/3RnAv1l8tVbCdUz3i1U/ryFcOHS9BLdTy+tprfc8amEfNfVrx/WpwSl4eXZImsOaQAKvzAPsCSDK/2DOQ0NPfUD1ECm0AqxVBWemDCITP3g+GRMueRRo1ui89BvhnK+B8bApJeUVMw3Ltw0cgps2fKfeGqKf9Ree9Twt6Mpkr04owVLXCdNMU4p2ilhcWmgvVJRQxAfH1yx519vAtv mythmon@gmail.com";
          uberj_blue = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEAmBT7pbSrGPU7CpWYslgzoPYSfALaw4c6XPIlCQDKRzlSruhKTVizF2wGWyL4UB20xW08TAR0myNOXCz0NLVnxO5dRPMngqGSbTBqwzGkFic18T+CCcCgv1dVw3GD0TZkxF7w+oOjiH8VvlhciKMcF9Id8aBPF48ioGSbDTGNyeA0MTh+kJUx2EVbGxprfoHxjKrp1s8CiaV2LpKPgBnRLqB7BAFRph2ZuJTE8e4fGrh7iHp/N9QzqF7ts2CR2AJZexGaQKJBbVU1YNRtGn6Bji0oU0kRJ1MZJL8ttWztPSkIOTeAj1bWCpwZggjXKuwCdYUxJLXIrXcp13YnmVN uberj@blue";
          uberj_carbon = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyZNEN9j8oD5ZCXYcnUDbwEJbb5w1RkRR2dYXqOyFWptXBpLaBiVAVqQlq7GAqqn0vnLyANSr77RjxjadVKq8K4rcbwLIbeJglXumwYZNLzWt57JhZoptp9K1krvb1Fptyj5fpM0iBN8BAC2aCJwbe9OSOcccPMByHb8bQWDV849ZcA7Z2PfKqd3FoTQmRc28WXVb2Hki2xSVjrnYuoV0XSk1d0tXUysgl2acC5yc+I91DYl/iYu9RlcjrLUx05LpzIMwF9r2c2kleehgMESzrmRmll9FgomPNiNfL5BjP4Fiit0FFQo3uOiv3acDEmXcSYPEr0JMCx/drkfNXT/Bz uberj@uberj-ThinkPad-X1-Carbon";
        };

      in {
        root = {
          openssh.authorizedKeys.keys = [ keys.mythmon_gallium keys.mythmon_gmail ];
        };

        mythmon = {
          createHome = true;
          extraGroups = [ "wheel" ];
          isNormalUser = true;
          openssh.authorizedKeys.keys = [ keys.mythmon_gallium keys.mythmon_gmail ];
          shell = "/run/current-system/sw/bin/zsh";
        };

        uberj = {
          createHome = true;
          isNormalUser = true;
          openssh.authorizedKeys.keys = [ keys.uberj_blue keys.uberj_carbon ];
        };
      };
    };
}
