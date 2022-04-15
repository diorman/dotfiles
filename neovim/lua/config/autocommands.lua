vim.cmd([[
  augroup trim_trailing_whitespace
    autocmd!
    autocmd BufWritePre * :lua require("config.utils").trim_trailing_whitespace()
  augroup end

  augroup format_options
    autocmd!
    autocmd BufEnter * set formatoptions-=o
  augroup end
]])
