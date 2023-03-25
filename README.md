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
{ "fraso-dev/nvim-listchars", config = true }
```

### Packer

#### With defaults

```lua
use {
  "fraso-dev/nvim-listchars",
  config = function()
    require("nvim-listchars").setup()
  end
}
```

## ⚙️ Configuration

### Defaults

```lua
{
  save_state = true, -- If enabled, save toggled state in a cache file. Will overwrite current `vim.opt.list` value.
  listchars = { -- `listchars` to be displayed. See available options by running `:help listchars`
    tab = "> ",
    trail = "-",
    nbsp = "+",
  },
  exclude_filetypes = {}, -- List of filetypes where `listchars` is disabled
}
```

### Example with updated preferences

```lua
{
  "fraso-dev/nvim-listchars",
  config = function()
    require("nvim-listchars").setup({
      save_state = false,
      listchars = {
        trail = "-",
        eol = "↲",
        tab = "» ",
      },
      exclude_filetypes = {
        "markdown"
      }
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
```

## Notes

If you want to enable `tab` chars you must disable `expandtab`:

```lua
vim.opt.expandtab = false
```
