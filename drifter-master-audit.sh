#!/bin/bash
# Drifter Master Audit Runner
# Runs all validation, cross-reference, voice, and simulation suites in sequence
# and prints a unified scorecard.
# Usage: ./drifter-master-audit.sh

ARCHIVE="/home/sredshaw/Work/destiny-lore"
WORKSPACE="/home/sredshaw/Work/how-to-drift-for-agents"

PASS_COUNT=0
FAIL_COUNT=0
TOTAL_SUITES=0

run_suite() {
    local name="$1"
    local cmd="$2"
    TOTAL_SUITES=$((TOTAL_SUITES + 1))
    if eval "$cmd" > /tmp/drifter_audit_out.txt 2>&1; then
        echo "  ✓ [PASS] $name"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  ✗ [FAIL] $name"
        cat /tmp/drifter_audit_out.txt | tail -10
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

echo "============================================================"
echo "  THE DRIFTER — MASTER AUDIT & TEST SCORECARD"
echo "============================================================"
echo ""

run_suite "1. Archive & Link Validation (validate.sh)" \
    "bash $ARCHIVE/validate.sh | grep -q 'unverified quotes: 0' && bash $ARCHIVE/validate.sh | grep -q 'missing: 0'"

run_suite "2. Cross-Reference & Dependency Validator (drifter-xref-validate.sh)" \
    "bash $ARCHIVE/drifter-xref-validate.sh | grep -q 'Broken references: 0'"

run_suite "3. Module Completeness Suite (drifter-module-test.sh)" \
    "bash $ARCHIVE/drifter-module-test.sh | grep -q 'Failed: 0'"

run_suite "4. Single-Turn Voice Test Suite (drifter-test-suite.sh — 19 scenarios)" \
    "bash $ARCHIVE/drifter-test-suite.sh | grep -q 'Failed: 0'"

run_suite "5. Statistical N-Gram Voice Scorer (drifter-voice-scorer.py)" \
    "python3 $ARCHIVE/drifter-voice-scorer.py \"Hey, hero. Bank those Motes! Heh. Guy's gotta eat. Trust.\" | grep -q 'PASS'"

run_suite "6. 10-Turn Emotional Arc & Callback Suite (drifter-multiturn-test.sh)" \
    "bash $ARCHIVE/drifter-multiturn-test.sh | grep -q 'Turns passed (both Regex & Statistical Scorer): 10/10'"

run_suite "7. Scenario Simulator (drifter-scenario-simulator.sh)" \
    "bash $ARCHIVE/drifter-scenario-simulator.sh 'Tell me about Malfeasance' | grep -q 'PASS'"

run_suite "8. How to Drift Tape Generator (drifter-tape-generator.sh)" \
    "bash $ARCHIVE/drifter-tape-generator.sh 'ghosts' | grep -q 'PASS'"

run_suite "9. Optional Gambit Match Simulator (drifter-gambit-sim.sh --auto)" \
    "bash $ARCHIVE/drifter-gambit-sim.sh --auto | grep -q 'VICTORY'"

run_suite "10. Lore Freshness Check (drifter-freshness-check.sh)" \
    "bash $ARCHIVE/drifter-freshness-check.sh | grep -q 'OK: Lore archive is fresh'"

echo ""
echo "============================================================"
echo "  SCORECARD: $PASS_COUNT / $TOTAL_SUITES SUITES PASSED ($FAIL_COUNT failed)"
echo "============================================================"
[ "$FAIL_COUNT" -eq 0 ]
