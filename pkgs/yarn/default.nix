{ pkgs, stdenv, fetchFromGitHub, python, utillinux }:

with stdenv.lib;

let
  nodePackages = pkgs.callPackage "${pkgs.path}/pkgs/top-level/node-packages.nix" {
    self = nodePackages;
    generated = ./package.nix;
  };
  yarn = nodePackages.by-version."yarn"."0.16.1";

in yarn.override rec {
  meta = {
    description = "Fast, reliable, and secure dependency management.";
    license = licenses.bsd2;
    homepage = https://yarnpkg.com;
    maintainers = with maintainers; [ mythmon ];
    platforms = platforms.unix;
  };
}
