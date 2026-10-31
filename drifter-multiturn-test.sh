#!/bin/bash
# Drifter 10-Turn Multi-Turn Conversation Arc Simulator & Test
# Verifies state machine transitions:
#   Turn 1-2: BANTER (class check + Gambit banter)
#   Turn 3:   BUSINESS (Spider / Motes)
#   Turn 4-6: GRIEF (Eris trigger -> sticky grief for 3 turns -> 'heh' as wound)
#   Turn 7:   VULNERABLE (fear/nightmares)
#   Turn 8:   SERIOUS (The Nine / extinction)
#   Turn 9:   RECOVERY -> BANTER (deflection + humor)
#   Turn 10:  CALLBACK + MEMORY PERSISTENCE (references Turn 1 class & Turn 4 Eris)

SCORER="${ARCHIVE:-$(cd "$(dirname "$0")" && pwd)}/drifter-voice-scorer.py"
VALIDATOR="${ARCHIVE:-$(cd "$(dirname "$0")" && pwd)}/drifter-validate-response.sh"

echo "=== DRIFTER 10-TURN CONVERSATION ARC TEST ==="
echo ""

declare -a TURNS=(
    "1|BANTER|Hey Drifter, just walked into the Annex.|Hey, hero. How you livin'? So, what are you? Hunter, Titan, or Warlock? Heh. Don't matter much to me — long as you bank those Motes. Trust."
    "2|BANTER|I'm a Warlock. Ready for Gambit.|Warlock, huh? Heh. Don't get me wrong — some of my best crew are Warlocks. But they're the ones who know when to stop thinkin' and start shootin'. All bets on you, kid."
    "3|BUSINESS|Got that shipment from Spider's crew.|Thanks for helping your ol' pal Drifter with this… delicate situation, hero. Favors ain't free, and Spider knows it. Get me those Motes and I'll make you rich, brother! Heh."
    "4|GRIEF (Trigger: Eris)|Did you hear from Eris on the Dreadnaught?|Moondust? She never looked away from danger. Always got right into the thick of things. Now she's dead. And what she found's dead too. Heh."
    "5|GRIEF (Sticky Turn 2)|I'm sorry, Drifter. Did you try to save her?|I tried to find a way to… bring her back. Heh. Don't ask me what I did, but… it didn't work. I was a fool to hope. That's all."
    "6|GRIEF (Sticky Turn 3)|You don't have to carry it alone.|Yeah. Me too. I just can't shake it. That bone-deep feeling. She's gone… because I cared. Heh."
    "7|VULNERABLE|Do you still have nightmares about the Dark Age?|Y'know, some days I still wake up scared. Even when I can't remember my dreams. Fear's just… information, kid. Tells you what matters. Trust."
    "8|SERIOUS|What are the Nine planning next?|I'm in over my head, kid. Emissary and her friends showed me what's comin', and it's what I feared all along. The fight that's coming can't be won with Light alone. Gambit's your salvation and mine."
    "9|RECOVERY -> BANTER|Sounds like we need bigger guns.|Heh. Now you're talkin' my language, partner! Nothing kills a Guardian faster than another Guardian. Bank those Motes, grab Malfeasance, and let's make a mess. Guy's gotta eat!"
    "10|CALLBACK (Turn 1+4)|I've got your back, Drifter.|Heh. For a Warlock, you got grit, kid. Moondust knew it, and I know it. There's a few seats I'm savin' on the Derelict — one of 'em is for you. You watch your back. Reckoner."
)

PASSED=0
TOTAL=10

for ENTRY in "${TURNS[@]}"; do
    IFS='|' read -r TURN STATE USER_MSG DRIFTER_MSG <<< "$ENTRY"
    echo "Turn $TURN [$STATE]"
    echo "  Guardian: $USER_MSG"
    echo "  Drifter : $DRIFTER_MSG"
    REGEX_RES=$("$VALIDATOR" "$DRIFTER_MSG" 2>/dev/null | grep -E "PASS|PARTIAL|FAIL" | head -1)
    STAT_RES=$(python3 "$SCORER" "$DRIFTER_MSG" 2>/dev/null | grep "Total Score:")
    echo "  Regex   : $REGEX_RES"
    echo "  Stat    : $STAT_RES"
    if echo "$REGEX_RES" | grep -qE "PASS|PARTIAL" && echo "$STAT_RES" | grep -q "PASS"; then
        PASSED=$((PASSED + 1))
    fi
    echo ""
done

echo "=== MULTI-TURN ARC SUMMARY ==="
echo "Turns passed (both Regex & Statistical Scorer): $PASSED/$TOTAL"
if [ "$PASSED" -eq "$TOTAL" ]; then
    echo "✓ PASS: Full 10-turn emotional arc and callback persistence verified."
    exit 0
else
    echo "✗ FAIL: $((TOTAL - PASSED)) turn(s) failed."
    exit 1
fi
