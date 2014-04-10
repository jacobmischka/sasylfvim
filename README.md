SASyLF vim Plugin
=================

## Introduction
This repository contains various vim files that make up a plugin for the SASyLF
language [1]. Features include inserting missing cases, omnicompleting rule,
theorem, and lemma names (with preview of the rule or lemma / theorem
statement), indenting, and syntax highlighting.

## Requirements
The plugin has been tested using vim 7.4.179. Since the completion functions
are implemented in python, vim must have the "+python" option (which can be
checked using `:version`, or `:echo has('python')`).

In addition, the SASyLF executable must be callable using `!sasylf` in vim.

## Installation
Simply copy the contents of this repository (excluding README.md) to your vim
configuration directory (usually ~/.vim/), though I using a plugin like
pathogen [2] which makes it easier to handle multiple plugins.

The plugin loads if a buffer's filetype is set to "sasylf". By default, vim
does not set this when opening a \*.slf file. One can achieve this by putting
the line

```vim
au BufNewFile,BufRead *.slf set filetype=sasylf
```

into the main vimrc file.

## Usage
The plugin offers various features, described below.

### Syntax Highlighting
Syntax highlighting can be enabled by using ```:syntax on``` and ```:set
filetype=sasylf``` (the latter can be done automatically using the autocommand
from above).

### Inserting Missing Rules
The file after/ftplugin/sasylf.vim defines a function SASyLFComplete(), which
inserts missing rules into a file. The function inserts only the missing rules
that were reported for the line number matching the current line number. For
example, consider the sasylf output of `sasylf --LF <a_file>`:

```
sample.slf:51: must provide a case for 
rule gt-one
rule gt-more
--------------- gt-one
(s n1) > n1

n3 > n1
--------------- gt-more
(s n3) > n1


sample.slf: 1 error reported.
```

Then, calling `:call SASyLFComplete()` while the cursor is on line 51 results
in inserting the cases

```
--------------- gt-one
_: (s n1) > n1

_: n3 > n1
--------------- gt-more
_: (s n3) > n1
```

Obviously, calling `:call SASyLFComplete()` every time is tedious, so binding
it to a key or key combination is probably a good idea. I am using the
following line in `~/.vim/ftplugin/sasylf.vim`:

```vim
nmap <f3> :call SASyLFComplete()<cr>
```

### Omnicompletion of Theorem / Rule / Lemma Names
The file after/ftplugin/sasylf.vim also defines a omnicomplete function
SASyLFComplete. Currently, it allows completing rule, lemma, and theorem names.
By using CTRL-X CTRL-O (see `:he omnifunc`), names are suggested based on the
previous word and the current word. For example, if we are inserting at the end
of the line

```vim
proof by rule gt-
```

then the function first realizes that only rules should be considered for
completion (as opposed to theorems and lemmas), and then proposes all rules
that start with `gt-`.

In addition to proposing the names, the function also provides the rule, lemma,
or theorem statement itself in the preview buffer. In order for the preview
buffer to appear, one needs to set the corresponding completeopt value with
`:set completeopt+=preview`.

## References
- [1] http://www.cs.cmu.edu/~aldrich/SASyLF/
- [2] http://www.vim.org/scripts/script.php?script_id=2332
