return {
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_compiler_latexmk = {
      out_dir = "build",
      build_dir = "build",
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      pattern = "*.tex",
      callback = function(args)
        local current = vim.api.nvim_buf_get_name(args.buf)
        if current == "" then
          return
        end

        local dir = vim.fs.dirname(current)
        if not dir or dir == "" then
          return
        end

        local candidates = vim.fs.find("main.tex", {
          path = dir,
          upward = true,
          type = "file",
          limit = 1,
        })

        local main = candidates[1]
        if not main then
          return
        end

        if vim.fs.normalize(main) ~= vim.fs.normalize(current) then
          vim.b[args.buf].vimtex_main = main
        end
      end,
      desc = "Set VimTeX main file by searching upward for main.tex",
    })
  end,
  config = function()
    local wk = require("which-key")
    local function toggle_tex_autosave()
      if vim.bo.filetype ~= "tex" then
        vim.notify("Open a .tex file to use this toggle", vim.log.levels.WARN, { title = "VimTeX" })
        return
      end
      vim.cmd("TexAutosaveToggle")
    end

    wk.add({
      { "<leader>ml",  group = "LaTeX", },
      { "<leader>mlc", "<cmd>VimtexCompile<cr>", desc = "Compile", },
      { "<leader>mls", "<cmd>VimtexStop<cr>",    desc = "Stop Compiler", },
      { "<leader>mlv", "<cmd>VimtexView<cr>",    desc = "View PDF", },
      { "<leader>mlt", "<cmd>VimtexTocOpen<cr>", desc = "Open TOC", },
      { "<leader>mlk", "<cmd>VimtexClean<cr>",   desc = "Clean Aux Files", },
      { "<leader>mlK", "<cmd>VimtexClean!<cr>",  desc = "Clean Project", },
      { "<leader>mle", "<cmd>VimtexErrors<cr>",  desc = "Show Errors", },
      { "<leader>mla", toggle_tex_autosave,      desc = "Toggle autosave", },
    })
  end,
}
