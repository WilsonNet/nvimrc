local dap = require('dap')
local dapui = require('dapui')
local dap_virtual_text = require('nvim-dap-virtual-text')


-- DAP UI setup (minimal, can be extended)
dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

-- DAP signs (icons)
vim.fn.sign_define('DapBreakpoint', {text='', texthl='DiagnosticSignError', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='', texthl='DiagnosticSignWarn', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='DiagnosticSignInfo', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='', texthl='DiagnosticSignInfo', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='DiagnosticSignHint', linehl='Visual', numhl=''})

-- Keymaps (all lowercase)
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = "Debug: Start/Continue" })
vim.keymap.set('n', '<leader>dsi', dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set('n', '<leader>dso', dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set('n', '<leader>do', dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set('n', '<leader>dbb', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Debug: Set Conditional Breakpoint" })
vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = "Debug: Toggle UI" })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = "Debug: Run Last Configuration" })

-- Auto open/close dapui
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dap_virtual_text.setup()

-- Python DAP setup (no mason, just python)
local dap_python = require('dap-python')
dap_python.setup('python') -- Uses system python, or specify venv path
