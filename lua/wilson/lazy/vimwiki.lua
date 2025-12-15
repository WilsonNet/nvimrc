return {
	'vimwiki/vimwiki',
	config = function()
		-- Configure vimwiki to use markdown in ~/notes
		vim.g.vimwiki_list = {
			{
				path = vim.fn.expand('~/notes'),
				syntax = 'markdown',
				ext = '.md',
				diary_ext = '.md'
			}
		}
		vim.g.vimwiki_global_ext = 0
		vim.g.vimwiki_ext2syntax = {}
		-- Map Ctrl+Space to toggle checkbox
		vim.keymap.set('n', '<C-Space>', '<Plug>VimwikiToggleListItem')
	end
}
