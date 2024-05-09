{ pkgs, config, ... }:

let
  settings = import ../settings.nix;
in
{
  programs = {
    # shell prompt
    starship.enable = true;

    bash.enable = true;

    fish = {
      enable = true;

      shellInit = ''
        if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
        end
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
        gs = "git status";

        hm = "home-manager";

        bash = "$HOME/.nix-profile/bin/bash";

        lg = "lazygit";
      };

    };
  };

  home.packages = with pkgs; [
    bashInteractive
  ];

  home.file."${config.xdg.configHome}/starship.toml".source = ./starship.toml;
}
