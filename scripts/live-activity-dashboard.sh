#!/bin/bash
# Live Activity Dashboard - Real-time view of all repos and branches
# Shows latest commits, active branches, and ongoing work across the ecosystem
# Usage: ./live-activity-dashboard.sh [days] [--detailed]

set -e

ORG="namastexlabs"
DAYS=${1:-7}
DETAILED=""

# Check for --detailed flag
for arg in "$@"; do
  if [ "$arg" == "--detailed" ]; then
    DETAILED="true"
  fi
done

# Define all automagik repos
declare -A REPOS=(
  ["omni"]="automagik-omni"
  ["hive"]="automagik-hive"
  ["spark"]="automagik-spark"
  ["forge"]="automagik-forge"
  ["genie"]="automagik-genie"
  ["tools"]="automagik-tools"
  ["roadmap"]="automagik-roadmap"
)

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║     🔴 LIVE: AUTOMAGIK ECOSYSTEM ACTIVITY DASHBOARD           ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "📅 Time Range: Last $DAYS days"
echo "⏰ Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Calculate cutoff date
CUTOFF_DATE=$(date -d "$DAYS days ago" +%Y-%m-%d 2>/dev/null || date -v-${DAYS}d +%Y-%m-%d 2>/dev/null)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 QUICK STATS - Last $DAYS Days"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

total_commits=0
total_prs=0
total_issues=0
active_repos=0

for project in "${!REPOS[@]}"; do
  repo="${REPOS[$project]}"

  # Count recent commits on default branch
  recent_commits=$(gh api repos/$ORG/$repo/commits --jq --arg cutoff "$CUTOFF_DATE" '[.[] | select(.commit.author.date[:10] >= $cutoff)] | length' 2>/dev/null || echo "0")

  # Count open PRs
  open_prs=$(gh api repos/$ORG/$repo/pulls?state=open --jq 'length' 2>/dev/null || echo "0")

  # Count recent issues
  recent_issues=$(gh api repos/$ORG/$repo/issues?state=open --jq --arg cutoff "$CUTOFF_DATE" '[.[] | select(.created_at[:10] >= $cutoff)] | length' 2>/dev/null || echo "0")

  total_commits=$((total_commits + recent_commits))
  total_prs=$((total_prs + open_prs))
  total_issues=$((total_issues + recent_issues))

  if [ "$recent_commits" -gt 0 ]; then
    active_repos=$((active_repos + 1))
  fi
done

echo "📈 Total commits (last $DAYS days): $total_commits"
echo "🔀 Total open PRs: $total_prs"
echo "🐛 Total new issues: $total_issues"
echo "✅ Active repositories: $active_repos/${#REPOS[@]}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔥 LATEST COMMITS (All Repos, All Branches)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Get latest commits across all repos (sorted by date)
declare -a all_commits=()

for project in "${!REPOS[@]}"; do
  repo="${REPOS[$project]}"

  # Get recent push events to capture all branch activity
  events=$(gh api repos/$ORG/$repo/events --jq --arg cutoff "$CUTOFF_DATE" '[.[] | select(.type == "PushEvent" and .created_at[:10] >= $cutoff)] | .[:5][] | {
    repo: "'$project'",
    date: .created_at,
    author: .actor.login,
    branch: (.payload.ref | split("/") | .[-1]),
    commits: (.payload.commits | length),
    message: (.payload.commits[0].message // "No message")
  }' 2>/dev/null || echo "")

  if [ -n "$events" ]; then
    all_commits+=("$events")
  fi
done

# Display latest commits (last 20)
echo "${all_commits[@]}" | jq -s 'add | sort_by(.date) | reverse | .[:20][] | "[\(.repo)] \(.date[:16]) @\(.author) → \(.branch) (\(.commits) commit\(if .commits == 1 then "" else "s" end))\n  \(.message[:80])"' -r 2>/dev/null || echo "No recent commits found"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌿 ACTIVE BRANCHES (Non-Default Branches with Recent Activity)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for project in "${!REPOS[@]}"; do
  repo="${REPOS[$project]}"

  # Get default branch
  default_branch=$(gh api repos/$ORG/$repo --jq '.default_branch' 2>/dev/null || echo "main")

  # Get all branches
  branches=$(gh api repos/$ORG/$repo/branches --paginate --jq '.[].name' 2>/dev/null)

  if [ -z "$branches" ]; then
    continue
  fi

  active_branches=()

  # Check each non-default branch for recent activity
  for branch in $branches; do
    if [ "$branch" == "$default_branch" ]; then
      continue
    fi

    # Get latest commit on branch
    latest_commit=$(gh api repos/$ORG/$repo/commits?sha=$branch --jq '.[0] | {date: .commit.author.date, author: .commit.author.name, message: .commit.message}' 2>/dev/null)

    if [ -n "$latest_commit" ]; then
      commit_date=$(echo "$latest_commit" | jq -r '.date[:10]')

      # Check if commit is within our time range
      if [[ "$commit_date" > "$CUTOFF_DATE" ]] || [[ "$commit_date" == "$CUTOFF_DATE" ]]; then
        author=$(echo "$latest_commit" | jq -r '.author')
        message=$(echo "$latest_commit" | jq -r '.message[:60]')
        active_branches+=("  🌱 $branch @ $commit_date by $author\n     \"$message\"")
      fi
    fi
  done

  # Print if has active branches
  if [ ${#active_branches[@]} -gt 0 ]; then
    echo ""
    echo "📦 $project (${REPOS[$project]}):"
    printf '%b\n' "${active_branches[@]}"
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔀 OPEN PULL REQUESTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for project in "${!REPOS[@]}"; do
  repo="${REPOS[$project]}"

  prs=$(gh pr list --repo $ORG/$repo --json number,title,author,createdAt,updatedAt,headRefName --jq '.[] | "  #\(.number) [\(.headRefName)] \(.title)\n     by @\(.author.login) | Created: \(.createdAt[:10]) | Updated: \(.updatedAt[:10])"' 2>/dev/null)

  if [ -n "$prs" ]; then
    echo ""
    echo "📦 $project:"
    echo "$prs"
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👥 CONTRIBUTOR ACTIVITY (Last $DAYS Days)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Aggregate contributor stats
declare -A contributor_commits
declare -A contributor_repos

for project in "${!REPOS[@]}"; do
  repo="${REPOS[$project]}"

  # Get recent commits and authors
  commits=$(gh api repos/$ORG/$repo/commits --jq --arg cutoff "$CUTOFF_DATE" '[.[] | select(.commit.author.date[:10] >= $cutoff)] | .[] | .commit.author.name' 2>/dev/null || echo "")

  if [ -n "$commits" ]; then
    while IFS= read -r author; do
      if [ -n "$author" ]; then
        contributor_commits["$author"]=$((${contributor_commits["$author"]:-0} + 1))

        # Track which repos they contributed to
        if [[ ! "${contributor_repos[$author]}" =~ "$project" ]]; then
          contributor_repos["$author"]="${contributor_repos[$author]} $project"
        fi
      fi
    done <<< "$commits"
  fi
done

# Sort and display top contributors
for author in "${!contributor_commits[@]}"; do
  echo "${contributor_commits[$author]} $author ${contributor_repos[$author]}"
done | sort -rn | head -10 | while read count author repos; do
  echo "  👤 $author: $count commits across ($repos )"
done

if [ -n "$DETAILED" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 DETAILED: Repository Status"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  for project in "${!REPOS[@]}"; do
    repo="${REPOS[$project]}"

    echo ""
    echo "📦 $project (${REPOS[$project]})"

    # Default branch
    default_branch=$(gh api repos/$ORG/$repo --jq '.default_branch' 2>/dev/null || echo "main")
    echo "   Default branch: $default_branch"

    # Total branches
    branch_count=$(gh api repos/$ORG/$repo/branches --paginate --jq 'length' 2>/dev/null || echo "0")
    echo "   Total branches: $branch_count"

    # Stars, forks
    stats=$(gh api repos/$ORG/$repo --jq '{stars: .stargazers_count, forks: .forks_count, open_issues: .open_issues_count}' 2>/dev/null)
    echo "   $(echo $stats | jq -r 'to_entries | .[] | "  \(.key): \(.value)"')"

    # Latest release
    latest_release=$(gh api repos/$ORG/$repo/releases/latest --jq '.tag_name' 2>/dev/null || echo "No releases")
    echo "   Latest release: $latest_release"
  done
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    ✅ DASHBOARD COMPLETE                      ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "💡 Tips:"
echo "  - Run with different time ranges: ./live-activity-dashboard.sh 14"
echo "  - Get detailed stats: ./live-activity-dashboard.sh 7 --detailed"
echo "  - Schedule via cron: */30 * * * * cd ~/roadmap && ./scripts/live-activity-dashboard.sh 1 > /tmp/activity.txt"
echo ""
