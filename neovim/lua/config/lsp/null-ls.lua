local null_ls = require("null-ls")
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

null_ls.setup({
  debug = false,
  sources = {
    diagnostics.eslint,
    formatting.prettierd,
    formatting.stylua,
  },
})
