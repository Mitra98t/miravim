return {
  "norcalli/nvim-colorizer.lua",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require 'colorizer'.setup({
      "*",
      css = { rgb_fn = true },
    })
    local wk = require 'which-key'
    wk.add({
      {
        "<leader>uc",
        function()
          vim.cmd("ColorizerToggle")
          vim.g.colorizer_enabled = not vim.g.colorizer_enabled
          require("core.ui_persist").save("colorizer", vim.g.colorizer_enabled)
        end,
        desc = "Toggle colors display on current buffer"
      },
    })
  end,
}
