#!/bin/bash

# Load configuration
CONFIG_FILE="book.conf"
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  echo "❌ Config file '$CONFIG_FILE' not found."
  exit 1
fi

# Fallbacks if variables missing
TITLE=${TITLE:-"Untitled"}
AUTHOR=${AUTHOR:-"Anonymous"}
OUTPUT=${OUTPUT:-"output.epub"}
COVER=${COVER:-""}
CSS=${CSS:-""}
rm "$OUTPUT"
# Find and sort markdown files
CHAPTERS=$(ls [0-9][0-9][0-9]*.md | sort)
APPENDICES=$(ls A[0-9][0-9][0-9]*.md | sort)

echo "📚 Detected chapters:"
for file in $CHAPTERS; do
  title=$(grep -m 1 '^# ' "$file" | sed 's/^# //')
  printf " - %s → %s\n" "$file" "$title"
done

echo "📚 Detected appendices:"
for file in $APPENDICES; do
  title=$(grep -m 1 '^# ' "$file" | sed 's/^# //')
  printf " - %s → %s\n" "$file" "$title"
done


# Build pandoc command
CMD="pandoc $PRE $CHAPTERS $APPENDICES $POST -o \"$OUTPUT\" --toc"
CMD+=" --metadata title=\"$TITLE\""
CMD+=" --metadata author=\"$AUTHOR\""

# Include cover if present
if [ -f "$COVER" ]; then
  CMD+=" --epub-cover-image=\"$COVER\""
  echo "✅ Using cover image: $COVER"
fi

# Include CSS if present
if [ -f "$CSS" ]; then
  CMD+=" --css=\"$CSS\"" # --standalone"
  echo "✅ Using stylesheet: $CSS"
fi

# Execute
echo "📘 Generating EPUB: $OUTPUT"
eval $CMD

# Result
if [ -f "$OUTPUT" ]; then
  echo "🎉 EPUB created successfully: $OUTPUT"
else
  echo "❌ Something went wrong."
fi
