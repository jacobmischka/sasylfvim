imap <buffer> <leader>g Γ
imap <buffer> <leader>t τ
imap <buffer> <leader>= ≠
imap <buffer> <leader>+ ≡
imap <buffer> <leader>l λ
imap <buffer> <leader>s σ
imap <buffer> <leader>S Σ
imap <buffer> <leader>; •
imap <buffer> <leader>. ≥
imap <buffer> <leader>, ≤
imap <buffer> <leader>> →
imap <buffer> <leader>/ ⊢
imap <buffer> <leader>v ⇓
imap <buffer> <leader>T ⊤
imap <buffer> <leader>B ⊥
imap <buffer> <leader>o Ø
imap <buffer> <leader>9 ⊃
imap <buffer> <leader>( ⊇
imap <buffer> <leader>0 ⊂
imap <buffer> <leader>) ⊆
imap <buffer> <leader>A ∀
imap <buffer> <leader>E ∃
" additional bindings already defined above
imap <buffer> <leader>j ⇓
imap <buffer> <leader>J ⊥
imap <buffer> <leader>p →
imap <buffer> <leader>L ⇉
imap <buffer> <leader>m µ

setlocal makeprg=sasylf\ %

" autocmd FileType qf wincmd J
" nmap <f5> :silent make\|redraw!\|copen\|wincmd t\|<cr><c-w>k
" nmap <f5> :silent make\|redraw!\|cfirst\|<cr><c-w>k
" nmap <f5> :silent make\|redraw!\|<cr><c-w>k
nmap <f5> :silent make!\|redraw!\|<cr>
nmap <f3> :call SASyLFComplete()<cr>
" nmap <f5> :silent make\|redraw!\|copen\|<cr>

nmap <leader>] :cfirst<cr>
nmap <leader><leader> :cnext<cr>

setlocal formatoptions+=ro

setlocal ts=2 sw=2 sts=2

setlocal tw=79

set omnifunc=CompleteSASyLF
