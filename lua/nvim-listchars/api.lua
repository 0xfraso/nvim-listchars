local config_mgr = require("nvim-listchars.config")
local cache = require("nvim-listchars.cache")
local util = require("nvim-listchars.util")

local M = {}

---Print `listchars` state, their values and current highlights
function M.recall()
	if vim.opt.list:get() then
		vim.notify(
			("Listchars enabled %s" .. string.char(10) .. "Current highlights: %s")
			:format(vim.inspect(vim.opt.listchars:get()), vim.inspect(M.get_highlights())),
			vim.log.levels.INFO
		)
	else
		vim.notify("Listchars disabled", vim.log.levels.INFO)
	end
end

function M.get_highlights()
	local whitespace_hl = vim.api.nvim_get_hl_by_name("Whitespace", true)
	local whitespace_fg = string.format("#%06x", whitespace_hl["foreground"])

	local nontext_hl = vim.api.nvim_get_hl_by_name("NonText", true)
	local nontext_fg = string.format("#%06x", nontext_hl["foreground"])

	return {
		Whitespace = {
			fg = whitespace_fg
		},
		NonText = {
			fg = nontext_fg
		}
	}
end

---Toggle plugin ON/OFF
---@param state? table
function M.toggle_listchars(state)
	local enabled = state and state[1]
	local hl = state and state[2] or M.get_highlights()["Whitespace"]["fg"]
	local resolved_switch = enabled == "enabled" or not vim.opt.list:get()
	vim.opt.list = resolved_switch
	if config_mgr.config.notifications then
		vim.notify(("listchars toggled %s"):format(resolved_switch and "ON" or "OFF"), vim.log.levels.INFO)
	end
	if resolved_switch then
		vim.opt.listchars:append(config_mgr.config.listchars)
	end
	vim.api.nvim_set_hl(0, "Whitespace", { fg = hl })
	vim.api.nvim_set_hl(0, "NonText", { fg = hl })

	cache.write(resolved_switch, hl)
end

---@param amount number
function M.lighten_colors(amount)
	local highlights = M.get_highlights()

	local new_highlights = {
		Whitespace = {
			fg = util.lighten(highlights.Whitespace["fg"], amount),
		},
		NonText = {
			fg = util.lighten(highlights.NonText["fg"], amount),
		}
	}

	for group, hl in pairs(new_highlights) do
		vim.api.nvim_set_hl(0, group, hl)
	end

	cache.write(vim.opt.list:get(), M.get_highlights()["Whitespace"]["fg"])
end

return M
