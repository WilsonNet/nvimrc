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

-- Python DAP setup for pipenv
local dap_python = require('dap-python')

-- Automatically find and set the python interpreter from pipenv
local python_path = 'python'
if vim.fn.filereadable('Pipfile') == 1 then
  local venv = vim.fn.trim(vim.fn.system('pipenv --venv'))
  if vim.fn.isdirectory(venv) == 1 then
    python_path = venv .. '/bin/python'
  end
end
dap_python.setup(python_path)

-- Add launch configurations for Python, including FastAPI
dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'FastAPI (ump-bm/api)',
        module = 'uvicorn',
        args = { 'src.app:app', '--host', '0.0.0.0', '--port', '8000', '--reload' },
        cwd = '${workspaceFolder}',
        env = {
            PYTHONPATH = '${workspaceFolder}/src',
            PLATFORM_MODULE_KEY = 'debug_secret_key',  -- Set a default for debugging
        },
    },
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
    },
}
