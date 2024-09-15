(local utils (require :dap-rego.utils))

(local default-opts
       {:adapter_name :regal-debug
        :regal
        {:path :regal
         :args [:debug]}
        :defaults
        {:log_level :info}
        :configurations []})

(fn default-configurations [opts]
  [{:type :rego
    :name "Debug Workspace"
    :request :launch
    :command :eval
    :query :data
    :enablePrint true
    :logLevel opts.defaults.log_level
    :bundlePaths ["${workspaceFolder}"]}
   {:type :rego
    :name "Launch Rego Workspace"
    :request :launch
    :command :eval
    :query :data
    :enablePrint true
    :logLevel opts.defaults.log_level
    :inputPath "${workspaceFolder}/input.json"
    :bundlePaths ["${workspaceFolder}"]}])

(fn setup-adapter [dap opts]
  (set dap.adapters.rego
       {:name :regal-debug
        :type :executable
        :command opts.regal.path
        :args opts.regal.args}))

(fn setup-configurations [dap opts]
  (let [configurations (utils.concat
                         (default-configurations opts)
                         opts.configurations)]
    (set dap.configurations.rego configurations)))

(fn setup [opts]
  (let [opts (vim.tbl_deep_extend :force default-opts (or opts {}))
        dap (utils.load-module :dap)]
    (setup-adapter dap opts)
    (setup-configurations dap opts)))

{: setup}
