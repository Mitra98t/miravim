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

    -- Rimuove i default LSP keymaps di Neovim 0.10+ (grn, gra, grr, gri, gO, K)
    -- che confliggono con i nostri mapping globali in snacks.lua / which-key.lua
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local defaults = { "grn", "grr", "gra", "gri", "gO", "K" }
        for _, key in ipairs(defaults) do
          pcall(vim.keymap.del, "n", key, { buffer = args.buf })
        end
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, args.buf)
        end
      end,
    })

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
