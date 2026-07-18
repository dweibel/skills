---
name: pdf-reader
description: Use this skill whenever you need to read, extract text from, or analyze the content of a PDF file. This includes extracting plain text, extracting tables, reading specific pages or page ranges, summarizing PDF content, answering questions about PDF content, and performing OCR on scanned PDFs. Activate this skill any time the user mentions reading a .pdf file, asks what a PDF contains, or wants text pulled from a PDF document.
---

# PDF Reader

## Overview

This skill focuses exclusively on **reading and extracting content** from PDF files. It uses `pdfplumber` for text and table extraction, with `pytesseract` + `pdf2image` as a fallback for scanned/image-based PDFs.

## Quick Start

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    for page in pdf.pages:
        text = page.extract_text()
        if text:
            print(text)
```

## Dependencies

Install before use:

```bash
pip install pdfplumber
```

For scanned PDFs (OCR fallback):

```bash
pip install pytesseract pdf2image
# Also requires system packages: tesseract-ocr, poppler-utils
```

## Extraction Methods

### Extract All Text

```python
import pdfplumber

def extract_full_text(pdf_path):
    """Extract all text from every page of a PDF."""
    text_parts = []
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            page_text = page.extract_text()
            if page_text:
                text_parts.append(page_text)
    return "\n\n".join(text_parts)
```

### Extract Specific Pages

```python
import pdfplumber

def extract_pages(pdf_path, start=1, end=None):
    """Extract text from a range of pages (1-indexed)."""
    text_parts = []
    with pdfplumber.open(pdf_path) as pdf:
        end = end or len(pdf.pages)
        for i in range(start - 1, min(end, len(pdf.pages))):
            page_text = pdf.pages[i].extract_text()
            if page_text:
                text_parts.append(f"--- Page {i + 1} ---\n{page_text}")
    return "\n\n".join(text_parts)
```

### Extract Tables

```python
import pdfplumber

def extract_tables(pdf_path):
    """Extract all tables from a PDF as lists of rows."""
    all_tables = []
    with pdfplumber.open(pdf_path) as pdf:
        for i, page in enumerate(pdf.pages):
            tables = page.extract_tables()
            for j, table in enumerate(tables):
                all_tables.append({
                    "page": i + 1,
                    "table_index": j + 1,
                    "rows": table
                })
    return all_tables
```

### Get Page Count and Metadata

```python
import pdfplumber

def get_pdf_info(pdf_path):
    """Get basic info about a PDF."""
    with pdfplumber.open(pdf_path) as pdf:
        return {
            "pages": len(pdf.pages),
            "metadata": pdf.metadata
        }
```

### OCR Fallback for Scanned PDFs

If `pdfplumber` returns empty text for pages (common with scanned documents), fall back to OCR:

```python
import pytesseract
from pdf2image import convert_from_path

def ocr_pdf(pdf_path, start_page=None, end_page=None):
    """OCR a scanned PDF to extract text."""
    kwargs = {}
    if start_page:
        kwargs["first_page"] = start_page
    if end_page:
        kwargs["last_page"] = end_page

    images = convert_from_path(pdf_path, **kwargs)
    text_parts = []
    for i, image in enumerate(images):
        page_num = (start_page or 1) + i
        page_text = pytesseract.image_to_string(image)
        if page_text.strip():
            text_parts.append(f"--- Page {page_num} ---\n{page_text}")
    return "\n\n".join(text_parts)
```

## Workflow

When asked to read a PDF:

1. **Get page count first** — use `get_pdf_info()` to understand the document size.
2. **Try pdfplumber** — attempt text extraction with `pdfplumber`. This handles most digitally-created PDFs.
3. **Check for empty results** — if pages return `None` or empty strings, the PDF is likely scanned.
4. **Fall back to OCR** — use `ocr_pdf()` for scanned documents.
5. **Extract in chunks** — for large PDFs (50+ pages), extract in page ranges rather than all at once to avoid overwhelming context.

## Command-Line Alternative

When Python is inconvenient, use `pdftotext` from poppler-utils:

```bash
# Extract all text
pdftotext input.pdf output.txt

# Preserve layout
pdftotext -layout input.pdf output.txt

# Extract specific pages (e.g., pages 5-10)
pdftotext -f 5 -l 10 input.pdf output.txt
```

## Tips

- **Large PDFs:** Extract a table of contents or first few pages to understand structure before pulling specific sections.
- **Multi-column layouts:** Use `pdftotext -layout` or pdfplumber extract_text(layout=True) for better column handling.
- **Tables:** Always try `page.extract_tables()` before attempting to parse tabular data from raw text.
- **Mixed PDFs:** Some PDFs have both digital text and scanned images. Check each page individually — extract text where available, OCR where not.
