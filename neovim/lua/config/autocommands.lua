vim.cmd([[
  augroup trim_trailing_whitespace
    autocmd!
    autocmd BufWritePre * :lua require("config.utils").trim_trailing_whitespace()
  augroup end
]])
