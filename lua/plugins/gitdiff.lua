return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  cmd = "CodeDiff",
  config = function()
    local wk = require 'which-key'
    wk.add({
      { "<leader>gf", "<cmd>CodeDiff<cr>", desc = "Open Diff Visualizer" },

    })
  end,
}
