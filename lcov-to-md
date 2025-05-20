#!/bin/bash

LCOV_FILE="coverage.lcov"
OUTPUT_FILE="COVERAGE.md"

# Git info
BRANCH=${SEMAPHORE_GIT_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
COMMIT=$(git rev-parse HEAD)
AUTHOR=$(git log -1 --pretty=format:'%an')
DATE=$(git log -1 --pretty=format:'%ad')
MESSAGE=$(git log -1 --pretty=format:'%s')
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD)

# Temp file for sorting
TMP_FILE=$(mktemp)

OVERALL_TOTAL=0
OVERALL_COVERED=0
CURRENT_FILE=""
FILE_TOTAL=0
FILE_COVERED=0

while IFS= read -r line; do
  case "$line" in
    SF:*)
      CURRENT_FILE=$(basename "${line#SF:}")
      FILE_TOTAL=0
      FILE_COVERED=0
      ;;
    DA:*)
      count=$(echo "$line" | cut -d',' -f2)
      FILE_TOTAL=$((FILE_TOTAL + 1))
      OVERALL_TOTAL=$((OVERALL_TOTAL + 1))
      if [ "$count" -gt 0 ]; then
        FILE_COVERED=$((FILE_COVERED + 1))
        OVERALL_COVERED=$((OVERALL_COVERED + 1))
      fi
      ;;
    end_of_record)
      if [ -n "$CURRENT_FILE" ]; then
        if [ "$FILE_TOTAL" -gt 0 ]; then
          percent=$(awk "BEGIN { printf \"%.2f\", ($FILE_COVERED/$FILE_TOTAL)*100 }")
        else
          percent="0.00"
        fi
        printf "%07.2f|%s|%d|%d\n" "$percent" "$CURRENT_FILE" "$FILE_COVERED" "$FILE_TOTAL" >> "$TMP_FILE"
      fi
      ;;
  esac
done < "$LCOV_FILE"

if [ "$OVERALL_TOTAL" -gt 0 ]; then
  OVERALL_COVERAGE=$(awk "BEGIN { printf \"%.2f\", ($OVERALL_COVERED/$OVERALL_TOTAL)*100 }")
else
  OVERALL_COVERAGE="0.00"
fi

# Write markdown report
{
  echo "# 📈 Code Coverage Report"
  echo
  echo "## 🔧 Commit Info"
  echo "- **Branch**: \`$BRANCH\`"
  echo "- **Commit**: \`$COMMIT\`"
  echo "- **Author**: $AUTHOR"
  echo "- **Date**: $DATE"
  echo "- **Message**: _${MESSAGE}_"
  echo
  echo "---"
  echo
  echo "## 🧵 Workflow Debug Info"
  echo
  echo "| Variable | Value |"
  echo "|----------|-------|"
  for var in SEMAPHORE_GIT_BRANCH SEMAPHORE_GIT_COMMITTER SEMAPHORE_JOB_ID SEMAPHORE_PROJECT_NAME SEMAPHORE_PIPELINE_ID SEMAPHORE_WORKFLOW_ID SEMAPHORE_GIT_SHA SEMAPHORE_GIT_REPO_NAME; do
    val="${!var}"
    echo "| \`$var\` | \`$val\` |"
  done
  echo
  echo "---"
  echo
  echo "## 📝 Changed Files"
  echo
  echo '```diff'
  for file in $CHANGED_FILES; do echo "+ $file"; done
  echo '```'
  echo
  echo "---"
  echo
  echo "## 🔍 Per-File Coverage"
  echo
  echo "| File | Coverage | Visual |"
  echo "|------|----------|--------|"

  sort "$TMP_FILE" | while IFS='|' read -r padded file covered total; do
    percent=$(echo "$padded" | sed 's/^0*//')
    bar_len=20
    filled=$(awk "BEGIN { printf \"%d\", ($percent/100)*$bar_len }")
    empty=$((bar_len - filled))
    filled_bar=$(yes '🟩' | head -n "$filled" | tr -d '\n')
    empty_bar=$(yes '⬜' | head -n "$empty" | tr -d '\n')
    echo "| \`$file\` | $percent% ($covered/$total) | $filled_bar$empty_bar |"
  done

  echo
  echo "---"
  echo
  echo "## 📊 Total Coverage"
  echo "**$OVERALL_COVERED / $OVERALL_TOTAL → $OVERALL_COVERAGE%**"
} > "$OUTPUT_FILE"

rm -f "$TMP_FILE"

echo "✅ Report saved to $OUTPUT_FILE"
