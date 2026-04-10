---@module "neominimap.config.meta"
return {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false, -- NOTE: NO NEED to Lazy load
  init = function()
    -- The following options are recommended when layout == "float"
    vim.opt.wrap = false
    vim.opt.sidescrolloff = 36 -- Set a large value

    --- Put your configuration here
    ---@type Neominimap.UserConfig
    vim.g.neominimap = {
      auto_enable = true,
    }
  end,
  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>un", group = "Minimap" },

      -- Global Minimap Controls
      { "<leader>unm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
      { "<leader>uno", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
      { "<leader>unc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
      { "<leader>unr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },

      -- Window-Specific Minimap Controls
      { "<leader>unw", group = "Window minimap" },
      { "<leader>unwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
      { "<leader>unwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },
      { "<leader>unwo", "<cmd>Neominimap WinEnable<cr>", desc = "Enable minimap for current window" },
      { "<leader>unwc", "<cmd>Neominimap WinDisable<cr>", desc = "Disable minimap for current window" },

      -- Tab-Specific Minimap Controls
      { "<leader>unt", group = "Tab minimap" },
      { "<leader>untt", "<cmd>Neominimap TabToggle<cr>", desc = "Toggle minimap for current tab" },
      { "<leader>untr", "<cmd>Neominimap TabRefresh<cr>", desc = "Refresh minimap for current tab" },
      { "<leader>unto", "<cmd>Neominimap TabEnable<cr>", desc = "Enable minimap for current tab" },
      { "<leader>untc", "<cmd>Neominimap TabDisable<cr>", desc = "Disable minimap for current tab" },

      -- Buffer-Specific Minimap Controls
      { "<leader>unb", group = "Buffer minimap" },
      { "<leader>unbt", "<cmd>Neominimap BufToggle<cr>", desc = "Toggle minimap for current buffer" },
      { "<leader>unbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Refresh minimap for current buffer" },
      { "<leader>unbo", "<cmd>Neominimap BufEnable<cr>", desc = "Enable minimap for current buffer" },
      { "<leader>unbc", "<cmd>Neominimap BufDisable<cr>", desc = "Disable minimap for current buffer" },

      -- Focus Controls
      { "<leader>unf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
      { "<leader>unu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
      { "<leader>uns", "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
    })
  end
}
