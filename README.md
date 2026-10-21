# Offline Case Analyzer

> 📘 New here? Start with **[READ_THIS_OVERVIEW.md](READ_THIS_OVERVIEW.md)** for a plain-English walkthrough.

Point it at a folder of mixed evidence — screenshots, PDFs, Word files, video — and get a structured case report, fully offline.

## Workflow

![Workflow diagram](docs/workflow.png)

> **Diagram key:** blue = input · purple = AI model · grey = processing · amber = storage · red = safety / guard rail · green = output

<details><summary>Diagram source (renders on GitHub)</summary>

```mermaid
flowchart TD
  IN([Case folder · scanned recursively]):::input --> SC[Collect every file + SHA-256 fingerprint]:::step
  SC --> IM[Images<br/>OCR]:::step & PD[PDFs<br/>text]:::step & DX[Word docs<br/>text]:::step & VD[Video<br/>key frames + OCR]:::step
  IM & PD & DX & VD --> A1[[Local LLM · analyse each evidence type]]:::ai
  A1 --> SY[[Local LLM · merge into one structured result]]:::ai
  SY --> V{Valid JSON?}:::guard
  V -->|no · retry up to 3×| SY
  V -->|yes| RW([Word report · timeline · parties · issues · evidence index]):::output
  V -->|yes| RJ([JSON report]):::output

  classDef input fill:#e8f1ff,stroke:#3b82f6,color:#0b2a5b,stroke-width:1.5px
  classDef ai fill:#f1e8ff,stroke:#8b5cf6,color:#2e1065,stroke-width:1.5px
  classDef step fill:#f4f4f5,stroke:#71717a,color:#18181b,stroke-width:1.2px
  classDef store fill:#fff6e0,stroke:#d97706,color:#5a3300,stroke-width:1.2px
  classDef output fill:#e7f8ee,stroke:#16a34a,color:#073b1c,stroke-width:1.5px
  classDef guard fill:#ffecec,stroke:#dc2626,color:#5c0a0a,stroke-width:1.2px
```
</details>

## What it does
- Walks a case folder and fingerprints every file so the report can reference exact evidence.
- Extracts text from images (OCR), PDFs, Word documents and frames pulled from video.
- Runs a local model over each evidence type, then a second pass that merges everything into one structured result.
- Validates the model's output before writing a formatted Word report and a JSON copy.
- Nothing leaves the machine — no cloud API.

## What this project demonstrates
- Multi-modal document pipeline (OCR, PDF, DOCX, video frames)
- Two-stage LLM map → reduce summarisation
- Strict JSON extraction from model output
- Automated report generation

## Quick start
1. Install Ollama and a model (default `llama3.2`), plus the Tesseract OCR program.
2. `pip install -r requirements.txt`
3. `python case_analyzer.py --case-folder ./MyCase --case-name "My case"`

## Project layout
```
case_analyzer.py   ← whole pipeline
run_case_analyzer.sh
```

## Notes
Produces an organised summary to help prepare for a lawyer — not legal advice.

## License
MIT — see [LICENSE](LICENSE).
