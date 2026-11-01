#!/bin/bash
# Lore Archive Integrity Check
# Verifies the archive structure: books, transcripts, indexes.
# Usage: ./tests/lore-integrity.sh

ARCHIVE="${ARCHIVE:-$(cd "$(dirname "$0")/.." && pwd)}"

echo "=== LORE ARCHIVE INTEGRITY CHECK ==="
echo ""

PASS=0; FAIL=0

check() {
    if eval "$1" >/dev/null 2>&1; then
        echo "  ✓ $2"; PASS=$((PASS+1))
    else
        echo "  ✗ $2"; FAIL=$((FAIL+1))
    fi
}

# Directory structure
check "[ -d $ARCHIVE/books ]" "books/ directory exists"
check "[ -d $ARCHIVE/transcripts ]" "transcripts/ directory exists"
check "[ -f $ARCHIVE/index.md ]" "index.md exists"
check "[ -f $ARCHIVE/transcripts/index.md ]" "transcripts/index.md exists"

# File counts
BOOKS=$(ls "$ARCHIVE/books"/*.md 2>/dev/null | wc -l)
TRANSCRIPTS=$(ls "$ARCHIVE/transcripts"/*.md 2>/dev/null | grep -v 'index.md' | wc -l)
check "[ $BOOKS -ge 100 ]" "Books: $BOOKS (expected 109+)"
check "[ $TRANSCRIPTS -ge 60 ]" "Transcripts: $TRANSCRIPTS (expected 68+)"

# No empty files
EMPTY=$(find "$ARCHIVE/books" "$ARCHIVE/transcripts" -name '*.md' -empty 2>/dev/null | wc -l)
check "[ $EMPTY -eq 0 ]" "No empty files (found: $EMPTY)"

# Verify index.md has book entries
python3 - "$ARCHIVE" << 'PY'
import os, re, sys
archive = sys.argv[1]
idx = open(os.path.join(archive, 'index.md')).read()
entries = [l for l in idx.split('\n') if '|' in l and ('done' in l or 'partial' in l or 'pending' in l)]
print("  ✓ index.md has %d book entries" % len(entries))
if len(entries) < 100:
    sys.exit(1)
PY
if [ $? -eq 0 ]; then PASS=$((PASS+1)); else FAIL=$((FAIL+1)); fi

echo ""
echo "Books: $BOOKS | Transcripts: $TRANSCRIPTS | Empty: $EMPTY"
echo "Passed: $PASS | Failed: $FAIL"
[ "$FAIL" -eq 0 ]
