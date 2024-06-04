local viml_conf_dir = vim.fn.stdpath("config") .. "/vim/"
-- for files in the dir

local function source_viml_files()
	local files = vim.fn.glob(viml_conf_dir .. "*.vim", false, true)
	for _, file in ipairs(files) do
		vim.cmd("source " .. file)
	end
end
source_viml_files()
