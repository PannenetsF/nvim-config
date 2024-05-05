-- 设置WhichKey的触发键为<Space>
vim.g.which_key_map_leader = " "

-- 设置 WhichKey 映射
local which_key_map = {
	["e"] = {
		":NvimTreeToggle <CR>",
		"Toggle NvimTree and reveal current file",
	},
	["E"] = { "<cmd>SidebarNvimToggle<CR>", "Toggle Sidebar" },
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
	},
	t = {
		name = "Terminal",
		f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
		t = { "<cmd>ToggleTerm direction=tab<cr>", "Table terminal" },
		v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Vertical terminal" },
		h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Horizontal terminal" },
	},
}

-- 设置 WhichKey 映射前缀
vim.g.which_key_leader = " "
vim.g.which_key_timeout = 1000

-- 启用 WhichKey
require("which-key").register(which_key_map, { prefix = "<Space>" })
