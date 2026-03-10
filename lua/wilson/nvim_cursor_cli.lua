--- nvim-cursor-cli: Copy location / path:line for Cursor and other tools.
--- Extend this module to add more Cursor-related functionality.

local M = {}

--- Build location string: path:line or path:start-end (or path:line:col-col for single-line selection).
--- @param path_mod string fnamemodify modifier, e.g. ":." for relative or ":p" for absolute
--- @return string|nil location string, or nil if no file path
local function get_location(path_mod)
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), path_mod)
	if path == "" then
		return nil
	end
	local loc
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "\22" then
		local start_mark = vim.api.nvim_buf_get_mark(0, "<")
		local end_mark = vim.api.nvim_buf_get_mark(0, ">")
		local start_line, start_col = start_mark[1], start_mark[2]
		local end_line, end_col = end_mark[1], end_mark[2]
		if start_line == end_line and start_col ~= end_col then
			loc = ("%s:%d:%d-%d"):format(path, start_line, start_col + 1, end_col + 1)
		elseif start_line == end_line then
			loc = ("%s:%d"):format(path, start_line)
		else
			loc = ("%s:%d-%d"):format(path, start_line, end_line)
		end
	else
		local line = vim.api.nvim_win_get_cursor(0)[1]
		loc = ("%s:%d"):format(path, line)
	end
	return loc
end

--- Copy file path and line (or visual selection range) to the system clipboard.
--- Normal: path:line  |  Visual: path:start_line-end_line or path:line:start_col-end_col
function M.copy_location()
	local loc = get_location(":.")
	if not loc then
		vim.notify("No file path (unsaved buffer)", vim.log.levels.WARN)
		return
	end
	vim.fn.setreg("+", loc)
	vim.notify(("Copied: %s"):format(loc), vim.log.levels.INFO)
end

--- Send current location to Cursor via CLI: opens/jumps to file:line in Cursor (reuse window).
--- Uses absolute path so Cursor can resolve the file from any cwd.
--- Cursor CLI has no way to inject text into the Composer; this uses `cursor -r -g path:line`.
function M.send_to_cursor()
	local loc = get_location(":p")
	if not loc then
		vim.notify("No file path (unsaved buffer)", vim.log.levels.WARN)
		return
	end
	-- cursor -g accepts file:line[:character]; use start of range for visual
	local goto_spec = loc:match("^([^:]+:%d+)") or loc
	local job_id = vim.fn.jobstart({ "cursor", "-r", "-g", goto_spec }, {
		detach = true,
	})
	if job_id <= 0 then
		vim.notify("Cursor CLI not found or failed to start", vim.log.levels.ERROR)
		return
	end
	vim.notify(("Sent to Cursor: %s"):format(goto_spec), vim.log.levels.INFO)
end

function M.setup()
	vim.keymap.set("n", "<leader>cy", M.copy_location, { desc = "Copy file:line (or selection range) to clipboard" })
	vim.keymap.set("v", "<leader>cy", M.copy_location, { desc = "Copy file:line range of selection to clipboard" })
	vim.keymap.set("n", "<leader>co", M.send_to_cursor, { desc = "Open current location in Cursor (goto)" })
	vim.keymap.set("v", "<leader>co", M.send_to_cursor, { desc = "Open selection start in Cursor (goto)" })
end

M.setup()
return M
