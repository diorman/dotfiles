local M = {}

M.virtual_text = false

local function set_config(config)
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local _config = vim.tbl_deep_extend("force", {
    virtual_text = false,
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      source = "always",
    },
  }, config)

  vim.diagnostic.config(_config)
end

M.setup = function()
  require("config.utils").keymaps({
    n = {
      ["<leader>e"] = ":lua vim.diagnostic.open_float()<CR>",
      ["[d"] = ":lua vim.diagnostic.goto_prev()<CR>",
      ["]d"] = ":lua vim.diagnostic.goto_next()<CR>",
      ["<leader>q"] = ":lua vim.diagnostic.setloclist()<CR>",
      ["<leader>dt"] = ":lua require('config.lsp.diagnostic').toggle_virtual_text()<CR>",
    },
  })

  set_config({ virtual_text = M.virtual_text })
end

M.toggle_virtual_text = function()
  M.virtual_text = not M.virtual_text
  set_config({ virtual_text = M.virtual_text })
end

return M
