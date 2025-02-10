<!-- *********************************************************************** -->
<!--                                                                         -->
<!--                                                      :::      ::::::::  -->
<!-- README.md                                          :+:      :+:    :+:  -->
<!--                                                  +:+ +:+         +:+    -->
<!-- By: chenxu <chenxu@mail.ustc.edu.cn>           +#+  +:+       +#+       -->
<!--                                              +#+#+#+#+#+   +#+          -->
<!-- Created: 2024/12/14 20:43:55 by chenxu            #+#    #+#            -->
<!-- Updated: 2024/12/14 21:04:32 by chenxu           ###   ########.fr      -->
<!--                                                                         -->
<!-- *********************************************************************** -->
<!-- cspell:ignore orcid -->

# Easy update plugins for lazy.nvim

A NeoVim plugin to fast update plugins installed by lazy.nvim

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "cxwx/lazyUrlUpdate.nvim",
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
* open short URL `LazyUrlOpen` (only support macOS)

    - [X] `github` github:cxwx/lazyUrlUpdate.nvim/issues/1
    - [X] `arxiv` arxiv:1803.05072
    - [X] `doi` doi:10.1088/1742-6596/2742/1/012014
    - [X] `orcid` orcid:0000-0001-6332-2005

## Commands

The plugin provides the user command `:LazyUrlUpdate`.
Invoke it when the cursor is on the name of a repo.

## TODO

- [ ] `xdg-open` for linux
