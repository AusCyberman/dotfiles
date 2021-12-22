(module plugins.cmp
  {require {luasnip luasnip
            cmp_nvim_lsp cmp_nvim_lsp
            _ cmp_buffer
            _ cmp_luasnip
            lspkind lspkind
            cmp cmp
            a aniseed.core
            nvim aniseed.nvim
            cmp_autopairs nvim-autopairs.completion.cmp}
   require-macros [macros zest.macros]})
(set _G.sources [{:name :copilot}
                 {:name :luasnip}
                 {:name :buffer}
                 {:name :path}
                 {:name :nvim_lua}])
(fn has_words_before []
  (let [(line col) (unpack (vim.api.nvim_win_get_cursor 0))]
    (and (~= col 0) (= (: (: (. (vim.api.nvim_buf_get_lines 0 (- line 1) line true) 1) :sub col col) :match "%s") nil))))

(cmp.setup {
              :snippet {
                        :expand (fn [args] (luasnip.lsp_expand args.body))}
              :mapping {
                        :<C-d> (cmp.mapping (cmp.mapping.scroll_docs -4) [ :i :c])
                        :<C-f> (cmp.mapping (cmp.mapping.scroll_docs 4) [ :i :c])
                        :<C-Space> (cmp.mapping (cmp.mapping.complete) [ :i :c])
                        :<C-e> (cmp.mapping {
                                                :i (cmp.mapping.abort)
                                                :c  (cmp.mapping.close)})
                        :<Up> (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Select})
                        :<Down> (cmp.mapping.select_next_item {:behavior cmp.SelectBehavior.Select})
                        :<Tab> (cmp.mapping
                                 (fn [fallback]
                                    (if (cmp.visible)
                                     (cmp.select_next_item)
                                     (if (luasnip.expand_or_jumpable)
                                       (luasnip.expand_or_jump)
                                       (if (has_words_before)
                                         (cmp.complete)
                                         (fallback))))))
                        :<S-Tab> (cmp.mapping
                                   (fn [fallback]
                                     (if (cmp.visible)
                                       (cmp.select_prev_item)
                                       (if (luasnip.jumpable -1)
                                         (luasnip.jump -1)
                                         (fallback)))) [:i :s])
                        :<CR> (cmp.mapping.confirm {:behavior  cmp.ConfirmBehavior.Replace :select true})}
              :experimental {
                             :native_menu false
                             :ghost_text true}
              :sources (cmp.config.sources sources)
              :formatting {:format
                           (lspkind.cmp_format {
                                                :with_text true
                                                :menu
                                                  {:buffer "[buf]"
                                                   :nvim_lsp "[lsp]"
                                                   :nvim_lua "[api]"
                                                   :luasnip "[snip]"
                                                   :copilot "[copilot]"}})}})
;(vim.api.nvim_exec "imap <silent><script><expr> <C-J> copilot#Accept(\"\\<CR>\")
(vim.api.nvim_exec "let g:copilot_no_tab_map = v:true"  false)

(def-keymap :<C-Tab> [i] "<expr> copilot#Accept(\"\\<CR>\")<CR>")
(cmp.setup.cmdline
  :/ {
      :sources [
                {:name :buffer :keyword_length 5}]})
(cmp.event:on :confirm_done (cmp_autopairs.on_confirm_done {:map_char {:tex ""}}))
(vim.api.nvim_set_keymap "i" "<C-E>" "<Plug>luasnip-next-choice" {})
(vim.api.nvim_set_keymap "s" "<C-E>" "<Plug>luasnip-next-choice" {})
(def-autocmd-fn [:BufRead :BufNewFile] ["Cargo.toml"] (do
                                                        (nvim.buf_set_keymap 0 :n :K ":lua require('crates').show_popup()<CR>" {:silent true :noremap true})
                                      (cmp.setup.buffer {:sources [{:name :crates}]})))
(def-autocmd-fn [:FileType] [:norg] (cmp.setup.buffer {:sources [{:name :neorg}]}))
(def-autocmd-fn [:FileType] [:lua] (cmp.setup.buffer {:sources [{:name :nvim_lua}]}))
