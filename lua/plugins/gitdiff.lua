return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  cmd = "CodeDiff",
  config = function()
    require("codediff").setup({
      diff = {
        conflict_result_position = "center",
      },
    })

    local wk = require 'which-key'
    wk.add({
      { "<leader>g",  group = "Git" },
      {
        mode = { "v" }, -- NORMAL and VISUAL mode
        {
          "<leader>gh",
          ":CodeDiff history<CR>",
          desc = "View selection history"
        },
      },
      {
        mode = { "n" }, -- NORMAL and VISUAL mode
        { "<leader>gh", "<cmd>CodeDiff history %<cr>", desc = "View file history" },
      },
      { "<leader>gf", "<cmd>CodeDiff file HEAD --inline<cr>", desc = "Diff file vs HEAD" },
      { "<leader>gF", "<cmd>CodeDiff HEAD<cr>",               desc = "Diff repo vs HEAD" },
      { "<leader>gd", "<cmd>CodeDiff<cr>",                    desc = "Git status explorer" },
      {
        "<leader>gp",
        function()
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes(":CodeDiff ...<Left><Left><Left>", true, true, true),
            "n",
            false
          )
        end,
        desc = "PR diff (merge-base, inserisci branch)"
      },
      { "<leader>gH", "<cmd>CodeDiff history<cr>", desc = "Repo commit history" },
      {
        "<leader>gD",
        function()
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes(":CodeDiff ", true, true, true),
            "n",
            false
          )
        end,
        desc = "CodeDiff (custom revision)"
      },
    })
  end,
}
