#!/bin/bash

# Usage: ./make_chapters.sh 5  → creates 001.md to 005.md

if [ -z "$1" ]; then
  echo "❌ Please specify the number of chapters to create."
  echo "   Example: ./make_chapters.sh 10"
  exit 1
fi

count=$1

for i in $(seq -f "%03g" 1 "$count"); do
  file="$i.md"
  if [ ! -f "$file" ]; then
    touch "$file"
    echo "✅ Created: $file"
  else
    echo "⚠️  Exists:  $file"
  fi
done
