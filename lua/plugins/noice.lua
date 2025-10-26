return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = function()
    local border = vim.g.floating_border_style or "rounded"
    return {
      presets = {
        lsp_doc_border = true,
      },
      views = {
        hover = {
          border = {
            style = border,
          },
        },
      },
    }
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
  }
}
