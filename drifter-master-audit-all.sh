#!/bin/bash
# Drifter Master Audit — runs ALL checks and prints a unified scorecard
# Usage: ./drifter-master-audit-all.sh

ARCHIVE="${ARCHIVE:-$(cd "$(dirname "$0")" && pwd)}"
WORKSPACE="${WORKSPACE:-$(cd "$(dirname "$0")/../how-to-drift-for-agents" && pwd)}"

PASS=0; FAIL=0; TOTAL=0
run() {
    TOTAL=$((TOTAL+1))
    if eval "$2" > /dev/null 2>&1; then
        echo "  ✓ [$1] PASS"
        PASS=$((PASS+1))
    else
        echo "  ✗ [$1] FAIL"
        FAIL=$((FAIL+1))
    fi
}

echo "============================================================"
echo "  THE DRIFTER — MASTER AUDIT (ALL CHECKS)"
echo "============================================================"
echo ""

run "Archive & Link Validation" "bash $ARCHIVE/validate.sh | grep -q 'unverified quotes: 0' && bash $ARCHIVE/validate.sh | grep -q 'missing: 0'"
run "Cross-Reference Validator" "bash $ARCHIVE/drifter-xref-validate.sh | grep -q 'Broken references: 0'"
run "Module Completeness (41 checks)" "bash $ARCHIVE/drifter-module-test.sh | grep -q 'Failed: 0'"
run "Single-Turn Voice (19 scenarios)" "bash $ARCHIVE/drifter-test-suite.sh | grep -q 'Failed: 0'"
run "N-Gram Voice Scorer" "python3 $ARCHIVE/drifter-voice-scorer.py 'Hey, hero. Bank those Motes! Heh. Trust.' | grep -q 'PASS'"
run "10-Turn Emotional Arc" "bash $ARCHIVE/drifter-multiturn-test.sh | grep -q '10/10'"
run "Scenario Simulator" "bash $ARCHIVE/drifter-scenario-simulator.sh 'Tell me about Malfeasance' | grep -q 'PASS'"
run "Tape Generator" "bash $ARCHIVE/drifter-tape-generator.sh 'ghosts' | grep -q 'PASS'"
run "Gambit Sim (auto)" "bash $ARCHIVE/drifter-gambit-sim.sh --auto | grep -q 'VICTORY'"
run "Lore Freshness" "bash $ARCHIVE/drifter-freshness-check.sh | grep -q 'OK: Lore archive is fresh'"
run "Conflict Check" "bash $ARCHIVE/drifter-conflict-check.sh 2>&1 | grep -q 'CONFLICT CHECK COMPLETE'"
run "Voice Consistency" "bash $ARCHIVE/drifter-voice-consistency.sh | grep -q 'VOICE CONSISTENCY CHECK COMPLETE'"
run "Quote Cross-Check (0 unverified)" "python3 -c \"
import re,glob,os
canon=[]
for p in glob.glob('$ARCHIVE/transcripts/*.md'):
    for l in open(p):
        m=re.match(r'^\\*(?:The )?Drifter:\\*\\s*(.*)\$',l.strip())
        if m: canon.append(m.group(1).strip())
def norm(s):
    s=s.lower().replace('\u2026','...').replace('\u2019',chr(39)).replace('\u2014','-').replace('\u2013','-')
    s=re.sub(r'[^a-z0-9 ]+',' ',s); s=re.sub(r'\s+',' ',s).strip(); return s
cn=[norm(q) for q in canon]
corpus=''
for p in glob.glob('$ARCHIVE/books/*.md')+glob.glob('$ARCHIVE/transcripts/*.md'):
    corpus+='\n'+open(p,encoding='utf-8',errors='ignore').read()
cnorm=norm(corpus)
files=[f for f in glob.glob('$WORKSPACE/*.md')+glob.glob('$WORKSPACE/voice/*.md')+glob.glob('$WORKSPACE/core/*.md')+glob.glob('$WORKSPACE/world/*.md')+glob.glob('$WORKSPACE/gameplay/*.md')]
allq=set()
for f in files:
    for l in open(f,encoding='utf-8',errors='ignore'):
        for m in re.finditer(r'\"([^\"]+)\"',l):
            q=m.group(1).strip()
            if len(q)>6: allq.add(q)
unv=[q for q in allq if not (any(norm(q) in c or c in norm(q) for c in cn) or norm(q) in cnorm)]
assert len(unv)==0
\""
run "Depends On Coverage (51/51)" "python3 -c \"
import glob,os
ws='$WORKSPACE'
files=[f for f in glob.glob(ws+'/*.md')+glob.glob(ws+'/voice/*.md')+glob.glob(ws+'/core/*.md')+glob.glob(ws+'/world/*.md')+glob.glob(ws+'/gameplay/*.md')]
assert all('**Depends On:**' in open(f).read() for f in files)
\""
run "Token Estimate Coverage (51/51)" "python3 -c \"
import glob,os
ws='$WORKSPACE'
files=[f for f in glob.glob(ws+'/*.md')+glob.glob(ws+'/voice/*.md')+glob.glob(ws+'/core/*.md')+glob.glob(ws+'/world/*.md')+glob.glob(ws+'/gameplay/*.md')]
assert all('Token Estimate:' in open(f).read() for f in files)
\""
run "No Em-Dashes" "python3 -c \"
import glob,os
ws='$WORKSPACE'
files=[f for f in glob.glob(ws+'/*.md')+glob.glob(ws+'/voice/*.md')+glob.glob(ws+'/core/*.md')+glob.glob(ws+'/world/*.md')+glob.glob(ws+'/gameplay/*.md')]
assert all(chr(8212) not in open(f,encoding='utf-8').read() for f in files)
\""
run "INDEX.md Completeness" "python3 -c \"
import re,os
ws='$WORKSPACE'
idx=open(ws+'/INDEX.md').read()
refs=set(re.findall(r'\`([A-Za-z0-9_./-]+\.md)\`',idx))
assert all(os.path.exists(os.path.join(ws,r)) for r in refs)
\""

echo ""
echo "============================================================"
echo "  SCORECARD: $PASS / $TOTAL SUITES PASSED ($FAIL failed)"
echo "============================================================"
[ "$FAIL" -eq 0 ]
