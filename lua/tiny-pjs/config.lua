---@class PjsConfig
---@field defaults PjsConfig
---@field setup function merges defaults with user settings
local M = {}

---@class PjsConfigSettings
---@field state_dir string the path to the state directory, defaults to tiny-pjs.nvim inside data path
---@field consider table a list of files to consider, defaults to `{'.nvim/init.lua' }`
M.defaults = {
    state_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'tiny-pjs.nvim'),
    consider = { '.nvim/init.lua' },
}

---@param table opts the user options to override defaults
---@return PjsConfigSettings the settings combined with user options
M.setup = function(opts or {})
    local config = vim.tbl_deep_extend('force', M.defaults, opts)
    return config
end

return M
