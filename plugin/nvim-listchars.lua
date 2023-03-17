if vim.g.loaded_nvim_listchars == 1 then
	return
end

vim.g.loaded_nvim_listchars = 1

local nvim_listchars = require("nvim-listchars")

vim.api.nvim_create_user_command("ListcharsToggle", function()
	nvim_listchars.toggle_listchars()
end, { desc = "Toggle listchars ON/OFF" })
vim.api.nvim_create_user_command("ListcharsDisable", function()
	nvim_listchars.toggle_listchars(false)
end, { desc = "Disable listchars" })
vim.api.nvim_create_user_command("ListcharsEnable", function()
	nvim_listchars.toggle_listchars(true)
end, { desc = "Enable listchars" })

nvim_listchars.setup()
