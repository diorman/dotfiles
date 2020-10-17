{ pkgs ? (import <nixpkgs> { }), version, sha256 }:

let
  stdenv = pkgs.stdenvNoCC;
  nodejs = pkgs.nodejs;
  unzip = pkgs.unzip;

  platform = if stdenv.hostPlatform.isDarwin then
    "macos"
  else
    "linux";
in
  stdenv.mkDerivation rec {
    name = "iidy-${version}";
    src = builtins.fetchurl {
      url = "https://github.com/unbounce/iidy/releases/download/v${version}/iidy-${platform}-amd64.zip";
      sha256 = sha256;
    };

    buildInputs = [
      unzip
    ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      mkdir -p $out/bin
      mv iidy $out/bin
    '';
  }
