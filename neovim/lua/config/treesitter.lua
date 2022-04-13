require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "nix",
    "typescript",
  },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
