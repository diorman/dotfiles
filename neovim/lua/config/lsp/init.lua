require("config.utils").keymaps({
  n = {
    ["<leader>e"] = ":lua vim.diagnostic.open_float()<CR>",
    ["[d"] = ":lua vim.diagnostic.goto_prev()<CR>",
    ["]d"] = ":lua vim.diagnostic.goto_next()<CR>",
    ["<leader>q"] = ":lua vim.diagnostic.setloclist()<CR>",
  },
})

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
  -- disable virtual text
  virtual_text = false,
  -- show signs
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
}

vim.diagnostic.config(config)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local _on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  require("config.utils").buf_keymaps(bufnr, {
    n = {
      ["gD"] = ":lua vim.lsp.buf.declaration()<CR>",
      ["gd"] = ":lua vim.lsp.buf.definition()<CR>",
      ["K"] = ":lua vim.lsp.buf.hover()<CR>",
      ["gi"] = ":lua vim.lsp.buf.implementation()<CR>",
      ["<C-k>"] = ":lua vim.lsp.buf.signature_help()<CR>",
      ["<leader>wa"] = ":lua vim.lsp.buf.add_workspace_folder()<CR>",
      ["<leader>wr"] = ":lua vim.lsp.buf.remove_workspace_folder()<CR>",
      ["<leader>wl"] = ":lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
      ["<leader>D"] = ":lua vim.lsp.buf.type_definition()<CR>",
      ["<leader>rn"] = ":lua vim.lsp.buf.rename()<CR>",
      ["<leader>ca"] = ":lua vim.lsp.buf.code_action()<CR>",
      ["gr"] = ":lua vim.lsp.buf.references()<CR>",
      ["<leader>f"] = ":lua vim.lsp.buf.formatting_sync()<CR>",
    },
  })

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end

  if client.resolved_capabilities.code_lens then
    vim.cmd([[
      augroup lsp_document_codelens
        au! * <buffer>
        autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
        autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
      augroup END
    ]])
  end
end

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").sumneko_lua.setup({
  on_attach = function(client, bufnr)
    _on_attach(client, bufnr)
    vim.cmd([[
      augroup lsp_buf_format
        au! BufWritePre <buffer>
        autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()
      augroup end
    ]])
  end,
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
})

require("lspconfig").tsserver.setup({
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    _on_attach(client, bufnr)
  end,
})
