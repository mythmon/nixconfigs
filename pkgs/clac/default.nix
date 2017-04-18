{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "clac-${version}";

  version = "0";

  src = fetchurl {
    url = "https://github.com/soveran/clac/archive/d5a113ea578c42ddd65b40203ada72dde85cc217.tar.gz";
    sha256 = "0qylhl1ilwm3aqn689kl68cjdlwhawvfvxfdnx14x1kfk7f983g1";
  };

  makeFlags = [
    "PREFIX=\"$(out)\""
  ];

  meta = {
    description = "A command line, stack-based calculator with postfix notation";
    homepage = "https://github.com/soveran/clac";
    license = stdenv.lib.licenses.bsd-2-clause;
  };
}

