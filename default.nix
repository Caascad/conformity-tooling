{
 pkgs ? import <nixpkgs> {}
}:
{
	getrancherCreds = pkgs.callPackage ./getRancherCreds/default.nix {};
	checkmetrics = pkgs.callPackage ./checkmetrics/default.nix {};
}
