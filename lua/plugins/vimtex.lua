return {
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_compiler_latexmk = {
      out_dir = "build",
    }
  end,
  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>m",  group = "LaTeX",           },
      { "<leader>mc", "<cmd>VimtexCompile<cr>", desc = "Compile",         },
      { "<leader>ms", "<cmd>VimtexStop<cr>",    desc = "Stop Compiler",   },
      { "<leader>mv", "<cmd>VimtexView<cr>",    desc = "View PDF",        },
      { "<leader>mt", "<cmd>VimtexTocOpen<cr>", desc = "Open TOC",        },
      { "<leader>mk", "<cmd>VimtexClean<cr>",   desc = "Clean Aux Files", },
      { "<leader>mK", "<cmd>VimtexClean!<cr>",  desc = "Clean Project",   },
      { "<leader>me", "<cmd>VimtexErrors<cr>",  desc = "Show Errors",     },
    })
  end,
}
