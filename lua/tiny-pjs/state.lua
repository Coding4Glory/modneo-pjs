---@class PjsState
local M = {}

local cf_name = "known.projects"

---@return file*?
local function open_state(path, mode)
    local filename = vim.fs.joinpath(path, cf_name)
    local file, error = io.open(filename, mode)

    if not file then
        local action = (mode == "r" and "reading" or "writing")
        vim.api.nvim_err_writeln("Error " .. action .. " project config " .. filename .. " :" .. error)
        return nil
    end

    return file

end

---@private
---@return table?
local function load_state(path)
    local file = open_state(path, "r")
    if not file then
        return nil
    end

    local known_pjs = {}
    for line in file:lines() do
        table.insert(known_pjs, line)
    end
    file:close()
    return known_pjs
end

---@private
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
---@return table
local function remove_from_table(t, value)
    for i, p in ipairs(t) do
        if p == value then
            table.remove(t, i)
            return t
        end
    end
    return t
end

---@type PjsConfigSettings
M.config = {}

---@type function
---@param opts PjsConfigSettings
---@return PjsState
M.init = function(opts)
    M.config = opts
    return M
end

---@type function checks if the current working directory is in a trusted path
---@param path string the path to the current file or project
---@return boolean `true` if the path is trusted, otherwise `false`
M.is_trusted = function(path)
    local known_pjs = load_state() or {}
    for _, pj_path in ipairs(known_pjs) do
        if vim.startswith(path, pj_path) then
            return true
        end
    end
    return false
end

---@type function adds a path to the trusted paths
---@param path string path to add to trusted paths
M.add_trusted = function(path)
    local current = load_state() or {}
    table.insert(current, path)
    write_state(current, M.config.state_dir)
end

---@type function removes a path from the trusted paths
---@param path string path to remove from trusted projects
M.del_trusted = function(path)
    local cleaned = remove_from_table(load_state(), path)
    write_state(cleaned, M.config.state_dir)
end

return M
