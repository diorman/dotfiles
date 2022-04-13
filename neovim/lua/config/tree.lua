require("nvim-tree").setup()

require("config.utils").keymaps({
  n = {
    ["<leader>tt"] = ":NvimTreeToggle<CR>",
    ["<leader>tr"] = ":NvimTreeRefresh<CR>",
  },
})
