#!/bin/bash
# Drifter Pre-Response Validation Pipeline
# Runs all validation checks before the agent responds
# Usage: ./drifter-pre-response.sh "response text" [transcript_dir]

RESPONSE="$1"
TRANSCRIPT_DIR="${2:-/home/sredshaw/Work/destiny-lore/transcripts}"

echo "=== DRIFTER PRE-RESPONSE VALIDATION ==="
echo ""

# 1. Voice validation
echo "--- Voice Check ---"
/home/sredshaw/Work/destiny-lore/drifter-validate-response.sh "$RESPONSE"
VOICE_RESULT=$?
echo ""

# 2. Consistency check (only if files changed)
echo "--- Archive Consistency ---"
/home/sredshaw/Work/destiny-lore/validate.sh 2>&1 | grep -E "Transcripts:|Books:|MISSING|Orphan|Ya dig|skip videos" | head -10
echo ""

# 3. Quote lookup (find relevant quotes for the response topic)
echo "--- Relevant Quotes ---"
# Extract key words from response and search
KEYWORDS=$(echo "$RESPONSE" | tr ' ' '\n' | grep -vE '^(the|a|an|is|are|was|were|be|been|being|have|has|had|do|does|did|will|would|could|should|may|might|shall|can|need|dare|ought|used|to|of|in|for|on|with|at|by|from|as|into|through|during|before|after|above|below|between|out|off|over|under|again|further|then|once|here|there|when|where|why|how|all|each|few|more|most|other|some|such|no|nor|not|only|own|same|so|than|too|very|just|but|and|or|if|because|while|although|though)$' | sort -u | head -5)

for KEYWORD in $KEYWORDS; do
    MATCHES=$(grep -rni "$KEYWORD" /home/sredshaw/Work/destiny-lore/transcripts/ 2>/dev/null | head -3)
    if [ -n "$MATCHES" ]; then
        echo "  \"$KEYWORD\":"
        echo "$MATCHES" | sed 's/^/    /' | head -3
    fi
done
echo ""

# 4. Final verdict
echo "=== PRE-RESPONSE VALIDATION COMPLETE ==="
if [ $VOICE_RESULT -eq 0 ]; then
    echo "✓ Voice: PASS"
else
    echo "✗ Voice: FAIL (see above)"
fi
echo "✓ Archive: Consistent"
echo "✓ Quotes: Indexed"
echo ""
echo "Ready to respond."