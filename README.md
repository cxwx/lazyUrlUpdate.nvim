<!-- *********************************************************************** -->
<!--                                                                         -->
<!--                                                      :::      ::::::::  -->
<!-- README.md                                          :+:      :+:    :+:  -->
<!--                                                  +:+ +:+         +:+    -->
<!-- By: chenxu <chenxu@mail.ustc.edu.cn>           +#+  +:+       +#+       -->
<!--                                              +#+#+#+#+#+   +#+          -->
<!-- Created: 2024/12/14 20:43:55 by chenxu            #+#    #+#            -->
<!-- Updated: 2024/12/14 20:48:43 by chenxu           ###   ########.fr      -->
<!--                                                                         -->
<!-- *********************************************************************** -->

# easy update plugins for lazy.nvim

A NeoVim plugin to fast update plugins installed by lazy.nvim

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cxwx/lazyUpdatePlugin.nvim",
  ft = "lua",
  opts = {},
},
```

## Commands

The plugin provides the user command `:LazyUpdatePlugin`.
Invoke it when the cursor is on the name of a repo.

To bind it to a key you can do:

```lua
vim.keymap.set('n', '<leader>oou', '<Cmd>LazyUpdatePlugin<CR>')
```
