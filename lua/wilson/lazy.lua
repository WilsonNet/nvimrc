-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	require("wilson.lazy.telescope"),
	require("wilson.lazy.comment"),
	require("wilson.lazy.tokyonight"),
	require("wilson.lazy.rose_pine"),
	require("wilson.lazy.treesitter"),
	require("wilson.lazy.oil"),
	require("wilson.lazy.copilotchat"),
	require("wilson.lazy.harpoon"),
	require("wilson.lazy.undotree"),
	require("wilson.lazy.fugitive"),
	require("wilson.lazy.none_ls"),
	require("wilson.lazy.mason"),
	require("wilson.lazy.mason_lspconfig"),
	require("wilson.lazy.octo"),
	require("wilson.lazy.trouble"),
	require("wilson.lazy.lsp_zero"),
	require("wilson.lazy.lspconfig"),
	require("wilson.lazy.cmp"),
	require("wilson.lazy.nio"),
	require("wilson.lazy.dap"),
	require("wilson.lazy.dap_ui"),
	require("wilson.lazy.dap_python"),
	require("wilson.lazy.dap_virtual_text"),
	require("wilson.lazy.opencode"),
})



vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight-night')
