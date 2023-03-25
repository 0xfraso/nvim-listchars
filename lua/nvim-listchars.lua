local api = require("nvim-listchars.api")
local config_mgr = require("nvim-listchars.config")
local cache = require("nvim-listchars.cache")

---@class NvimListchars
---@field private resolved_config PluginConfig
local M = {}

---Create user commands belonging to this plugin
local function create_user_commands()
	vim.api.nvim_create_user_command("ListcharsStatus", api.recall, { desc = "Prints listchars table" })
	vim.api.nvim_create_user_command("ListcharsToggle", function()
		api.toggle_listchars()
	end, { desc = "Toggle listchars ON/OFF" })
	vim.api.nvim_create_user_command("ListcharsDisable", function()
		api.toggle_listchars(false)
	end, { desc = "Disable listchars" })
	vim.api.nvim_create_user_command("ListcharsEnable", function()
		api.toggle_listchars(true)
	end, { desc = "Enable listchars" })
	vim.api.nvim_create_user_command("ListcharsClearCache", function()
		cache.clear()
	end, { desc = "Clear nvim-listchars state cache" })
end

---Create autocmds belonging to this plugin
local function create_autocmds()
	local listchars_group = vim.api.nvim_create_augroup("NvimListchars", { clear = true })
	vim.api.nvim_create_autocmd("BufEnter", {
		desc = "disable listchars on specific filetypes",
		group = listchars_group,
		callback = function(o)
			if vim.tbl_contains(config_mgr.config.exclude_filetypes, vim.bo[o.buf].filetype) then
				vim.opt.list = false
			end
		end,
	})
end

---Setup NvimListchars
---@param opts? PluginConfig
function M.setup(opts)
  config_mgr.setup(opts)

	if vim.opt.list:get() and config_mgr.config.save_state then
		local save_state = cache.read()
		api.toggle_listchars(save_state)
	end

	create_user_commands()
	create_autocmds()
end

return M
