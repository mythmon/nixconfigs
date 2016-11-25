{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "yarn-${version}";
  version = "0.17.8";

  src = fetchurl {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "072lkfbsgwlqch6ymrdcmw2sw6krqcww5ydhqqizpwal58p7ckmm";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cd $out
    tar xzvf $src --strip-components 1
    patchShebangs $out/bin/yarn
  '';

  meta = {
    description = "Fast, reliable, and secure dependency management for JavaScript";
    homepage = "https://yarnpkg.com/";
    license = stdenv.lib.licenses.bsd2;
  };
}

