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
	local command_type = state and state[1]
	local hl = state and state[2] or M.get_highlights()["Whitespace"]["fg"]
	local current_list_value = vim.opt.list:get()

	local new_list_state

	if command_type == "enabled" then
		new_list_state = true
	elseif command_type == "disabled" then
		new_list_state = false
	else
		new_list_state = not current_list_value
	end

	vim.opt.list = new_list_state

	if config_mgr.config.notifications then
		local msg
		if command_type == "enabled" then
			msg = "listchars enabled"
		elseif command_type == "disabled" then
			msg = "listchars disabled"
		else
			msg = ("listchars toggled %s"):format(new_list_state and "ON" or "OFF")
		end
		vim.notify(msg, vim.log.levels.INFO)
	end
	if new_list_state then
		vim.opt.listchars:append(config_mgr.config.listchars)
	end
	vim.api.nvim_set_hl(0, "Whitespace", { fg = hl })
	vim.api.nvim_set_hl(0, "NonText", { fg = hl })

	cache.write(new_list_state, hl)
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
