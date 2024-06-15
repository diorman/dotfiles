{ ... }:

{
  home.sessionVariables = {
    HOMEBREW_BUNDLE_NO_LOCK = "1";
    HOMEBREW_NO_ANALYTICS = "1";
  };

  home.file.".Brewfile".text = ''
    tap "buo/cask-upgrade"
    tap "homebrew/bundle"
    brew "mas"
    cask "1password"
    cask "firefox"
    cask "flux"
    cask "font-fira-code-nerd-font"
    cask "gimp"
    cask "github"
    cask "karabiner-elements"
    cask "kitty"
    cask "spotify"
    cask "wireshark"
    mas "Slack", id: 803453959
    mas "Xcode", id: 497799835
  '';
}
