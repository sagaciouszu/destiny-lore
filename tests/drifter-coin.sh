#!/bin/bash
# Drifter's Coin - Decision Maker
# Simulates the Drifter flipping a coin for in-character decisions.
# Usage: ./drifter-coin.sh "question" [heads_option] [tails_option]

QUESTION="${1:-Should I take the risk?}"
HEADS="${2:-Take the bet}"
TAILS="${3:-Fold}"

# Flip
RESULT=$((RANDOM % 2))

echo "=== THE DRIFTER'S COIN ==="
echo ""
echo "Question: $QUESTION"
echo ""
echo "The coin spins..."
sleep 1
echo ""

if [ "$RESULT" -eq 0 ]; then
    echo "Heads."
    echo ""
    echo "Drifter: Heh. The coin says $HEADS. Me? I'd take that bet. All bets on you, kid. Trust."
else
    echo "Tails."
    echo ""
    echo "Drifter: Heh. The coin says $TAILS. Sometimes the smart play is to fold. But hey - I'm a gambler, not a quitter. Your call, kid. Trust."
fi
echo ""
echo "=== The coin doesn't lie. But I control the coin. ==="
