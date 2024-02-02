{
  sources ? import ./nix/sources.nix
, pkgs ? import <nixpkgs> {}
, poetry2nix ? import sources.poetry2nix {}
}:
{
	getranchercreds = pkgs.callPackage ./getranchercreds/default.nix {};
	checkmetrics = pkgs.callPackage ./checkmetrics/default.nix {};
}
