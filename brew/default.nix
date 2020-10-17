{ ... }:

let
  m = type: list: map (item: "${type} \"${item}\"") list;

  taps = [
    "homebrew/bundle"
    "homebrew/cask"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/cask-fonts"
    "homebrew/services"
  ];

  casks = [
    "1password"
    "adobe-acrobat-reader"
    "docker"
    "font-fira-code-nerd-font"
    "firefox"
    "flux"
    "gimp"
    "github"
    "google-chrome"
    "intellij-idea-ce"
    "iterm2"
    "ngrok"
    "nosql-workbench-for-amazon-dynamodb"
    "sequel-pro"
    "slack"
    "spotify"
    "stoplight-studio"
    "visual-studio-code"
    "vlc"
    "whatsapp"
    "zoomus"
  ];

  bundle = builtins.concatStringsSep "\n" ((m "tap" taps) ++ (m "cask" casks));

in {
  home.sessionVariables = {
    HOMEBREW_BUNDLE_NO_LOCK = "1";
    HOMEBREW_NO_ANALYTICS = "1";
  };

  programs.zsh.initExtra = ''
    export PATH="$PATH:/usr/local/sbin"
  '';

  home.file.".Brewfile".text = bundle;
}
