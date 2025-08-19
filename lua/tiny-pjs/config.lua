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

---@class PjsConfig
---@field defaults PjsConfigOptions default settings
local M = {}

---@class PjsConfigOptions
M.defaults = {
    ---@type string
    ---string the path to the state directory, defaults to tiny-pjs.nvim inside data path
    state_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'tiny-pjs.nvim'),
    ---@type table
    --- a list of files to consider, defaults to `{'.nvim/init.lua' }`
    consider = { '.nvim/init.lua' },
    ---@type boolean
    ---adds the edit command, defaults to false
    enable_edit = false,
    ---@type boolean
    ---load only the first file found
    only_first = false,
}

---@param opts PjsConfigOptions? the user options to override defaults
---@return PjsConfigOptions the settings combined with user options
M.setup = function(opts)
    M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
    return M.options
end

return M
