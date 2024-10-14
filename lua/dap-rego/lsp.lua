-- [nfnl] Compiled from fnl/dap-rego/lsp.fnl by https://github.com/Olical/nfnl, do not edit.
local function debug_codelens_handler(dap, opts)
  local function _1_(err, result, ctx, config)
    if not (dap.session() == nil) then
      return nil, vim.lsp.rpc.rpc_response_error(vim.lsp.protocol.ErrorCodes.InvalidRequest, "active debug session already exists")
    else
      local dconf = vim.tbl_deep_extend("force", result, {stopOnEntry = opts.defaults.stop_on_entry, stopOnFail = opts.defaults.stop_on_fail, stopOnResult = opts.defaults.stop_on_result, trace = opts.defaults.trace, enablePrint = opts.defaults.enable_print, ruleIndexing = opts.defaults.rule_indexing, logLevel = opts.defaults.log_level, bundlePaths = {"${workspaceFolder}"}})
      dap.run(dconf)
      return {ok = true}, nil
    end
  end
  return _1_
end
local function extmark_prints(ns, outputs)
  for file, prints in pairs(outputs) do
    local path = vim.fn.substitute(file, "^file://", "", "")
    local current = vim.fn.expand("%:p")
    if (path == current) then
      vim.notify(vim.inspect(prints))
      for l, rawtxts in pairs(prints) do
        local text = ""
        local line = (l - 1)
        for _, rawtxt in ipairs(rawtxts) do
          text = (text .. " => " .. rawtxt)
        end
        vim.api.nvim_buf_set_extmark(0, ns, line, 0, {virt_text = {{text, "Comment"}}, virt_text_pos = "eol"})
      end
    else
    end
  end
  return nil
end
local function extmark_package(ns, result)
  local line = (result.line - 1)
  local txt = ("=> " .. vim.fn.json_encode(result.result.value))
  return vim.api.nvim_buf_set_extmark(0, ns, line, 0, {virt_text = {{txt, "Comment"}}, virt_text_pos = "eol"})
end
local function extmark_rule_heads(ns, result)
  local txt = ("=> " .. vim.fn.json_encode(result.result.value))
  for _, loc in ipairs(result.rule_head_locations) do
    local line = (loc.row - 1)
    vim.api.nvim_buf_set_extmark(0, ns, line, 0, {virt_text = {{txt, "Comment"}}, virt_text_pos = "eol"})
  end
  return nil
end
local function evaluate_codelens_handler()
  local function _4_(err, result, ctx, config)
    do
      local ns = vim.api.nvim_create_namespace("regal.codelens.evaluate")
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
      extmark_prints(ns, result.result.printOutput)
      if (result.target == "package") then
        extmark_package(ns, result)
      else
        extmark_rule_heads(ns, result)
      end
    end
    return {ok = true}, nil
  end
  return _4_
end
return {["debug-codelens-handler"] = debug_codelens_handler, ["evaluate-codelens-handler"] = evaluate_codelens_handler}
