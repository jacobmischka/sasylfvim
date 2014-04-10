" author: Claudio Corrodi <corrodi.claudio@gmail.com>
" notes: This is a sample file I have in my ~/.vim/ftplugin/ folder under
" sasylf.vim (which is separate from ftplugin/sasylf.vim, since I am using
" pathogen to load the plugin itself). It contains a few keybindings and
" settings, in particular, it allows met to do the completion with a single
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

" The following lines are in my ~/.ctags file in order to generate tags for
" rules, lemmas, and theorems.
"
" --langdef=sasylf
" --langmap=sasylf:.slf
" --regex-sasylf=/^(theorem)\s+(.+)\s*:.*/\2 \3/t,definition/
" --regex-sasylf=/^(lemma)\s+(.+)\s*:\s*$/\2/l,definition/
" --regex-sasylf=/^-+\s+(.*)$/\1/r,definition/
