{ pkgs ? import <nixpkgs> }:

rec {
  allowUnfreePredicate = pkg: (
    pkgs.lib.hasPrefix "firefox-" pkg.name
  );
  pulseaudio = true;

  packageOverrides = pkgs: rec {
    # Hold atom at 1.6.2, since it works.
    atom = pkgs.lib.overrideDerivation pkgs.atom (attrs: rec {
      version = "1.9.6";
      name = "atom-${version}";
      src = pkgs.fetchurl {
        url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
        sha256 = "1hw3s4zc0rs138gg429w98kkgmkm19wgq7r790hic5naci7d7f4i";
        name = "${name}.deb";
      };
    });
  };
}
