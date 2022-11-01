{ pkgs, stdenv, ... }:

let
  extraNodePackages = import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in
{
  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    nodePackages.eslint_d
    extraNodePackages."@fsouza/prettierd"
    node2nix
  ];

  home.sessionVariables = {
    PRETTIERD_LOCAL_PRETTIER_ONLY = 1;
    ESLINT_D_LOCAL_ESLINT_ONLY = 1;
  };
}

