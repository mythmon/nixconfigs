{ pkgs, ... }:

rec {
  boot = {
    cleanTmpDir = true;
    tmpOnTmpfs = true;
  };

  environment.systemPackages = with pkgs; [
    git
    httpie
    tmux
    wget
    zsh
  ];

  networking = {
    firewall = {
      allowPing = true;
      enable = true;
    };
  };

  nix = {
    extraOptions = "auto-optimize-store = true";
  };

  programs.zsh.enable = true;

  services = {
    chrony.enable = true;

    # Too much difficulty getting this to be performant
    # TODO: prunt git and hg directories?
    locate.enable = false;

    ntp.enable = false;
  };

  system = {
    autoUpgrade.enable = true;
    copySystemConfiguration = true;
    # The NixOS release to be compatible with for stateful data such as databases.
    stateVersion = "16.03";
  };
}
