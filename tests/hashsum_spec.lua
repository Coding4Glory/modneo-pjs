require'luassert'

describe('hashsum', function()
    it('returns only checksum', function()
        local sut = require'modneo-pjs.hashsum'
        local result = sut('.gitignore')
        assert.not_match('%s', result)
        assert.is_match('^%w+$', result)
    end)
end)
