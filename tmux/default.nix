{ pkgs, ... }:

let
  thoughtbotDotfiles  = pkgs.fetchgit {
    url = "https://github.com/thoughtbot/dotfiles";
    rev = "de02da4fc665dbe9e371a41e23ef94d4254ba0e9";
    sha256 = "0khdzlw5dliv77y0pkmrmkzpszmbvg4j4aj1mpldxcywir0r2r31";
  };

  tat = pkgs.runCommand "tat" { } ''
    mkdir -p $out/bin
    ln -s ${thoughtbotDotfiles}/bin/tat $out/bin/tat
  '';

in {
  home.packages = [ tat ];

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = builtins.readFile ./extra.conf;
  };
}
