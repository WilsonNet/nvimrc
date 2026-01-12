-- Load project-specific settings
local function load_project_settings()
	local settings_path = vim.fn.getcwd() .. '/settings.lua'
	if vim.fn.filereadable(settings_path) == 1 then
		local ok, settings = pcall(dofile, settings_path)
		if ok then
			return settings
		end
	end
	return {}
end

local project_settings = load_project_settings()

-- Mason setup for automatic LSP installation
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'lua_ls',
		'cssls',
		'emmet_ls',
		'pyright',
		'tailwindcss',
		'eslint',
		'jdtls',
		'typos_lsp',
		'vtsls',
		'cucumber_language_server'
	},
})

-- Configure pyright with project-specific python path
vim.lsp.config('pyright', {
	settings = {
		python = {
			pythonPath = project_settings.python_path
		}
	}
})

-- Configure other language servers if needed
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			}
		}
	}
})

-- Enable language servers
vim.lsp.enable({
	'lua_ls',
	'cssls', 
	'emmet_ls',
	'pyright',
	'tailwindcss',
	'eslint',
	'typos_lsp',
	'vtsls'
})

-- Note: jdtls and cucumber_language_server need special handling
-- You can enable them manually when needed

-- CMP setup
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	sources = {
		{ name = 'vim-dadbod-completion' },
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
})

-- LSP keymaps (using native LspAttach autocmd)
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(event)
		local opts = { buffer = event.buf, remap = false }

		-- Navigation
		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
		vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
		vim.keymap.set("n", "<leader>vwg", function() vim.lsp.buf.document_symbol() end, opts)
		
		-- Diagnostics
		vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
		vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
		
		-- Actions
		vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
		vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
		vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
		
		-- Help
		vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
		
		-- Formatting
		vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end, opts)
		vim.keymap.set("n", "<leader>fe", ':EslintFixAll<CR>', opts)
	end,
})