{ pkgs, stdenv, config, ... }:

let
  extraNodePackages = import ./node2nix/composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = "lua require('dc')";
    plugins = with pkgs.vimPlugins; [
      packer-nvim
    ];
  };

  home.packages = with pkgs; [
    # Go
    gopls

    # Rust
    rust-analyzer

    # Nix
    rnix-lsp

    # Lua
    sumneko-lua-language-server
    stylua

    # TypeScript/JavaScript
    node2nix
    nodePackages.typescript-language-server
    nodePackages.eslint_d
    extraNodePackages."@fsouza/prettierd"
  ];

  home.sessionVariables = {
    PRETTIERD_LOCAL_PRETTIER_ONLY = 1;
    ESLINT_D_LOCAL_ESLINT_ONLY = 1;
  };

  home.file."${config.xdg.configHome}/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink ./lua;
}
