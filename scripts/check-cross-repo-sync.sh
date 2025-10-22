#!/bin/bash
# Check if roadmap initiatives align with actual repos
# Verifies that projects listed in roadmap have corresponding active repositories
# Usage: ./check-cross-repo-sync.sh

set -e

ORG="namastexlabs"
ROADMAP_REPO="automagik-roadmap"

# Define project repos mapping
declare -A PROJECT_REPOS=(
  ["omni"]="automagik-omni"
  ["hive"]="automagik-hive"
  ["spark"]="automagik-spark"
  ["forge"]="automagik-forge"
  ["genie"]="automagik-genie"
  ["tools"]="automagik-tools"
)

echo "=== 🔄 Cross-Repo Sync Checker ==="
echo "=== Checking Roadmap vs Actual Repositories ==="
echo ""

# 1. Check repository accessibility and recent activity
echo "📦 Repository Status Check:"
for project in "${!PROJECT_REPOS[@]}"; do
  repo="${PROJECT_REPOS[$project]}"
  echo ""
  echo "--- Project: $project (Repo: $repo) ---"

  # Check if repo is accessible
  if gh repo view "$ORG/$repo" &>/dev/null; then
    echo "  ✅ Repository accessible"

    # Get last commit date
    LAST_COMMIT=$(gh api repos/$ORG/$repo/commits --jq '.[0].commit.author.date' 2>/dev/null || echo "N/A")
    echo "  📅 Last commit: $LAST_COMMIT"

    # Get open issues count
    OPEN_ISSUES=$(gh api repos/$ORG/$repo/issues?state=open --jq 'length' 2>/dev/null || echo "0")
    echo "  🐛 Open issues: $OPEN_ISSUES"

    # Get open PRs count
    OPEN_PRS=$(gh api repos/$ORG/$repo/pulls?state=open --jq 'length' 2>/dev/null || echo "0")
    echo "  🔀 Open PRs: $OPEN_PRS"

    # Count roadmap initiatives for this project
    INITIATIVES=$(gh issue list --repo $ORG/$ROADMAP_REPO --label "project:$project" --state open --limit 1000 --json number --jq 'length')
    echo "  🎯 Roadmap initiatives: $INITIATIVES"
  else
    echo "  ❌ Repository not accessible or doesn't exist"
    echo "  ⚠️  Warning: Roadmap has initiatives for non-existent repo!"
  fi
done

echo ""
echo "=== 🎯 Roadmap Orphans Check ==="
echo "Checking for initiatives without corresponding active repos..."

# Get all project labels from roadmap
ALL_PROJECTS=$(gh issue list --repo $ORG/$ROADMAP_REPO --label initiative --state open --limit 1000 --json labels \
  --jq '[.[] | .labels[] | select(.name | startswith("project:")) | .name | split(":")[1]] | unique | .[]')

for project in $ALL_PROJECTS; do
  if [[ ! -v PROJECT_REPOS[$project] ]]; then
    echo "  ⚠️  Warning: Project '$project' in roadmap but no known repository mapping"
  fi
done

echo ""
echo "=== 🔍 Cross-Project Dependencies ==="
CROSS_PROJECT=$(gh issue list --repo $ORG/$ROADMAP_REPO --label "project:cross-project" --state open --json number,title,labels)
CROSS_COUNT=$(echo "$CROSS_PROJECT" | jq 'length')

if [ "$CROSS_COUNT" -gt 0 ]; then
  echo "Found $CROSS_COUNT cross-project initiatives:"
  echo "$CROSS_PROJECT" | jq -r '.[] | "  #\(.number) - \(.title)"'
else
  echo "No cross-project initiatives found"
fi

echo ""
echo "=== 📊 Activity Summary by Project ==="
echo "Project | Roadmap Initiatives | Repo Issues | Repo PRs | Last Commit"
echo "--------|---------------------|-------------|----------|-------------"

for project in "${!PROJECT_REPOS[@]}"; do
  repo="${PROJECT_REPOS[$project]}"

  # Get roadmap count
  ROADMAP_COUNT=$(gh issue list --repo $ORG/$ROADMAP_REPO --label "project:$project" --state open --limit 1000 --json number --jq 'length')

  # Get repo stats (suppress errors for inaccessible repos)
  REPO_ISSUES=$(gh api repos/$ORG/$repo/issues?state=open --jq 'length' 2>/dev/null || echo "N/A")
  REPO_PRS=$(gh api repos/$ORG/$repo/pulls?state=open --jq 'length' 2>/dev/null || echo "N/A")
  LAST_COMMIT=$(gh api repos/$ORG/$repo/commits --jq '.[0].commit.author.date[:10]' 2>/dev/null || echo "N/A")

  printf "%-7s | %-19s | %-11s | %-8s | %s\n" "$project" "$ROADMAP_COUNT" "$REPO_ISSUES" "$REPO_PRS" "$LAST_COMMIT"
done

echo ""
echo "✅ Cross-Repo Sync Check Complete!"
