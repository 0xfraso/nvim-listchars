local api = vim.api
local cache = require("nvim-listchars.cache")

---@module "nvim-listchars.types"

---@class NvimListchars
---@field private resolved_config PluginConfig
local M = {
	---Configuration the plugin will use
	resolved_config = {
		enable = true,
		save_state = true,
		listchars = {
			tab = vim.opt.listchars:get()["tab"],
			trail = vim.opt.listchars:get()["trail"],
			nbsp = vim.opt.listchars:get()["nbsp"],
		},
		exclude_filetypes = {},
	},
}

if M.resolved_config.enable and M.resolved_config.save_state then
	local save_state = cache.read()
	vim.g.listchar_enabled = save_state
end

---Plugin configuration bootstrapper
---@param opts? PluginConfig
M.setup = function(opts)
	M.resolved_config = vim.tbl_deep_extend("force", M.resolved_config, opts or {})

	if vim.g.listchar_enabled == nil then
		vim.g.listchar_enabled = M.resolved_config.enable
	end

	M.toggle_listchars(vim.g.listchar_enabled)

	api.nvim_create_user_command("ListcharsStatus", function(_)
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
