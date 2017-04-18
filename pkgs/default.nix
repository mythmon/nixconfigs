{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = rec {
    btrbk = callPackage ./btrbk { };

    btrfs-snap = callPackage ./btrfs-snap { };

    clac = callPackage ./clac { };

    flam3 = callPackage ./flam3 { };

    firefox-nightly-bin = callPackage ./firefox-bin {
      browserName = "nightly";
    };

    firefox-aurora-bin = callPackage ./firefox-bin {
      browserName = "aurora";
    };

    firefox-unbranded-bin = callPackage ./firefox-unbranded-bin { };

    firefox-beta-unbranded-bin = callPackage ./firefox-beta-unbranded-bin { };

    ripgrep = callPackage ./ripgrep { };

    yarn = callPackage ./yarn { };
  };

in self
