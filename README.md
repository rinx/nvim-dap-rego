# nvim-dap-rego

nvim-dap-rego is an extension for nvim-dap, used for debugging OPA/Rego using Regal (https://github.com/StyraInc/regal).
This extension sets up adapter and basic configurations for debugging Rego policies.

## Install

This extension requires both nvim-dap and Regal (>= 0.26.0).

Please install nvim-dap-rego as usual.

- vim-plug

```vim
Plug 'rinx/nvim-dap-rego'
```

- Packer

```lua
use {
  "rinx/nvim-dap-rego"
}
```

- lazy.nvim

```lua
{
  "rinx/nvim-dap-rego"
}
```

## Configurations

To use nvim-dap-rego, you'll need to set up it.
This is done by calling `setup()` function.

```lua
    require('dap-rego').setup()
```

It is possible to custom nvim-dap-rego behavior by passing a config table to this function.

```lua
    require('dap-rego').setup(
      {
        -- here's show the default parameters

        -- dap adapter name
        adapter_name = "regal-debug",

        -- regal executable options
        regal = {
          -- the path to the regal executable
          path = "regal",
          -- the arguments that passed to regal executable
          args = {"debug"},
        },

        -- default parameters that passed to pre-defined dap configurations
        defaults = {
          -- log level
          log_level = "info",
          -- automatically stop on entry, fail, result
          stop_on_entry = true,
          stop_on_fail = false,
          stop_on_result = true,
          -- enable logging for dap
          trace = true,
          -- enable print statements
          enable_print = true,
          -- enable rule indexing
          rule_indexing = true,
        },

        -- additional dap configurations
        configurations = {},
      }
    )
```
