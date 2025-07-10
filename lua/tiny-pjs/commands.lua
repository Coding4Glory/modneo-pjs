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

---@class PjsCommands
return {
    ---@type function
    ---defines the user commands
    ---@param core PjsCore
    setup = function(core)
        vim.api.nvim_create_user_command("PjsTrusted", function(opts)
            core.state.add_trusted(vim.fn.getcwd())
            if opts.bang then
                core.apply()
            end
        end, { desc = "add {cwd} to trusted", bang = true })

        vim.api.nvim_create_user_command("PjsUntrusted", function()
            core.state.del_trusted(vim.fn.getcwd())
        end, { desc = "removes {cwd} from trusted" })

        vim.api.nvim_create_user_command("PjsTrustInfo", function()
            if core.state.is_trusted(vim.fn.getcwd()) then
                vim.notify("Current dir is trusted", vim.log.levels.WARN)
                return
            else
                vim.notify("Current dir is NOT trusted", vim.log.levels.INFO)
            end
        end, { desc = "check if {cwd} is trusted" })

        vim.api.nvim_create_user_command("PjsApply", function(opts)
            core.apply(opts.bang)
        end, { desc = "apply project settings", bang = true })
    end,
}
