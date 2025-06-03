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

    wk.setup({
      -- classic - modern - helix
      preset = 'modern',
    })
    wk.add({
      {
        "<leader>u", group = "UI"
      },
      {
        mode = { 'v' },
        { "<S-Up>",   ":m '<-2<CR>gv=gv", desc = "Move up" },
        { "<S-Down>", ":m '>+1<CR>gv=gv", desc = "Move down" },
      },
      {
        mode = { 'v', 'n', 'i' },
        { "<C-s>", "<cmd>w<cr>",    desc = "Write File" },
        { "<C-q>", "<cmd>qall<cr>", desc = "Exit Nvim" }
      },
      {
        { "gd",         "<cmd>FzfLua lsp_declarations<cr>", desc = "Go to declaration" },
        { "<leader>cr", vim.lsp.buf.rename,                 desc = "Smart Rename" },
      }
    })
  end
}
