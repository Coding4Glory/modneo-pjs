# tiny.nvim project settings support

aka tiny-pjs

A simple loader for project defined settings. **USE WITH CARE**

> Loading settings from a public repository has always to be considered dangerous, it could contain harmful commands executed in your user context

## Features

- Only auto load settings from trusted projects
- supports lua and vimscript < 9

## Setup 🚀

Setup with Lazy 

```lua
return { "coding4glory/tiny-pjs.nvim", opts = {}, lazy = false }
```

### Configuration ⚙

following the default options

```lua
opts = {
    -- path to directory where the known.projects file will be written
    state_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'tiny-pjs.nvim'),
    -- the files to consider during startup, files are sourced in order
    consider = { '.nvim/init.lua' },
}
```

Since the `:source` function is used, lua and vimscript files can be uses likewise, e. g:

```lua
return { 
    "coding4glory/tiny-pjs.nvim", 
    opts = { 
        consider = { 
            '.nvim/init.lua', 
            '.vimrc'
        }
    }
}
```

## Commands ⌨

- `:PjsTrusted[!]` adds the current working directory from known projects, with bang project settings will be loaded directly
- `:PjsUntrusted` removes the current working directory from known projects
- `:PjsTrustInfo` notifies if the current project is trusted
- `:PjsApply[!]` applies the current project settings, bang is required if current working directory is not trusted. This can be used to avoid trust but still load settings on demand.


## Contribution 🤜🤛

There is not really somthing to add, but maybe something to optimize. If you think you found something, you might add a PR. But don't be sad if it's not accepted. The module is meant be tiny 😉.

