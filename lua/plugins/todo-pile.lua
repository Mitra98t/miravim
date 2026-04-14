return {
  "Mitra98t/TodoPile",
  dependencies = { "folke/snacks.nvim" }, -- optional, remove if not using snacks in favor of default picker
  config = function()
    require("todo_pile").setup({
      ghost_text = true,
      ghost_text_hl = "DiagnosticHint", 
      jump_after_pop = false,
    })

    local wk = require 'which-key'
    wk.add({
      { "<leader>ct",  group = "Stack TODOs" },
      { "<leader>ctj", "<cmd>TodoPileJump<cr>",         desc = "Jump to head" },
      { "<leader>cta", "<cmd>TodoPileAdd<cr>",          desc = "Add to stack" },
      { "<leader>ctp", "<cmd>TodoPilePop<cr>",          desc = "Pop from stack" },
      { "<leader>ctl", "<cmd>TodoPileList<cr>",         desc = "List todo stack" },
      { "<leader>ctr", "<cmd>TodoPileReorder<cr>",      desc = "Reorder todo stack" },
      { "<leader>ctx", "<cmd>TodoPileClose<cr>",        desc = "Remove single todo from stack" },
      { "<leader>ctX", "<cmd>TodoPileClearProject<cr>", desc = "Clear the todo stack" },
    })
  end,
}
