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

---@class Modneo.ProjectSettings.Config
---@field defaults Modneo.ProjectSettings.ConfigOptions default settings
local M = {}

---@class Modneo.ProjectSettings.ConfigOptions
local defaults = {
    ---string the path to the state directory, defaults to tiny-pjs.nvim inside data path
    ---@type string
    state_dir = vim.fs.joinpath(vim.fn.stdpath('state'), 'modneo-pjs'),
    --- a list of files to consider, defaults to `{'.nvim/init.lua' }`
    ---@type table
    consider = { '.nvim/init.lua' },
    ---adds the edit command, defaults to false
    ---@type boolean
    enable_edit = false,
    ---load only the first file found
    ---@type boolean
    only_first = false,
    ---Set to false to disable checksum validation.
    ---This can improve performance in closed environments or be usefull
    ---when debugging project settings.
    ---**Warning:** Setting this to false is not recomended!
    ---@type boolean
    checksum = true,
}

---@param opts Modneo.ProjectSettings.ConfigOptions? the user options to override defaults
---@return Modneo.ProjectSettings.ConfigOptions the settings combined with user options
M.setup = function(opts)
    M.options = vim.tbl_deep_extend('force', M.options or defaults, opts or {})
    return M.options
end

M.init = function()
    return M.setup()
end

return M
