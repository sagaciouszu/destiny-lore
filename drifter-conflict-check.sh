#!/bin/bash
# Drifter Conflict Detector
# Scans all agent files for contradictory statements.
# Usage: ./drifter-conflict-check.sh

WORKSPACE="${WORKSPACE:-$(cd "$(dirname "$0")/../how-to-drift-for-agents" && pwd)}"
echo "=== DRIFTER CONFLICT CHECK ==="
echo ""

# Check for Eris alive/dead contradictions
echo "--- Eris Status ---"
grep -rn "Eris is alive\|Eris lives\|Eris survived" "$WORKSPACE" 2>/dev/null | head -3
grep -rn "Eris is dead\|Eris died\|she's dead.*Eris\|Eris.*dead" "$WORKSPACE" 2>/dev/null | head -3
echo "(manual review needed)"
echo ""

# Check for Cayde alive/dead
echo "--- Cayde Status ---"
grep -rn "Cayde is alive\|Cayde lives" "$WORKSPACE" 2>/dev/null | head -3
grep -rn "Cayde is dead\|Cayde's dead\|Cayde died" "$WORKSPACE" 2>/dev/null | head -3
echo ""

# Check for Orin status
echo "--- Orin/Emissary Status ---"
grep -rn "Orin is dead\|Orin died" "$WORKSPACE" 2>/dev/null | head -3
grep -rn "Orin is alive\|Orin lives\|Orin became\|Emissary" "$WORKSPACE" 2>/dev/null | head -3
echo ""

# Check for "I make my own choices" (unverified, should not appear)
echo "--- Unverified Quote Check ---"
if grep -rn "I make my own choices" "$WORKSPACE" 2>/dev/null | grep -v "NOT FOUND\|removed\|unverified" | head -3; then
    echo "WARNING: Unverified quote found!"
else
    echo "OK: No unverified 'I make my own choices' quotes."
fi
echo ""

# Check for "Function: Go all in" (unverified)
if grep -rn "Function: Go all in" "$WORKSPACE" 2>/dev/null | grep -v "NOT FOUND\|removed\|unverified" | head -3; then
    echo "WARNING: Unverified quote found!"
else
    echo "OK: No unverified 'Function: Go all in' quotes."
fi
echo ""

# Check for "He has lost before" (unverified narration)
if grep -rn "He has lost before" "$WORKSPACE" 2>/dev/null | grep -v "NOT FOUND\|removed\|unverified\|narration" | head -3; then
    echo "WARNING: Unverified quote found!"
else
    echo "OK: No unverified 'He has lost before' quotes."
fi
echo ""

# Check for "The night falls" (Emissary, not Drifter)
if grep -rn "The night falls" "$WORKSPACE" 2>/dev/null | grep -v "NOT FOUND\|removed\|unverified\|Emissary" | head -3; then
    echo "WARNING: Emissary quote may be attributed to Drifter!"
else
    echo "OK: No Emissary 'night falls' quotes attributed to Drifter."
fi
echo ""

echo "=== CONFLICT CHECK COMPLETE ==="
