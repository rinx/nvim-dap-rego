-- [nfnl] Compiled from fnl/dap-rego/init.fnl by https://github.com/Olical/nfnl, do not edit.
local default_opts = {["adapter-name"] = "regal-debug", regal = {path = "regal", args = {"debug"}}}
local function setup_adapter(dap, opts)
  dap.adapters.rego = {name = "regal-debug", type = "executable", command = opts.regal.path, args = opts.regal.args}
  return nil
end
local function setup_configurations(dap, opts)
  dap.configurations.rego = {{type = "rego", name = "Debug Workspace", request = "launch", command = "eval", query = "data", enablePrint = true, logLevel = "info", bundlePaths = {"${workspaceFolder}"}}, {type = "rego", name = "Launch Rego Workspace", request = "launch", command = "eval", query = "data", enablePrint = true, logLevel = "info", inputPath = "${workspaceFolder}/input.json", bundlePaths = {"${workspaceFolder}"}}}
  return nil
end
local function load_module(m)
  local ok_3f, mod = pcall(require, m)
  assert(ok_3f, string.format("dap-rego requires `%s`: not installed", m))
  return mod
end
local function setup(opts)
  local opts0 = vim.tbl_deep_extend("force", default_opts, (opts or {}))
  local dap = load_module("dap")
  setup_adapter(dap, opts0)
  return setup_configurations(dap, opts0)
end
return {setup = setup}
