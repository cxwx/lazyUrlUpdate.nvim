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

# easy update plugins for lazy.nvim

A NeoVim plugin to fast update plugins installed by lazy.nvim

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "cxwx/lazyUpdatePlugin.nvim",
    ft = "lua",
    opts = {},
    keys = {
        {"<leader>up", "<cmd>LazyUrlUpdate<CR>", desc = "Update plugin under cursor"},
    }
},
```

## Commands

The plugin provides the user command `:LazyUrlUpdate`.
Invoke it when the cursor is on the name of a repo.
