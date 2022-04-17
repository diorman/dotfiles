local config = require("config.lsp.core").make_config()
require("lspconfig").rnix.setup(config)
