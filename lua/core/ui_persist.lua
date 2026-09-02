local M = {}
local state_file = vim.fn.stdpath("data") .. "/nvim_ui_state.json"

local defaults = {
  breadcrumbs        = true,
  path               = true,
  spell              = false,
  spelllang          = "en_us",
  format_on_save     = true,
  colorizer          = true,  -- colorizer.setup(*) lo abilita di default
  minimap            = false, -- neominimap parte con auto_enable = false
  smooth_scroll      = true,
  listchars          = 0,     -- 0=off 1=tabs 2=spaces 3=all
  colorscheme        = "ember-soft",
  image_max_width    = 15,   -- max_width colonne per preview immagini inline
}

-- Livello 0: spento | 1: tab+trail | 2: +space+nbsp | 3: +eol
local listchars_levels = {
  [0] = nil,
  [1] = { tab = '→ ', trail = '·' },
  [2] = { tab = '→ ', space = '·', trail = '•', nbsp = '␣' },
  [3] = { tab = '→ ', space = '·', trail = '•', eol = '↲', nbsp = '␣' },
}

function M.apply_listchars(level)
  local chars = listchars_levels[level or 0]
  if chars then
    vim.opt.listchars = chars
    vim.opt.list = true
  else
    vim.opt.list = false
  end
end

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

-- Migrazione: vecchio stato booleano → intero
if type(M.state.listchars) == "boolean" then
  M.state.listchars = M.state.listchars and 3 or 0
  write_state(M.state)
end

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
M.apply_listchars(M.state.listchars)

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
      vim.cmd("Neominimap Enable")
      vim.g.minimap_enabled = true
    end
    if not M.state.smooth_scroll then
      require("snacks").scroll.disable()
    end
  end,
})

return M
