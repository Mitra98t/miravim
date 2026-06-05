-- Imposta i bordi arrotondati per tutte le finestre flottanti LSP
local border_style = "rounded"

-- Gestori LSP con bordi
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  return vim.lsp.handlers.hover(err, result, ctx, vim.tbl_deep_extend("force", config or {}, { border = border_style }))
end
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  return vim.lsp.handlers.signature_help(err, result, ctx,
    vim.tbl_deep_extend("force", config or {}, { border = border_style }))
end
vim.diagnostic.config({ float = { border = border_style } })

-- Override per tutte le finestre flottanti di Neovim
-- local orig_float = vim.api.nvim_open_win
-- vim.api.nvim_open_win = function(buf, enter, config)
--   config.border = config.border or border_style
--   return orig_float(buf, enter, config)
-- end
