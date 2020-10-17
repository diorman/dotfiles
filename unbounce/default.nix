{ ... }:

let
  settings = import ../settings.nix;
  gitConfig = settings.git;

in {
  home.sessionVariables = {
    PJ_DEFAULT_ORG = "unbounce";
  };

  programs.zsh.initExtra = ''
    export PATH="$PATH:${settings.codeSrcPath}/github.com/unbounce/dev-env/bin"
  '';

  programs.git = {
    includes = [{
      condition = "gitdir:**/github.com/unbounce/*/.git";
      contents = {
        user = {
          email = gitConfig.unbounce.email;
          signingKey = gitConfig.unbounce.signingKey;
        };
      };
    }];
  };
}
