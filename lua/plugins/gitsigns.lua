return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gs = require("gitsigns")

    gs.setup({
      current_line_blame = true,
    })
  end,
}
