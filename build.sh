#!/bin/bash
set -e

# Generate documentation
echo "Generating documentation..."
./docs.exe src/SUMMARY.md \
  -o book \
  --index src/index.html \
  --favicon assets/Favicon256.png \
  --logo assets/Logo512.png \
  --description "Chemical Programming Language Documentation - A modern systems programming language" \
  --author "Chemical Lang Team" \
  --keywords "chemical,programming,language,compiler,systems,documentation"

echo "Documentation built successfully in ./book"
