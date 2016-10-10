{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "btrfs-snap-${version}";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "jf647";
    repo = "btrfs-snap";
    rev = "91b7563aaf26145e87eedaafc2b871fc3e1f3e00";
    sha256 = "1kpgfqxp4zxmrkprd5q0pi67dbl47c2kkrxa00578y5y31961zb3";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/btrfs-snap $out/bin/btrfs-snap
    patchShebangs $out/bin/btrfs-snap
  '';

  meta = {
    description = "btrfs snapshots with rotation";
    homepage = "https://github.com/jf647/btrfs-snap";
    license = stdenv.lib.licenses.gpl3;
  };
}

