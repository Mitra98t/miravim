return {
  "norcalli/nvim-colorizer.lua",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require 'colorizer'.setup()
    local wk = require 'which-key'
    wk.add({
      { "<leader>uc", "<cmd>ColorizerToggle<cr>", desc = "Toggle colors display on current buffer" },
    })
  end,
}
