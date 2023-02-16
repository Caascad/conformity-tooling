{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "get-rancher-creds";
  version = "0.2.1";
  dontBuild = true;
  dontConfigure = true;
  unpackPhase = ":";

  buildInputs = [
    pkgs.jq
    pkgs.curl
    pkgs.cmake
    pkgs.vault
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${./getRancherCreds.sh} $out/bin/get-rancher-creds
    chmod +x $out/bin/get-rancher-creds
  '';
}

