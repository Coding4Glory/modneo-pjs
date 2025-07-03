---@class PjsModule
return {
    ---@type function initializes the module
	---@param state PjsState
	setup = function(state)
		vim.api.nvim_create_user_command("PjsTrusted", function()
			state.add_trusted(vim.vn.getcwd())
		end, { desc = "add {cwd} to trusted" })

        vim.api.nvim_create_user_command("PjsUntrusted", function()
			state.del_trusted(vim.vn.getcwd())
		end, { desc = "removes {cwd} from trusted" })

        vim.api.nvim_create_user_command("PjsTrustInfo", function()
			if state.is_trusted(vim.fn.getcwd()) then
				vim.notify("Current dir is trusted", vim.log.levels.WARN)
				return
			else
				vim.notify("Current dir is NOT trusted", vim.log.levels.INFO)
			end
		end, { desc = "check if {cwd} is trusted" })
	end,
}
