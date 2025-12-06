return {
  "folke/snacks.nvim",
  dependencies = {
    "folke/todo-comments.nvim",
  },
  priority = 1000,
  lazy = false,
  config = function()
    local Snacks = require 'snacks'
    Snacks.setup {

      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      debug = { enabled = true },
      explorer = { enabled = true },
      image = { enabled = true },
      indent = { enabled = true },
      picker = {
        enabled = true,
        hidden = true,
        ignored = true,
        exclude = { "docs", "node_modules", ".git" },
        layout = {
          preset = "telescope",
        },
      },
      -- lazygit = { enabled = true },
      notifier = { enabled = true },
      notify = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      -- terminal = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      util = { enabled = true },
      input = {
        enabled = true,
        icon = " ",
        icon_hl = "SnacksInputIcon",
        icon_pos = "left",
        prompt_pos = "title",
        win = { style = "input" },
        expand = true,
      },
      zen = {
        enabled = true,
        toggles = {
          dim = false,
        },
        ---@type snacks.win.Config
        win = {
          backdrop = {
            transparent = false,
          }
        }
      },
      dashboard =
      {
        enabled = true,
        sections = {
          { section = "header",
          },
          {
            pane = 2,
            section = "terminal",
            cmd = "echo Work.",
            height = 5,
            padding = 1,
          },
          { section = "keys",   gap = 1, padding = 1 },
          {
            pane = 2,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil

            local function command_succeeds(command)
              if not command or #command == 0 then
                return false
              end
              if vim.fn.executable(command[1]) ~= 1 then
                return false
              end
              if vim.system then
                local job = vim.system(command, { text = true })
                local result = job:wait()
                return result and result.code == 0
              end
              vim.fn.system(command)
              return vim.v.shell_error == 0
            end

            local function gh_ready(command)
              if not in_git then
                return false
              end
              if not command_succeeds({ "gh", "auth", "status" }) then
                return false
              end
              return command_succeeds(command)
            end

            local cmds = {
              {
                title = "Notifications",
                cmd = "gh notify -s -n5",
                action = function()
                  vim.ui.open("https://github.com/notifications")
                end,
                key = "n",
                icon = " ",
                height = 5,
                enabled = function()
                  return gh_ready({ "gh", "notify", "-s", "-n5" })
                end,
              },
              {
                title = "Open Issues",
                cmd = "gh issue list -L 3",
                key = "i",
                action = function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end,
                icon = " ",
                height = 7,
                enabled = function()
                  return gh_ready({ "gh", "issue", "list", "-L", "3" })
                end,
              },
              {
                icon = " ",
                title = "Open PRs",
                cmd = "gh pr list -L 3",
                key = "P",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 7,
                enabled = function()
                  return gh_ready({ "gh", "pr", "list", "-L", "3" })
                end,
              },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
          { section = "startup" },
        },
      },
    }

    local wk = require 'which-key'
    wk.add({
      {
        "<leader>uz",
        function()
          Snacks.zen()
        end,
        desc = "Zen Mode"
      },

      {
        "<leader>e", group = "Explorer"
      },
      {
        "<leader>ee",
        function()
          Snacks.explorer()
        end,
        desc = "Toggle file explorer"
      },
      {
        mode = { "n", "v" }, -- NORMAL and VISUAL mode
        { "<leader>f",  group = "Find Selected" },
        { "<leader>fw", function() Snacks.picker.grep_word({ layout = { preset = "bottom" } }) end, desc = "Find Word/Selection" },
      },
      { "<leader>f",  group = "Find" },
      {
        "<leader><leader>",
        function()
          Snacks.picker.smart({
            layout = { preset = "dropdown", }
          })
        end,
        desc = "Find Files"
      },
      { "<leader>ff", function() Snacks.picker.resume() end,        desc = "Resume last search" },
      { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Find TODOs" },
      {
        "<leader>fW",
        function()
          Snacks.picker.grep({
            layout = { preset = "bottom", }
          })
        end,
        desc = "Find Word"
      },
      {
        "<leader>fw",
        function()
          Snacks.picker.grep_word({
            layout = { preset = "bottom", }
          })
        end,
        desc = "Find Word under cursor"
      },
      { "<leader>fl", function() Snacks.picker.lines() end,              desc = "Find Commands" },
      -- FIX: doed not work as expected
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end,        desc = "Find Symbols" },
      { "<leader>fr", function() Snacks.picker.lsp_references() end,     desc = "Find references" },
      { "<leader>fd", function() Snacks.picker.lsp_declarations() end,   desc = "Find Declarations" },
      { "gd",         function() Snacks.picker.lsp_declarations() end,   desc = "Find Declarations" },
      { "<leader>fx", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics CWD" },
      { "<leader>fX", function() Snacks.picker.diagnostics() end,        desc = "Diagnostics workspace" },
      { "<leader>fm", function() Snacks.picker.man() end,                desc = "Find Man Entry" },
      { "<leader>fb", function() Snacks.picker.buffers() end,            desc = "Find Buffers" },
      { "<leader>fq", function() Snacks.picker.registers() end,          desc = "Find Registers" },
      { "<leader>fn", function() Snacks.picker.notifications() end,      desc = "Find Notification History" },
      { "<leader>fp", function() Snacks.picker.projects() end,           desc = "Find Projects" },
      { "<leader>fg", function() Snacks.picker.git_diff() end,           desc = "Find Git Diff (Hunks)" },
      {
        "<leader>ut",
        function()
          Snacks.picker.colorschemes({
            finder = "vim_colorschemes",
            format = "text",
            preview = "colorscheme",
            preset = "vertical",
            hidden = { "preview" },
            confirm = function(picker, item)
              picker:close()
              if item then
                picker.preview.state.colorscheme = nil
                vim.schedule(function()
                  vim.cmd("colorscheme " .. item.text)
                  local config_file = vim.fn.stdpath("config") .. "/lua/core/colorscheme_percist.lua"

                  local content = {
                    "vim.cmd 'colorscheme " .. item.text .. "'",
                  }

                  vim.fn.writefile(content, config_file)
                end)
              end
            end,
          })
        end,
        desc = "Theme Switcher",
      },
    })
  end
}
