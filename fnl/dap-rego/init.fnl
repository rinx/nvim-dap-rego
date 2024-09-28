(local utils (require :dap-rego.utils))

(local default-opts
       {:adapter_name :regal-debug
        :regal
        {:path :regal
         :args [:debug]}
        :defaults
        {:log_level :info
         :stop_on_entry true
         :stop_on_fail false
         :stop_on_result true
         :trace true
         :enable_print true
         :rule_indexing false}
        :configurations []})

(fn default-configurations [dap opts]
  (let [find-input-path (fn []
                          (let [path (.. (vim.fn.getcwd) :/input.json)]
                            (when (= (vim.fn.filereadable path) 1)
                              path)))
        query-input (fn []
                      (coroutine.create
                        (fn [co]
                          (vim.ui.input
                            {:prompt :Query
                             :default :data}
                            (fn [input]
                              (if (= input "")
                                (coroutine.resume co dap.ABORT)
                                (coroutine.resume co input)))))))]
    [{:type :rego
      :name "Debug Rego Workspace by Query"
      :request :launch
      :command :eval
      :query query-input
      :stopOnEntry opts.defaults.stop_on_entry
      :stopOnFail opts.defaults.stop_on_fail
      :stopOnResult opts.defaults.stop_on_result
      :trace opts.defaults.trace
      :enablePrint opts.defaults.enable_print
      :ruleIndexing opts.defaults.rule_indexing
      :logLevel opts.defaults.log_level
      :inputPath find-input-path
      :bundlePaths ["${workspaceFolder}"]}
     {:type :rego
      :name "Debug Rego Workspace All"
      :request :launch
      :command :eval
      :query :data
      :stopOnEntry opts.defaults.stop_on_entry
      :stopOnFail opts.defaults.stop_on_fail
      :stopOnResult opts.defaults.stop_on_result
      :trace opts.defaults.trace
      :enablePrint opts.defaults.enable_print
      :ruleIndexing opts.defaults.rule_indexing
      :logLevel opts.defaults.log_level
      :inputPath find-input-path
      :bundlePaths ["${workspaceFolder}"]}]))

(fn setup-adapter [dap opts]
  (set dap.adapters.rego
       {:name opts.adapter_name
        :type :executable
        :command opts.regal.path
        :args opts.regal.args}))

(fn setup-configurations [dap opts]
  (let [configurations (utils.concat
                         (default-configurations dap opts)
                         opts.configurations)]
    (set dap.configurations.rego configurations)))

(fn setup [opts]
  (let [opts (vim.tbl_deep_extend :force default-opts (or opts {}))
        dap (utils.load-module :dap)]
    (setup-adapter dap opts)
    (setup-configurations dap opts)))

{: setup}
