---@class ProjectSettingsLoader
---@field setup function initializes the module
return {
    setup = function(opts)
        local settings = require('tiny-pjs.config').setup(opts)
        local core = require('tiny-pjs.core').setup(settings)
        require('tiny-pjs.commands').setup(core)
    end
}
