return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gs = require("gitsigns")
    local border = vim.g.floating_border_style or "rounded"

    gs.setup({
      current_line_blame = true,
      preview_config = {
        border = border,
      },
    })


    local wk = require 'which-key'
    wk.add({
      { "]c",         "<cmd>Gitsigns nav_hunk next<cr>",       desc = "Goto Next Hunk" },
      { "[c",         "<cmd>Gitsigns nav_hunk prev<cr>",       desc = "Goto Prev Hunk" },
      { "<leader>g",  group = "Git" },
      { "<leader>gb", "<cmd>Gitsigns blame<cr>",               desc = "Show Blame of Entire File" },
      { "<leader>gg", "<cmd>Gitsigns preview_hunk<cr>",        desc = "Preview Hunk" },
      { "<leader>gG", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Preview Hunk Inline" },
      { "<leader>gn", "<cmd>Gitsigns nav_hunk next<cr>",       desc = "Goto Next Hunk" },
      { "<leader>gN", "<cmd>Gitsigns nav_hunk prev<cr>",       desc = "Goto Prev Hunk" },
      { "<leader>xg", "<cmd>Gitsigns setqflist<cr>",           desc = "Open quick fix list for Hunks" },

    })
  end,
}
