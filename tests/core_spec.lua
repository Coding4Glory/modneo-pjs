local uv = (vim.uv or vim.loop)
local project_root = uv.cwd()
local test_dir = vim.fs.joinpath(project_root, 'tests')
local fixture = vim.fs.joinpath(test_dir, 'fixture')
local state_dir = vim.fs.joinpath(test_dir, 'state')


local test_defaults = require('tiny-pjs.config').setup({
   state_dir = state_dir,
   consider = { 'tests/fixture/init.lua' }
})

describe('modeline', function()
    it('loads test file', function()
        require('tiny-pjs').setup(test_defaults)
        vim.cmd('PjsApply!')
        assert.truthy(vim.g.pjs_test_run, 'setting not truthy')
        assert.truthy(uv.fs_stat(vim.fs.joinpath(state_dir, 'known.projects')))
        vim.g.pjs_test_run = 0
        vim.fs.rm(state_dir, { recursive = true })
    end)


end)

