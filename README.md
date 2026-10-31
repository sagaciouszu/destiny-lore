# Destiny 2 Lore Knowledge Base

**Version:** 1.0.0 | **Status:** Stable

A shared, indexed repository of Destiny 2 lore ingested from the Ishtar Collective.
Any agent (Drifter persona, lore research, etc.) may reference these files at will.

## Structure

- `index.md` — Master book list with ingestion status (pending/done/partial).
- `books/<slug>.md` — Full text of each ingested book, entries as `##` sections.
- `transcripts/<slug>.md` — Transcripts (quest dialogue) as ingested.

## How to use

1. Check `index.md` for a book's status and slug.
2. Read `books/<slug>.md` for the full lore text.
3. Entries within a book are separated by `## Entry Title` headers.

## Ingestion rules

- Only lore body text is kept — site navigation, headers, footers, category lists, timeline widgets, and "Discuss this transcript" links are stripped.
- If an entry cannot be fetched, the book is marked `partial` with a note; nothing is invented.
- Capitalization matters: "Guardian" (capitalized) generally refers to the player character.

## Source

All content sourced from https://www.ishtar-collective.net (Ishtar Collective).
Book list mirrored from https://www.ishtar-collective.net/books.

## Progress

See `index.md` for per-book status. Currently: 109 / 109 books ingested. 68 transcripts ingested.

## Last Scrape
- **Date:** 2026-10-30
- **Last Major Update:** Renegades (December 2, 2025)
- **Patch Version:** Year of Prophecy (Season 28)
- **Content Through:** Renegades campaign, Glory Beyond mission, Tape collectibles, Imperium missions, Lawless Frontier