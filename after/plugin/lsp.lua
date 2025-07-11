local lsp_zero = require("lsp-zero")

require('mason').setup({})
require('mason-tool-installer').setup({
	ensure_installed = {
		'java-debug-adapter',
		'java-test',
	},
})
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
	handlers = {
		function(server_name)
			if server_name ~= 'jdtls' then
				require('lspconfig')[server_name].setup({})
			end
		end,
		jdtls = lsp_zero.noop,
	},
})

vim.api.nvim_command('MasonToolsInstall')



local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
})

lsp_zero.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vwg", function() vim.lsp.buf.document_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end, opts)
	vim.keymap.set("n", "<leader>fe", ':EslintFixAll<CR>', opts)
end)
