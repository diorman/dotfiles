local function keymap(mode, lhs, rhs, bufnr)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

local function keymaps(mappings)
  for mode, mode_mappings in pairs(mappings) do
    for lhs, rhs in pairs(mode_mappings) do
      keymap(mode, lhs, rhs)
    end
  end
end

local utils = {
  keymap = keymap,
  keymaps = keymaps,
}

return utils
