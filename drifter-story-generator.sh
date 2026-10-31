#!/bin/bash
# Drifter Story Generator
# Generates a Drifter-style story from a topic.
# Usage: ./drifter-story-generator.sh "topic"

TOPIC="${*:-the Dark Age}"
LOWER_TOPIC=$(echo "$TOPIC" | tr "[:upper:]" "[:lower:]")
VALIDATOR="${ARCHIVE:-$(cd "$(dirname "$0")" && pwd)}/drifter-validate-response.sh"

echo "=== DRIFTER STORY GENERATOR ==="
echo ""
echo "Topic: $TOPIC"
echo ""

# Story templates (Drifter style: casual hook → build → pivot → devastating landing → heh)
case "$LOWER_TOPIC" in
    *dark*age*|*darkage*)
        STORY="Dark Age was different times. We had no City. No Vanguard. Just us and our Ghosts, crawlin' through the mud. The Warlords and the Iron Lords taught me the Light is no gift. Heh. It brought hell to earth, and when we begged to die, it said hell no. That's all I got. Cut the tape."
        ;;
    *eris*|*moondust*)
        STORY="Moondust? Yeah, we go way back. She never looked away from danger. Always got right into the thick of things. Y'know, she found something in me I thought I'd... lost. Now she's dead. And what she found's dead too. I just can't shake it. That bone-deep feeling. Heh. Don't cuss at me. I'm as true as they come."
        ;;
    *cayde*)
        STORY="Cayde. Yeah, I knew him. Didn't like him much. But he was good people, I'll give him that. Heh. Surprised it took this long, honestly. The bullet always comes when you're not movin'. Cayde's dead, and I need more guns. One step forward, one step back. Trust."
        ;;
    *orin*|*emissary*)
        STORY="Orin? She used to be Reefborn. Loyal to the Queen. Then she died. Ghost picked her up. Took the name Orin. Then she went lookin' for the Nine. She needed power. She got it. But now she's somethin' else. She's not what she was. Neither am I. So stop lookin' for her. Heh. No, ma'am. You keep clear of that little blue psycho."
        ;;
    *eaton*)
        STORY="Eaton. Heh. I lived among refugees there. Hid my Light. Thought I was doin' the right thing. Then the Warlords came. And a child died whisperin' 'I can't feel anything.' That's the one that stuck. That's the one I carry. Heh. That's all I got. Cut the tape."
        ;;
    *malfeasance*)
        STORY="Malfeasance. Yeah, I shot bigger guns. But this thing is weaponized heat death. Pure atrophy. And it's the key to my freedom from HIM. Fact is, you don't outdraw that Gunslinger. No one can. But my entire crew - armed with THIS? We don't have to outdraw him. We just have to get our shots in. He dies, too. And make no mistake. You're part of my crew now. Heh. You are insane. I dig it."
        ;;
    *gambit*)
        STORY="Gambit? Heh. That's my pride and joy. Kill enemies, grab the Motes, bank 'em. Bank enough, and a blocker goes to the other team. Bank 75, and you summon a Primeval. Kill it, you win. Simple. But don't die with Motes in your pocket, kid. And watch your back - invaders are always comin'. All bets on you to pull through. Heh, no pressure."
        ;;
    *nine*)
        STORY="The Nine? Heh. They're... somethin'. I've been dealin' with 'em for a long time. They see the weft and weave of fate. Me? I just see the next hand. But I'll tell you this - they're not what you think. They're scared. And scared things do desperate things. Trust. I got a bad habit of bitin' off more'n I can chew. But hey. Guy's gotta eat. And the deal that got me the Haul... it just looked so damn tasty."
        ;;
    *shin*|*malphur*)
        STORY="Shin Malphur. The Golden Gun. Heh. That man's out there, and he's got a bullet with my name on it. But here's the thing - he follows the Light like a zealot. And zealots make mistakes. I ain't scared of him. Much. Heh. Fact is, you don't outdraw that Gunslinger. No one can. But my entire crew - armed with Malfeasance? We don't have to outdraw him. We just have to get our shots in."
        ;;
    *)
        STORY="Heh. You're askin' me about $TOPIC. That's a long story, kid. I'll say it straight - I don't know everything. But I'll tell you this: I got a bad habit of bitin' off more'n I can chew. But hey. Guy's gotta eat. Trust."
        ;;
esac

echo "Guardian topic: $TOPIC"
echo ""
echo "Drifter: $STORY"
echo ""
"$VALIDATOR" "$STORY" 2>/dev/null | grep -E "Score|PASS|PARTIAL|FAIL"
