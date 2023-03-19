local api = vim.api
local uv = vim.loop

local M = {}

local cache_path = vim.fn.stdpath("data") .. "/nvim-listchar"

---Open the file where the toggle flag is saved.
---See `:h uv.fs_open()` for a better description of parameters.
---
---@param mode string r for read, w for write
---@return integer|nil fd
M.open = function(mode)
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
M.read = function()
	local fd = M.open("r")
	if not fd then
		return nil
	end

	local stat = assert(uv.fs_fstat(fd))
	local data = assert(uv.fs_read(fd, stat.size, -1))
	assert(uv.fs_close(fd))

	local enabled, _ = data:gsub("[\n\r]", "")
	return enabled == "true"
end

---Writes the cache to save the the last toggle flag.
---
---@return boolean|nil enabled
M.write = function()
	local fd = M.open("w")
	if not fd then
		api.nvim_notify("Could not write cache file!\n\n", vim.log.levels.ERROR, {})
		return
	end

	assert(uv.fs_write(fd, ("%s\n"):format(vim.g.listchar_enabled), -1))
	assert(uv.fs_close(fd))
end

return M
