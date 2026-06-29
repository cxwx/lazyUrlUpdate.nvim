
# Easy Update Plugins For `lazy.nvim`

A Neovim plugin to fast update plugins installed by lazy.nvim

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "cxwx/lazyUrlUpdate.nvim", -- github plugin will be removed soon.
    ft = "lua",
    opts = {},
    keys = {
        {"<leader>up", "<cmd>LazyUrlUpdate<CR>", desc = "Update plugin under cursor"},
        {"<leader>bp", "<cmd>LazyUrlBuild<CR>", desc = "Build plugin under cursor"},
    }
},
```

## Feature

* update plugin `LazyUrlUpdate`
* rebuild plugin `LazyUrlBuild`
* short URL `LazyUrlShort`
* Open short URL with Chrome `LazyUrlOpen`, `LazyUrlOpenChrome`(only macOS)
* short issue URL `LazyUrlShortExt` (`https://github.com/o/r/issues/42` -> `ISSUE:#42`; also PR:# / DISCUSSION:#)
* open issue/PR/discussion `LazyUrlOpenExt` (`ISSUE:#42` / `PR:#42` / `DISCUSSION:#42` under cursor, repo from plugin spec; github only)

```org
    - [X] github github:cxwx/lazyUrlUpdate.nvim/issues/1
    - [X] gitlab gitlab:...
    - [X] arxiv arxiv:1803.05072
    - [X] doi doi:10.1088/1742-6596/2742/1/012014
    - [X] orcid orcid:0000-0001-6332-2005
    - [X] codeberg codeberg:cxwx/lazyUrlUpdate.nvim
    - [X] bitbucket bitbucket:dtsarkov/factplusplus
```

## Commands

The plugin provides the user command `:LazyUrlUpdate`.
Invoke it when the cursor is on the name of a repo.

## To Do

- [ ] `xdg-open` for Linux
- [ ] string match with \` and `"`
