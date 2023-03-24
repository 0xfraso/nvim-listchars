local api = vim.api
local cache = require("nvim-listchars.cache")

---@module "nvim-listchars.types"

---@class NvimListchars
---@field private resolved_config PluginConfig
local M = {
	---Configuration the plugin will use
	resolved_config = {
		save_state = true,
		listchars = {
			tab = vim.opt.listchars:get()["tab"],
			trail = vim.opt.listchars:get()["trail"],
			nbsp = vim.opt.listchars:get()["nbsp"],
		},
		exclude_filetypes = {},
	},
}

---Create user commands belonging to this plugin
local function create_user_commands()
	api.nvim_create_user_command("ListcharsStatus", M.recall, { desc = "Prints listchars table" })
	api.nvim_create_user_command("ListcharsToggle", function()
		M.toggle_listchars()
	end, { desc = "Toggle listchars ON/OFF" })
	api.nvim_create_user_command("ListcharsDisable", function()
		M.toggle_listchars(false)
	end, { desc = "Disable listchars" })
	api.nvim_create_user_command("ListcharsEnable", function()
		M.toggle_listchars(true)
	end, { desc = "Enable listchars" })
end

---Plugin configuration bootstrapper
---@param opts? PluginConfig
function M.setup(opts)
	M.resolved_config = vim.tbl_deep_extend("force", M.resolved_config, opts or {})

	if M.resolved_config.save_state then
		local save_state = cache.read()
		M.toggle_listchars(save_state)
	end

	create_user_commands()
end

---Print plugin state
function M.recall()
	if vim.opt.list:get() then
		vim.notify(("Listchars enabled %s"):format(vim.inspect(vim.opt.listchars:get())), vim.log.levels.INFO)
	else
		vim.notify("Listchars disabled", vim.log.levels.INFO)
	end
end

---Toggle plugin ON/OFF
---@param switch? boolean
function M.toggle_listchars(switch)
	local resolved_switch = switch or not vim.opt.list:get()
	vim.opt.list = resolved_switch
	vim.notify(("listchars toggled %s"):format(resolved_switch and "ON" or "OFF"), vim.log.levels.INFO)

	if vim.opt.list:get() then
		vim.opt.listchars:append(M.resolved_config.listchars)
	end
	cache.write()

	if next(M.resolved_config.exclude_filetypes) ~= nil then
		vim.api.nvim_create_autocmd("BufEnter", {
			desc = "disable listchars on specific filetype",
			group = vim.api.nvim_create_augroup("listchars_filetypes", { clear = true }),
			callback = function(o)
				if vim.tbl_contains(M.resolved_config.exclude_filetypes, vim.bo[o.buf].filetype) then
					vim.opt.list = false
				end
			end,
		})
	end
end

return M
