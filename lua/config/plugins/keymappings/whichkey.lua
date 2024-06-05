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

-- 向右分割并将当前 buffer 复制到新窗口
-- 设置 WhichKey 映射前缀
M.set_global = function()
	vim.g.which_key_leader = " "
end

M.load_plugin_specific = function()
	local normal_map = utils.load_from_directory("lua/config/plugins/", "normal_key_map")
	which_key_nmap = vim.tbl_extend("force", which_key_nmap, normal_map)
	local visual_map = utils.load_from_directory("lua/config/plugins/", "visual_key_map")
	which_key_vmap = vim.tbl_extend("force", which_key_vmap, visual_map)
end

-- vim.g.which_key_timeout = 1000
-- 启用 WhichKey
M.setup = function()
	M.set_global()
	M.load_plugin_specific()
	require("which-key").register(which_key_nmap, which_key_nopt)
	require("which-key").register(which_key_vmap, which_key_vopt)
	require("which-key").register({
		["<localleader>"] = {
			name = "+localleader",
			f = { "<cmd>Telescope find_files<cr>", "Find Files" },
			g = { "<cmd>Telescope live_grep<cr>", "Grep" },
			b = { "<cmd>Telescope buffers<cr>", "Buffers" },
			h = { "<cmd>Telescope help_tags<cr>", "Help" },
		},
	})
end

return M
