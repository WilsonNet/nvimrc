local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>pf', builtin.git_files, {})
vim.keymap.set('n', '<leader>pg', function() builtin.live_grep({grep_open_files=true}) end)
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ps',  function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") } );
end)


function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end


local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<space>g', ':Telescope current_buffer_fuzzy_find<cr>', opts)
keymap('v', '<space>g', function()
	local text = vim.getVisualSelection()
	builtin.current_buffer_fuzzy_find({ default_text = text })
end, opts)

keymap('n', '<space>G', ':Telescope live_grep<cr>', opts)
keymap('v', '<space>G', function()
	local text = vim.getVisualSelection()
	builtin.live_grep({ default_text = text })
end, opts)
