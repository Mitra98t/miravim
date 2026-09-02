return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	config = function()
		local actions = require("diffview.actions")

		require("diffview").setup({
      file_panel = {
        listing_style = "list",
        win_config = {
          width = 40,
        },
      },
      enhanced_diff_hl = true,
			keymaps = {
				disable_defaults = false,
				view = {
					{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
				},
				file_panel = {
					{ "n", "q",     "<cmd>DiffviewClose<cr>",  { desc = "Close Diffview" } },
				},
				file_history_panel = {
					{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
				},
			},
		})

		local wk = require("which-key")
		wk.add({
			{ "<leader>g", group = "Git" },
			{
				mode = { "v" },
				{ "<leader>gh", ":'<,'>DiffviewFileHistory<cr>", desc = "View selection history" },
			},
			{
				mode = { "n" },
				{
					"<leader>gh",
					function() vim.cmd("DiffviewFileHistory " .. vim.fn.expand("%")) end,
					desc = "View file history",
				},
			},
			{
				"<leader>gf",
				function() vim.cmd("DiffviewOpen HEAD -- " .. vim.fn.expand("%")) end,
				desc = "Diff file vs HEAD",
			},
			{ "<leader>gF", "<cmd>DiffviewOpen HEAD<cr>",        desc = "Diff repo vs HEAD" },
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>",              desc = "Git status explorer" },
			{
				"<leader>gp",
				function()
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes(":DiffviewOpen ...<Left><Left><Left>", true, true, true),
						"n",
						false
					)
				end,
				desc = "PR diff (merge-base, insert branch)",
			},
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo commit history" },
			{
				"<leader>gD",
				function()
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes(":DiffviewOpen ", true, true, true),
						"n",
						false
					)
				end,
				desc = "DiffviewOpen (custom revision)",
			},
		})
	end,
}
