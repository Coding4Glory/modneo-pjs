---@class PjsModule
return {
    ---@type function initializes the module
    ---@param core PjsCore
    setup = function(core)
        vim.api.nvim_create_user_command("PjsTrusted", function()
            core.state.add_trusted(vim.fn.getcwd())
            core.apply()
        end, { desc = "add {cwd} to trusted" })

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
    end,
}
