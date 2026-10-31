#!/bin/bash
# Drifter Lore Freshness Check
# Checks if the lore archive needs updating.
# Usage: ./drifter-freshness-check.sh

ARCHIVE="/home/sredshaw/Work/destiny-lore"
WORKSPACE="/home/sredshaw/Work/how-to-drift-for-agents"

echo "=== DRIFTER LORE FRESHNESS CHECK ==="
echo ""

# Check last scrape date
LAST_SCRAPE=$(grep -oE 'Last Scrape.*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$ARCHIVE/index.md" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
echo "Last scrape date: $LAST_SCRAPE"
echo "Current date: $(date +%Y-%m-%d)"
echo ""

# Check if stale (more than 30 days)
if [ -n "$LAST_SCRAPE" ]; then
    LAST_EPOCH=$(date -d "$LAST_SCRAPE" +%s 2>/dev/null || echo "0")
    NOW_EPOCH=$(date +%s)
    DIFF_DAYS=$(( (NOW_EPOCH - LAST_EPOCH) / 86400 ))
    echo "Days since last scrape: $DIFF_DAYS"
    if [ "$DIFF_DAYS" -gt 30 ]; then
        echo "WARNING: Lore archive is $DIFF_DAYS days old. Consider re-scraping."
    else
        echo "OK: Lore archive is fresh ($DIFF_DAYS days old)."
    fi
else
    echo "WARNING: Could not determine last scrape date."
fi
echo ""

# Check book count
BOOKS=$(ls "$ARCHIVE/books"/*.md 2>/dev/null | wc -l)
TRANSCRIPTS=$(ls "$ARCHIVE/transcripts"/*.md 2>/dev/null | grep -v 'index.md' | wc -l)
echo "Books: $BOOKS (expected ~109)"
echo "Transcripts: $TRANSCRIPTS (expected ~68)"
echo ""

# Check knowledge web exists
if [ -f "$ARCHIVE/knowledge-web.md" ]; then
    echo "knowledge-web.md: EXISTS ($(wc -l < "$ARCHIVE/knowledge-web.md") lines)"
else
    echo "knowledge-web.md: MISSING"
fi

echo ""
echo "=== FRESHNESS CHECK COMPLETE ==="
