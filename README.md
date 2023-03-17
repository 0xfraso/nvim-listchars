# nvim-listchars

Configure and toggle listchars easily

![example](https://user-images.githubusercontent.com/116293603/225258794-e083246c-4262-474e-b68d-827da4d17fe0.gif)

## Installation

### Packer

```lua
use "fraso-dev/nvim-listchars"
```

### Lazy

```lua
{ "fraso-dev/nvim-listchars" }
```

## Configuration

Defaults

```lua
require("nvim-listchars").setup({
  enable = true,
  listchars = {
    tab = "> ",
    trail = "-",
    nbsp = "+",
  },
})
```

Example configuration with updated preferences

```lua
require("nvim-listchars").setup({
  enable = true,
  listchars = {
    trail = "-",
    eol = "↲",
    tab = "» ",
  },
})
```

You can find the complete list of available chars by running `:help listchars`

### Disable by default

```lua
vim.g.listchar_enabled = false
```

## Commands

```
:ListcharsStatus
:ListcharsToggle
:ListcharsDisable
:ListcharsEnable
```

## Notes

If you want to enable `tab` chars you must disable `expandtab`:

```lua
vim.opt.expandtab = false
```
