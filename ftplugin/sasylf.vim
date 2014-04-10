" author: Claudio Corrodi <corrodi.claudio@gmail.com>
" notes: This file contains keybindings for some characters often used in
" SASyLF proofs (and in particular, in the course on Type Systems by Prof.
" Boyland).
" notes: This file contains a few keybindings to use this plugin. In
" particular, f5 allows running SASyLF (the quickfix buffer can then show the
" errors / output, and one can cycle through the errors), and f3 for adding
" missing cases on the current line (e.g. if the cursor is on a "case analysis
" by d:" line with missing cases, only the cases for this case analysis are
" inserted).

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

setlocal formatoptions+=ro
setlocal makeprg=sasylf\ %
setlocal omnifunc=CompleteSASyLF
