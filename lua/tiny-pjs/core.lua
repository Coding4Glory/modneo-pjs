---@class PjsCore
---@field state PjsState an instance of the state service
---@field settings PjsConfigSettings the settings for this session
local M = {}

---@type function
---applies the project settings to the current session if folder is trusted
---@param force boolean set a truthy value to force enabling
M.apply = function(force)
    if not M.state.is_trusted(vim.fn.getcwd()) and not force then
        return
    end
    for _, file in ipairs(M.settings.consider) do
        if (vim.uv or vim.loop).fs_stat(file) then
            vim.cmd('source ' .. file)
        end
    end
end

---@type function
---this function acutally loads the project settings if the current
---path is trusted
---@param settings PjsConfigSettings
---@return PjsCore
M.setup = function(settings)
    M.settings = settings
    M.state = require('tiny-pjs.state').setup(M.settings)
    M.apply()
    return M
end

return M

