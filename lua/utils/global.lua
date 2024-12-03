local M = {}

local uv = vim.loop
local path_sep = uv.os_uname().version:match("Windows") and "\\" or "/"

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
	local result = table.concat({ ... }, path_sep)
	return result
end

---Get the full path to `$LUNARVIM_CONFIG_DIR`
---@return string|nil
function _G.get_config_dir()
	return vim.call("stdpath", "config")
end

---Get the full path to `$LUNARVIM_CACHE_DIR`
---@return string|nil
function _G.get_cache_dir()
	return vim.call("stdpath", "cache")
end

function _G.split_right()
	vim.cmd("vsplit")
	vim.cmd("wincmd l")
	vim.cmd("b #")
end

-- 向左分割并将当前 buffer 复制到新窗口
function _G.split_left()
	vim.cmd("vsplit")
	vim.cmd("wincmd h")
	vim.cmd("b #")
end

-- From vim defaults.vim
-- ---
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.api.nvim_create_augroup("UserGroup", {})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = "UserGroup",
	callback = function(args)
		local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line("$")
		local not_commit = vim.b[args.buf].filetype ~= "commit"

		if valid_line and not_commit then
			vim.cmd([[normal! g`"]])
		end
	end,
})

return M
