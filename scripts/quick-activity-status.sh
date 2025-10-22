#!/bin/bash
# Quick Activity Status - Fast snapshot of latest commits across all repos
# Usage: ./quick-activity-status.sh [days]

set -e

ORG="namastexlabs"
DAYS=${1:-7}

# Define all automagik repos
declare -a REPOS=("automagik-omni" "automagik-hive" "automagik-spark" "automagik-forge" "automagik-genie" "automagik-tools" "automagik-roadmap")

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        🚀 QUICK ACTIVITY STATUS - Last $DAYS Days             ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "⏰ $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

CUTOFF_DATE=$(date -d "$DAYS days ago" +%Y-%m-%d 2>/dev/null || date -v-${DAYS}d +%Y-%m-%d 2>/dev/null)

echo "Repo                | Last Commit | Author           | Branch      | Open PRs | Open Issues"
echo "--------------------+-------------+------------------+-------------+----------+-------------"

for repo in "${REPOS[@]}"; do
  # Get latest commit info (faster than checking all branches)
  latest=$(gh api repos/$ORG/$repo/commits?per_page=1 --jq '.[0] | {
    date: .commit.author.date[:10],
    author: .commit.author.name[:15],
    branch: "default"
  }' 2>/dev/null || echo '{"date":"N/A","author":"N/A","branch":"N/A"}')

  date=$(echo "$latest" | jq -r '.date')
  author=$(echo "$latest" | jq -r '.author')
  branch=$(echo "$latest" | jq -r '.branch')

  # Get PR and issue counts (parallel would be better but keeping simple)
  prs=$(gh api repos/$ORG/$repo/pulls?state=open --jq 'length' 2>/dev/null || echo "0")
  issues=$(gh api repos/$ORG/$repo/issues?state=open --jq 'length' 2>/dev/null || echo "0")

  # Format output
  repo_short=$(echo "$repo" | sed 's/automagik-//')
  printf "%-19s | %-11s | %-16s | %-11s | %-8s | %-11s\n" "$repo_short" "$date" "$author" "$branch" "$prs" "$issues"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔥 Latest Commit Per Repo (Last $DAYS Days)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for repo in "${REPOS[@]}"; do
  # Get latest commit with message
  commit_info=$(gh api repos/$ORG/$repo/commits?per_page=1 --jq '.[0] | {
    date: .commit.author.date,
    author: .commit.author.name,
    message: .commit.message,
    sha: .sha[:7]
  }' 2>/dev/null)

  if [ -n "$commit_info" ]; then
    date=$(echo "$commit_info" | jq -r '.date[:16]')
    author=$(echo "$commit_info" | jq -r '.author')
    message=$(echo "$commit_info" | jq -r '.message' | head -1)
    sha=$(echo "$commit_info" | jq -r '.sha')

    repo_short=$(echo "$repo" | sed 's/automagik-//')

    # Only show if within time range
    commit_date=$(echo "$commit_info" | jq -r '.date[:10]')
    if [[ "$commit_date" > "$CUTOFF_DATE" ]] || [[ "$commit_date" == "$CUTOFF_DATE" ]]; then
      echo "📦 $repo_short"
      echo "   [$sha] $date by $author"
      echo "   $message"
      echo ""
    fi
  fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌿 Active Feature Branches (Last $DAYS Days)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for repo in "${REPOS[@]}"; do
  # Get recent push events to see all branch activity
  events=$(gh api repos/$ORG/$repo/events?per_page=30 --jq '[.[] | select(.type == "PushEvent")] | group_by(.payload.ref) | .[] | {
    branch: (.[0].payload.ref | split("/") | .[-1]),
    last_push: .[0].created_at[:16],
    author: .[0].actor.login,
    commits: (.[0].payload.commits | length)
  }' 2>/dev/null)

  if [ -n "$events" ]; then
    branches=$(echo "$events" | jq -s 'add' 2>/dev/null)

    if [ -n "$branches" ] && [ "$branches" != "null" ]; then
      repo_short=$(echo "$repo" | sed 's/automagik-//')

      # Filter out main/master branches
      active=$(echo "$branches" | jq -r '.[] | select(.branch != "main" and .branch != "master" and .branch != "dev") | "  🌱 \(.branch) - Last push: \(.last_push) by @\(.author)"' 2>/dev/null | head -5)

      if [ -n "$active" ]; then
        echo "📦 $repo_short"
        echo "$active"
        echo ""
      fi
    fi
  fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Status Check Complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 Tips:"
echo "  - Different time range: ./quick-activity-status.sh 14"
echo "  - Full dashboard: ./live-activity-dashboard.sh 7"
echo "  - Single repo: ./check-repo-activity.sh namastexlabs/automagik-genie 7"
echo ""
