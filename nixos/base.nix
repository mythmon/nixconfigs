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
    vim
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
    locate.enable = true;
    ntp.enable = false;
  };

  system = {
    autoUpgrade.enable = true;
    copySystemConfiguration = true;
    # The NixOS release to be compatible with for stateful data such as databases.
    stateVersion = "16.03";
  };
}
