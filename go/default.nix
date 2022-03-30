{ ... }:

{
  programs.go = {
    enable = true;
  };

  home.sessionVariables = {
    GO111MODULE = "auto";
  };
}
