local fn = vim.fn

local M = {}

function M.executable(name)
	if fn.executable(name) > 0 then
		return true
	end

	return false
end

--- check whether a feature exists in Nvim
--- @feat: string
---   the feature name, like `nvim-0.7` or `unix`.
--- return: bool
M.has = function(feat)
	if fn.has(feat) == 1 then
		return true
	end

	return false
end

--- Create a dir if it does not exist
function M.may_create_dir(dir)
	local res = fn.isdirectory(dir)

	if res == 0 then
		fn.mkdir(dir, "p")
	end
end

--- Generate random integers in the range [Low, High], inclusive,
--- adapted from https://stackoverflow.com/a/12739441/6064933
--- @low: the lower value for this range
--- @high: the upper value for this range
function M.rand_int(low, high)
	-- Use lua to generate random int, see also: https://stackoverflow.com/a/20157671/6064933
	math.randomseed(os.time())

	return math.random(low, high)
end

--- Select a random element from a sequence/list.
--- @seq: the sequence to choose an element
function M.rand_element(seq)
	local idx = M.rand_int(1, #seq)

	return seq[idx]
end

function M.add_pack(name)
	local status, error = pcall(vim.cmd, "packadd " .. name)

	return status
end

--- Checks whether a given path exists and is a directory
--@param path (string) path to check
--@returns (bool)
function M.is_directory(path)
	local uv = vim.loop
	local stat = uv.fs_stat(path)
	return stat and stat.type == "directory" or false
end
function M.isempty(s)
	return s == nil or s == ""
end

function M.get_buf_option(opt)
	local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
	if not status_ok then
		return nil
	else
		return buf_option
	end
end

-- 用于加载文件并检查指定属性的函数
local function load_and_merge(path, key, m)
	local ok, attr = pcall(dofile, path)
	if not ok then
		return
	end
	-- load if this is a table
	-- if key in this table, merge it to M

	if type(attr) == "table" then
		io.popen("echo " .. path .. " >> /tmp/log")
		io.popen("echo " .. tostring(attr) .. key .. tostring(attr[key]) .. " >> /tmp/log")
		if attr[key] then
			for k, v in pairs(attr[key]) do
				m[k] = v
			end
		end
	end
end
local function get_lua_files_recursively(path)
	local all_lua_files = {}
	local p = io.popen('find "' .. path .. '" -type f -name "*.lua"')
	if not p then
		return all_lua_files
	end
	for file in p:lines() do
		table.insert(all_lua_files, file)
	end
	return all_lua_files
end

-- 定义一个主函数来启动整个过程
local function merge_tables_from_directories(path, attr)
	local all_lua_files = get_lua_files_recursively(path)
	local m = {}
	for _, file in ipairs(all_lua_files) do
		load_and_merge(file, attr, m)
	end
	return m
end

M.load_from_directory = function(dir, attr)
	return merge_tables_from_directories(dir, attr)
end

return M
