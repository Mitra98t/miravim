return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local format_on_save_enabled = false

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "ast-grep", "stylua" },
        python = { "isort", "black" },
      },
      format_on_save = function(_)
        if format_on_save_enabled then
          return { lsp_fallback = true, async = false, timeout_ms = 1000 }
        end
      end,
    })

    local wk = require("which-key")

    wk.add({
      {
        mode = { "n", "v" }, -- NORMAL and VISUAL mode
        {
          "<leader>cf",
          function()
            conform.format({
              lsp_fallback = true,
              async = false,
              timeout_ms = 1000,
            })
          end,
          desc = "Format file (or range in visual mode)"
        }
      },
      {
        "<leader>uf",
        function()
          format_on_save_enabled = not format_on_save_enabled
          vim.notify(
            "Format on save " .. (format_on_save_enabled and "enabled" or "disabled"),
            vim.log.levels.INFO
          )
        end,
        desc = "Toggle format on save"
      }
    })
  end,
}
