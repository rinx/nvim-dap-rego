(local default-opts
       {:adapter-name :regal-debug
        :regal
        {:path :regal
         :args [:debug]}})

(fn setup-adapter [dap opts]
  (set dap.adapters.rego
       {:name :regal-debug
        :type :executable
        :command opts.regal.path
        :args opts.regal.args}))

(fn setup-configurations [dap opts]
  (set dap.configurations.rego
       [{:type :rego
         :name "Debug Workspace"
         :request :launch
         :command :eval
         :query :data
         :enablePrint true
         :logLevel :info
         :bundlePaths ["${workspaceFolder}"]}
        {:type :rego
         :name "Launch Rego Workspace"
         :request :launch
         :command :eval
         :query :data
         :enablePrint true
         :logLevel :info
         :inputPath "${workspaceFolder}/input.json"
         :bundlePaths ["${workspaceFolder}"]}]))

(fn load-module [m]
  (let [(ok? mod) (pcall require m)]
    (assert ok? (string.format "dap-rego requires `%s`: not installed" m))
    mod))

(fn setup [opts]
  (let [opts (vim.tbl_deep_extend "force" default-opts (or opts {}))
        dap (load-module :dap)]
    (setup-adapter dap opts)
    (setup-configurations dap opts)))

{: setup}
