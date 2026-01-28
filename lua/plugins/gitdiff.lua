return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  cmd = "CodeDiff",
  config = function()
    local wk = require 'which-key'
    wk.add({
      { "<leader>gf", "<cmd>CodeDiff<cr>", desc = "Open Diff Visualizer" },
      {
        "<leader>gF",
        function()
          vim.ui.input({ prompt = "CodeDiff revision (es: HEAD, HEAD~1, main, v1.0.0): ", default = "HEAD" },
            function(rev)
              if not rev or rev == "" then return end
              vim.cmd("CodeDiff file " .. rev)
            end)
        end,
        desc = "CodeDiff current file vs revision"
      },
    })
  end,
}
