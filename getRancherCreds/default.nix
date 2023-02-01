{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "getRancherCreds";
  version = "0.1.0";
  dontBuild = true;
  dontConfigure = true;
  unpackPhase = ":";
  #src = ./getRancherCreds.sh;

  buildInputs = [
    pkgs.jq
    pkgs.curl
    pkgs.cmake
    pkgs.vault
  ];
  installPhase = ''
    mkdir -p $out/bin
    chmod +x ${./getRancherCreds.sh}
    cp ${./getRancherCreds.sh} $out/bin/getRancherCreds
  '';
}

