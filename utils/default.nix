{ pkgs, config, ... }:

let
  pj = pkgs.writeScriptBin "pj" "${builtins.readFile ./pj.sh}";
in {
  home.packages = [ pj ];
}
