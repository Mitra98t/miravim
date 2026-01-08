return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local border = vim.g.floating_border_style or "rounded"
      local toggleterm = require("toggleterm")
      toggleterm.setup({
        shade_terminals = false,
      })
      local Terminal = require("toggleterm.terminal").Terminal

      local floating = Terminal:new({
        direction = "float",
        float_opts = {
          border = border,
        },
      })

      function _floating_toggle()
        floating:toggle()
      end

      local btm = Terminal:new({
        cmd = "btm",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = border,
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "n",
            "q",
            "<cmd>close<CR>",
            { noremap = true, silent = true }
          )
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _btm_toggle()
        btm:toggle()
      end

      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = border,
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "n",
            "q",
            "<cmd>close<CR>",
            { noremap = true, silent = true }
          )
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      local codex = Terminal:new({
        cmd = "codex",
        dir = "git_dir",
        direction = "vertical",
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd("startinsert!")
          local target_width = math.floor(vim.o.columns * 0.40)
          if vim.api.nvim_win_is_valid(term.window) then
            vim.api.nvim_win_set_width(term.window, target_width)
          end
          vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "n",
            "q",
            "<cmd>close<CR>",
            { noremap = true, silent = true }
          )
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _codex_toggle()
        codex:toggle()
      end

      local wk = require("which-key")

      wk.add({
        { "<leader>t",  group = "Terminal" },
        { "<leader>tt", "<cmd>ToggleTerm<cr>",             desc = "Open last Terminal" },
        { "<leader>tf", "<cmd>lua _floating_toggle()<cr>", desc = "Open floating Terminal" },
        { "<leader>tg", "<cmd>lua _lazygit_toggle()<cr>",  desc = "Open LazyGit" },
        { "<leader>tb", "<cmd>lua _btm_toggle()<cr>",      desc = "Open Cottom" },
        { "<leader>tc", "<cmd>lua _codex_toggle()<cr>",    desc = "Open Codex" },
        {
          mode = { "t" },
          { "<C-w>", [[<C-\><C-n><C-w>]], desc = "Enter normal mode" },
          { "<esc>", [[<C-\><C-n>]],      desc = "Enter normal mode" },
        },
      })
    end,
  },
}
