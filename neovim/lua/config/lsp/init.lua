require("config.lsp.diagnostic").setup()

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

local lspconfig = require("lspconfig")
local core = require("config.lsp.core")
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
  sumneko_lua = {
    enabled = true,
    make_config = require("config.lsp.sumneko-lua").make_config,
  },

  -- typescript
  tsserver = {
    enabled = true,
    make_config = require("config.lsp.tsserver").make_config,
  },
}

for server, settings in pairs(servers) do
  if settings.enabled then
    lspconfig[server].setup(settings.make_config())
  end
end
