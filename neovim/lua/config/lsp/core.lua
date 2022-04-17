local M = {}

local set_keymaps = function(bufnr)
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
end

local set_autocommands = function(client)
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
        autocmd! * <buffer>
        autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
        autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
      augroup END
    ]])
  end

  vim.cmd([[
    augroup lsp_buf_format
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    augroup end
  ]])
end

M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  set_keymaps(bufnr)
  set_autocommands(client)
end

M.make_config = function(config)
  return vim.tbl_deep_extend("force", {
    on_attach = M.on_attach,
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    },
  }, config or {})
end

return M
