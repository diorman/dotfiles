{ pkgs, config, ... }:

let
  gitGet = pkgs.writeScriptBin "git-get" "${builtins.readFile ./git-get.sh}";
  kittyWindowManager = pkgs.writeScriptBin "kitty-window-manager" "${builtins.readFile ./kitty-window-manager.py}";
in {
  home.packages = [ gitGet kittyWindowManager ];
}
