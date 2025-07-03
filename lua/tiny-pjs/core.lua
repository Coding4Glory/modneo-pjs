local M = {}

---@param settings PjsConfigSettings
---@return PjsState
M.setup = function(settings)
    local state = require('tiny-pjs.state').init(settings)
    if not state.is_trusted(vim.fn.getcwd()) then
        return
    end

    for _, file in ipairs(settings.consider) do
        if (vim.uv or vim.loop).fs_stat(file) then
            vim.cmd('source .nvim/init.lua')
        end
    end

    return state
end

return M
