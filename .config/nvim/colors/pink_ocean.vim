hi clear
 set background=dark
if exists("syntax_on")
    syntax reset
endif

function! s:h(group, fg, bg, attr)
  exec "hi " . a:group . " guifg=" . a:fg . " guibg=" . a:bg
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  else
    exec "hi " . a:group . " gui=NONE cterm=NONE"
  endif
endfun

" let g:colors_name="auscyber_theme"
let g:colors_name="pink_ocean"

let s:bg = "#1F1F1F"

hi Search guibg=#ffd1dc
hi BufferLineTabSelected guifg=#ffd1dc
hi Constant ctermfg=217 guifg=#ffa0a0
"if exists("g:neovide_refresh_rate")
    hi Normal guibg=#1f1f1f
"endif
hi Normal  ctermfg=251 ctermbg=235 guifg=#eeeeee 
hi Folded  guifg=#A04668 guibg=#282828
hi CursorLineNr ctermfg=224 guifg=#ffd1dc
hi LineNr guifg=#ffd1dc ctermfg=224
hi Statement guifg=#8BB2C1 ctermfg=109
hi Identifier guifg=#738290 ctermfg=246
hi Title guifg=#738290 ctermfg=246
hi Comment guifg=#707078 ctermfg=60
hi Type guifg=#A04668 ctermfg=131
hi PreProc guifg=#DB5461 ctermfg=167
hi Special guifg=#ffd1dc ctermfg=224
hi Error guibg=#DB5461 ctermfg=167
hi Pmenu guifg=#121212 guibg=#FFFFFF ctermfg=16 ctermbg=231
hi NonText guifg=#8BB2C1 ctermfg=16
