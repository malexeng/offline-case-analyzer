#!/bin/bash
# ── FULLY AUTOMATED LEGAL CASE ANALYZER LAUNCHER ──

set -e

CASE_FOLDER="$HOME/Agent_Library/Case_Analyzer/evidence"
OUTPUT_JSON="$HOME/Agent_Library/Case_Analyzer/case_report.json"
OUTPUT_DOCX="$HOME/Agent_Library/Case_Analyzer/case_report.docx"

# 1️⃣ Check python3
if ! command -v python3 &>/dev/null; then
    echo "❌ python3 not found. Install it first."
    exit 1
fi

# 2️⃣ Create venv if not exists
VENV="$HOME/Agent_Library/Case_Analyzer/venv"
if [ ! -d "$VENV" ]; then
    echo "⚡ Creating virtual environment..."
    python3 -m venv "$VENV"
fi
source "$VENV/bin/activate"

# 3️⃣ Upgrade pip & install packages
echo "⚡ Installing required packages..."
pip install --upgrade pip
pip install --upgrade anthropic python-docx Pillow pymupdf opencv-python

# 4️⃣ Run the Python analysis
python3 - <<'PYTHON_EOF'
import os
from pathlib import Path
from case_analyzer import EvidenceCollector, CaseAnalyzer, ReportGenerator, save_json_report

case_folder = os.path.expanduser(os.environ.get("CASE_FOLDER", "$HOME/Agent_Library/Case_Analyzer/evidence"))
collector = EvidenceCollector(case_folder)
evidence = collector.scan()

api_key = os.environ.get("ANTHROPIC_API_KEY")
if not api_key:
    raise ValueError("Set your ANTHROPIC_API_KEY in environment variables!")

analyzer = CaseAnalyzer(api_key=api_key)

image_results = analyzer.analyze_images(evidence["images"])
doc_results   = analyzer.analyze_documents(evidence["documents"])
video_results = analyzer.analyze_videos(evidence["videos"])

synthesis = analyzer.synthesize_case(
    case_name="Sample Case",
    case_description="Automated analysis run.",
    image_analysis=image_results,
    doc_analysis=doc_results,
    video_analysis=video_results,
    victim_name="The Complainant"
)

# Save JSON
save_json_report(synthesis, os.path.expanduser(os.environ.get("OUTPUT_JSON", "$HOME/Agent_Library/Case_Analyzer/case_report.json")))

# Generate DOCX report
report_gen = ReportGenerator()
report_gen.generate(
    "Sample Case",
    synthesis,
    os.path.expanduser(os.environ.get("OUTPUT_DOCX", "$HOME/Agent_Library/Case_Analyzer/case_report.docx")),
    image_analysis_raw=image_results,
    doc_analysis_raw=doc_results
)
PYTHON_EOF

echo "✅ Full automation complete!"
echo "   JSON: $OUTPUT_JSON"
echo "   DOCX: $OUTPUT_DOCX"
