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
]] --

---@class Modneo.PjsCommands
return {
    ---@type function
    ---defines the user commands
    ---@param core Modneo.ProjectSettings
    setup = function(core)
        -- PjsTrusted
        vim.api.nvim_create_user_command("PjsTrusted", function(opts)
            core.state.add_trusted(vim.fn.getcwd())
            if opts.bang then
                core.apply()
            end
        end, { desc = "add {cwd} to trusted projects", bang = true })

        -- PjsUntrusted
        vim.api.nvim_create_user_command("PjsUntrusted", function()
            core.state.del_trusted(vim.fn.getcwd())
        end, { desc = "removes {cwd} from trusted projects" })

        -- PjsTrustInfo
        vim.api.nvim_create_user_command("PjsTrustInfo", function()
            if core.state.is_trusted(vim.fn.getcwd()) then
                vim.notify("Current dir is trusted", vim.log.levels.WARN)
                return
            else
                vim.notify("Current dir is NOT trusted", vim.log.levels.INFO)
            end
        end, { desc = "check if {cwd} is trusted" })

        -- PjsApply
        vim.api.nvim_create_user_command("PjsApply", function(args)
            local applied = core.apply(args.bang)
            if applied == nil then
                vim.notify("No project config found", vim.log.levels.INFO)
            elseif not applied then
                vim.notify("Project not trusted", vim.log.levels.WARN)
            end
        end, { desc = "apply project settings", bang = true })

        -- PjsList
        vim.api.nvim_create_user_command("PjsList", core.print_trusted, { desc = "list trusted projects" })

        -- PjsZEdit
        if core.options.enable_edit then
            vim.api.nvim_create_user_command("PjsZEdit", function(args)
                    if not args.bang then
                        vim.notify("Editing the state file directly is not recommended, use bang ! to override",
                            vim.log.levels.WARN)
                        return
                    end
                    core.edit_statefile()
                end,
                { desc = "edit trusted projects file", bang = true })
        end
    end,
    ---removes the commands added by the plugin **experimental**
    unload = function()
        local commands = { 'PjsTrusted', 'PjsUntrusted', 'PjsTrustInfo', 'PjsApply', 'PjsList', 'PjsZEdit' }
        for name, _ in pairs(vim.api.nvim_get_commands({ builtin = false })) do
            if vim.startswith(name, "Pjs") and vim.tbl_contains(commands, name) then
                vim.api.nvim_del_user_command(name)
            end
        end
    end
}
