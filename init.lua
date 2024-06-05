local core_conf_files = {
	"global_settings.lua", -- load autocommands
	"viml_load.lua", -- load autocommands
	"lazy_load.lua", -- install all plugins first
	"common/", -- config all needed things
}

local viml_conf_dir = vim.fn.stdpath("config") .. "/viml_conf"
-- source all the core config files
for _, file_name in ipairs(core_conf_files) do
	if vim.endswith(file_name, "vim") then
		local path = string.format("%s/%s", viml_conf_dir, file_name)
		local source_cmd = "source " .. path
		vim.cmd(source_cmd)
	elseif vim.endswith(file_name, "lua") then
		local module_name, _ = string.gsub(file_name, "%.lua", "")
		package.loaded[module_name] = nil
		require(module_name)
	-- is dir
	elseif vim.endswith(file_name, "/") then
		file_name = file_name:sub(1, -2)
		local module = require(file_name)
		module.setup()
	end
end
