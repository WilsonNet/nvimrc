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
function M.send_to_cursor()
	local loc = get_location(":p")
	if not loc then
		vim.notify("No file path (unsaved buffer)", vim.log.levels.WARN)
		return
	end
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

--- Send @path:line (or range) to Cursor agent via tmux (same session only).
function M.send_to_cursor_agent()
	M.send_to_cursor_agent_tmux()
end

--- Find a tmux pane running cursor/agent in the current session and send @path:line there.
--- Only considers panes in the same tmux session (so each session can have its own Cursor CLI).
--- Set g:nvim_cursor_cli_tmux_target (e.g. "mysession:0.0") to force a pane when auto-detect fails.
function M.send_to_cursor_agent_tmux()
	if not vim.env.TMUX or vim.env.TMUX == "" then
		vim.notify("Not inside tmux. CursorSend over tmux only works when Neovim is run in a tmux pane.", vim.log.levels.WARN)
		return
	end
	local loc = get_location(":p")
	if not loc then
		vim.notify("No file path (unsaved buffer)", vim.log.levels.WARN)
		return
	end
	local ref = "@" .. loc .. " "
	local target = vim.g.nvim_cursor_cli_tmux_target
	if not target or target == "" then
		local session = vim.trim(vim.fn.system("tmux display-message -p '#{session_name}'"))
		if not session or session == "" or vim.v.shell_error ~= 0 then
			vim.notify("Could not get current tmux session.", vim.log.levels.WARN)
			return
		end
		-- List only panes in the current session (same-session exclusive)
		local out = vim.fn.system(string.format(
			'tmux list-panes -t %s -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command} #{window_name}"',
			vim.fn.shellescape(session)
		))
		if vim.v.shell_error ~= 0 or not out then
			vim.notify("tmux list-panes failed for session " .. session, vim.log.levels.WARN)
			return
		end
		for line in vim.gsplit(out, "\n", { plain = true }) do
			if line == "" then goto continue end
			local pane_target = line:match("^([%w:.-]+)")
			local rest = line:sub(#(pane_target or "") + 2) or ""
			if rest:lower():match("cursor") or rest:lower():match("agent") then
				target = pane_target
				break
			end
			::continue::
		end
		-- Cursor agent often shows as "node"; fallback to first window of same session
		if not target or target == "" then
			target = session .. ":0.0"
		end
	end
	if not target or target == "" then
		vim.notify(
			"No tmux pane with 'cursor' or 'agent' in this session. Set g:nvim_cursor_cli_tmux_target (e.g. session:0.0).",
			vim.log.levels.WARN
		)
		return
	end
	-- -l = literal (no special key parsing)
	local job_id = vim.fn.jobstart({ "tmux", "send-keys", "-l", "-t", target, ref }, { detach = true })
	if job_id <= 0 then
		vim.notify("tmux send-keys failed for target " .. target, vim.log.levels.ERROR)
		return
	end
	vim.notify(("Sent %s to tmux %s"):format(ref:gsub("%s+$", ""), target), vim.log.levels.INFO)
end

function M.setup()
	vim.keymap.set("n", "<leader>cy", M.copy_location, { desc = "Copy file:line (or selection range) to clipboard" })
	vim.keymap.set("v", "<leader>cy", M.copy_location, { desc = "Copy file:line range of selection to clipboard" })
	vim.keymap.set("n", "<leader>co", M.send_to_cursor, { desc = "Open current location in Cursor (goto)" })
	vim.keymap.set("v", "<leader>co", M.send_to_cursor, { desc = "Open selection start in Cursor (goto)" })
	vim.keymap.set("n", "<leader>ca", M.send_to_cursor_agent, { desc = "Send @path:line to Cursor agent (term or tmux)" })
	vim.keymap.set("v", "<leader>ca", M.send_to_cursor_agent, { desc = "Send @path:range to Cursor agent (term or tmux)" })
	vim.api.nvim_create_user_command("CursorSend", M.send_to_cursor_agent, { desc = "Send @path:line to Cursor agent terminal" })
end

M.setup()
return M
