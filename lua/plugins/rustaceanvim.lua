return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  ft = { 'rust' },
  config = function()
    local wk = require("which-key")

    local function rust_lsp_prompt(subcommand, opts)
      opts = opts or {}
      local prompt = opts.prompt or ("Args for RustLsp " .. subcommand .. " (space separated, leave empty for none): ")
      return function()
        vim.ui.input({ prompt = prompt }, function(input)
          if input == nil then
            return
          end
          if input:match("^%s*$") then
            vim.cmd.RustLsp(subcommand)
            return
          end
          local command = { subcommand }
          for arg in input:gmatch("%S+") do
            table.insert(command, arg)
          end
          vim.cmd.RustLsp(command)
        end)
      end
    end

    local mappings = {
      { "<leader>cd", "debug",       "Quick Debug", "Args per RustLsp debug (spazi per separare, lascia vuoto per nessuno): " },
      { "<leader>cD", "debuggables", "Debug",       "Args per RustLsp debuggables (spazi per separare, lascia vuoto per nessuno): " },
      { "<leader>ct", "testables",   "Tests",       "Args per RustLsp testables (spazi per separare, lascia vuoto per nessuno): " },
      { "<leader>cs", "run",         "Quick Run",   "Args per RustLsp run (spazi per separare, lascia vuoto per nessuno): " },
      { "<leader>cS", "runnables",   "Run",         "Args per RustLsp runnables (spazi per separare, lascia vuoto per nessuno): " },
    }

    local registrations = {}
    for _, map in ipairs(mappings) do
      table.insert(registrations, {
        map[1],
        rust_lsp_prompt(map[2], { prompt = map[4] }),
        desc = map[3],
      })
    end

    wk.add(registrations)
  end
}
