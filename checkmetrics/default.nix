{
  sources ? import ../nix/sources.nix
, pkgs ? import sources.nixpkgs {}
, poetry2nix ? import sources.poetry2nix {}
}:

let
    checkmetrics = poetry2nix.mkPoetryApplication rec {
    projectDir = ./.;
    python = pkgs.python3;

    meta = with pkgs.lib; {
      description = "checkmetrics";
    };
  };

in checkmetrics.overrideAttrs (old: rec {
  pname = "check-metrics";
  version = old.version;
  name = "${pname}-${version}";
})
