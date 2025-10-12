--[[
projectsettings.nvim
Copyright (C) 2025  Markus Hergenröder

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
--]]

local env = vim.startswith((vim.uv or vim.loop).os_uname().sysname, 'Windows')
    and 'Win'
    or 'UX'

local function get_command(filename)
    return env == 'UX'
    and { 'sha256sum', filename }
    or { 'powershell', '-Command', string.format('$hash = Get-FileHash %s -Algorithm SHA256 | $hash.Hash', filename:gsub('\\', '\\\\') ) }
end

---@param result vim.SystemCompleted
local result_handler = function(result)
    if result.code == 0 then
        return result.stdout:match('^(.*)%s?.*$')
    else
        error(result.stderr)
    end
end

---Creates the checksums for the state file and comparison
---@param filename string full path to script file
---@return string
return function(filename)
    if filename == nil or filename == '' then
        error('no filename given')
    end

    local result = vim.system(get_command(filename), { text = true }):wait()
    return result_handler(result)
end


