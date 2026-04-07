return {
  -- Allows to reorder, rename, duplicate, delete and annotate declaration (lsp
  -- based)
  "Sang-it/fluoride",
  config = function()
    require("fluoride").setup({
      max_depth = 5,
    })
    local wk = require 'which-key'
    wk.add({
      { "<leader>cR", "<cmd>Fluoride<cr>", desc = "Reorder properties" }
    })
  end,
}
