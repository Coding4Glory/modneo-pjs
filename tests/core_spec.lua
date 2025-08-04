local uv = (vim.uv or vim.loop)
local project_root = uv.cwd()
local test_dir = vim.fs.joinpath(project_root, 'tests')
local state_dir = vim.fs.joinpath(test_dir, 'state')

describe('tiny-pjs tests', function()
    it('loads test files', function()
        require('tiny-pjs').setup({
            state_dir = state_dir,
            consider = { 'tests/fixture/init.lua', 'tests/fixture/second.vim' }
        })
        vim.cmd('PjsApply!')
        assert.truthy(vim.g.pjs_test_run, 'setting not truthy')
        assert.is_equal(3, vim.g.pjs_test_run, 'only one file ran')
        assert.truthy(uv.fs_stat(vim.fs.joinpath(state_dir, 'known.projects')))
        vim.g.pjs_test_run = 0
        vim.fs.rm(state_dir, { recursive = true })
    end)
    it('loads only the first file', function()
        require('tiny-pjs').setup({
            only_first = true,
            state_dir = state_dir,
            consider = { 'tests/fixture/init.lua', 'tests/fixture/second.vim' }
        })
        vim.cmd('PjsApply!')
        assert.truthy(vim.g.pjs_test_run, 'setting not truthy')
        assert.is_equal(1, vim.g.pjs_test_run, '3 = both files ran; 2 = wrong file')
        vim.g.pjs_test_run = 0
        vim.fs.rm(state_dir, { recursive = true, force = true })
    end)
end)
