require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "go",
    "lua",
    "nix",
    "rust",
    "toml",
    "typescript",
  },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
