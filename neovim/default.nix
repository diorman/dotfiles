{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      packer-nvim
    ];

    extraConfig = ''
      lua require('config')
    '';
  };

  home.packages = with pkgs; [
    ripgrep
    rnix-lsp
    gopls
  ];

  home.file."${config.xdg.configHome}/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink ./lua;
}
