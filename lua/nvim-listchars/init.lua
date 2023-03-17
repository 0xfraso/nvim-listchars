local api = vim.api
local uv = vim.loop

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
	},
}

local cache_path = vim.fn.stdpath("data") .. "/nvim-listchar"

---Open the file where the toggle flag is saved.
---See `:h uv.fs_open()` for a better description of parameters.
---
---@param mode string r for read, w for write
---@return integer|nil fd
local open_cache_file = function(mode)
	--- 438(10) == 666(8) [owner/group/others can read/write]
	local flags = 438
	local fd, err = uv.fs_open(cache_path, mode, flags)
	if err then
		api.nvim_notify(("Error opening cache file:\n\n%s"):format(err), vim.log.levels.ERROR, {})
	end
	return fd
end

---Reads the cache to find the the last toggle flag.
---
---@return boolean|nil enabled
local read_cache_file = function()
	local fd = open_cache_file("r")
	if not fd then
		return nil
	end

	local stat = assert(uv.fs_fstat(fd))
	local data = assert(uv.fs_read(fd, stat.size, -1))
	assert(uv.fs_close(fd))

	local enabled, _ = data:gsub("[\n\r]", "")
	return enabled == "true"
end

---Plugin configuration bootstrapper
---@param opts? PluginConfig
M.setup = function(opts)
	M.resolved_config = vim.tbl_deep_extend("force", M.resolved_config, opts or {})

	---Read cache file if enabled
	if M.resolved_config.enable and M.resolved_config.save_state then
		local save_state = read_cache_file()
		vim.g.listchar_enabled = save_state
	end

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

	---Write to cache file
	local fd = open_cache_file("w")
	if not fd then
		api.nvim_notify("Could not write cache file!\n\n", vim.log.levels.ERROR, {})
		return
	end

	assert(uv.fs_write(fd, ("%s\n"):format(vim.g.listchar_enabled), -1))
	assert(uv.fs_close(fd))
end

return M
