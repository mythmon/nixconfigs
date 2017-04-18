{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = rec {
    btrbk = callPackage ./btrbk { };

    btrfs-snap = callPackage ./btrfs-snap { };

    clac = callPackage ./clac { };

    flam3 = callPackage ./flam3 { };

    firefox-beta-bin = callPackage ./firefox-bin {
      browserName = "beta";
    };

    firefox-aurora-bin = callPackage ./firefox-bin {
      browserName = "aurora";
    };

    firefox-nightly-bin = callPackage ./firefox-bin {
      browserName = "nightly";
    };

    irccloud-desktop = callPackage ./irccloud-desktop { };

    pipenv = callPackage ./pipenv { };

    ripgrep = callPackage ./ripgrep { };

    yarn = callPackage ./yarn { };
  };

in self
