{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "de79be2db2ae82b004a503ce31263370ebbca2ae";
    sha256 = "0whw6hqjkf6sysrfv931jaia2hqhy8m9aa5rxax1kygm4snz4j85";
  };

  depsSha256 = "10f7pkgaxwizl7kzhkry7wx1rgm9wsybwkk92myc29s7sqir2mx4";

  meta = with stdenv.lib; {
    homepage = https://github.com/BurntSushi/ripgrep/;
    description = "ripgrep combines the usability of The Silver Searcher with the raw speed of grep.";
    license = licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}


