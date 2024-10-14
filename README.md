# nvim-dap-rego

nvim-dap-rego is an extension for nvim-dap, used for debugging OPA/Rego using Regal (https://github.com/StyraInc/regal).
This extension sets up adapter and basic configurations for debugging Rego policies.

This extension also provides Neovim LSP handlers for Regal Codelenses.
It is useful if you use Regal's LSP feature.

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

    codelens_handler = {
      -- register `regal/startDebugging` handler to Neovim LSP
      -- this enables to start debugger by `Debug` codelens
      start_debugging = true,
      -- register `regal/showEvalResult` handler to Neovim LSP
      show_eval_result = true,
    },
  }
)
```

## LSP Handlers

This extension additionally provides Neovim LSP handlers for these Regal's Codelens features.

![nvim-regal-codelens](https://github.com/user-attachments/assets/582162c5-de4c-42f0-bbff-12d106ac53d1)

- Evaluate Codelens (`regal/showEvalResult`)
    - Provides a feature to evaluate rules on the buffer.
      This handler shows the evaluation result as virtual texts.
    - Ref: https://docs.styra.com/regal/language-server#code-lenses-evaluation
- Debug Codelens (`regal/startDebugging`)
    - Provides a feature to provide a launch configuration about a rule or package.
      This handler starts a new debug session by the provided configuration.
    - Ref: https://github.com/StyraInc/regal/releases/tag/v0.27.0

To enable these features, it is needed to enable codelens features by setting `init_options`.

```lua
require'lspconfig'.regal.setup(
  {
    init_options = {
      enableDebugCodelens = true,
      evalCodelensDisplayInline = true,
    },
  }
)
```
