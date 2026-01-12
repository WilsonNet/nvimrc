return {
	'kristijanhusak/vim-dadbod-ui',
	dependencies = {
		{ 'tpope/vim-dadbod', lazy = true },
		{ 'kristijanhusak/vim-dadbod-completion', dependencies = { 'hrsh7th/nvim-cmp' }, ft = { 'sql', 'mysql', 'plsql' } },
	},
	cmd = {
		'DBUI',
		'DBUIToggle',
		'DBUIAddConnection',
		'DBUIFindBuffer',
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_show_database_icon = 1
		vim.g.db_ui_force_echo_notifications = 1
		vim.g.db_ui_win_position = 'left'
		vim.g.db_ui_winwidth = 30
	end,
}