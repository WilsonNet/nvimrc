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

vim.keymap.set({"n", "i"}, "<Leader>cf", function()
  require("telescope.builtin").find_files({
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        if entry and entry.path then
          local rel_path = vim.fn.fnamemodify(entry.path, ":.")
          require("telescope.actions").close(prompt_bufnr)
          vim.api.nvim_put({rel_path}, 'c', true, true)
        end
      end)
      map("n", "<CR>", function(prompt_bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        if entry and entry.path then
          local rel_path = vim.fn.fnamemodify(entry.path, ":.")
          require("telescope.actions").close(prompt_bufnr)
          vim.api.nvim_put({rel_path}, 'c', true, true)
        end
      end)
      return true
    end,
  })
end, { desc = "Telescope: Insert relative file path" })



require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    }
  }
}
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
