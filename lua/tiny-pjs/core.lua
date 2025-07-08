---@class PjsCore
local M = {}

---@type function
---this function acutally loads the project settings if the current
---path is trusted
---@param settings PjsConfigSettings
---@return PjsState
M.setup = function(settings)
    local state = require('tiny-pjs.state').setup(settings)
    if state.is_trusted(vim.fn.getcwd()) then
        for _, file in ipairs(settings.consider) do
            if (vim.uv or vim.loop).fs_stat(file) then
                vim.cmd('source ' .. file)
            end
        end
    end

    return state
end

return M

