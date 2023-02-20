{
pkgs ? import <nixpkgs> {}
}:

with pkgs;
with pkgs.lib;

let
    checkmetrics = poetry2nix.mkPoetryApplication rec {
    projectDir = ./.;
    python = pkgs.python39;

    meta = with pkgs.lib; {
      description = "quote";
    };
  };

in checkmetrics.overrideAttrs (old: rec {
  pname = "quote";
  version = old.version;
  name = "${pname}-${version}";
})
