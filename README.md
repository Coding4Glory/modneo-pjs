# modneo-pjs

former tiny-pjs.nvim

A simple loader for project defined settings. **USE WITH CARE**

> Loading settings from a public repository has always to be considered dangerous, it could contain harmful commands executed in your user context

## Features

- Only auto load settings from trusted projects
- Hashes files to avoid execution after change
    - Automatically re-hashes the file if edited in nvim
- supports lua and vimscript < 9

## Setup 🚀

Setup with Lazy 

```lua
return { "Coding4Glory/modneo-pjs", opts = {}, lazy = false }
```

### Configuration ⚙

following the default options

```lua
opts = {
    -- path to directory where the known.projects file will be written
    state_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'modneo-pjs'),
    -- the files to consider during startup, files are sourced in order
    consider = { '.nvim/init.lua' },
    -- add the edit command for the state file
    enable_edit = false,
    -- only load the first found file and skip others
    only_first = false,
    ---automatically hash files on local edit
    autohash = true,
    ---Set to false to disable checksum validation.
    ---This can improve performance in closed environments or be usefull
    ---when debugging project settings.
    ---**Warning:** Setting this to false is not recomended!
    checksum = true,
}
```

Since the `:source` function is used, lua and vimscript files can be uses likewise, e. g:

```lua
return { 
    "Coding4Clory/modneo-pjs", 
    opts = { 
        consider = { 
            '.nvim/init.lua', 
            '.vimrc'
        }
    }
}
```


## Commands ⌨

```vimdoc
                                                       *modneo-pjs-PjsTrusted*
:PjsTrust[!]           adds the current working directory from known
                       projects. If bang is present project settings will be
                       loaded directly.

                                                     *modneo-pjs-PjsUntrusted*
:PjsUntrust            removes the current working directory from known
                       projects

                                                     *modneo-pjs-PjsTrustInfo*
:PjsTrustInfo          notifies about the current project's trust state

                                                         *modneo-pjs-PjsApply*
:PjsApply              applies the current project settings, bang is required
                       if current working directory is not trusted. This can
                       be used to avoid trust but still load settings on
                       demand. Depding on the project settings this command
                       may also be used for a reload after change.

                                                          *modneo-pjs-PjsList*
:PjsList               !experimental! lists the trusted projects. Since it
                       uses `vim.print()` the output is not very readable.

                                                         *modneo-pjs-PjsZEdit*
:PjsZEdit!             !disabled per default! opens the state file in a
                       buffer. Even if enabled a bang is required to
                       actually open the state file, otherwise a warning
                       will be emmited
                       The Z was injected in the name to let this command
                       appear at the last position in auto completion.
```

## Contribution 🤜🤛

There is not really somthing to add, but maybe something to optimize. If you think you found something, you might add a PR. But don't be sad if it's not accepted. The module is meant be tiny 😉.

## Known Issues

- [which-key.nvim](https://github.com/folke/which-key.nvim) may not appear for keymaps added with `PjsApply` containing a previously unused *leaderkey* like `<localleader>`.
