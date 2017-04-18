{ lib, stdenv, fetchurl, python35Packages }:

python35Packages.buildPythonPackage rec {
  version = "3.5.0";
  name = "pipenv-${version}";

  src = fetchurl {
    url = "https://github.com/kennethreitz/pipenv/archive/v${version}.tar.gz";
    sha256 = "0dphg70wd5g3nj3yrfyyvhwbysi3v8v9kd8i8q5sr5l29ccncg4j";
  };

  propagatedBuildInputs = with python35Packages; [
    click
    #crayons
    #toml
    "delegator.py"
    requests
    #requirements-parser
    #parse
    #pipfile
    #click-completion
    psutil
    pew
    blindspin
    "backports.shutil_get_terminal_size"
  ];

  meta = {
    homepage = "http://pipenv.org";
    description = "Sacred Marriage of Pipfile, Pip, & Virtualenv";
    license = lib.licenses.mit;
  };
}

