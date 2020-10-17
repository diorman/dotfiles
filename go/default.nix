{ ... }:

let
  goPath = (import ../settings.nix).codeDir;

in {
  programs.go = {
    enable = true;
    inherit goPath;
  };

  home.sessionVariables = {
    GO111MODULE = "on";
  };
}
