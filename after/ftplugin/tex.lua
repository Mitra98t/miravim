local bufnr = vim.api.nvim_get_current_buf()
local group = vim.api.nvim_create_augroup("tex_idle_autowrite_" .. bufnr, { clear = true })
local timer = vim.uv.new_timer()
local idle_ms = 2200
vim.b[bufnr].tex_idle_autowrite_enabled = true

local function stop_timer()
  if timer and not timer:is_closing() then
    timer:stop()
  end
end

local function can_save()
  return vim.api.nvim_buf_is_valid(bufnr)
      and vim.bo[bufnr].buftype == ""
      and vim.bo[bufnr].modifiable
      and not vim.bo[bufnr].readonly
      and vim.bo[bufnr].modified
end

local function save_after_idle()
  if not vim.b[bufnr].tex_idle_autowrite_enabled then
    stop_timer()
    return
  end

  stop_timer()
  timer:start(idle_ms, 0, function()
    vim.schedule(function()
      if not vim.b[bufnr].tex_idle_autowrite_enabled then
        return
      end

      if not can_save() then
        return
      end

      local mode = vim.api.nvim_get_mode().mode
      if mode:match("^[iR]") then
        return
      end

      pcall(vim.api.nvim_buf_call, bufnr, function()
        vim.cmd("silent! w!")
      end)
    end)
  end)
end

vim.api.nvim_buf_create_user_command(bufnr, "TexAutosaveToggle", function()
  vim.b[bufnr].tex_idle_autowrite_enabled = not vim.b[bufnr].tex_idle_autowrite_enabled
  stop_timer()
  local state = vim.b[bufnr].tex_idle_autowrite_enabled and "ON" or "OFF"
  vim.notify("TeX idle autosave: " .. state, vim.log.levels.INFO, { title = "VimTeX" })
end, {
  desc = "Toggle TeX idle autosave",
})

vim.api.nvim_create_autocmd("InsertLeave", {
  buffer = bufnr,
  group = group,
  callback = save_after_idle,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  buffer = bufnr,
  group = group,
  callback = stop_timer,
})

vim.api.nvim_create_autocmd({ "BufUnload", "BufWipeout" }, {
  buffer = bufnr,
  group = group,
  callback = function()
    if timer and not timer:is_closing() then
      timer:stop()
      timer:close()
    end
  end,
})
