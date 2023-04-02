local config_mgr = require("nvim-listchars.config")
local cache = require("nvim-listchars.cache")
local util = require("nvim-listchars.util")

local M = {}

---Print `listchars` state and their values
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

	if resolved_switch then
		vim.opt.listchars:append(config_mgr.config.listchars)
	end

	cache.write(resolved_switch)
end

---@param amount number
function M.lighten_colors(amount)
	local whitespace_hl = vim.api.nvim_get_hl_by_name("Whitespace", true)
	local whitespace_fg = string.format("#%06x", whitespace_hl["foreground"])

	local nontext_hl = vim.api.nvim_get_hl_by_name("NonText", true)
	local nontext_fg = string.format("#%06x", nontext_hl["foreground"])

	local new_highlights = {
		Whitespace = {
			fg = util.lighten(whitespace_fg, amount),
		},
		NonText = {
			fg = util.lighten(nontext_fg, amount),
		},
	}

	for group, hl in pairs(new_highlights) do
		vim.api.nvim_set_hl(0, group, hl)
	end
end

return M
