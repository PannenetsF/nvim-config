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
	local status, _ = pcall(vim.cmd, "packadd " .. name)
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

local function _extend_table(t, ext)
	for k, v in pairs(ext) do
		-- if k not in t, then add it
		-- if yes, then _extend it
		if t[k] == nil then
			t[k] = v
		else
			if type(t[k]) == "table" and type(v) == "table" then
				_extend_table(t[k], v)
			else
				t[k] = v
			end
		end
	end
end
-- 用于加载文件并检查指定属性的函数
local function load_and_merge(path, key, m)
	local ok, attr = pcall(dofile, path)
	if not ok then
		return
	end
	if type(attr) == "table" then
		if attr[key] then
			-- for k, v in pairs(attr[key]) do
			-- 	m[k] = v
			-- end
			_extend_table(m, attr[key])
		end
	end
end
local function get_lua_files_recursively(path)
	local all_lua_files = {}
	local config_path = _G.get_config_dir()
	if config_path then
		-- add / if not present
		if not config_path:match(".*/$") then
			config_path = config_path .. "/"
		end
		path = config_path .. path
	end
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

M.firenvim_not_active = function()
	return not vim.g.started_by_firenvim
end

-- set quickfix list from diagnostics in a certain buffer, not the whole workspace
local set_qflist = function(buf_num, severity)
	local diagnostics = nil
	diagnostics = vim.diagnostic.get(buf_num, { severity = severity })

	local qf_items = vim.diagnostic.toqflist(diagnostics)
	vim.fn.setqflist({}, " ", { title = "Diagnostics", items = qf_items })

	-- open quickfix by default
	vim.cmd([[copen]])
end

M.custom_attach = function(client, bufnr)
	-- Mappings.
	local map = function(mode, l, r, opts)
		opts = opts or {}
		opts.silent = true
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	local diagnostic = vim.diagnostic
	local api = vim.api
	local lsp = vim.lsp

	map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
	map("n", "<C-]>", vim.lsp.buf.definition)
	map("n", "K", vim.lsp.buf.hover)
	map("n", "<C-k>", vim.lsp.buf.signature_help)
	map("n", "<space>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
	map("n", "gr", vim.lsp.buf.references, { desc = "show references" })
	map("n", "[d", diagnostic.goto_prev, { desc = "previous diagnostic" })
	map("n", "]d", diagnostic.goto_next, { desc = "next diagnostic" })
	-- this puts diagnostics from opened files to quickfix
	map("n", "<space>qw", diagnostic.setqflist, { desc = "put window diagnostics to qf" })
	-- this puts diagnostics from current buffer to quickfix
	map("n", "<space>qb", function()
		set_qflist(bufnr)
	end, { desc = "put buffer diagnostics to qf" })
	-- map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
	map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
	map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
	map("n", "<space>wl", function()
		vim.inspect(vim.lsp.buf.list_workspace_folders())
	end, { desc = "list workspace folder" })

	-- Set some key bindings conditional on server capabilities
	if client.server_capabilities.documentFormattingProvider then
		map("n", "<space>l", vim.lsp.buf.format, { desc = "format code" })
	end

	api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			local float_opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "rounded",
				source = "always", -- show source in diagnostic popup window
				prefix = " ",
			}

			if not vim.b.diagnostics_pos then
				vim.b.diagnostics_pos = { nil, nil }
			end

			local cursor_pos = api.nvim_win_get_cursor(0)
			if
				(cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
				and #diagnostic.get() > 0
			then
				diagnostic.open_float(nil, float_opts)
			end

			vim.b.diagnostics_pos = cursor_pos
		end,
	})

	-- The blow command will highlight the current variable and its usages in the buffer.
	if client.server_capabilities.documentHighlightProvider then
		vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

		local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		api.nvim_create_autocmd("CursorHold", {
			group = gid,
			buffer = bufnr,
			callback = function()
				lsp.buf.document_highlight()
			end,
		})

		api.nvim_create_autocmd("CursorMoved", {
			group = gid,
			buffer = bufnr,
			callback = function()
				lsp.buf.clear_references()
			end,
		})
	end

	if vim.g.logging_level == "debug" then
		local msg = string.format("Language server %s started!", client.name)
		vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
	end
end

return M
