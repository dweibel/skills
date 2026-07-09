#!/usr/bin/env python3
"""Detect overlapping text in a PDF by checking if text bounding boxes overlap horizontally."""

import fitz  # PyMuPDF
import sys
from collections import defaultdict


def detect_overlaps(pdf_path, margin=2.0):
    """Find text spans that overlap horizontally on the same line."""
    doc = fitz.open(pdf_path)
    issues = []

    for page_num in range(len(doc)):
        page = doc[page_num]
        blocks = page.get_text("dict")["blocks"]

        for block in blocks:
            if block["type"] != 0:  # text block
                continue
            for line in block["lines"]:
                spans = line["spans"]
                # Sort spans by x position
                spans_sorted = sorted(spans, key=lambda s: s["bbox"][0])

                for i in range(len(spans_sorted) - 1):
                    curr = spans_sorted[i]
                    next_span = spans_sorted[i + 1]

                    curr_right = curr["bbox"][2]
                    next_left = next_span["bbox"][0]

                    # If current span's right edge exceeds next span's left edge
                    overlap = curr_right - next_left
                    if overlap > margin:
                        # Check if it's in a table-like context (multiple spans close together)
                        curr_text = curr["text"].strip()
                        next_text = next_span["text"].strip()
                        if curr_text and next_text:
                            issues.append({
                                "page": page_num + 1,
                                "overlap_px": round(overlap, 1),
                                "text1": curr_text[:40],
                                "text2": next_text[:40],
                                "y": round(curr["bbox"][1], 0),
                            })

    doc.close()
    return issues


def find_table_overflow(pdf_path):
    """Find text that extends beyond the page margins (right edge)."""
    doc = fitz.open(pdf_path)
    issues = []

    for page_num in range(len(doc)):
        page = doc[page_num]
        page_width = page.rect.width
        right_margin = page_width - 72  # 1 inch margin = 72 points

        blocks = page.get_text("dict")["blocks"]
        for block in blocks:
            if block["type"] != 0:
                continue
            for line in block["lines"]:
                for span in line["spans"]:
                    if span["bbox"][2] > right_margin + 5:  # 5pt tolerance
                        text = span["text"].strip()
                        if text:
                            issues.append({
                                "page": page_num + 1,
                                "overflow_px": round(span["bbox"][2] - right_margin, 1),
                                "text": text[:60],
                                "y": round(span["bbox"][1], 0),
                            })

    doc.close()
    return issues


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: detect-overlaps.py <path-to-pdf>")
        print("  Checks a PDF for overlapping text and right-margin overflow.")
        sys.exit(1)

    pdf_path = sys.argv[1]

    print("=== OVERLAPPING TEXT ===")
    overlaps = detect_overlaps(pdf_path)
    if overlaps:
        # Group by page
        by_page = defaultdict(list)
        for o in overlaps:
            by_page[o["page"]].append(o)

        for page in sorted(by_page.keys()):
            print(f"\nPage {page}:")
            for o in by_page[page][:5]:  # limit per page
                print(f"  [{o['overlap_px']}px] \"{o['text1']}\" <-> \"{o['text2']}\"")
            if len(by_page[page]) > 5:
                print(f"  ... and {len(by_page[page]) - 5} more")
    else:
        print("No overlapping text detected.")

    print("\n=== TEXT BEYOND RIGHT MARGIN ===")
    overflows = find_table_overflow(pdf_path)
    if overflows:
        by_page = defaultdict(list)
        for o in overflows:
            by_page[o["page"]].append(o)

        for page in sorted(by_page.keys()):
            print(f"\nPage {page}:")
            for o in by_page[page][:5]:
                print(f"  [+{o['overflow_px']}px] \"{o['text']}\"")
            if len(by_page[page]) > 5:
                print(f"  ... and {len(by_page[page]) - 5} more")
    else:
        print("No text beyond right margin detected.")
