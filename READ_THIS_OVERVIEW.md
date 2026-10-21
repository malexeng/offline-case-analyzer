# Read This — Offline Case Analyzer Overview

*A plain-English guide so you can explain this project in an interview, a demo or a talk.*

## In one sentence
Point it at a messy folder of evidence (screenshots, PDFs, Word files, videos) and it produces an organised case report, without any of it leaving your computer.

## The problem it solves
Preparing a complaint or dispute means sorting through hundreds of files by hand to build a timeline. It's slow, error-prone and exhausting. Uploading sensitive documents to cloud AI raises real privacy concerns.

## How it works, step by step
1. It scans the whole case folder and gives every file a digital fingerprint (SHA-256), so each piece of evidence can be identified exactly and shown not to have changed.
2. It pulls the text out of everything: OCR reads text from screenshots, PDFs and Word files are read directly, and videos are sampled into still frames that are then OCR'd.
3. A local AI model analyses each type of evidence separately (map).
4. A second pass merges all of those findings into one structured result covering timeline, people involved, issues and evidence links (reduce).
5. It checks that the AI's output is valid, structured data and retries up to 3 times if not, then writes a formatted Word report and a data file.

See the diagram: [docs/workflow.png](docs/workflow.png)

## The everyday comparison
A paralegal who reads every document in the box, makes neat notes on each, then writes one summary memo that cites exactly which document says what.

## Why it works
AI models have a limited reading window, so you can't feed them a whole case at once. Analysing piece by piece and then combining (map → reduce) gets around that. Demanding strict structured output and checking it stops the report from being vague or invented.

## What makes it impressive
- Handles four different file types in one pipeline.
- Fingerprinting gives you a reliable evidence index.
- The validate-and-retry loop is a production-grade habit for working with AI output.
- Fully offline, which matters for sensitive material.

## Your 30-second pitch
> "This tool takes a folder of mixed evidence and builds a structured case report entirely offline. It extracts text from images, PDFs, documents and video frames, analyses each with a local model, then merges everything into one validated result and writes a formatted report. It's the same map-reduce approach used for summarising large document sets in law, insurance and compliance."

## Questions you'll likely get, and good answers
**Q: Why offline?**  
A: Evidence is sensitive. Nothing gets uploaded.

**Q: How do you stop the AI making things up?**  
A: Every finding is tied to a fingerprinted source file, and the output has to pass a structure check or it gets retried.

**Q: Where else could this be used?**  
A: Insurance claims, HR investigations, compliance audits, due diligence.

## Words to know
- **OCR**: reading text out of images
- **Map → reduce**: summarise pieces separately, then combine
- **SHA-256 fingerprint**: a unique code that proves a file hasn't changed
- **JSON**: structured data that software can read

## Honest limits (say these before someone else does)
It organises evidence. It isn't legal advice. OCR quality depends on image quality.
