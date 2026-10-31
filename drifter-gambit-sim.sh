#!/bin/bash
# Drifter Optional Gambit Match Simulator
# Simulates a Gambit match narrated by the Drifter using canonical callouts.
# Usage:
#   ./drifter-gambit-sim.sh --auto     (automated simulation for testing/agents)
#   ./drifter-gambit-sim.sh            (interactive CLI mini-game)

AUTO=0
if [ "${1:-}" = "--auto" ]; then AUTO=1; fi

BANK=0
TARGET=75
FACTIONS=("Hive! Bring a sword." "Fallen on the horizon!" "Cabal on the field!" "Vex on the field!" "Scorn approaching!")
FACTION="${FACTIONS[$((RANDOM % ${#FACTIONS[@]}))]}"

echo "=== GAMBIT MATCH SIMULATOR (OPTIONAL) ==="
echo "Drifter: Alright, mavericks. Ready to see what we're fightin' today?"
echo "Drifter: (flicking jade coin) Ding, Ding, Ding, Ding, Ding!"
echo "Drifter: $FACTION"
echo "Drifter: Prepare for transmat!"
echo ""

STEP=0
while [ "$BANK" -lt "$TARGET" ]; do
    STEP=$((STEP + 1))
    if [ "$AUTO" -eq 1 ]; then
        CHOICE=$(( (STEP % 3) + 1 ))
    else
        echo "[Bank: $BANK/$TARGET Motes] Choose action: (1) Bank 15 Motes (2) Kill Blockers (3) Invade"
        read -rp "> " CHOICE
    fi

    case "$CHOICE" in
        1)
            BANK=$((BANK + 15))
            if [ "$BANK" -gt "$TARGET" ]; then BANK=$TARGET; fi
            echo "Action : Banked 15 Motes ($BANK/$TARGET)"
            echo "Drifter: Giant blocker outbound! You're a terrible friend, but you'll get paid!"
            ;;
        2)
            BANK=$((BANK + 10))
            if [ "$BANK" -gt "$TARGET" ]; then BANK=$TARGET; fi
            echo "Action : Cleared Bank & Banked 10 Motes ($BANK/$TARGET)"
            echo "Drifter: Medium Blocker outbound! Hey, you fight dirty. I like it."
            ;;
        3)
            BANK=$((BANK + 15))
            if [ "$BANK" -gt "$TARGET" ]; then BANK=$TARGET; fi
            echo "Action : Invaded enemy side & wiped 4 Guardians! ($BANK/$TARGET)"
            echo "Drifter: Portal's up! Go look 'em in the eyes. Hahaha! I'm sorry, were they saying something?! 'Cause they're dead now!!"
            ;;
        *)
            BANK=$((BANK + 15))
            ;;
    esac
    echo ""
done

echo "=== PRIMEVAL PHASE (75/75 MOTES) ==="
echo "Drifter: Bank down! Ring that dinner bell. Stretch. Soup's on!"
echo "Drifter: Envoys are in the dirt! Now focus on the Primeval!"
echo "Drifter: Primeval's compromised. Burn it down!"
echo "Drifter: Hey. Takes a special kind of guardian to kill a special kind of primeval. Proud of you, brother/sister."
echo "=== VICTORY — GAMBIT SIMULATION COMPLETE ==="
