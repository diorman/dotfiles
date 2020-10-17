{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh;
  settings = import ../settings.nix;
  profileDirectory = config.home.profileDirectory;

  antibodyBundle = pkgs.runCommand "antibody-bundle" {
    buildInputs = with pkgs; [ antibody git cacert ];
  } ''
    export ANTIBODY_HOME=$out/etc/antibody
    mkdir -p $ANTIBODY_HOME
    antibody bundle < "${./plugins.txt}" > $ANTIBODY_HOME/plugins.sh
    antibody update
  '';

in {

  home.packages = [ antibodyBundle pkgs.zsh ];

  # prompt
  programs.starship.enable = true;

  programs.zsh.initExtraBeforeCompInit = ''
    ${readFile ./pre-compinit.zsh}
  '';

  home.sessionVariables = {
    CLICOLOR = true;
    EDITOR = "vim";
    VEDITOR = "code";
    KEYTIMEOUT = 1; # reduce delay when entering command mode (esc)
    PJ_PATH = settings.codeSrcPath;
    NIX_PROFILE_DIRECTORY = profileDirectory;
  };

  home.file.".zsh_functions".source = ./functions;

  home.file.".zprofile".text = ''
    #!/bin/zsh

    source "${profileDirectory}/etc/profile.d/nix.sh"
    source "${profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';

  home.file.".zshrc".text = ''
    #!/bin/zsh

    if [ "$ZSHRC_DEBUG" = "1" ]; then; zmodload zsh/zprof; fi

    typeset -U path cdpath fpath manpath

    cdpath+=("${settings.codeSrcPath}")

    ${cfg.initExtraBeforeCompInit}

    ${readFile ./compinit.zsh}

    ${cfg.initExtra}

    ${concatStringsSep "\n" (
      mapAttrsToList (k: v: "alias ${k}=${escapeShellArg v}") cfg.shellAliases
    )}

    if [ "$ZSHRC_DEBUG" = "1" ]; then; zprof; fi
  '';
}
