local M = {}

M.show_virtual_text = true

local function set_config()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local virtual_text = {}

  if M.show_virtual_text then
    virtual_text = {
      severity = nil,
      source = "if_many",
      format = nil,
    }
  end

  vim.diagnostic.config({
    virtual_text,
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
  })
end

local function toggle_virtual_text()
  M.show_virtual_text = not M.show_virtual_text
  set_config()
end

M.setup = function()
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
  vim.keymap.set("n", "<leader>vt", toggle_virtual_text)

  set_config()
end

return M
