(fn debug-codelens-handler [dap opts]
  (fn [err result ctx config]
    (if (not (= (dap.session) nil))
      (values nil (vim.lsp.rpc.rpc_response_error
                    vim.lsp.protocol.ErrorCodes.InvalidRequest
                    "active debug session already exists"))
      (let [dconf (vim.tbl_deep_extend
                   :force
                   result
                   {:stopOnEntry opts.defaults.stop_on_entry
                    :stopOnFail opts.defaults.stop_on_fail
                    :stopOnResult opts.defaults.stop_on_result
                    :trace opts.defaults.trace
                    :enablePrint opts.defaults.enable_print
                    :ruleIndexing opts.defaults.rule_indexing
                    :logLevel opts.defaults.log_level
                    :bundlePaths ["${workspaceFolder}"]})]
        (dap.run dconf)
        (values {:ok true} nil)))))

(fn extmark-prints [ns outputs]
  (each [file prints (pairs outputs)]
    (let [path (vim.fn.substitute file "^file://" "" "")
          current (vim.fn.expand "%:p")]
      (when (= path current)
        (each [l [rawtxt] (pairs prints)]
          (let [txt (.. "=> " rawtxt)
                line (- l 1)]
            (vim.api.nvim_buf_set_extmark
              0 ns line 0
              {:virt_text [[txt :Comment]]
               :virt_text_pos :eol})))))))

(fn extmark-package [ns result]
  (let [line (- result.line 1)
         txt (.. "=> " (vim.fn.json_encode result.result.value))]
     (vim.api.nvim_buf_set_extmark
       0 ns line 0
       {:virt_text [[txt :Comment]]
        :virt_text_pos :eol})))

(fn extmark-rule-heads [ns result]
  (let [txt (.. "=> " (vim.fn.json_encode result.result.value))]
    (each [_ loc (ipairs result.rule_head_locations)]
      (let [line (- loc.row 1)]
        (vim.api.nvim_buf_set_extmark
          0 ns line 0
          {:virt_text [[txt :Comment]]
           :virt_text_pos :eol})))))

(fn evaluate-codelens-handler []
  (fn [err result ctx config]
    (let [ns (vim.api.nvim_create_namespace :regal.codelens.evaluate)]
      (vim.api.nvim_buf_clear_namespace 0 ns 0 -1)
      (extmark-prints ns result.result.printOutput)
      (if (= result.target :package)
          (extmark-package ns result)
          (extmark-rule-heads ns result)))
    (values {:ok true} nil)))

{: debug-codelens-handler
 : evaluate-codelens-handler}
