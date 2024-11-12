#!/usr/bin/env bash

DIR=${1:-/}

echo "Storage Usage Analysis for: $DIR"
echo "---------------------------------"

echo "1. Disk Space Summary:"
df -h "$DIR"
echo

echo "2. Top 10 Largest Directories:"
du -h "$DIR" 2>/dev/null | sort -hr | head -n 10
echo

echo "3. Top 10 Largest Files:"
find "$DIR" -type f -exec du -h {} + 2>/dev/null | sort -hr | head -n 10
echo

echo "4. Directory Size Summary (level 1):"
du -h --max-depth=1 "$DIR" 2>/dev/null | sort -hr
echo

echo "Analysis Complete!"
