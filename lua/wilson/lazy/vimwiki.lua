return {
	'vimwiki/vimwiki',
	init = function()
		-- Configure vimwiki BEFORE it loads to prevent - mapping
		vim.g.vimwiki_list = {
			{
				path = vim.fn.expand('~/notes'),
				syntax = 'markdown',
				ext = '.md',
				diary_ext = '.md'
			}
		}
		vim.g.vimwiki_global_ext = 0
		-- Disable vimwiki's default - mapping to avoid conflict with oil.nvim
		vim.g.vimwiki_key_mappings = {
			all_maps = 1,
			headers = 0,  -- Disable header mappings (-, +, =)
		}
	end,
	config = function()
		-- Map Ctrl+Space to toggle checkbox
		vim.keymap.set('n', '<C-Space>', '<Plug>VimwikiToggleListItem')
	end
}
