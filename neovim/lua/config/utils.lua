local M = {}

local function keymap(mode, lhs, rhs, bufnr)
  local opts = { noremap = true, silent = true }
  if bufnr then
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

M.keymaps = function(mappings)
  for mode, mode_mappings in pairs(mappings) do
    for lhs, rhs in pairs(mode_mappings) do
      keymap(mode, lhs, rhs)
    end
  end
end

M.buf_keymaps = function(bufnr, mappings)
  for mode, mode_mappings in pairs(mappings) do
    for lhs, rhs in pairs(mode_mappings) do
      keymap(mode, lhs, rhs, bufnr)
    end
  end
end

M.trim_trailing_whitespace = function()
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]]) -- keeppatterns: prevents the \s\+$ pattern from being added to the search history.
  vim.fn.winrestview(view)
end

return M
