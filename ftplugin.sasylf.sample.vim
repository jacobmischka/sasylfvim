" author: Claudio Corrodi <corrodi.claudio@gmail.com>
" notes: This is a sample file I have in my ~/.vim/ftplugin/ folder under
" sasylf.vim (which is separate from ftplugin/sasylf.vim, since I am using
" pathogen to load the plugin itself). It contains a few keybindings and
" settings, in particular, it allows me to do the completion with a single
" keypress, as well as generating exuberant ctags in order to display them in
" tagbar (or a similar plugin).

" map missing case completion
nmap <f3> :call SASyLFComplete()<cr>
" map f4 to generating ctags
nmap <f4> :silent !ctags\|redraw!\|<cr>
" map f5 to running sasylf (this generates quickfix messages)
nmap <f5> :silent make!\|redraw!\|<cr>

" These two mappings allow jumping to the first/next line where an error or
" warning (which are in the quickfix list) occurs.
nmap <leader>] :cfirst<cr>
nmap <leader><leader> :cnext<cr>

" This is for the tagbar plugin and tells it which tags to display.
let g:tagbar_type_sasylf = {'ctagstype' : 'sasylf', 'kinds' : [
			\'r:rules',
			\'l:lemmas',
			\'t:theorems'
			\], 'sort' : 0 }

" See 'formatoptions' for details.
setlocal formatoptions+=ro

" Set make program to sasylf (one can later use :make to run this).
setlocal makeprg=sasylf\ %

" Omni completion (CTRL-X CTRL-O) should use the function defined in the
" plugin.
setlocal omnifunc=CompleteSASyLF

" Sample keybindings for some special characters often seen in proofs.
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

" The following lines are in my ~/.ctags file in order to generate tags for
" rules, lemmas, and theorems.
"
" --langdef=sasylf
" --langmap=sasylf:.slf
" --regex-sasylf=/^(theorem)\s+(.+)\s*:.*/\2 \3/t,definition/
" --regex-sasylf=/^(lemma)\s+(.+)\s*:\s*$/\2/l,definition/
" --regex-sasylf=/^-+\s+(.*)$/\1/r,definition/
