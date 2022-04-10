require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "**/node_modules/*"
    }
  }
})

require("config.utils").keymaps {
  n = {
    ["<C-p>"] = ":lua require('telescope.builtin').find_files()<CR>",
    ["<leader>ff"] = ":lua require('telescope.builtin').live_grep()<CR>",
    ["<leader>bb"] = ":lua require('telescope.builtin').buffers()<CR>",
  }
}
