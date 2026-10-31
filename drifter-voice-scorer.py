#!/usr/bin/env python3
"""
Drifter Statistical Voice Similarity Scorer
Compares a candidate response against the 473 canonical Drifter transcript lines
using vocabulary overlap, character/word n-gram similarity, sentence-length
distribution, and signature marker density.

Usage:
  ./drifter-voice-scorer.py "Hey, hero. Bank those Motes! Heh. Trust."
"""
import glob, math, os, re, sys
from collections import Counter

ARCHIVE = os.environ.get("ARCHIVE", os.path.dirname(os.path.abspath(__file__)))

def tokenize(text):
    return re.findall(r"[a-z0-9']+", text.lower())

def ngrams(tokens, n):
    return [tuple(tokens[i:i+n]) for i in range(len(tokens)-n+1)]

def load_corpus():
    lines = []
    for p in glob.glob(os.path.join(ARCHIVE, "transcripts/*.md")):
        for line in open(p, encoding="utf-8", errors="ignore"):
            m = re.match(r"^\*(?:The )?Drifter:\*\s*(.*)$", line.strip())
            if m:
                lines.append(m.group(1).strip())
        # Also include Destinypedia in-game quotes file lines
        if os.path.basename(p) == "ingame-quotes-drifter-destinypedia.md":
            for line in open(p, encoding="utf-8", errors="ignore"):
                m = re.match(r'^- "([^"]+)"', line.strip())
                if m:
                    lines.append(m.group(1).strip())
    return lines

MARKERS = {
    "heh", "nah", "yeah", "kid", "hero", "partner", "brother", "sister",
    "punk", "snitch", "reckoner", "moondust", "trust", "motes", "bank",
    "gambit", "derelict", "haul", "primeval", "blocker", "invader",
    "gotta", "doin'", "nothin'", "somethin'", "lookin'", "talkin'",
    "runnin'", "comin'", "ol'", "ain't", "wager", "bet", "bets", "coin"
}

def score_response(candidate, corpus_lines):
    cand_tokens = tokenize(candidate)
    if not cand_tokens:
        return 0.0, {}

    all_tokens = []
    for l in corpus_lines:
        all_tokens.extend(tokenize(l))

    vocab = set(all_tokens)
    uni_counts = Counter(all_tokens)
    bi_set = set(ngrams(all_tokens, 2))
    tri_set = set(ngrams(all_tokens, 3))

    # 1. Vocabulary overlap (0-25 pts)
    in_vocab = sum(1 for t in cand_tokens if t in vocab)
    vocab_ratio = in_vocab / len(cand_tokens)
    vocab_score = min(25.0, vocab_ratio * 28.0)

    # 2. Bigram & trigram overlap with canonical Drifter phrasing (0-25 pts)
    cand_bi = ngrams(cand_tokens, 2)
    cand_tri = ngrams(cand_tokens, 3)
    bi_hits = sum(1 for b in cand_bi if b in bi_set) / max(1, len(cand_bi))
    tri_hits = sum(1 for t in cand_tri if t in tri_set) / max(1, len(cand_tri))
    ngram_score = min(25.0, (bi_hits * 18.0) + (tri_hits * 35.0))

    # 3. Signature marker density (0-30 pts)
    marker_hits = [t for t in cand_tokens if t in MARKERS or t.endswith("in'")]
    unique_markers = len(set(marker_hits))
    marker_score = min(30.0, unique_markers * 7.5)

    # 4. Sentence cadence & length profile (0-20 pts)
    sents = [s.strip() for s in re.split(r"[.!?]+", candidate) if s.strip()]
    avg_words = len(cand_tokens) / max(1, len(sents))
    # Drifter speaks in punchy sentences (avg 3-14 words)
    if 2.0 <= avg_words <= 14.0:
        cadence_score = 20.0
    elif avg_words <= 20.0:
        cadence_score = 12.0
    else:
        cadence_score = 5.0

    total = round(vocab_score + ngram_score + marker_score + cadence_score, 1)
    details = {
        "vocab_score": round(vocab_score, 1),
        "ngram_score": round(ngram_score, 1),
        "marker_score": round(marker_score, 1),
        "cadence_score": round(cadence_score, 1),
        "markers_found": sorted(set(marker_hits)),
        "avg_words_per_sentence": round(avg_words, 1),
        "corpus_lines": len(corpus_lines),
    }
    return total, details

def main():
    if len(sys.argv) < 2:
        print("Usage: drifter-voice-scorer.py \"<response>\"")
        sys.exit(1)
    candidate = " ".join(sys.argv[1:])
    corpus = load_corpus()
    total, d = score_response(candidate, corpus)
    status = "PASS" if total >= 55.0 else ("PARTIAL" if total >= 40.0 else "FAIL")
    print(f"=== DRIFTER STATISTICAL VOICE SCORER ===")
    print(f"Corpus size: {d['corpus_lines']} canonical lines")
    print(f"Total Score: {total}/100 ({status})")
    print(f"  Vocabulary overlap : {d['vocab_score']}/25")
    print(f"  N-gram phrasing    : {d['ngram_score']}/25")
    print(f"  Signature markers  : {d['marker_score']}/30 ({', '.join(d['markers_found']) or 'none'})")
    print(f"  Sentence cadence   : {d['cadence_score']}/20 (avg {d['avg_words_per_sentence']} words/sentence)")
    sys.exit(0 if total >= 55.0 else 1)

if __name__ == "__main__":
    main()
