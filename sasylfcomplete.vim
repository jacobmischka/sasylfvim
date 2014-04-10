function! SASyLFComplete()

let fixno=line(".")
let theline=getline(".")

python << EOF
import vim
import subprocess
import re

fixno = int(vim.eval("fixno"))
current_line = vim.eval("getline(\".\")")
filename = vim.eval("bufname(\"%\")")
#print "current line: " + current_line
#print "fixno " + str(fixno) + "\n"

class MissingCase(object):
    def __init__(self, case, lineno, is_rule):
        self.case = case
        self.lineno = lineno
        self.is_rule = is_rule

    def __repr__(self):
        s = "Line: " + self.lineno + "\n"
        s += "Case:" + self.case + "\n"
        return s

    def to_insert(self):
        s = ""
        if self.is_rule:
            s += "case rule\n"
        else:
            s += "case "

        for line in self.case.split("\n"):
            if line == "":
                continue

            if self.is_rule and not line.startswith("-") and not line == "":
                line = "_: " + line
            if self.is_rule:
                line = "\t" + line

            #s += line + "\n"
            if self.is_rule:
                s += line + "\n"
            else:
                s += line + " "

        s += "is\n"
        s += "\tproof by unproved\n"
        s += "end case\n"

        return s.split("\n")

def parse(text):
    #print("Parsing text.\n")
    lines = text.split("\n")

    line_pattern = re.compile("^.*:(\d+):.*$")
    final_pattern = re.compile("^.*warnings reported.$")
    desc_clause_pattern = re.compile("^DESCCLAUSE (.*)$")
    desc_rule_pattern = re.compile("^rule (.*)$")
    #case_start_pattern = re.compile("CASESTART")
    case_end_pattern = re.compile("^$")

    missing_cases = []
    current_loc = -1
    current_case = []
    is_rule = False

    for line in lines:
        match = re.match(final_pattern, line)
        if match:
            continue

        match = re.match(line_pattern, line)
        if match:
            current_loc = match.group(1)
            is_rule = False
            current_case = []
            continue

        match = re.match(desc_rule_pattern, line)
        if match:
            is_rule = True
            continue

        match = re.match(case_end_pattern, line)
        if match:
            if is_rule and current_case != []:
                missing_cases.append(MissingCase("\n".join(current_case), current_loc, is_rule))
            elif len(current_case) > 1:
                #current_case = [i for i in current_case if i == ""]
                l = len(current_case)
                for c in current_case[l/2:]:
                    missing_cases.append(MissingCase(c, current_loc, is_rule))

            current_case = []
            continue

        # else
        current_case.append(line)

    return missing_cases

#filename = "sample.slf"
process = subprocess.Popen(["sasylf", "--LF", filename],
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE)
out, err = process.communicate()
cases = parse(err)
cases.reverse()

def indent(data, ind):
    return [ind + "\t" + i for i in data]

def getindent():
    #print "finding indent for line:\n\"" + current_line + "\""
    match = re.match(re.compile("^([\s]*)"), current_line)
    if match:
        return match.group(1)
    else:
        return ""

for case in cases:
    if int(case.lineno) == fixno:
        lineno = int(case.lineno)
        data = case.to_insert() #case.case.split("\n")
        data = indent(data, getindent())
        vim.current.buffer[lineno:lineno] = data

EOF

endfunction

function! CompleteSASyLF(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    " find months matching with "a:base"
    let res = []
    for m in split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec")
      if m =~ '^' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfunction

function! CompleteSASyLF(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\a'
            let start -= 1
        endwhile
        return start
    else
python << EOF
import vim
import re

class Tag(object):
    def __init__(self, value, filename, raw="", kind="", info=""):
        self.value = value
        self.filename = filename
        self.raw = raw
        self.kind = kind
        self.info = self.pretty(info)

    def pretty(self, text):
        text = text.replace("forall", "∀")
        text = text.replace("exists", "∃")
        return text

    def out(self):
        return self.value

    def to_append(self):
        d = {
            "word": self.value,
            #"info": "some info text",
            #"menu": "more menu text"
            }
        if self.info:
            d["info"] = self.info
        return d

#f = open("tags")
#lines = f.readlines()
#taglist = []
#tags = {"t": [], "l": [], "r": []}
#for i in lines:
#    if not i.startswith("!"):
#        v, f, r, k = i.split("\t")
#        k = k[0]
#        tag = Tag(v, f, r, k)
#        taglist.append(tag)
#        tags[k].append(tag)

f = open("sample.slf")
lines = f.readlines()

thm_pattern = re.compile("^theorem\s+(.+)\s*:.*$")
lemma_pattern = re.compile("^lemma\s+(.+)\s*:.*$")
rule_pattern = re.compile("^-+\s+([^\s]+).*$")
info_end_pattern = re.compile("^.*\.\s+$")
empty_pattern = re.compile("^\s*$")

last_value = ""
last_fn = ""
last_raw = ""
last_kind = ""
last_info = ""
first = True
in_info = False

tags = {"t": [], "l": [], "r": []}

idx = 0
for line in lines:
    match = re.match(thm_pattern, line)
    if not match:
        match = re.match(lemma_pattern, line)
    if match:
        if not first:
            tag = Tag(last_value,
                      last_fn,
                      last_raw,
                      last_kind,
                      last_info)
            if tags.has_key(last_kind):
                tags[last_kind].append(tag)
        else:
            first = False

        last_value = match.group(1)
        last_fn = "sample.slf"
        last_raw = ""
        last_kind = "t"
        last_info = ""
        in_info = True
        in_info_first = True

    match = re.match(rule_pattern, line)
    if match:
        first = True
        before = []
        i = idx - 1
        while idx >= 0:
            if not re.match(empty_pattern, lines[i]):
                before.append(lines[i][:-1])
            else:
                break
            i -= 1
        before.reverse()

        after = []
        i = idx + 1
        while idx < len(lines):
            if not re.match(empty_pattern, lines[i]):
                after.append(lines[i][:-1])
            else:
                break
            i += 1

        contextlist = before + [lines[idx][:-1],] + after
        context = "\n".join(contextlist)
        value = match.group(1)
        tag = Tag(value,
                  last_fn,
                  "",
                  "r",
                  context)
        if tags.has_key("r"):
            tags["r"].append(tag)

    if in_info:
        if in_info_first:
            in_info_first = False
        else:
            last_info += re.sub("^\s+", "", line)
        match = re.match(info_end_pattern, line)
        if match:
            in_info = False

    idx += 1

current_column = int(vim.eval("col(\".\")"))
current_line = vim.eval("getline(\".\")")
head = current_line[:current_column]
tail = current_line[current_column:]

res = []

kind = ""
start = vim.eval("a:base")
match = re.match(re.compile(".*\s+$"), head)
if match:
    match = re.match(re.compile(".*(\W|^)(\w+)\s+$"), head)
    if match:
        kind = match.group(2)[0]

if tags.has_key(kind):
    for tag in tags[kind]:
        if tag.value.startswith(start):
            res.append(tag.to_append())

vim.command("let res = []")
for i in res:
    vim.command(("let tmp = {}"))
    for k, v in i.items():
        vim.command("let tmp.%s = \"%s\"" % (k, v))
    vim.command("call add(res, tmp)")
EOF
        return res
    endif
endfunction
