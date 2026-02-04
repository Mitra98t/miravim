return {
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "skim"
  end,
  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>m", group = "LaTeX", ft = "tex" },
      { "<leader>mc", "<cmd>VimtexCompile<cr>", desc = "Compile", ft = "tex" },
      { "<leader>ms", "<cmd>VimtexStop<cr>", desc = "Stop Compiler", ft = "tex" },
      { "<leader>mv", "<cmd>VimtexView<cr>", desc = "View PDF", ft = "tex" },
      { "<leader>mt", "<cmd>VimtexTocOpen<cr>", desc = "Open TOC", ft = "tex" },
      { "<leader>mk", "<cmd>VimtexClean<cr>", desc = "Clean Aux Files", ft = "tex" },
      { "<leader>mK", "<cmd>VimtexClean!<cr>", desc = "Clean Project", ft = "tex" },
      { "<leader>me", "<cmd>VimtexErrors<cr>", desc = "Show Errors", ft = "tex" },
    })
  end,
}
