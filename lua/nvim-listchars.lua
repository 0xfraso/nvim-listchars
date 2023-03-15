local M = {}

-- default values
local config = {
    enable = true,
    listchars = {
        tab = '> ',
        trail = '-',
        nbsp = '+',
    },
}

M.setup = function(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})

    if vim.g.listchar_enabled == nil then
        vim.g.listchar_enabled = config.enable
    end
    M.toggle_listchars(vim.g.listchar_enabled)

    vim.api.nvim_create_user_command('ListcharsStatus', function(_)
        print(M.recall())
    end, { desc = 'Prints listchars table' })
end

M.recall = function()
    if vim.g.listchar_enabled then
        print("Listchars enabled", vim.inspect(vim.opt.listchars:get()))
    else
        print("Listchars disabled")
    end
end

M.toggle_listchars = function(opt)
    if opt == nil then
        vim.g.listchar_enabled = not vim.g.listchar_enabled
    else
        vim.g.listchar_enabled = opt
    end

    vim.opt.list = vim.g.listchar_enabled

    if vim.g.listchar_enabled then
        vim.opt.listchars:append(config.listchars)
    end
end

return M
