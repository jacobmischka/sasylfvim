" author: Claudio Corrodi <corrodi.claudio@gmail.com>
" notes: adapted from indent/ocaml.vim found in the vim source distribution

"if exists("b:did_indent")
" finish
"endif
"let b:did_indent = 1

setlocal indentexpr=GetSASyLFIndent()
setlocal indentkeys=o,=end,=end.,=end\ ,=lemma,=analysis,=analysis\ ,=induction,=induction\ ,=is,=is.,=is\ ,=rule,=rule.,=rule\ ,=theorem,=theorem.,=theorem\ ,=case,=case.,=case\ ,<:>
setlocal comments=sr:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-

function! GetSASyLFIndent()
	" At the start of the file use zero indent.
	if lnum == 0
		return 0
	endif

	let lnum = line('.')
	let line = getline(lnum)
	let prev_lnum = prevnonblank(lnum-1)
	let prev_line = getline(prev_lnum)
	let prev_ind = indent(prev_lnum)

	" Work with indent from previous line.
	let ind = prev_ind

	" First do all the cases where we need to indent further.
	if prev_line =~ '^\s*/\*'
		let ind = ind + 1
	elseif line =~ '^\s*\*'
		let ind = prev_ind
	elseif prev_line =~ '^\s*\/\/'
		let ind = prev_ind
	elseif prev_line =~ ':\s*$'
		let ind = ind + &sw
	elseif prev_line =~ '^\s*case rule\s*$'
		let ind = ind + &sw
	elseif prev_line =~ '\<is\s*$'
		let ind = ind + &sw
	end

	" Now do all the cases where we need to un-indent.
	if line =~ '^\s*\(lemma\|theorem\)\s\+.*:\s*$'
		let ind = 0
	elseif line =~ 'end\( \(lemma\|case analysis\|induction\|theorem\|case\)\)\?$'
		let ind = ind - &sw
	elseif line =~ '^\s*is\s*$'
		let ind = ind - &sw
	elseif prev_line =~ '\*/\s*'
		let ind = ind - 1
	end
	
	return ind
endfunction
