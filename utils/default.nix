{ pkgs, config, ... }:

let
  pj = pkgs.writeScriptBin "pj" "${builtins.readFile ./pj.sh}";
  gitGet = pkgs.writeScriptBin "git-get" "${builtins.readFile ./git-get.sh}";
  kittyWindowManager = pkgs.writeScriptBin "kitty-window-manager" "${builtins.readFile ./kitty-window-manager.py}";
in {
  home.packages = [ pj gitGet kittyWindowManager ];
}
