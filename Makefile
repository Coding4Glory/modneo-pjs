PLENARY_INIT=tests/init.lua
TESTS_DIR=tests

.PHONY: test clean

tests/fixture/init.lua:
	@mkdir -p $(@D)
	@echo "vim.g.pjs_test_run = 1" > $@

tests/fixture/second.vim:
	@mkdir -p $(@D)
	@echo "let g:pjs_test_run=g:pjs_test_run+2"

test: tests/fixture/init.lua tests/fixture/second.vim
	@nvim \
		--headless \
		--noplugin \
		-u ${PLENARY_INIT} \
		-c "PlenaryBustedDirectory ${TESTS_DIR} { minimal_init = '${PLENARY_INIT}' }"

clean:
	@rm -rf /tmp/plenary.nvim
	@rm -rf tests/fixture
