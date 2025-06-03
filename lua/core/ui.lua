-- Imposta i bordi arrotondati per tutte le finestre flottanti LSP
local border_style = "rounded"

-- Gestori LSP con bordi
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border_style })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border_style })
vim.diagnostic.config({ float = { border = border_style } })

-- Override per tutte le finestre flottanti di Neovim
-- local orig_float = vim.api.nvim_open_win
-- vim.api.nvim_open_win = function(buf, enter, config)
--   config.border = config.border or border_style
--   return orig_float(buf, enter, config)
-- end
