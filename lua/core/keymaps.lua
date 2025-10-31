-- Symbol navigation helpers driven by the LSP documentSymbol response.
local function collect_symbols(bufnr)
  local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
  local responses = vim.lsp.buf_request_sync(bufnr, "textDocument/documentSymbol", params, 1000)
  if not responses then
    return {}
  end

  local symbols = {}
  for _, response in pairs(responses) do
    if response.result then
      local items = vim.lsp.util.symbols_to_items(response.result, bufnr)
      if items then
        vim.list_extend(symbols, items)
      end
    end
  end

  table.sort(symbols, function(a, b)
    if a.lnum == b.lnum then
      return (a.col or 0) < (b.col or 0)
    end
    return a.lnum < b.lnum
  end)
  return symbols
end

local function attached_clients(bufnr)
  if vim.lsp.get_clients then
    return vim.lsp.get_clients({ bufnr = bufnr })
  end
  return vim.lsp.get_active_clients({ bufnr = bufnr })
end

local function goto_symbol(direction)
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = attached_clients(bufnr)
  if not clients or vim.tbl_isempty(clients) then
    vim.notify("No LSP client attached to buffer.", vim.log.levels.WARN)
    return
  end

  local symbols = collect_symbols(bufnr)
  if vim.tbl_isempty(symbols) then
    vim.notify("No symbols available for this buffer.", vim.log.levels.WARN)
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local col = cursor[2] + 1

  local target
  if direction > 0 then
    for _, item in ipairs(symbols) do
      local iline, icol = item.lnum, item.col or 1
      if iline > line or (iline == line and icol > col) then
        target = item
        break
      end
    end
    target = target or symbols[1]
  else
    for i = #symbols, 1, -1 do
      local item = symbols[i]
      local iline, icol = item.lnum, item.col or 1
      if iline < line or (iline == line and icol < col) then
        target = item
        break
      end
    end
    target = target or symbols[#symbols]
  end

  if target then
    vim.api.nvim_win_set_cursor(0, { target.lnum, (target.col or 1) - 1 })
  end
end

vim.keymap.set("n", "]]", function()
  goto_symbol(1)
end, { desc = "Go to next document symbol" })

vim.keymap.set("n", "[[", function()
  goto_symbol(-1)
end, { desc = "Go to previous document symbol" })
