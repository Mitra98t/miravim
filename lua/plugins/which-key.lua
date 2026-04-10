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
      { "<leader>us",  group = "Speelcheck" },
      { "<leader>use", ":setlocal spell spelllang=en_us<cr>", desc = "Speelcheck" },
      { "<leader>usi", ":setlocal spell spelllang=it_it<cr>", desc = "Speelcheck" },
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
      { "<leader>c", group = "Code" },
      {
        { "gd",         "<cmd>FzfLua lsp_declarations<cr>", desc = "Go to declaration" },
        { "<leader>cr", vim.lsp.buf.rename,                 desc = "Smart Rename" },
      }
    })
  end
}
