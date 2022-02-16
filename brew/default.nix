{ ... }:

{
  home.sessionVariables = {
    HOMEBREW_BUNDLE_NO_LOCK = "1";
    HOMEBREW_NO_ANALYTICS = "1";
  };

  home.file.".Brewfile".text = ''
    tap "homebrew/bundle"
    tap "homebrew/cask"
    tap "homebrew/cask-fonts"
    tap "homebrew/cask-versions"
    tap "homebrew/core"
    brew "mas"
    cask "docker"
    cask "firefox"
    cask "font-fira-code-nerd-font"
    cask "github"
    cask "iterm2"
    cask "ngrok"
    cask "spotify"
    cask "visual-studio-code"
    cask "zoom"
    mas "1Password 7", id: 1333542190
    mas "Bear", id: 1091189122
    mas "Slack", id: 803453959
    mas "Xcode", id: 497799835
  '';
}
