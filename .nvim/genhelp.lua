for _, ct_engine in ipairs({ 'podman', 'docker' }) do
    local found = vim.fn.system('which ' .. ct_engine)
    if found ~= nil and found:len() > 0 then
        vim.keymap.set('n', '<localleader>bd', function()
            vim.system({
                    "podman",
                    "run",
                    "--rm",
                    "-v",
                    ".:/workspace",
                    "panvimdoc:latest",
                    "--project-name",
                    "tiny-pjs.nvim",
                    "--input-file",
                    "README.md",
                    "--vim-version",
                    "neovim-0.12",
                    "--toc",
                    "true",
                    "--demojify",
                    "true",
                    "--dedup-subheadings",
                    "true"
                },
                {
                    text = true
                },
                function(obj)
                    if obj.code == 0 then
                        print(obj.stdout)
                    else
                        print(obj.stderr)
                    end
                end
            )
        end, { desc = '[b]uild [d]ocumentation' })
        return
    end
end

vim.print('no container engine found, <localleader>bd not mapped')

