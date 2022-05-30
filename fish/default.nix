{ config, pkgs, ... }:

let
  settings = import ../settings.nix;

  nixEnvFish = pkgs.fetchgit {
    url = "https://github.com/lilyball/nix-env.fish";
    rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
    sha256 = "069ybzdj29s320wzdyxqjhmpm9ir5815yx6n522adav0z2nz8vs4";
  };

in
{
  programs.fish = {
    enable = true;

    shellInit = ''
      fish_add_path ${settings.codePath}/bin
    '';

    interactiveShellInit = ''
      # disable the welcome message
      set fish_greeting

      # required by GPG agent
      set -x GPG_TTY (tty)

      fish_default_key_bindings
    '';

    shellAbbrs = {
      g = "git";
      ga = "git add";
      gc = "git commit";
      gs = "git status";
      gri = "git rebase -i HEAD~";

      hm = "home-manager";
    };
  };

  # https://github.com/NixOS/nix/issues/1512#issuecomment-1025520466
  home.file."${config.xdg.configHome}/fish/conf.d/nix-env.fish".source = "${nixEnvFish}/conf.d/nix-env.fish";
  home.file."${config.xdg.configHome}/fish/functions/fish_title.fish".source = ./functions/fish_title.fish;
  # home.file."${config.xdg.configHome}/fish/completions/pj.fish".source = ./completions/pj.fish;
}
