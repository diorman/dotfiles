{ config, pkgs, ... }:

let
  terminalIcons = pkgs.fetchgit {
    url = "https://github.com/dhanishgajjar/terminal-icons";
    rev = "fe7efa876a6c2a221caa3123d73f4a629c222405";
    sha256 = "0212dbwyyh3bir5ydc6bix7n5k6li70pz6y6lxyzy6smdg73c2vm";
  };

  snazzyTheme = pkgs.fetchgit {
    url = "https://github.com/connorholyday/kitty-snazzy";
    rev = "6ae245a6319dc0d6416457355678fa48f275c971";
    sha256 = "098qpq2v72hk6mafbrxhjzh6pvmima7wydd6fzlq6zy4jxxq53l5";
  };

in
{
  home.file."${config.xdg.configHome}/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink ./kitty.conf;
  home.file."${config.xdg.configHome}/kitty/snazzy.conf".source = "${snazzyTheme}/snazzy.conf";
  home.file."${config.xdg.configHome}/kitty/kitty.app.icns".source = "${terminalIcons}/icns/dracula.icns";
  home.file."${config.xdg.configHome}/kitty/window_manager".source = config.lib.file.mkOutOfStoreSymlink ./window_manager;
}
