return {
  "Bekaboo/dropbar.nvim",
  -- optional, but required for fuzzy finder support
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  config = function()
    local dropbar_api = require("dropbar.api")

    local wk = require("which-key")

    wk.add({
      { "<leader>;", group = "Breadcrums" },
      {
        "<leader>;;",
        function()
          dropbar_api.pick()
        end,
        desc = "Pick symbols in winbar"
      }
    })

  end,
}
