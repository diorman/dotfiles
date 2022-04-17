local core = require("config.lsp.core")
local config = core.make_config({
  on_attach = function(client, bufnr)
    -- use prettier for formatting instead
    client.resolved_capabilities.document_formatting = false
    core.on_attach(client, bufnr)
  end,
})

require("lspconfig").tsserver.setup(config)
