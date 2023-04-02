---@alias ListType
---| "eol"
---| "tab"
---| "space"
---| "multispace"
---| "lead"
---| "leadmultispace"
---| "trail"
---| "extends"
---| "precedes"
---| "conceal"
---| "nbsp"

---@class PluginConfig
---@field save_state boolean
---@field listchars table<ListType, string>
---@field exclude_filetypes string[]
---@field lighten_step number

---@type PluginConfig
local DEFAULTS = {
	save_state = true,
	listchars = {
		tab = vim.opt.listchars:get()["tab"],
		trail = vim.opt.listchars:get()["trail"],
		nbsp = vim.opt.listchars:get()["nbsp"],
	},
	exclude_filetypes = {},
	lighten_step = 5,
}

---@class ConfigMgr
---@field config PluginConfig
local M = {
	config = DEFAULTS,
}

---Bootstrap NvimListchars configuration
---@param opts? PluginConfig
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
