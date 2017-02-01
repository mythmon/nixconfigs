{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "btrbk-${version}";
  version = "0.24.0";

  configurePhase = ''
    makeFlags="PREFIX=$out"
  '';

  patchPhase = ''
    sed -i -e '/CONFDIR/ s@/etc@$(PREFIX)/etc@' Makefile
    sed -i -e '/CRONDIR/ s@/etc@$(PREFIX)/etc@' Makefile
    sed -i -e 's@#!/usr/bin/perl@#!${perl.out}/bin/perl@' btrbk
  '';

  src = fetchFromGitHub {
    owner = "digint";
    repo = "btrbk";
    rev = "da849b37ae066396b303576f332d148d364ad3dc";
    sha256 = "0i0wa85lwzngxr5p2gaqhqhv36brdiyldx4c15isrq01inbwmg85";
  };

  meta = {
    description = "Tool for creating snapshots and remote backups of btrfs subvolumes";
    homepage = "http://digint.ch/btrbk/";
    license = stdenv.lib.licenses.gpl3;
  };
}

