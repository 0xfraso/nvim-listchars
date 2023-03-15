# nvim-listchars

Configure and toggle listchars easily

## Usage

Example config

```lua
require("nvim-listchars").setup({
		enable = true, -- enables listchars
		listchars = { -- default chars (:help listchars for additional info)
		trail = '-',
		eol = '↲',
		tab = '» ',
	}
})
```

You can find the complete list of available chars here `:help listchars`

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

If you want to enable `tab` chars you must enable `expandtab`:

```lua
vim.opt.expandtab = true
```
