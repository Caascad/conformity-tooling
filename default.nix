{
 pkgs ? import <nixpkgs> {}
}:
{
	getranchercreds = pkgs.callPackage ./getranchercreds/default.nix {};
	checkmetrics = pkgs.callPackage ./checkmetrics/default.nix {};
}
