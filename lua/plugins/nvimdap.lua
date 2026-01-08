return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --   dapui.close()
    -- end

    -- Godot Debugger Adapter
    dap.adapters.godot = {
      type = "server",
      host = "127.0.0.1",
      port = 6006,
    }
    dap.configurations.gdscript = {
      {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
        launch_scene = true,
      },
    }

    local wk = require("which-key")
    wk.add({
      {
        "<leader>d", group = "Debugger"
      },
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
      { "<leader>ds", "<cmd>DapContinue<cr>",         desc = "Continue" },
      { "<leader>dd", "<cmd>DapStepInto<cr>",         desc = "Step Into" },
      { "<leader>do", "<cmd>DapStepOver<cr>",         desc = "Step Over" },
      { "<leader>du", "<cmd>DapStepOut<cr>",          desc = "Step Out" },
      { "<leader>dt", "<cmd>DapTerminate<cr>",        desc = "Terminate" },
      { "<leader>dq", "<cmd>DapTerminate<cr>",        desc = "Close UI" },
      {
        "<leader>dp",
        function()
          require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
        end,
        desc = "Log Message"
      },
    })
  end
}
