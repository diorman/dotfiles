{ pkgs, ... }:

let
  iidy = pkgs.callPackage ./iidy.nix {
    version = "1.11.0";
    sha256 = "64fad0d20a1a64d351106a7fc8736ae5fd4c0f4886e0b35e80064253d85cc640";
  };

in {
  home.packages = [ iidy ];
}
