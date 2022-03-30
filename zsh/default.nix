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

  programs.zsh = {
    shellAliases = {
      hms = "home-manager switch";
      kc = "kubectl";
      ls = "ls --color=auto -F";
      "r!" = "unset __HM_SESS_VARS_SOURCED; exec \"$SHELL\" -l";

      g = "git";
      ga = "git add";
      gc = "git commit";
      gs = "git status";
    };

    initExtraBeforeCompInit = ''
      NIX_PROFILE_DIRECTORY=${profileDirectory};
      export NIX_PROFILE_DIRECTORY

      ${readFile ./pre-compinit.zsh}
    '';

    initExtra = ''
      GPG_TTY="$(tty)"
      export GPG_TTY

      KEYTIMEOUT=1 # reduce delay when entering command mode (esc)
      export KEYTIMEOUT

      PATH="${settings.codePath}/bin:$PATH"
    '';
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

    cdpath+=("${settings.codePath}")

    ${cfg.initExtraBeforeCompInit}

    ${readFile ./compinit.zsh}

    ${cfg.initExtra}

    ${concatStringsSep "\n" (
      mapAttrsToList (k: v: "alias ${k}=${escapeShellArg v}") cfg.shellAliases
    )}

    if [ "$ZSHRC_DEBUG" = "1" ]; then; zprof; fi
  '';
}
