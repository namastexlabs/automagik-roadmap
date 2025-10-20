#!/bin/bash
# Check all repository activity across all branches
# Usage: ./check-repo-activity.sh owner/repo [days]
# Example: ./check-repo-activity.sh namastexlabs/automagik-genie 7

REPO=$1
DAYS=${2:-7}

if [ -z "$REPO" ]; then
  echo "Usage: $0 owner/repo [days]"
  echo "Example: $0 namastexlabs/automagik-genie 7"
  exit 1
fi

echo "=== Repository: $REPO ==="
echo "=== Checking last $DAYS days ==="
echo ""

# 1. Get recent events (captures activity across all branches)
echo "📊 Recent Push Events (All Branches):"
gh api repos/$REPO/events --jq ".[] | select(.type == \"PushEvent\") | {
  date: .created_at,
  author: .actor.login,
  branch: (.payload.ref | split(\"/\") | .[-1]),
  commits: (.payload.commits | length)
}" | head -20

echo ""
echo "🌿 All Branches:"
gh api repos/$REPO/branches --paginate --jq '.[].name' | head -20

echo ""
echo "🔥 Most Active Branches (by recent commits):"
for branch in $(gh api repos/$REPO/branches --paginate --jq '.[].name' | head -10); do
  count=$(gh api repos/$REPO/commits?sha=$branch --jq 'length' 2>/dev/null)
  latest=$(gh api repos/$REPO/commits?sha=$branch --jq '.[0].commit.author.date' 2>/dev/null)
  echo "$branch: $count commits (latest: $latest)"
done

echo ""
echo "✅ Done checking $REPO"
