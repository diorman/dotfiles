{ pkgs, ... }:

let
  iidy = pkgs.callPackage ./iidy.nix {
    version = "1.12.0";
    sha256 = "2c6dd182edc023c18882eb9ede74607cd7bebee7a644864fd8fbbcfcbdcf17d1";
  };

in {
  home.packages = [ iidy ];
}
