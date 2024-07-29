local M = {}
local utils = require("utils.functions")

-- 设置 WhichKey 映射
local which_key_nmap = {}

local which_key_nopt = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local which_key_vmap = {}

local which_key_vopt = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local which_key_local_nmap = {}

local which_key_local_nopt = {
	mode = "n", -- NORMAL mode
	prefix = "<localleader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

-- 向右分割并将当前 buffer 复制到新窗口
-- 设置 WhichKey 映射前缀
M.set_global = function()
	vim.g.which_key_leader = " "
end

M.load_plugin_specific = function()
	local normal_map = utils.load_from_directory("lua/config/", "normal_key_map")
	which_key_nmap = vim.tbl_extend("force", which_key_nmap, normal_map)
	local visual_map = utils.load_from_directory("lua/config/", "visual_key_map")
	which_key_vmap = vim.tbl_extend("force", which_key_vmap, visual_map)
	local local_map = utils.load_from_directory("lua/config/", "normal_local_key_map")
	which_key_local_nmap = vim.tbl_extend("force", which_key_local_nmap, local_map)
	-- save to output.log
end
local function merge_tables(input_table, config_table)
	local merged_table = {}
	local prefix = config_table.prefix or ""
	local mode = config_table.mode or ""
	local noremap = config_table.noremap or false
	local nowait = config_table.nowait or false
	local silent = config_table.silent or false

	local function add_to_merged_table(keys, command, desc)
		local entry = {
			prefix .. keys,
			command,
			desc = desc,
			nowait = nowait,
			remap = not noremap,
			mode = mode,
		}
		table.insert(merged_table, entry)
	end

	local function process_sub_table(sub_table, prefix_keys)
		for key, value in pairs(sub_table) do
			if type(key) == "string" and #key == 1 then
				if type(value) == "table" and value.name then
					table.insert(
						merged_table,
						{ prefix .. prefix_keys .. key, group = value.name, nowait = true, remap = false }
					)
					process_sub_table(value, prefix_keys .. key)
				else
					add_to_merged_table(prefix_keys .. key, value[1], value[2])
				end
			else
				if type(value) == "table" then
					for k, v in pairs(value) do
						if type(v) == "table" then
							add_to_merged_table(prefix_keys .. key .. k, v[1], v[2])
						end
					end
				end
			end
		end
	end

	for key, value in pairs(input_table) do
		if type(key) == "string" and #key == 1 then
			if type(value) == "table" and value.name then
				table.insert(merged_table, { prefix .. key, group = value.name, nowait = true, remap = false })
				process_sub_table(value, key)
			else
				add_to_merged_table(key, value[1], value[2])
			end
		else
			config_table[key] = value
		end
	end

	return merged_table
end

M.setup = function()
	M.set_global()
	M.load_plugin_specific()
	require("which-key").add(merge_tables(which_key_nmap, which_key_nopt))
	require("which-key").add(merge_tables(which_key_vmap, which_key_vopt))
	require("which-key").add(merge_tables(which_key_local_nmap, which_key_local_nopt))
end

return M
