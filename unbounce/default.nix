{ ... }:

let
  settings = import ../settings.nix;
  gitConfig = settings.git;
  devEnvBin = "${settings.codePath}/github.com/unbounce/dev-env/bin";

in
{
  home.sessionVariables = {
    PJ_DEFAULT_USER = "unbounce";
  };

  programs = {
    zsh.initExtra = ''
      export PATH="$PATH:${devEnvBin}"
    '';

    fish.shellInit = ''
      fish_add_path ${devEnvBin}
    '';
  };

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
    ignores = [
      "devenv.*"
      ".devenv/"
      ".devenv.*"
      ".envrc"
      "shell.nix"
      ".nix/"
    ];
  };
}
