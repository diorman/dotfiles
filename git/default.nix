{ ... }:

let
  gitConfig = (import ../settings.nix).git;

in {
  programs.git = {
    enable = true;
    userName = "Diorman Colmenares";
    userEmail = gitConfig.default.email;
    signing = {
      key = gitConfig.default.signingKey;
      signByDefault = true;
    };
    extraConfig = {
      alias = {
        a = "add";
        c = "commit";
        co = "checkout";
        commend = "commit --amend --no-edit";
        st = "status";
      };
      branch.autosetuprebase = "always";
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        ui = true;
      };
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      credential.helper = "osxkeychain";
      fetch.prune = true;
      format.pretty = "format:%Cred%h%Creset%C(yellow)%d%Creset %s %C(bold blue)<%an>%n%C(magenta)%ad %Cgreen(%cr)%Creset%n";
      init.defaultBranch = "main";
      push = {
        default = "current";
        followTags = true;
      };
    };

    ignores = [
      ".direnv/"
      ".DS_Store"
      ".idea"
      "*.iml"
      ".classpath"
      ".project"
      ".settings"
      ".vscode/"
      ".envrc"
      "shell.nix"
      ".factorypath"
    ];
  };
}
