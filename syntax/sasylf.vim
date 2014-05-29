" Author: Claudio Corrodi <corrodi.claudio@gmail.com>
" Notes: This file is based on a syntax file for SASyLF by Rohit Kumar
" <roxtar@gmail.com> from 2011-10-16, see https://github.com/roxtar/sasylfvim/.
if exists("b:current_syntax")
		finish
endif

" Lemmas
syn region Lemma start="^\s*lemma\s*.*:" end="end lemma" transparent fold keepend contains=ALL
syn match LemmaDef contained /lemma/
hi def link LemmaDef Keyword
syn match LemmaEnd contained /end lemma/
hi def link LemmaEnd Keyword

" Theorems
syn region Theorem start="^\s*theorem\s*.*:" end="end theorem" transparent fold keepend contains=ALL
syn match TheoremDef contained /theorem/
hi def link TheoremDef Keyword
syn match TheoremEnd contained /end theorem/
hi def link TheoremEnd Keyword

" Keywords
syn keyword SASyLFKeyword terminals syntax judgment assumes induction analysis hypothesis is unproved proof solve and or rule case end
syn keyword SASyLFConditional forall exists by on

hi def link SASyLFKeyword Keyword
hi def link SASyLFConditional Conditional

" Labels
"syn match SASyLFLabel /\S\+\s*:/
"hi def link SASyLFLabel Identifier

" Rules
syn match Bar /\(\-\|─\|―\)\{3,\}.*$/
hi def link Bar Special

" Comments
syn match SASyLFComment /\/\/.*/
syn region SASyLFCommentBlock start="/\*" end="\*/" extend
hi def link SASyLFComment Comment
hi def link SASyLFCommentBlock Comment

let b:current_syntax = "sasylf"

syn sync fromstart
