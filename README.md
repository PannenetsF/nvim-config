# PF's nvim config 

## Logic of startup

1. Load global settings, which are mainly independent of the plugins.
2. Load viml settings, which are purely autocommands, and are independent from but used for plugins.
3. Load plugins with `lazy.nvim`. 
4. Finalize with common settings, which are dependent on the plugins, like setup some plugins and bindings.

## Logic of plugins management 

1. The plugins is maintained under `lua/plugins/` directory, where each plugin has its own file.
2. If the plugin is almost free from settings, it has no config file. (Most plugins are like this)
3. If the plugin has some settings, it has a config file under `lua/configs/plugins` directory.
4. In the config directory, the plugins is categorized by the directory name, and the config file is named after the plugin name.
5. For now, the categories are like: 
```bash
.
├── edition
│   ├── autopairs.lua
│   ├── auto-save.lua
│   ├── comments.lua
│   ├── navic.lua
│   ├── treesitter.lua
│   └── true-zen.lua
├── keymappings
│   └── whichkey.lua
├── lsp
│   ├── lsp.lua
│   └── mason.lua
├── tools
│   └── nvim-cmp.lua
└── ui
    ├── bufferline.lua
    ├── lualine.lua
    └── noice.lua
```

## Logic of utils 

Only shared resources like UI elements and functions are placed under `lua/utils/` directory.


