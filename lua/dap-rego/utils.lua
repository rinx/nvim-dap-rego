-- [nfnl] Compiled from fnl/dap-rego/utils.fnl by https://github.com/Olical/nfnl, do not edit.
local function concat(...)
  local result = {}
  for _, xs in ipairs({...}) do
    for _0, x in ipairs(xs) do
      table.insert(result, x)
    end
  end
  return result
end
--[[ (concat [] []) (concat ["a" "b"] []) (concat [] ["a" "b"]) (concat ["a" "b"] ["c" "d"]) ]]
local function load_module(m)
  local ok_3f, mod = pcall(require, m)
  assert(ok_3f, string.format("dap-rego requires `%s`: not installed", m))
  return mod
end
return {concat = concat, ["load-module"] = load_module}
