{ pkgs, config, ... }:

let
  gitFixup = pkgs.writeScriptBin "git-fixup" "${builtins.readFile ./git-fixup.sh}";
  gitFuzzySwitch = pkgs.writeScriptBin "git-fuzzy-switch" "${builtins.readFile ./git-fuzzy-switch.sh}";
  gitGet = pkgs.writeScriptBin "git-get" "${builtins.readFile ./git-get.sh}";
  kittyWindowManager = pkgs.writeScriptBin "kitty-window-manager" "${builtins.readFile ./kitty-window-manager.py}";
in
{
  home.packages = [ gitFixup gitFuzzySwitch gitGet kittyWindowManager ];
}
