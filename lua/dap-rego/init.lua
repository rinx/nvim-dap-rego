-- [nfnl] Compiled from fnl/dap-rego/init.fnl by https://github.com/Olical/nfnl, do not edit.
local utils = require("dap-rego.utils")
local default_opts = {adapter_name = "regal-debug", regal = {path = "regal", args = {"debug"}}, defaults = {log_level = "info"}, configurations = {}}
local function default_configurations(opts)
  return {{type = "rego", name = "Debug Workspace", request = "launch", command = "eval", query = "data", enablePrint = true, logLevel = opts.defaults.log_level, bundlePaths = {"${workspaceFolder}"}}, {type = "rego", name = "Launch Rego Workspace", request = "launch", command = "eval", query = "data", enablePrint = true, logLevel = opts.defaults.log_level, inputPath = "${workspaceFolder}/input.json", bundlePaths = {"${workspaceFolder}"}}}
end
local function setup_adapter(dap, opts)
  dap.adapters.rego = {name = "regal-debug", type = "executable", command = opts.regal.path, args = opts.regal.args}
  return nil
end
local function setup_configurations(dap, opts)
  local configurations = utils.concat(default_configurations(opts), opts.configurations)
  dap.configurations.rego = configurations
  return nil
end
local function setup(opts)
  local opts0 = vim.tbl_deep_extend("force", default_opts, (opts or {}))
  local dap = utils["load-module"]("dap")
  setup_adapter(dap, opts0)
  return setup_configurations(dap, opts0)
end
return {setup = setup}
