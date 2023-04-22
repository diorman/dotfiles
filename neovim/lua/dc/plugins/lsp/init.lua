require("dc.plugins.lsp.diagnostic").setup()
require("fidget").setup()

local null_ls = require("null-ls")
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

null_ls.setup({
  debug = false,
  sources = {
    diagnostics.eslint_d,
    formatting.prettierd,
    formatting.stylua,
  },
})

local lspconfig = require("lspconfig")
local core = require("dc.plugins.lsp.core")
local servers = {
  -- golang
  gopls = {
    enabled = true,
    make_config = core.make_config,
  },

  -- nix
  rnix = {
    enabled = true,
    make_config = core.make_config,
  },

  -- lua
  lua_ls = {
    enabled = true,
    make_config = require("dc.plugins.lsp.lua-ls").make_config,
  },

  -- typescript
  tsserver = {
    enabled = true,
    make_config = require("dc.plugins.lsp.tsserver").make_config,
  },

  -- rust
  rust_analyzer = {
    enabled = true,
    make_config = core.make_config,
  },
}

for server, settings in pairs(servers) do
  if settings.enabled then
    lspconfig[server].setup(settings.make_config())
  end
end
