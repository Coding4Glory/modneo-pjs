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

---@class Modneo.ProjectSettings
---@field state Modneo.ProjectSettings.State an instance of the state service
---@field options Modneo.ProjectSettings.ConfigOptions the settings for this session
local M = {}

local hashsum = require('modneo-pjs.hashsum')

---applies the project settings to the current session if folder is trusted
---@param force boolean? set a truthy value to force enabling
---@return boolean? true if settings got applied, nil of no script was found, false if not trusted
M.apply = function(force)
    local current_dir = vim.fn.getcwd()
    local applied = false
    if not M.state.is_known(current_dir) and not force then
        return applied
    end

    local function _apply(file)
        vim.cmd('source ' .. file)
        applied = true
    end
    for _, file in ipairs(M.options.consider) do
        if (vim.uv or vim.loop).fs_stat(file) then
            if force or not M.options.checksum
                or M.state.is_trusted(current_dir, file, hashsum(file))
            then
                _apply(file)
                if M.options.only_first then return applied end
            end
        end
    end
    return applied
end

---prints the trusted networks
M.print_trusted = function()
    vim.print(M.state.get_trusted())
end

---opens a new editor buffer for the state file
M.edit_statefile = function()
    vim.cmd('edit ' .. M.state.get_filename())
end

---this function acutally loads the project settings if the current
---path is trusted
---@return Modneo.ProjectSettings
M.init = function()
    M.options = require('modneo-pjs.config').options
    M.state = require('modneo-pjs.state').init()
    xpcall(M.apply, function(err)
        print('ERROR loading project settings: ', err)
    end)
    return M
end

return M

