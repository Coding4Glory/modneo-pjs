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

---@class PjsState
---simple class to handle the known.projects file to ensure only
---tracked projects are loaded
---@field config PjsConfigOptions
local M = {}

-- defines the file name
local cf_name = "known.projects"

---@private
---tries to open the file
---@param filename string full path to the state file
---@param mode string the mode string, see `io.open()` mode string for details
---@see io.open()
---@return file*? the file handle on success, otherwise `nil`
local function open_state(filename, mode)
    local file, error = io.open(filename, mode)

    if not file then
        local action = (mode == "r" and "reading" or "writing")
        vim.api.nvim_err_writeln("Error " .. action .. " project config " .. filename .. " :" .. error)
        return nil
    end

    return file
end

---@private
---loads the current state from given path
---@param path string path to state directory
---@return table the list of known projects
local function load_state(path)
    local file = open_state(path, "r")
    if not file then
        return {}
    end

    local known_pjs = {}
    for line in file:lines() do
        if line ~= nil then
            table.insert(known_pjs, line)
        end

    end
    file:close()
    return known_pjs
end

---@private
---writes the state to the known.projects file
---@param state string[] the list of known projects
---@param path string path to state directory
local function write_state(state, path)
    local file = open_state(path, "w")
    if not file then
        return
    end

    for _, p in ipairs(state) do
        file:write(p .. "\n")
    end
    file:flush()
    file:close()
end

---@private
---@param t table table to filter
---@param value any element to remove
---@return table the table without the element
local function remove_from_table(t, value)
    for i, p in ipairs(t) do
        if p == value then
            table.remove(t, i)
            return t
        end
    end
    return t
end

---@type function
---gets the full path of the state file
---@return string
M.get_filename = function()
    return vim.fs.joinpath(M.config.state_dir, cf_name)
end

---@type function
---checks if the current working directory is in a trusted path
---@param path string the path to the current file or project
---@return boolean `true` if the path is trusted, otherwise `false`
M.is_trusted = function(path)
    local known_pjs = load_state(M.get_filename()) or {}
    for _, pj_path in ipairs(known_pjs) do
        if vim.startswith(path, pj_path) then
            return true
        end
    end
    return false
end

---@type function
---adds a path to the trusted paths
---@param path string path to add to trusted paths
M.add_trusted = function(path)
    local current = load_state(M.get_filename())
    table.insert(current, path)
    write_state(current, M.get_filename())
end

---@type function
---removes a path from the trusted paths
---@param path string path to remove from trusted projects
M.del_trusted = function(path)
    local cleaned = remove_from_table(load_state(M.get_filename()), path)
    write_state(cleaned, M.get_filename())
end

---@type function
---gets the trusted projects as simple table
---@return table?
M.get_trusted = function()
    return load_state(M.get_filename())
end

---@type function
---initializes the state module
---@return PjsState the project state accessor
M.init = function()
    M.config = require('tiny-pjs.config').options
    local uv = (vim.uv or vim.loop)
    -- first ensure directory exists
    if not uv.fs_stat(M.get_filename()) then
        vim.system({ 'mkdir', '-p', M.config.state_dir }, {}):wait()
    end
    -- second check to recover from deleted state files
    if not uv.fs_stat(M.get_filename()) then
        write_state({}, M.get_filename())
    end
    return M
end

return M
