return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  opts = function()
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")
    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "clangd",
        "eslint_d",
      },
    })

    -- Godot LSP setup
    --
    local project_file = vim.fn.getcwd() .. "/project.godot"
    if vim.fn.filereadable(project_file) == 1 then
      vim.cmd("LspStart gdscript")
      vim.cmd("LspStart gdshader_lsp")
      -- require("lspconfig").start_server({
      --   name = "gdscript",
      --   cmd = { "godot-lsp" },
      --   capabilities = capabilities,
      -- })
    end

    local capabilities = require("blink.cmp").get_lsp_capabilities()
    return {
      ensure_installed = {
        "rust_analyzer",
      },
      automatic_installation = false,
      automatic_enable = {
        exclude = {
          "rust_analyzer",
        }
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({ capabilities = capabilities })
        end,
      },
    }
  end,
}
