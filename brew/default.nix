{ ... }:

{
  home.sessionVariables = {
    HOMEBREW_BUNDLE_NO_LOCK = "1";
    HOMEBREW_NO_ANALYTICS = "1";
  };

  home.file.".Brewfile".text = ''
    tap "buo/cask-upgrade"
    tap "homebrew/bundle"
    tap "homebrew/cask"
    tap "homebrew/cask-fonts"
    tap "homebrew/cask-versions"
    tap "homebrew/core"
    brew "mas"
    cask "1password"
    cask "dbeaver-community"
    cask "docker"
    cask "firefox"
    cask "font-fira-code-nerd-font"
    cask "gimp"
    cask "github"
    cask "karabiner-elements"
    cask "kitty"
    cask "ngrok"
    cask "spotify"
    cask "stoplight-studio"
    cask "visual-studio-code"
    cask "wireshark"
    cask "zoom"
    mas "Slack", id: 803453959
    mas "Xcode", id: 497799835
  '';
}
