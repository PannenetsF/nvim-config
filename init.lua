local globalset = require("global")
local settings = require("config.settings")
settings.load_defaults()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{ import = "plugins" },
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			require("noice").setup({
				views = {
					cmdline_popup = {
						position = {
							row = 20,
							col = "50%",
						},
						size = {
							width = 60,
							height = "auto",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = 8,
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
					signature = {
						enabled = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	"williamboman/mason-lspconfig.nvim",
	"LunarVim/bigfile.nvim",
	"MunifTanjim/nui.nvim",
	{
		"SmiteshP/nvim-navic",
		config = function()
			require("config.plugins.navic").setup()
		end,
		event = "User FileOpened",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		flavour = "auto", -- latte, frappe, macchiato, mocha
		background = { -- :h background
			light = "latte",
			dark = "mocha",
		},
		opts = {
			term_colors = true,
			transparent_background = false,
			styles = {
				comments = {},
				conditionals = {},
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
			},
			color_overrides = {
				mocha = {
					base = "#000000",
					mantle = "#000000",
					crust = "#000000",
				},
			},
			integrations = {
				telescope = {
					enabled = true,
					style = "nvchad",
				},
				dropbar = {
					enabled = true,
					color_mode = true,
				},
			},
		},
	},
	"nvim-lua/plenary.nvim",
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	"github/copilot.vim",
	{
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup({
				execution_message = {
					message = function() -- message to print on save
						return ""
					end,
					dim = 0.18, -- dim the color of `message`
					cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
				},
			})
		end,
	},
	{
		"Pocco81/true-zen.nvim",
		config = function()
			require("true-zen").setup({
				integrations = {
					tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
					kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
						enabled = false,
						font = "+3",
					},
					twilight = false, -- enable twilight (ataraxis)
					lualine = true, -- hide nvim-lualine (ataraxis)
				},
				modes = { -- configurations per mode
					ataraxis = {
						minimum_writing_area = { -- minimum size of main window
							width = 80,
							height = 44,
						},
						padding = { -- padding windows
							left = 200,
							right = 200,
							top = 0,
							bottom = 0,
						},
					},
					minimalist = {
						options = {
							relativenumber = true,
						},
					},
				},
			})
		end,
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{
		"folke/which-key.nvim",
		config = function()
			require("config.keybinding.whichkey")
		end,
		cmd = "WhichKey",
		event = "VeryLazy",
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-omni",
			"hrsh7th/cmp-emoji",
			"quangnguyen30192/cmp-nvim-ultisnips",
		},
		config = function()
			require("config.plugins.nvim-cmp")
		end,
	},
	{ "hrsh7th/cmp-nvim-lsp", lazy = true },
	{ "saadparwaiz1/cmp_luasnip", lazy = true },
	{ "hrsh7th/cmp-buffer", lazy = true },
	{ "hrsh7th/cmp-path", lazy = true },
	{
		"hrsh7th/cmp-cmdline",
		lazy = true,
	},
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_lua").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = paths,
			})
			require("luasnip.loaders.from_snipmate").lazy_load()
		end,
		event = "InsertEnter",
		dependencies = {
			"friendly-snippets",
		},
	},
	{ "rafamadriz/friendly-snippets", lazy = true },
	-- { "VonHeikemen/lsp-zero.nvim" },
	{
		"natecraddock/workspaces.nvim",
		config = function()
			require("workspaces").setup()
		end,
	},
	{ "honza/vim-snippets" },
	{ "SirVer/ultisnips", event = "InsertEnter" },
	{ "dstein64/vim-startuptime" },
	-- {
	-- 	"ray-x/lsp_signature.nvim",
	-- },
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({})
		end,
	},
	{
		"anuvyklack/pretty-fold.nvim",
		config = function()
			require("pretty-fold").setup()
		end,
	},
	"anuvyklack/keymap-amend.nvim",
	{
		"anuvyklack/fold-preview.nvim",
		requires = "anuvyklack/keymap-amend.nvim",
		config = function()
			require("fold-preview").setup({
				-- Your configuration goes here.
			})
		end,
	},
	"f-person/git-blame.nvim",
	{
		"puremourning/vimspector",
		init = function()
			vim.g.vimspector_enable_mappings = "VISUAL_STUDIO"
			vim.g.vimspector_install_gadgets = { "debugpy" }
		end,
	},
	{ "CRAG666/code_runner.nvim", config = true },
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			-- Setup orgmode
			require("orgmode").setup({
				org_agenda_files = "~/org/**/*",
				org_default_notes_file = "~/org/notes.org",
			})

			-- NOTE: If you are using nvim-treesitter with `ensure_installed = "all"` option
			-- add `org` to ignore_install
			-- require('nvim-treesitter.configs').setup({
			--   ensure_installed = 'all',
			--   ignore_install = { 'org' },
			-- })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
})

vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")

local commands = require("config.commands")
commands.load(commands.defaults)
require("config.keymappings").load_defaults()
require("config.keybinding.copilot")

require("mason").setup()
require("mason-lspconfig").setup()
-- require("lsp_signature").setup({})

local viml_conf_dir = vim.fn.stdpath("config") .. "/vim/"
vim.cmd("source " .. viml_conf_dir .. "autocommands.vim")
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
vim.g.UltiSnipsExpandTrigger = "<Tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
-- vim.g.UltiSnipsEnableSnipMate = 0  -- Disable SnipMate compatibility
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" } -- Only load snippets from UltiSnips directory
vim.g.UltiSnipsEditSplit = "vertical" -- Use vertical split for editing snippets
vim.g.UltiSnipsUsePythonVersion = 3 -- Ensure Python3 is used

-- Performance optimizations
vim.o.lazyredraw = true -- Reduces flickering by not redrawing while executing macros
vim.o.updatetime = 300 -- Reduce the time it takes to trigger the CursorHold event

require("gitblame").setup({ enable = true })
