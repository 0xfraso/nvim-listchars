---@module "nvim-listchars.types"

---@class NvimListchars
---@field private resolved_config PluginConfig
local M = {
	---Configuration the plugin will use
	resolved_config = {
		enable = true,
		listchars = {
			tab = vim.opt.listchars:get()["tab"],
			trail = vim.opt.listchars:get()["trail"],
			nbsp = vim.opt.listchars:get()["nbsp"],
		},
	},
}

---Plugin configuration bootstrapper
---@param opts? PluginConfig
M.setup = function(opts)
	M.resolved_config = vim.tbl_deep_extend("force", M.resolved_config, opts or {})

	if vim.g.listchar_enabled == nil then
		vim.g.listchar_enabled = M.resolved_config.enable
	end
	M.toggle_listchars(vim.g.listchar_enabled)

	vim.api.nvim_create_user_command("ListcharsStatus", function(_)
		print(M.recall())
	end, { desc = "Prints listchars table" })
end

---Print plugin state
M.recall = function()
	if vim.g.listchar_enabled then
		print("Listchars enabled", vim.inspect(vim.opt.listchars:get()))
	else
		print("Listchars disabled")
	end
end

---Toggle plugin ON/OFF
---@param switch? boolean
M.toggle_listchars = function(switch)
	if switch == nil then
		vim.g.listchar_enabled = not vim.g.listchar_enabled
	else
		vim.g.listchar_enabled = switch
	end

	vim.opt.list = vim.g.listchar_enabled

	if vim.g.listchar_enabled then
		vim.opt.listchars:append(M.resolved_config.listchars)
	end
end

return M
