return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "kLabz/haxe.vim",
    ft="haxe",
    dependencies={"mfussenegger/nvim-dap"}
  },
  {"nvim-neotest/nvim-nio"},
  ["hrsh7th/nvim-cmp"] = {
    lazy=false,
    config = function()
      local cmp = require "cmp"

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      require "plugins.configs.cmp"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies={"rcarriga/nvim-dap-ui"},
    config=function()
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
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
      vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
      vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
      vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
      vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
      vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
      vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
      vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
      vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
      vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
        require('dap.ui.widgets').hover()
      end)
      vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
        require('dap.ui.widgets').preview()
      end)
      vim.keymap.set('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end)
      vim.keymap.set('n', '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
      end)

      dap.adapters.hl = {
        type="executable",
        command="node",
        args = {'/path/to/your/hashlink-debugger/adapter.js'}
      }
      dap.configurations.haxe = {
        {
          name="HashLink",
          request="launch",
          type="hl",
          cwd=vim.fn.getcwd(),
          classPaths={'src'}, -- Hard code your class paths here
          program='path/to/your/binary.hl' -- Hard code your hl executable here
          --hotReload=true,
        }
      }
     end
  }
 }
