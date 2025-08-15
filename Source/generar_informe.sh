#!/bin/bash
pandoc informeSource.md -o informeSource.pdf \
  --from markdown \
  --pdf-engine=xelatex \
  -V geometry:margin=2.5cm \
  -V fontsize=12pt \
  -V colorlinks=true \
  -V linkcolor=blue

echo "✅ Informe exportado como informeSource.pdf"
