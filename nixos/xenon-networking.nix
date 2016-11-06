{ ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "2001:4860:4860::8844"
      "2001:4860:4860::8888"
      "8.8.8.8"
    ];
    defaultGateway = "45.55.128.1";
    defaultGateway6 = "2604:a880:800:10::1";
    interfaces = {
      eth0 = {
        ip4 = [
          { address="45.55.132.201"; prefixLength=18; }
          { address="10.17.0.5"; prefixLength=16; }
        ];
        ip6 = [
        ];
      };
      eth1 = {
        ip4 = [
          { address="10.132.76.148"; prefixLength=16; }
        ];
        ip6 = [
        ];
      };
    };
  };
  services.udev.extraRules = ''
    KERNEL=="eth*", ATTR{address}=="56:3d:61:1a:6a:67", NAME="eth0"
    KERNEL=="eth*", ATTR{address}=="42:0d:d4:f3:53:61", NAME="eth1"
  '';
}
