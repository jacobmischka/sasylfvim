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
    desc_clause_pattern = re.compile("^DESCCLAUSE (.*)$")
    desc_rule_pattern = re.compile("^rule (.*)$")
    #case_start_pattern = re.compile("CASESTART")
    case_end_pattern = re.compile("^$")

    missing_cases = []
    current_loc = -1
    current_case = []
    is_rule = False

    for line in lines:
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
