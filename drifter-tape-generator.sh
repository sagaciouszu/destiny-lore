#!/bin/bash
# Drifter "How to Drift" Audio Tape Generator
# Generates an EDZ-style hidden survival tape backed by canonical lore.
# Usage: ./drifter-tape-generator.sh [ghosts|hope|starvation|aunor|shin|extinction]

TOPIC="${1:-ghosts}"
LOWER=$(echo "$TOPIC" | tr '[:upper:]' '[:lower:]')
SCORER="${ARCHIVE:-$(cd "$(dirname "$0")" && pwd)}/drifter-voice-scorer.py"

case "$LOWER" in
    *ghost*)
        PART="Part Three: Never Trust Your Ghost"
        BODY="Hey, kid. It's me. The Drifter. And this is 'How to Drift,' $PART. He's a tool. A connection to the Light. Not a friend - not in any way that counts. You think he's saving your hide, bringing you back? He's saving his own. We don't know what Ghosts are. Take mine, for example. Really creeps me out… Cut the tape, Ghost. And don't gimme that look. You know where we stand."
        ;;
    *hope*|*eaton*)
        PART="Part One: Hope Gets You Killed"
        BODY="Hey, kid. It's me. The Drifter. And this is 'How to Drift,' $PART. Dark Age was different times. We had no City. This one time I found a village to hide out in. Nice folks. Kept my Light to myself. Then the Warlords came. Right before the light went out in her tiny eyes, she whispered, 'I can't feel anything.' Yeah. I couldn't either. Don't give in to hope. That gets you killed. That's all I got. Cut the tape."
        ;;
    *starv*|*food*|*eat*|*hungry*)
        PART="Part Two: Guy's Gotta Eat"
        BODY="Hey, kid. It's me. The Drifter. And this is 'How to Drift,' $PART. You ever go hungry 'til you keeled over? We did that a lot in the Dark Age. Our Ghosts would bring us back - still hungry. Really pissed me off. Out on the frontier, you ask yourself: think you can eat a Hive Knight? Vex have that soft spot at the center. Bet you could cook that — eat it. Heh. That's all I got. Cut the tape."
        ;;
    *aunor*|*praxic*|*vanguard*)
        PART="Part Four: Watch the Hardliners"
        BODY="Hey, kid. It's me. The Drifter. And this is 'How to Drift,' $PART. I thought the City had made you all soft. But there's this hardliner - a Warlock named Aunor. Pretty sure she's trying to kill me. She crashed a handoff between me and the Shadows of Yor in Midtown. Took out a City block. I woulda' talked them down. No one had to get hurt. You watch your back out there, partner. That's all I got. Cut the tape."
        ;;
    *shin*|*malphur*|*golden*)
        PART="Part Five: The Man with the Golden Gun"
        BODY="Hey, kid. It's me. The Drifter. And this is 'How to Drift,' $PART. Fact is, you don't outdraw that Gunslinger. No one can. He follows the Light like a zealot. But my entire crew - armed with Malfeasance? We don't have to outdraw him. We just have to get our shots in. He dies, too. And make no mistake. You're part of my crew now. That's all I got. Cut the tape."
        ;;
    *)
        PART="Part Six: Seats I'm Savin'"
        BODY="Hey, kid. It's me. The Drifter. And this is 'How to Drift,' $PART. The Collapse wasn't the last extinction-level event to hit humanity. Ol' Drifter's seen another one comin'. Take every day as it is. Trade your jumpship for a long-range hauler and see the universe while you can. There's a few seats I'm savin'. One of 'em is for you. If you want it. That's all I got. Cut the tape."
        ;;
esac

echo "=== [AUDIO LOG: $PART] ==="
echo ""
echo "$BODY"
echo ""
python3 "$SCORER" "$BODY" | grep -E "Total Score:"
