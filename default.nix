let pkgs = import <nixpkgs> {}; in
{
	getrancherCreds = pkgs.callPackage ./getRancherCreds/default.nix {};
	checkmetrics = pkgs.callPackage ./checkmetrics/default.nix {};
}
