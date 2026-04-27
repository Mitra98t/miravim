local M = {}
local state_file = vim.fn.stdpath("data") .. "/nvim_ui_state.json"

local defaults = {
  breadcrumbs    = true,
  path           = true,
  spell          = false,
  spelllang      = "en_us",
  format_on_save = true,
  colorizer      = true,   -- colorizer.setup(*) lo abilita di default
  minimap        = false,  -- neominimap parte con auto_enable = false
  smooth_scroll  = true,
  colorscheme    = "ember-soft",
}

local function write_state(state)
  local ok, encoded = pcall(vim.fn.json_encode, state)
  if ok then vim.fn.writefile({ encoded }, state_file) end
end

local function read_state()
  local ok, content = pcall(vim.fn.readfile, state_file)
  if not ok or #content == 0 then return nil end
  local ok2, decoded = pcall(vim.fn.json_decode, table.concat(content, ""))
  return (ok2 and type(decoded) == "table" and decoded) or nil
end

local existing = read_state()
local is_first_launch = existing == nil

M.state = vim.tbl_deep_extend("force", defaults, existing or {})

-- Primo avvio: scrivi subito i default su disco
if is_first_launch then
  write_state(M.state)
end

function M.get(key) return M.state[key] end

function M.save(key, value)
  M.state[key] = value
  write_state(M.state)
end

-- Impostazioni immediate (non dipendono da plugin)
pcall(vim.cmd, "colorscheme " .. M.state.colorscheme)
vim.g.statusline_show_breadcrumbs = M.state.breadcrumbs
vim.g.statusline_show_path        = M.state.path
vim.g.format_on_save_enabled      = M.state.format_on_save
vim.g.colorizer_enabled           = M.state.colorizer
vim.g.minimap_enabled             = M.state.minimap
vim.g.smooth_scroll_enabled       = M.state.smooth_scroll

if M.state.spell then
  vim.opt.spell     = true
  vim.opt.spelllang = M.state.spelllang
end

-- Impostazioni plugin-dipendenti: applica dopo il caricamento dei plugin
vim.api.nvim_create_autocmd("User", {
  pattern  = "VeryLazy",
  once     = true,
  callback = function()
    if not M.state.colorizer then
      vim.cmd("ColorizerToggle")
      vim.g.colorizer_enabled = false
    end
    if M.state.minimap then
      vim.cmd("Neominimap on")
      vim.g.minimap_enabled = true
    end
    if not M.state.smooth_scroll then
      require("snacks").scroll.disable()
    end
  end,
})

return M
