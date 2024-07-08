local M = {}

local fn = vim.fn

local is_mac = fn.has("mac") == 1 or fn.has("macunix") == 1
local is_linux = fn.has("unix") == 1 and not is_mac
local is_win = fn.has("win32") == 1 or fn.has("win64") == 1

if is_win then
	-- warn
	print("Windows is not supported")
end

M.platform = function()
	if is_mac then
		return "mac"
	elseif is_linux then
		return "linux"
	elseif is_win then
		return "win"
	else
		return "unknown"
	end
end

return M
