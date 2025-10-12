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

---@class Modneo.ProjectSettings.StateEntry
---@field [1] string relative path of the settings file
---@field [2] string hash of the file

---@class Modneo.ProjectSettings.State
---simple class to handle the known.projects file to ensure only
---tracked projects are loaded
---@field config Modneo.ProjectSettings.ConfigOptions
local M = {}

local uv = (vim.uv or vim.loop)

local hashsum = require('modneo-pjs.hashsum')

-- defines the file name
local cf_name = "projects.lock"

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

---loads the current state from given path
---@param path string path to state directory
---@return table<string,table<string,string>> current internal state
local function load_state(path)
    local state_file = open_state(path, "r")
    if not state_file then
        return {}
    end

    local known_pjs = {}
    local pj = nil
    for line in state_file:lines() do
        if line == nil or line == '' then goto continue end

        if string.match(line, '^[^%s].*$') then
            pj = line
            known_pjs[pj] = {}
        else
            local checksum, file = string.match(line, '^%s+(%x+)%s(.*)$')
            known_pjs[pj][file] = checksum
        end

        ::continue::
    end
    state_file:close()
    return known_pjs
end

---writes the current state to the given path
---@param state table<string,table<string,string>> the internal state structure
---@param path string full path for the lock file
local function write_state(state, path)
    local file = open_state(path, 'w')
    if not file then return end

    for p, s in pairs(state) do
        if s == nil or vim.tbl_isempty(s) then goto continue end

        file:write(p .. "\n")
        for f, h in pairs(s) do
            file:write(string.format("    %s %s\n", h, f))
        end

        ::continue::
    end
    file:flush()
    file:close()
end

---gets the full path of the state file
---@return string
M.get_filename = function()
    return vim.fs.joinpath(M.config.state_dir, cf_name)
end

---checks if the given directory is a known project
---@param path string the path to the current file or project
---@return boolean `true` if the path is trusted, otherwise `false`
M.is_known = function(path)
    local known_pjs = load_state(M.get_filename()) or {}
    return known_pjs[path] ~= nil
end

---gets a value indicating if the file is trusted
---@return boolean
M.is_trusted = function(path, file, hash)
    local known_pjs = load_state(M.get_filename()) or {}
    return known_pjs[path] ~= nil
        and known_pjs[path][file] == hash
end

---adds a path to the trusted paths
---@param path string path to add to trusted paths
M.add_trusted = function(path)
    local current = load_state(M.get_filename())
    for _, file in ipairs(M.config.consider) do
        if uv.fs_stat(file) then
            if current[path] == nil then current[path] = {} end
            current[path][file] = hashsum(file)
        end
    end
    write_state(current, M.get_filename())
    print(path .. ' added to trusted projects')
end

---removes a path from the trusted paths
---@param path string path to remove from trusted projects
M.del_trusted = function(path)
    local current = load_state(M.get_filename())
    current[path] = nil
    write_state(current, M.get_filename())
end

---gets the trusted projects as simple table
---@return table<string,table<string,string>>?
M.get_trusted = function()
    return load_state(M.get_filename())
end

--#region config-migration

---performs statefile migration for v0.2.0 to v0.2.1
local function migrate_statefile(new_path)
    local legacy_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'tiny-pjs.nvim')
    local legacy_file = vim.fs.joinpath(legacy_dir, "known.projects")
    if uv.fs_stat(legacy_file) ~= nil and uv.fs_stat(new_path) == nil then
        uv.fs_rename(legacy_file, new_path)
        uv.fs_rmdir(legacy_dir)
    end
end

---converts the statefile for v0.2.1 to v0.3.0
---@param filename string name of the state file
---@param options Modneo.ProjectSettings.ConfigOptions current options to find considered files
local function convert_statefile(filename, options)
    local file = open_state(filename, "r")
    if not file then
        return
    end

    local known_pjs = {}
    for line in file:lines() do
        if line ~= nil then
            -- already converted?
            if line:match('%s+.*') then file:close() return end

            known_pjs[line] = {}
            for _, c in ipairs(options.consider) do
                local candidate = vim.fs.joinpath(line, c)
                if uv.fs_stat(candidate) then
                    local checksum = hashsum(candidate)
                    known_pjs[line][file] = checksum
                end
            end
        end
    end
    file:close()
    if vim.tbl_isempty(known_pjs) then return end
    write_state(known_pjs, filename)
    print("pjs state file converted")
end

--#endrgion config-migration

---initializes the state module
---@return Modneo.ProjectSettings.State the project state accessor
M.init = function()
    M.config = require('modneo-pjs.config').options
    -- first ensure directory exists
    if not uv.fs_stat(M.get_filename()) then
        uv.fs_mkdir(M.config.state_dir, tonumber('755', 8) or 0)
    end

    local success, err = pcall(migrate_statefile, M.get_filename())
    if not success then print('could not migrate state file: ' .. err) end

    success, err = pcall(convert_statefile, M.get_filename(), M.config)
    if not success then print('could not convert state file: ' .. err) end

    -- second check to recover from deleted state files
    if not uv.fs_stat(M.get_filename()) then
        write_state({}, M.get_filename())
    end
    return M
end

return M
