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
---@field enable boolean
---@field listchars table<ListType, string>

