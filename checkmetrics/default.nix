{
pkgs ? import <nixpkgs> {}
}:

with pkgs;
with pkgs.lib;

let
    checkmetrics = poetry2nix.mkPoetryApplication rec {
    projectDir = ./.;
    python = pkgs.python38;

    meta = with pkgs.lib; {
      description = "checkmetrics";
    };
  };

in checkmetrics.overrideAttrs (old: rec {
  pname = "check-metrics";
  version = old.version;
  name = "${pname}-${version}";
})
