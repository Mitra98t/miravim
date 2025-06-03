return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false,   -- This plugin is already lazy
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>cd", "<cmd>RustLsp debug<cr>",       desc = "Quick Debug" },
      { "<leader>cD", "<cmd>RustLsp debuggables<cr>", desc = "Debug" },
      { "<leader>ct", "<cmd>RustLsp testables<cr>",   desc = "Tests" },
      { "<leader>cs", "<cmd>RustLsp run<cr>",         desc = "Quick Run" },
      { "<leader>cS", "<cmd>RustLsp runnables<cr>",   desc = "Run" },
    })
  end
}
