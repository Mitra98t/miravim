return {
  "folke/which-key.nvim",
  priority = 1000,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function()
    local wk = require('which-key')
    local function write_file()
      local ext = vim.fn.expand('%:e'):lower()
      vim.cmd(ext == 'tex' and 'w!' or 'w')
    end

    wk.setup({
      -- classic - modern - helix
      preset = 'helix',
    })
    wk.add({
      {
        "<leader>m", group = "Real Time Renderers"
      },
      {
        "<leader>mm", group = "Markdown"
      },
      {
        "<leader>u", group = "UI"
      },
      { "<leader>up", function()
          vim.g.statusline_show_path = not vim.g.statusline_show_path
          require("core.ui_persist").save("path", vim.g.statusline_show_path)
          vim.notify("Statusline path " .. (vim.g.statusline_show_path and "enabled" or "disabled"))
        end, desc = "Toggle statusline path" },
      { "<leader>ub", function()
          vim.g.statusline_show_breadcrumbs = not vim.g.statusline_show_breadcrumbs
          require("core.ui_persist").save("breadcrumbs", vim.g.statusline_show_breadcrumbs)
          vim.notify("Statusline breadcrumbs " .. (vim.g.statusline_show_breadcrumbs and "enabled" or "disabled"))
        end, desc = "Toggle statusline breadcrumbs" },
      { "<leader>us",  group = "Speelcheck" },
      { "<leader>use", function()
          vim.opt.spell = true
          vim.opt.spelllang = "en_us"
          local p = require("core.ui_persist")
          p.save("spell", true)
          p.save("spelllang", "en_us")
        end, desc = "Speelcheck English" },
      { "<leader>usi", function()
          vim.opt.spell = true
          vim.opt.spelllang = "it_it"
          local p = require("core.ui_persist")
          p.save("spell", true)
          p.save("spelllang", "it_it")
        end, desc = "Speelcheck Italian" },
      {
        mode = { 'v' },
        { "<S-Up>",   ":m '<-2<CR>gv=gv", desc = "Move up" },
        { "<S-Down>", ":m '>+1<CR>gv=gv", desc = "Move down" },
      },
      {
        mode = { 'v', 'n', 'i' },
        { "<C-s>", write_file,      desc = "Write File" },
        { "<C-q>", "<cmd>qall<cr>", desc = "Exit Nvim" }
      },
      { "<leader>a", group = "AI/Claude Code" },
      { "<leader>c", group = "Code" },
      {
        { "<leader>cr", vim.lsp.buf.rename,       desc = "Smart Rename" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
      }
    })
  end
}
