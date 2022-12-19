local M = {}

local set_keymaps = function(bufnr)
  local function nmap(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
end

local set_autocommands = function(client, bufnr)
  local function autocmd(args)
    local event = args[1]
    local group = args[2]
    local callback = args[3]

    vim.api.nvim_create_autocmd(event, {
      group = group,
      buffer = bufnr,
      callback = function()
        callback()
      end,
      once = args.once,
    })
  end

  local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
  local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
  local augroup_format = vim.api.nvim_create_augroup("custom-lsp-format", { clear = true })

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_clear_autocmds({ group = augroup_highlight, buffer = bufnr })
    autocmd({ "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight })
    autocmd({ "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references })
  end

  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_clear_autocmds({ group = augroup_codelens, buffer = bufnr })
    autocmd({ "BufEnter", augroup_codelens, vim.lsp.codelens.refresh, once = true })
    autocmd({ { "BufWritePost", "CursorHold" }, augroup_codelens, vim.lsp.codelens.refresh })
  end

  vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
  autocmd({
    "BufWritePre",
    augroup_format,
    function()
      vim.lsp.buf.format({ async = false })
    end,
  })
end

M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  set_keymaps(bufnr)
  set_autocommands(client, bufnr)
end

M.make_config = function(config)
  return vim.tbl_deep_extend("force", {
    on_attach = M.on_attach,
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  }, config or {})
end

return M
