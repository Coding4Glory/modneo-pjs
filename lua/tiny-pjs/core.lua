--[[
tiny-pjs.nvim
Copyright (C) 2025  Markus Hergenröder <markus@coding4glory.net>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

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
            if M.settings.only_first then return end
        end
    end
end

---@type function
---prints the trusted networks
M.print_trusted = function()
    vim.print(M.state.get_trusted())
end

---@type function
---opens a new editor buffer for the state file
M.edit_statefile = function()
    vim.cmd('edit ' .. M.state.get_filename())
end

---@type function
---this function acutally loads the project settings if the current
---path is trusted
---@param settings PjsConfigSettings
---@return PjsCore
M.setup = function(settings)
    M.settings = settings
    M.state = require('tiny-pjs.state').init(M.settings)
    xpcall(M.apply, function(err)
        print('ERROR loading project settings: ', err)
    end)
    return M
end

return M

