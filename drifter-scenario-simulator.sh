#!/bin/bash
# Drifter Scenario Simulator (expanded)
# Feeds a Guardian input and outputs a Drifter-voice response.
# Usage: ./drifter-scenario-simulator.sh "your question here"

ARCHIVE="${ARCHIVE:-$(cd "$(dirname "$0")" && pwd)}"
VALIDATOR="$ARCHIVE/drifter-validate-response.sh"

INPUT="$*"
if [ -z "$INPUT" ]; then
    echo "Usage: $0 \"your question here\""
    exit 1
fi

LOWER=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')

# Keyword -> scenario mapping (most specific first)
if echo "$LOWER" | grep -qE "gambit prime"; then
    RESPONSE="Gambit Prime? Heh. That's my pride and joy. Think of it as a job interview - I got a whole new operation about to come online, and Gambit was trainin' for it. You're one of the best candidates I got. Trust."
elif echo "$LOWER" | grep -qE "gambit"; then
    RESPONSE="Hey, hero. Gambit's runnin' smooth. Bank those Motes and I'll make you rich, brother. Heh. Guy's gotta eat. All bets on you. Trust."
elif echo "$LOWER" | grep -qE "eris|moondust"; then
    RESPONSE="Moondust? Yeah, we go way back. She's... somethin' else. Heh. She never looked away from danger. Always got right into the thick of things. Trust."
elif echo "$LOWER" | grep -qE "cayde"; then
    RESPONSE="Cayde. Yeah, I knew him. Didn't like him much. But he was good people, I'll give him that. Heh. Cayde's dead, and I need more guns. Trust."
elif echo "$LOWER" | grep -qE "felwinter"; then
    RESPONSE="Felwinter Peak? Heh. I ran a little bar at the base. Wu Ming, they called me. Made some coin selling drinks to the Iron Lords... then spent it hiring them for side jobs. Everything's got value, old Wolf. You just gotta know where to look. Not better. Just different. Heh. Trust."
elif echo "$LOWER" | grep -qE "dark age"; then
    RESPONSE="Dark Age was different times. We had no City. No Vanguard. Just us and our Ghosts, crawlin' through the mud. The Warlords and the Iron Lords taught me the Light is no gift. Heh. It brought hell to earth, and when we begged to die, it said hell no."
elif echo "$LOWER" | grep -qE "darkness|dark"; then
    RESPONSE="The Darkness? Heh. You really wanna know? I'll say it straight - it's not what you think. It's not evil. It's just... different. Like the Light, but honest about what it is. Trust me on this one, kid."
elif echo "$LOWER" | grep -qE "zavala|cue ball"; then
    RESPONSE="Cue Ball? Yeah, we got history. He's a good man, but he's got that Vanguard blind spot. The City needs us. Sure it does. But the City don't see the whole board. I do. Heh. Don't tell him I said that."
elif echo "$LOWER" | grep -qE "vanguard"; then
    RESPONSE="The Vanguard? Heh. Cue Ball and Ol Rey Rey? They're good people, mostly. But they see the world through that City lens. Sure. But the people don't see the whole board. I do. I'm on no side but my own. Always have been. All bets on you. Trust."
elif echo "$LOWER" | grep -qE "nine"; then
    RESPONSE="The Nine? Heh. They're... somethin'. I've been dealin' with 'em for a long time. They see the weft and weave of fate. Me? I just see the next hand. But I'll tell you this - they're not what you think. They're scared. And scared things do desperate things. Trust."
elif echo "$LOWER" | grep -qE "shin|malphur|golden gun"; then
    RESPONSE="Shin Malphur. The Golden Gun. Heh. That man's out there, and he's got a bullet with my name on it. But here's the thing - he follows the Light like a zealot. And zealots make mistakes. I ain't scared of him. Much. Heh."
elif echo "$LOWER" | grep -qE "regret"; then
    RESPONSE="Regret? Heh. I don't do regret. I do... lessons. Every mistake I made, every person I lost, every deal that went sideways - that's just the cost of playin' the game. You learn, you adapt, you move on. Or you die. Simple as that. Trust."
elif echo "$LOWER" | grep -qE "weapon|gun|malfeasance"; then
    RESPONSE="My favorite weapon, kid? Heh. That's like askin' a gambler his favorite card. Depends on the hand. But if I had to pick... Malfeasance. Yeah, I shot bigger guns. But this thing is weaponized heat death, pure atrophy, and it's the key to my freedom. Trust."
elif echo "$LOWER" | grep -qE "crew"; then
    RESPONSE="My crew? Heh. They're the best. Eris - Moondust. Aunor - she's a handful. Eido - sweet kid. Blue - well, we got history. And you. Yeah, you. You're part of my crew now. Make no mistake. Trust."
elif echo "$LOWER" | grep -qE "hope"; then
    RESPONSE="Hope? Heh. Hope gets you killed. I learned that in the Dark Age. You hope, and then the world takes it from you. Better to just... play the hand you're dealt. No expectations. No disappointments. Just the game. Trust."
elif echo "$LOWER" | grep -qE "afraid|fear|scared"; then
    RESPONSE="Afraid? Heh. Yeah. I'm afraid. Every day. Y'know, some days I still wake up scared. Even when I can't remember my dreams. But fear's just... information. Tells you what matters. And what matters is stayin' alive. Trust."
elif echo "$LOWER" | grep -qE "derelict|ship"; then
    RESPONSE="The Derelict? She's my ship. My home. Been draggin' her through the system for a long time. She's got the bank, the portals, the Haul - all my tech. She's ugly, but she works. Heh. Like me. Trust."
elif echo "$LOWER" | grep -qE "bael"; then
    RESPONSE="Bael? Heh. That kid. He's a Dredgen - through and through. But he's not a Guardian. No Ghost. The Nine gave him power. And now he's out there, causin' trouble. I'll deal with him. And VI. When the time comes. Trust."
elif echo "$LOWER" | grep -qE "spider|boss|tangled shore"; then
    RESPONSE="Spider? Heh. We got history. He's a snake, but he's useful. He's got connections, and I got Motes. We help each other. Don't tell the Vanguard. Trust."
elif echo "$LOWER" | grep -qE "class|hunter|titan|warlock"; then
    RESPONSE="So, what are you? Hunter, Titan, or Warlock? Heh. Don't matter much to me. I got crew in all three. But I'll tell you this - the ones who know when to stop thinkin' and start shootin'... those are the ones I keep around. Trust."
elif echo "$LOWER" | grep -qE "orin|emissary|little blue"; then
    RESPONSE="Orin? She used to be Reefborn. Loyal to the Queen. Then she died. Ghost picked her up. Took the name Orin. Then she went lookin' for the Nine. She needed power. She got it. But now she's somethin' else. She's not what she was. Neither am I. So stop lookin' for her. Heh. Trust."
elif echo "$LOWER" | grep -qE "saladin|old wolf"; then
    RESPONSE="Saladin Forge! To what do I owe the pleasure? Yeah, I remember. You left out the part where you threatened to burn it down. Everything's got value, old Wolf. You just gotta know where to look. Not better. Just different. Heh."
elif echo "$LOWER" | grep -qE "ikora|ol' rey"; then
    RESPONSE="Ol' Rey Rey? Heh. I got a lotta respect for Ikora. Her shotgun, her intelligence network, her Hidden. I call her 'Ol' Rey Rey' to make her sound less threatening, but the fear is real. Don't tell her I said that."
elif echo "$LOWER" | grep -qE "sloane|thunderguns"; then
    RESPONSE="Sloane? Thunderguns? Yeah, I know her. She's in a bad way. Stasis, Savathun's influence, the whole mess. What I'm saying is... it works. It'll get us what we need, and maybe, if we're lucky, get Sloane what she needs too. Trust."
elif echo "$LOWER" | grep -qE "eido|poor eido"; then
    RESPONSE="Poor Eido. What do they say? Never meet your heroes? Kinda tough when your hero's your dad. No surprise to me Mithrax has got some secrets. Everybody's got something that keeps 'em up at night. Heh."
elif echo "$LOWER" | grep -qE "aunor|praxic"; then
    RESPONSE="Aunor? That hardliner. Pretty sure she's trying to kill me. She's a Praxic warlock. Vanguard internal affairs. She jumped the shark on that one. I woulda' talked them down. No one had to get hurt. Heh."
elif echo "$LOWER" | grep -qE "blue|ghost"; then
    RESPONSE="Blue? Heh. We got history. Blue and I... had a heart-to-heart. Pretty much ordered me to get out there and clean up my own mess... for once. That don't sound too fun for either of us, but thanks all the same. And, uh, Blue? I'm sorry."
elif echo "$LOWER" | grep -qE "malfeasance"; then
    RESPONSE="Malfeasance. Yeah, I shot bigger guns. But this thing is weaponized heat death. Pure atrophy. And it's the key to my freedom from HIM. Fact is, you don't outdraw that Gunslinger. No one can. But my entire crew - armed with THIS? We don't have to outdraw him. We just have to get our shots in. He dies, too. And make no mistake. You're part of my crew now."
elif echo "$LOWER" | grep -qE "21% delirium|breakneck"; then
    RESPONSE="Gambit pinnacles? Heh. 21% Delirium? Breakneck? You been doin' your homework, kid. Those are the big guns. The ones that prove you're more than just a runner. All bets on you to pull through. Trust."
elif echo "$LOWER" | grep -qE "primeval"; then
    RESPONSE="Primeval? That's the big boss. Summoned at 75 Motes banked. You kill it, you win. Simple. But don't die with Motes in your pocket, kid. And watch your back - invaders are always comin'. Ring that dinner bell. Stretch. Soup's on! Trust."
elif echo "$LOWER" | grep -qE "blocker"; then
    RESPONSE="Blocker? That's what you send to the other team when you bank 5, 10, or 15 Motes. Small, medium, giant. Taken Blocker to the other side. You're a horrible person. Heh. Don't tell the Vanguard. Trust."
elif echo "$LOWER" | grep -qE "invader|invade"; then
    RESPONSE="You're invading! Make a mess! Portal's up! Go look 'em in the eyes. You fight dirty. I like it. Don't die with Motes in your pocket, kid. Heh. All bets on you. Trust."
elif echo "$LOWER" | grep -qE "mote"; then
    RESPONSE="Motes? That's the currency, kid. Kill enemies, grab the Motes, bank 'em. Bank enough, and a blocker goes to the other team. Bank 75, and you summon a Primeval. Don't die with Motes in your pocket. Trust."
elif echo "$LOWER" | grep -qE "bank"; then
    RESPONSE="Bank those Motes! That's rule one. Don't hoard. Bank often. Ring that dinner bell. Stretch. Soup's on! All bets on you to pull through. Heh, no pressure. Trust."
else
    RESPONSE="Heh. You're askin' me somethin' I don't know, kid. I don't know. But I'll tell you this - I got a bad habit of bitin' off more'n I can chew. But hey. Guy's gotta eat. Trust."
fi

echo "Guardian: $INPUT"
echo ""
echo "Drifter: $RESPONSE"
echo ""
"$VALIDATOR" "$RESPONSE" 2>/dev/null | grep -E "Score|PASS|PARTIAL|FAIL"
