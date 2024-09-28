-- [nfnl] Compiled from fnl/dap-rego/init.fnl by https://github.com/Olical/nfnl, do not edit.
local utils = require("dap-rego.utils")
local default_opts = {adapter_name = "regal-debug", regal = {path = "regal", args = {"debug"}}, defaults = {log_level = "info", stop_on_entry = true, stop_on_result = true, trace = true, enable_print = true, rule_indexing = false, stop_on_fail = false}, configurations = {}}
local function default_configurations(dap, opts)
  local find_input_path
  local function _1_()
    local path = (vim.fn.getcwd() .. "/input.json")
    if (vim.fn.filereadable(path) == 1) then
      return path
    else
      return nil
    end
  end
  find_input_path = _1_
  local query_input
  local function _3_()
    local function _4_(co)
      local function _5_(input)
        if (input == "") then
          return coroutine.resume(co, dap.ABORT)
        else
          return coroutine.resume(co, input)
        end
      end
      return vim.ui.input({prompt = "Query", default = "data"}, _5_)
    end
    return coroutine.create(_4_)
  end
  query_input = _3_
  return {{type = "rego", name = "Debug Rego Workspace by Query", request = "launch", command = "eval", query = query_input, stopOnEntry = opts.defaults.stop_on_entry, stopOnFail = opts.defaults.stop_on_fail, stopOnResult = opts.defaults.stop_on_result, trace = opts.defaults.trace, enablePrint = opts.defaults.enable_print, ruleIndexing = opts.defaults.rule_indexing, logLevel = opts.defaults.log_level, inputPath = find_input_path, bundlePaths = {"${workspaceFolder}"}}, {type = "rego", name = "Debug Rego Workspace All", request = "launch", command = "eval", query = "data", stopOnEntry = opts.defaults.stop_on_entry, stopOnFail = opts.defaults.stop_on_fail, stopOnResult = opts.defaults.stop_on_result, trace = opts.defaults.trace, enablePrint = opts.defaults.enable_print, ruleIndexing = opts.defaults.rule_indexing, logLevel = opts.defaults.log_level, inputPath = find_input_path, bundlePaths = {"${workspaceFolder}"}}}
end
local function setup_adapter(dap, opts)
  dap.adapters.rego = {name = opts.adapter_name, type = "executable", command = opts.regal.path, args = opts.regal.args}
  return nil
end
local function setup_configurations(dap, opts)
  local configurations = utils.concat(default_configurations(dap, opts), opts.configurations)
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
