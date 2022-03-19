{ pkgs, config, ... }:

let
  pj = pkgs.writeScriptBin "pj" "${builtins.readFile ./pj.sh}";
  gitGet = pkgs.writeScriptBin "git-get" "${builtins.readFile ./git-get.sh}";
  tab = pkgs.writeScriptBin "tab" "${builtins.readFile ./tab.sh}";
  tabTree = pkgs.writeScriptBin "tab-tree" "${builtins.readFile ./tab-tree.py}";
in {
  home.packages = [ pj gitGet tab tabTree ];
}
