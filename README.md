# nvim-listchars

Easily configure and toggle listchars

![example](https://user-images.githubusercontent.com/116293603/225258794-e083246c-4262-474e-b68d-827da4d17fe0.gif)

## 📦 Installation

In order to display `listchars` by default,
you must enable them somewhere in your `init.lua` **before** loading the plugin.

```lua
vim.opt.list = true
```

If you simply want to display `listchars` when needed,
you can toggle them ON/OFF with the command `:ListcharsToggle`.

### Lazy (recommended)

#### With defaults

```lua
{ "0xfraso/nvim-listchars", opts = true }
```

### Packer

#### With defaults

```lua
use {
  "0xfraso/nvim-listchars",
  config = function()
    require("nvim-listchars").setup()
  end
}
```

## ⚙️ Configuration

### Defaults

```lua
{
  save_state = true,      -- If enabled, save toggled state in a cache file. Will overwrite current `vim.opt.list` value.
  listchars = {           -- `listchars` to be displayed. See available options by running `:help listchars`
    tab = "> ",
    trail = "-",
    nbsp = "+",
  },
  notifications = true,   -- Enable or disable listchars notifications
  exclude_filetypes = {}, -- List of filetypes where `listchars` is disabled
  lighten_step = 5,       -- Amount to add/remove from base color
}
```

### Example with updated preferences

```lua
{
  "0xfraso/nvim-listchars",
  event = "BufEnter",
  config = function()
    require("nvim-listchars").setup({
      save_state = false,
      listchars = {
        trail = "-",
        eol = "↲",
        tab = "» ",
        space = "·",
      },
      notifications = true,
      exclude_filetypes = {
        "markdown"
      },
      lighten_step = 10,
    })
  end,
}
```

You can find the complete list of available chars by running `:help listchars`

## ⚡ Commands

```
:ListcharsStatus
:ListcharsToggle
:ListcharsDisable
:ListcharsEnable
:ListcharsClearCache
:ListcharsLightenColors
:ListcharsDarkenColors
```

## Notes

If you want to enable `tab` chars you must disable `expandtab`:

```lua
vim.opt.expandtab = false
```
