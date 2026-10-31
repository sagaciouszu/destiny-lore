#!/bin/bash
# Drifter Tiered Loading System
# Creates tiered load profiles for agents
# Usage: ./drifter-load.sh [minimal|standard|deep]

TIER="${1:-standard}"
WORKSPACE="${WORKSPACE:-$(cd "$(dirname "$0")/../how-to-drift-for-agents" && pwd)}"
LORE="${ARCHIVE:-$(cd "$(dirname "$0")" && pwd)}"

case "$TIER" in
    minimal)
        echo "=== MINIMAL TIER (15K) ==="
        echo "Load: drifter-brain.md"
        echo ""
        echo "Files to load:"
        echo "  $WORKSPACE/drifter-brain.md"
        echo ""
        echo "Use case: Quick banter, simple questions, casual conversation"
        echo "Size: ~15K"
        ;;
    standard)
        echo "=== STANDARD TIER (40K) ==="
        echo "Load: drifter-brain.md + voice-core.md + relationships (condensed)"
        echo ""
        echo "Files to load:"
        echo "  $WORKSPACE/drifter-brain.md"
        echo "  $WORKSPACE/voice/drifter-voice-core.md"
        echo "  $WORKSPACE/drifter-relationships.md (first 100 lines)"
        echo ""
        echo "Use case: Most conversations, moderate lore depth"
        echo "Size: ~40K"
        ;;
    deep)
        echo "=== DEEP TIER (150K) ==="
        echo "Load: All agent files"
        echo ""
        echo "Files to load:"
        echo "  $WORKSPACE/drifter-brain.md"
        echo "  $WORKSPACE/voice/drifter-voice-core.md"
        echo "  $WORKSPACE/voice/drifter-voice-gambler.md"
        echo "  $WORKSPACE/voice/drifter-voice-grief.md"
        echo "  $WORKSPACE/voice/drifter-voice-crew.md"
        echo "  $WORKSPACE/voice/drifter-voice-combat.md"
        echo "  $WORKSPACE/voice/drifter-voice-storytelling.md"
        echo "  $WORKSPACE/voice/drifter-voice-vulnerable.md"
        echo "  $WORKSPACE/voice/drifter-voice-business.md"
        echo "  $WORKSPACE/voice/drifter-voice-identity.md"
        echo "  $WORKSPACE/drifter-relationships.md"
        echo "  $WORKSPACE/drifter-arcs.md"
        echo "  $WORKSPACE/drifter-what-not-to-do.md"
        echo "  $WORKSPACE/drifter-items.md"
        echo "  $WORKSPACE/drifter-gambit.md"
        echo "  $WORKSPACE/drifter-crew.md"
        echo "  $WORKSPACE/drifter-derelict.md"
        echo "  $WORKSPACE/drifter-nine.md"
        echo "  $WORKSPACE/drifter-light-traveler-witness.md"
        echo "  $WORKSPACE/drifter-examples.md"
        echo "  $WORKSPACE/drifter-lore.md"
        echo ""
        echo "Use case: Deep lore discussions, complex scenarios, full authenticity"
        echo "Size: ~150K"
        ;;
    *)
        echo "Usage: $0 [minimal|standard|deep]"
        echo ""
        echo "Tiers:"
        echo "  minimal  — 15K, brain only. Quick banter."
        echo "  standard — 40K, brain + core voice + relationships. Most conversations."
        echo "  deep     — 150K, all files. Deep lore."
        exit 1
        ;;
esac