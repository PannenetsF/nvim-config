local telescope = require("telescope.builtin")

-- 向右分割并将当前 buffer 复制到新窗口
local function split_right()
	vim.cmd("vsplit")
	vim.cmd("wincmd l")
	vim.cmd("b #")
end

-- 向左分割并将当前 buffer 复制到新窗口
local function split_left()
	vim.cmd("vsplit")
	vim.cmd("wincmd h")
	vim.cmd("b #")
end

-- 设置 WhichKey 映射
local which_key_nmap = {
	["z"] = { "<cmd>TZAtaraxis<CR>", "+Zen Mode" },
	["e"] = {
		":NvimTreeToggle <CR>",
		"Toggle NvimTree and reveal current file",
	},
	s = {
		name = "Sidebar Management",
		s = { "<cmd>NvimTreeFindFileToggle<CR>", "Locate the file in sidebar" },
		g = { "<cmd>SidebarNvimToggle<CR>", "Toggle Status Bar" },
	},
	["g"] = { "<cmd>LazyGit<CR>", "Toggle LazyGit" },
	["c"] = { "<cmd>BufferKill<CR>", "Close Buffer" },
	b = {
		name = "Buffers",
		j = { "<cmd>BufferLinePick<cr>", "Jump" },
		f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
		b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
		n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
		W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
		-- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
		e = {
			"<cmd>BufferLinePickClose<cr>",
			"Pick which buffer to close",
		},
		h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
		l = {
			"<cmd>BufferLineCloseRight<cr>",
			"Close all to the right",
		},
		D = {
			"<cmd>BufferLineSortByDirectory<cr>",
			"Sort by directory",
		},
		L = {
			"<cmd>BufferLineSortByExtension<cr>",
			"Sort by language",
		},
		["\\"] = {
			name = "Split Buffer",
			l = { "<cmd>lua split_left()<cr>", "Split buffer to left" },
			r = { "<cmd>lua split_right()<cr>", "Split buffer to right" },
		},
	},
	f = {
		name = "Find",
		f = { telescope.find_files, "Find Files" },
		g = { telescope.live_grep, "Live Grep" },
		b = { telescope.buffers, "Buffers" },
		h = { telescope.help_tags, "Help Tags" },
	},
	t = {
		name = "Terminal",
		f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
		t = { "<cmd>ToggleTerm direction=tab<cr>", "Table terminal" },
		v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Vertical terminal" },
		h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Horizontal terminal" },
	},
	p = {
		name = "Goto preview",
		d = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", "Preview Definition" },
		t = { "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", "Preview Type Definition" },
		i = { "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", "Preview Implementation" },
		D = { "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", "Preview Declaration" },
		r = { "<cmd>lua require('goto-preview').goto_preview_references()<CR>", "Preview References" },
		P = { "<cmd>lua require('goto-preview').close_all_win()<CR>", "Close All Previews" },
	},
}

local which_key_nopt = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local which_key_vmapping = {}

local which_key_vopt = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

-- 设置 WhichKey 映射前缀
vim.g.which_key_leader = " "
vim.g.which_key_timeout = 1000

-- 启用 WhichKey
require("which-key").register(which_key_nmap, which_key_nopt)
_G.split_right = split_right
_G.split_left = split_left
