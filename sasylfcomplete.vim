function! SASyLFComplete()

let fixno=line(".")
let theline=getline(".")

python << EOF
import vim
import subprocess
import re

fixno = int(vim.eval("fixno"))
current_line = vim.eval("getline(\".\")")
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
            if self.is_rule and not line.startswith("-") and not line == "":
                line = "_: " + line
            line = "\t" + line
            s += line + "\n"

        s += "is\n"
        s += "\tproof by unproved\n"
        s += "end case\n"

        return s.split("\n")

def parse(text):
    #print("Parsing text.\n")
    lines = text.split("\n")

    line_pattern = re.compile("^.*:(\d+):.*$")
    desc_clause_pattern = re.compile("^DESCCLAUSE (.*)$")
    desc_rule_pattern = re.compile("^DESCRULE (.*)$")
    case_start_pattern = re.compile("CASESTART")
    case_rule_start_pattern = re.compile("CASESTART")
    case_end_pattern = re.compile("CASEEND")

    lineno = 0
    incase = False
    incase_rule = False
    is_rule = False
    current_case = ""
    cases = []
    missing_cases = []

    for line in lines:
        match = re.match(case_end_pattern, line)
        if match:
            incase = False
            #current_case += "\nis\n"
            #current_case += "proof by unproved\n"
            #current_case += "end case\n"
            missing_cases.append(MissingCase(current_case, lineno, is_rule))
            current_case = ""
            continue

        if incase:
            if line.startswith("-"):
                is_rule = True

            #if not line.startswith("-") and not line == "":
            #    line = ": " + line

            current_case += "\n" + line
            cases[-1] += "\n" + line
            continue

        match = re.match(case_start_pattern, line)
        if match:
            incase = True
            is_rule = False
            cases.append("")
            continue

        match = re.match(line_pattern, line)
        if match:
            lineno = match.group(1)
            continue

        match = re.match(desc_rule_pattern, line)
        if match:
            desc = match.group(1)
            continue

        match = re.match(desc_clause_pattern, line)
        if match:
            desc = match.group(1)
            continue

    return missing_cases


filename = "sample.slf"
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
