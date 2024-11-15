local uv = vim.loop

local M = {}

local cache_path = vim.fn.stdpath("cache") .. "/listchars"

---Open the file where the toggle flag is saved.
---See `:h uv.fs_open()` for a better description of parameters.
---
---@param mode string r for read, w for write
---@return integer|nil fd
local function open(mode)
	--- 438(10) == 666(8) [owner/group/others can read/write]
	local flags = 438
	local fd, err = uv.fs_open(cache_path, mode, flags)
	if err then
		vim.notify(("Error opening cache file:\n\n%s"):format(err), vim.log.levels.ERROR)
	end
	return fd
end

---Reads the cache to find the the last toggle flag.
---
---@return table|nil enabled
function M.read()
	local file = io.open(cache_path)
	if file then
		local lines = {}
		for line in file:lines() do
			table.insert(lines, line)
		end
		file:close()
		return lines
	else
		print("Error opening file:", cache_path)
		return nil
	end
end

---Get human-readable string representing `listchars` status
---@param listchars_enabled boolean
---@return "enabled"|"disabled"
local function get_status_string(listchars_enabled)
	return listchars_enabled and "enabled" or "disabled"
end

---Save the given toggle flag to cache
---@param listchars_enabled boolean
---@param hl string
function M.write(listchars_enabled, hl)
	hl = hl or nil
	local fd = open("w")
	if not fd then
		vim.notify("Could not write cache file!\n\n", vim.log.levels.ERROR)
		return
	end

	local blob = get_status_string(listchars_enabled)

	if hl and listchars_enabled then
		blob = blob .. "\n" .. hl
	end

	assert(uv.fs_write(fd, ("%s\n"):format(blob), -1))
	assert(uv.fs_close(fd))
end

---Clear the cache file, returning to the the value of `vim.opt.list`
---set in the user's `init.lua`
function M.clear()
	assert(uv.fs_unlink(cache_path))
end

return M
