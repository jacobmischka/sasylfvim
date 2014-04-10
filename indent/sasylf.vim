" author: Claudio Corrodi <corrodi.claudio@gmail.com>
" notes: adapted from indent/ocaml.vim found in the vim source distribution

if exists("b:did_indent")
 finish
endif
let b:did_indent = 1

setlocal indentexpr=GetSASyLFIndent()
setlocal indentkeys=o,=end,=end.,=end\ ,=is,=is.,=is\ 
setlocal comments=sr:/*,mbf:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-

function! GetSASyLFIndent()
	" At the start of the file use zero indent.
	if lnum == 0
		return 0
	endif

	let lnum = line('.')
	let line = getline(lnum)
	let prev_lnum = prevnonblank(lnum)
	let prev_line = getline(prev_lnum)
	let prev_ind = indent(prev_lnum)

	" Work with indent from previous line.
	let ind = prev_ind

	" Indent by one sw after colon.
	if prev_line =~ ':\s*$'
		let ind = ind + &sw
		return ind
	end

	" Indent one sw after syntax definition (t ::= ...).
	if prev_line =~ '^.*::=.*$'
		let ind = ind + &sw
		return ind
	end

	" Unindent if line with "end" or "is" is written.
	if line =~ 'end$\|is$'
		let ind = ind - &sw
		return ind
	end

	if line =~ 'end.$\|is.$'
		let ind = ind + &sw
		return ind
	end

	" Indent if prev line is "is".
	if prev_line =~ '\<is\>'
		let ind = ind + &sw
		return ind
	end

	return ind
endfunction
