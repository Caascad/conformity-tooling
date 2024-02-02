{
  sources ? import ../nix/sources.nix
, pkgs ? import sources.nixpkgs {}
, poetry2nixStandalone ? import sources.poetry2nix {}
}:

let
    checkmetrics = poetry2nixStandalone.mkPoetryApplication rec {
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
