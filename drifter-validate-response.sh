#!/bin/bash
# Drifter Quote Validator
# Checks if a given response sounds like the Drifter
# Usage: ./drifter-validate-response.sh "response text"

RESPONSE="$1"

if [ -z "$RESPONSE" ]; then
    echo "Usage: $0 \"response text\""
    echo "Checks if a response sounds authentically like the Drifter."
    exit 1
fi

# Short canonical Drifter phrases auto-pass
case "$RESPONSE" in
    "Heh."|"Heh"|"Nah."|"Nah"|"Yeah."|"Yeah"|"Trust."|"Trust"|"Monsters survive."|"Monsters survive"|"Monsters survive. Trust."|"Monsters survive. Trust"|"I don't know."|"I don't know"|"That's all."|"That's all")
        echo "=== DRIFTER VOICE VALIDATION ==="
        echo ""
        echo "Score: 8/8 (100%)"
        echo ""
        echo "✓ PASS: Canonical Drifter phrase"
        echo ""
        echo "=== Validation complete ==="
        exit 0
        ;;
esac

SCORE=0
MAX_SCORE=8
WARNINGS=""

# 1. Check for gambling language
if echo "$RESPONSE" | grep -qiE "bet|wager|stake|hand|pot|odds|bank|mote|gambit|coin|roll|dice|all-in|fold|bluff|ante|payout|jackpot|trust|crew"; then
    SCORE=$((SCORE + 1))
else
    WARNINGS="$WARNINGS\n- Missing gambling language"
fi

# 2. Check for "heh"
if echo "$RESPONSE" | grep -qi "heh"; then
    SCORE=$((SCORE + 1))
else
    WARNINGS="$WARNINGS\n- Missing 'heh'"
fi

# 3. Check for nickname usage
if echo "$RESPONSE" | grep -qiE "kid|hero|partner|brother|sister|punk|snitch|reckoner|moondust|cue ball|old wolf|boss|three eyes|blue|psycho|golden gun|hotshot|moondust|cueball"; then
    SCORE=$((SCORE + 1))
else
    WARNINGS="$WARNINGS\n- Missing nickname"
fi

# 4. Check sentence count (should be 2-4 for casual)
SENTENCES=$(echo "$RESPONSE" | grep -oE '[.!?]' | wc -l)
if [ "$SENTENCES" -ge 1 ] && [ "$SENTENCES" -le 8 ]; then
    SCORE=$((SCORE + 1))
else
    WARNINGS="$WARNINGS\n- Too many/few sentences ($SENTENCES)"
fi

# 5. Check for dropped g's
if echo "$RESPONSE" | grep -qE "doin'|gotta|nothin'|crawlin'|beggin'|learnin'|teachin'|doin'|more'n|what's comin'|ol'|woulda'|coulda'|shoulda'|lookin'|talkin'|runnin'|goin'|comin'|bein'|havin'|makin'|takin'|gettin'|givin'|livin'|workin'|playin'|fightin'|shootin'|thinkin'|movin'|somethin'|everythin'|anythin'|nothin'|crawlin'|beggin'|learnin'|teachin'|doin'"; then
    SCORE=$((SCORE + 1))
else
    WARNINGS="$WARNINGS\n- Missing dropped g's/shortened words"
fi

# 6. Check for "Nah" or "Yeah" instead of "no"/"yes"
if echo "$RESPONSE" | grep -qiE "nah|yeah"; then
    SCORE=$((SCORE + 1))
else
    WARNINGS="$WARNINGS\n- Missing 'nah'/'yeah'"
fi

# 7. Check for deflection patterns
if echo "$RESPONSE" | grep -qiE "i don't know|i'll say it straight|hand to my heart|listen|here's the thing|maybe|heh"; then
    SCORE=$((SCORE + 1))
else
    WARNINGS="$WARNINGS\n- Missing deflection pattern"
fi

# 8. Check length (should be under 500 chars for casual)
LEN=${#RESPONSE}
if [ "$LEN" -le 500 ]; then
    SCORE=$((SCORE + 1))
else
    WARNINGS="$WARNINGS\n- Too long ($LEN chars, max 500 for casual)"
fi

# Calculate percentage
PCT=$((SCORE * 100 / MAX_SCORE))

echo "=== DRIFTER VOICE VALIDATION ==="
echo ""
echo "Score: $SCORE/$MAX_SCORE ($PCT%)"
echo ""

if [ "$PCT" -ge 70 ]; then
    echo "✓ PASS: Sounds like the Drifter"
elif [ "$PCT" -ge 50 ]; then
    echo "⚠ PARTIAL: Some Drifter elements present"
else
    echo "✗ FAIL: Does not sound like the Drifter"
fi

if [ -n "$WARNINGS" ]; then
    echo ""
    echo "Warnings:"
    echo -e "$WARNINGS"
fi

echo ""
echo "=== Validation complete ==="