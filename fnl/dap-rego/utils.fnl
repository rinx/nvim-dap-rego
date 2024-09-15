(fn concat [...]
  (let [result []]
    (each [_ xs (ipairs [...])]
      (each [_ x (ipairs xs)]
        (table.insert result x)))
    result))

(comment
  (concat [] [])
  (concat [:a :b] [])
  (concat [] [:a :b])
  (concat [:a :b] [:c :d]))

(fn load-module [m]
  (let [(ok? mod) (pcall require m)]
    (assert ok? (string.format "dap-rego requires `%s`: not installed" m))
    mod))

{: concat
 : load-module}
