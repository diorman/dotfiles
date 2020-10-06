{ config, pkgs, ... }:

{

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };

    jq.enable = true;
  };

  home.packages = with pkgs; [
    niv
  ];
}
