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
---@field defaults PjsConfigSettings default settings
---@field setup function merges defaults with user settings
local M = {}

---@class PjsConfigSettings
---@field state_dir string the path to the state directory, defaults to tiny-pjs.nvim inside data path
---@field consider table a list of files to consider, defaults to `{'.nvim/init.lua' }`
M.defaults = {
    state_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'tiny-pjs.nvim'),
    consider = { '.nvim/init.lua' },
}

---@param opts PjsConfigSettings? the user options to override defaults
---@return PjsConfigSettings the settings combined with user options
M.setup = function(opts)
    local settings = vim.tbl_deep_extend('force', M.defaults, opts or {})
    return settings
end

return M
