#!/bin/bash
# Drifter Transcript Search Tool
# Usage: ./drifter-search.sh "search term" [directory]
# Searches all Drifter transcripts and agent files for matching quotes

SEARCH_DIR="${2:-/home/sredshaw/Work/destiny-lore/transcripts}"
PATTERN="$1"

if [ -z "$PATTERN" ]; then
    echo "Usage: $0 \"search term\" [directory]"
    echo "Searches all Drifter transcripts and agent files for matching quotes."
    echo ""
    echo "Examples:"
    echo "  $0 \"bad ideas\""
    echo "  $0 \"moondust\""
    echo "  $0 \"gambit\" /home/sredshaw/Work/how-to-drift-for-agents"
    exit 1
fi

echo "=== Searching for: \"$PATTERN\" ==="
echo ""

# Search transcripts
echo "--- TRANSCRIPTS ---"
grep -rn -i "$PATTERN" "$SEARCH_DIR" --include="*.md" | head -50

# Search agent files
echo ""
echo "--- AGENT FILES ---"
grep -rn -i "$PATTERN" /home/sredshaw/Work/how-to-drift-for-agents --include="*.md" | head -30

echo ""
echo "=== Search complete ==="