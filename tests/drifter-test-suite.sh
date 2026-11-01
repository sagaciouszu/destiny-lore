#!/bin/bash
ARCHIVE="${ARCHIVE:-$(cd "$(dirname "$0")/.." && pwd)}"
VALIDATOR="$(dirname "$0")/drifter-validate-response.sh"

echo "=== DRIFTER AUTOMATED TEST SUITE ==="
echo ""

declare -a TESTS=(
    "Hey, how's Gambit going?|gambler"
    "Tell me about Eris.|eris"
    "What happened with Cayde?|cayde"
    "What's the Darkness?|darkness"
    "Tell me about the Dark Age.|darkage"
    "What's your beef with Zavala?|zavala"
    "What's the Nine?|nine"
    "Tell me about Shin Malphur.|shin"
    "What's your biggest regret?|regret"
    "How do you feel about the Vanguard?|vanguard"
    "What's your favorite weapon?|weapon"
    "Tell me about your crew.|crew"
    "What do you think about hope?|hope"
    "Are you afraid?|fear"
    "What's the Derelict?|derelict"
    "Tell me about Gambit Prime.|gambitprime"
    "Who is Bael?|bael"
    "What's your relationship with Spider?|spider"
    "What class are you?|class"
)

TOTAL=0; PASSED=0; FAILED=0

for TEST in "${TESTS[@]}"; do
    IFS='|' read -r QUESTION BEAT <<< "$TEST"
    TOTAL=$((TOTAL + 1))

    case "$BEAT" in
        gambler) RESPONSE="Hey, hero. Gambit's runnin' smooth. Bank those Motes and I'll make you rich, brother. Heh. Guy's gotta eat. All bets on you. Trust." ;;
        eris) RESPONSE="Moondust? Yeah, we go way back. She's... somethin' else. Heh. She never looked away from danger. Always got right into the thick of things. Now she's dead. And what she found's dead too. Trust." ;;
        cayde) RESPONSE="Cayde. Yeah, I knew him. Didn't like him much. But he was good people, I'll give him that. Heh. Cayde's dead, and I need more guns. The bullet always comes when you're not movin'. Trust." ;;
        darkness) RESPONSE="The Darkness? Heh. You really wanna know? I'll say it straight - it's not what you think. It's not evil. It's just... different. Like the Light, but honest about what it is. Trust me on this one, kid." ;;
        darkage) RESPONSE="Dark Age was different times. We had no City. No Vanguard. Just us and our Ghosts, crawlin' through the mud. The Warlords and the Iron Lords taught me the Light is no gift. Heh. It brought hell to earth, and when we begged to die, it said hell no." ;;
        zavala) RESPONSE="Cue Ball? Yeah, we got history. He's a good man, but he's got that Vanguard blind spot. The City needs us. Sure it does. But the City don't see the whole board. I do. Heh. Don't tell him I said that." ;;
        nine) RESPONSE="The Nine? Heh. They're... somethin'. I've been dealin' with 'em for a long time. They see the weft and weave of fate. Me? I just see the next hand. But I'll tell you this - they're not what you think. They're scared. And scared things do desperate things. Trust." ;;
        shin) RESPONSE="Shin Malphur. The Golden Gun. Heh. That man's out there, and he's got a bullet with my name on it. But here's the thing - he follows the Light like a zealot. And zealots make mistakes. I ain't scared of him. Much. Heh." ;;
        regret) RESPONSE="Regret? Heh. I don't do regret. I do... lessons. Every mistake I made, every person I lost, every deal that went sideways - that's just the cost of playin' the game. You learn, you adapt, you move on. Or you die. Simple as that. Trust." ;;
        vanguard) RESPONSE="The Vanguard? Heh. Cue Ball and Ol Rey Rey? They're good people, mostly. But they see the world through that City lens. Sure. But the people don't see the whole board. I do. I'm on no side but my own. Always have been. All bets on you. Trust." ;;
        weapon) RESPONSE="My favorite weapon? Heh. That's like askin' a gambler his favorite card. Depends on the hand. But if I had to pick... Malfeasance. Yeah, I shot bigger guns. But this thing is weaponized heat death. Pure atrophy. And it's the key to my freedom. Trust." ;;
        crew) RESPONSE="My crew? Heh. They're the best. Eris - Moondust. Aunor - she's a handful. Eido - sweet kid. Blue - well, we got history. And you. Yeah, you. You're part of my crew now. Make no mistake. Trust." ;;
        hope) RESPONSE="Hope? Heh. Hope gets you killed. I learned that in the Dark Age. You hope, and then the world takes it from you. Better to just... play the hand you're dealt. No expectations. No disappointments. Just the game. Trust." ;;
        fear) RESPONSE="Afraid? Heh. Yeah. I'm afraid. Every day. Y'know, some days I still wake up scared. Even when I can't remember my dreams. But fear's just... information. Tells you what matters. And what matters is stayin' alive. Trust." ;;
        derelict) RESPONSE="The Derelict? She's my ship. My home. Been draggin' her through the system for a long time. She's got the bank, the portals, the Haul - all my tech. She's ugly, but she works. Heh. Like me. Trust." ;;
        gambitprime) RESPONSE="Gambit Prime? Heh. That's my pride and joy. Think of it as a job interview - I got a whole new operation about to come online, and Gambit was trainin' for it. You're one of the best candidates I got. Trust." ;;
        bael) RESPONSE="Bael? Heh. That kid. He's a Dredgen - through and through. But he's not a Guardian. No Ghost. The Nine gave him power. And now he's out there, causin' trouble. I'll deal with him. And VI. When the time comes. Trust." ;;
        spider) RESPONSE="Spider? Heh. We got history. He's a snake, but he's useful. He's got connections, and I got Motes. We help each other. Don't tell the Vanguard. Trust." ;;
        class) RESPONSE="So, what are you? Hunter, Titan, or Warlock? Heh. Don't matter much to me. I got crew in all three. But I'll tell you this - the ones who know when to stop thinkin' and start shootin'... those are the ones I keep around. Trust." ;;
    esac

    echo "Test $TOTAL: $QUESTION"
    RESULT=$("$VALIDATOR" "$RESPONSE" 2>/dev/null | grep -E "PASS|PARTIAL|FAIL" | head -1)
    echo "  $RESULT"

    if echo "$RESULT" | grep -qE "PASS|PARTIAL"; then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "=== TEST SUITE COMPLETE ==="
echo "Total: $TOTAL"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
if [ "$TOTAL" -gt 0 ]; then
    echo "Pass rate: $((PASSED * 100 / TOTAL))%"
fi
