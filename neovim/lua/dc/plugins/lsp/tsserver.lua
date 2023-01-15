local core = require("dc.plugins.lsp.core")
local M = {}

M.make_config = function()
  return core.make_config({
    on_attach = function(client, bufnr)
      -- use prettier for formatting instead
      client.server_capabilities.documentFormattingProvider = false
      core.on_attach(client, bufnr)
    end,
  })
end

return M
