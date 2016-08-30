{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = rec {
    flam3 = callPackage ./flam3 { };

    firefox-nightly-bin = callPackage ./firefox-nightly-bin { };

    firefox-unbranded-bin = callPackage ./firefox-unbranded-bin { };
  };

in self
