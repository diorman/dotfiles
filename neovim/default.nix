{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      nvim-tree-lua
      vim-nix
      nvim-treesitter
      nvim-lspconfig
      lspkind-nvim
      gitsigns-nvim
      comment-nvim
      lualine-nvim

      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp-nvim-lsp
      cmp_luasnip
      luasnip
      friendly-snippets
      null-ls-nvim

      plenary-nvim
      telescope-nvim

      # Theme
      nightfox-nvim

      # nvim-buffer-line-lue # tabs
      # galaxyline-nvim # status bar video: 43:40

      # Indent lines
      indent-blankline-nvim
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
