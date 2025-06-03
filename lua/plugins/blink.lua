return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',

  version = '*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'enter' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },


    signature = {
      enabled = true,
      window = {
        border = "rounded"
      }
    },

    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        window = { border = "rounded" },
      },
      menu = {
        border = "rounded",
        draw = {
          columns =
          { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
          treesitter = { "lsp" }
        }
      }
    },
  },
  opts_extend = { "sources.default" }
}
