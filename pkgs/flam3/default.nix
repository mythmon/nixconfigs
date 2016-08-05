{ stdenv, fetchurl, zlib, libpng, libjpeg, libxml2 }:

stdenv.mkDerivation rec {
  name = "flam3-${version}";

  version = "3.1.1";

  buildInputs = [
    zlib
    libpng
    libjpeg
    libxml2
  ];

  src = fetchurl {
    url = "https://github.com/scottdraves/flam3/archive/v${version}.tar.gz";
    sha256 = "17fi6mfrh70laygwqgnzslfrrnpvpdhk07xfyqs0wx4p73qlmkdg";
  };

  meta = {
    description = "The original fractal flame renderer and genetic language";
    homepage = "https://github.com/scottdraves/flam3";
    license = stdenv.lib.licenses.gpl3;
  };
}

