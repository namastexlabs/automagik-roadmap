#!/bin/bash
# Check roadmap project board health and completeness
# Usage: ./check-board-health.sh [--stale-days 30]
# Requires: GITHUB_TOKEN with read:project, read:org permissions

set -e

STALE_DAYS=${2:-30}
ORG="namastexlabs"
REPO="automagik-roadmap"
PROJECT_NUMBER=9

echo "=== 🏥 Roadmap Board Health Check ==="
echo "=== Organization: $ORG ==="
echo "=== Project #$PROJECT_NUMBER ==="
echo ""

# 1. Count initiatives by stage
echo "📊 Initiative Distribution by Stage:"
gh issue list --repo $ORG/$REPO --label initiative --state all --limit 1000 --json labels \
  --jq '[.[] | .labels[] | select(.name | startswith("stage:")) | .name] | group_by(.) | map({stage: .[0], count: length}) | .[]' \
  | jq -r '. | "\(.stage): \(.count)"' | sort

echo ""
echo "📈 Priority Distribution:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json labels \
  --jq '[.[] | .labels[] | select(.name | startswith("priority:")) | .name] | group_by(.) | map({priority: .[0], count: length}) | .[]' \
  | jq -r '. | "\(.priority): \(.count)"' | sort -r

echo ""
echo "🎯 Project Distribution:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json labels \
  --jq '[.[] | .labels[] | select(.name | startswith("project:")) | .name] | group_by(.) | map({project: .[0], count: length}) | .[]' \
  | jq -r '. | "\(.project): \(.count)"' | sort

echo ""
echo "⚠️  Issues Missing Critical Labels:"

# Missing priority
MISSING_PRIORITY=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | startswith("priority:")] | any | not)] | length')
echo "  - Missing priority: $MISSING_PRIORITY issues"

# Missing stage
MISSING_STAGE=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | startswith("stage:")] | any | not)] | length')
echo "  - Missing stage: $MISSING_STAGE issues"

# Missing project
MISSING_PROJECT=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | startswith("project:")] | any | not)] | length')
echo "  - Missing project: $MISSING_PROJECT issues"

# Missing quarter
MISSING_QUARTER=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | startswith("quarter:")] | any | not)] | length')
echo "  - Missing quarter/ETA: $MISSING_QUARTER issues"

echo ""
echo "🕒 Stale Initiatives (no activity in $STALE_DAYS days):"
CUTOFF_DATE=$(date -d "$STALE_DAYS days ago" +%Y-%m-%d 2>/dev/null || date -v-${STALE_DAYS}d +%Y-%m-%d 2>/dev/null)
gh issue list --repo $ORG/$REPO --label initiative,stage:Executing --state open --limit 1000 --json number,title,updatedAt \
  --jq '[.[] | select(.updatedAt[:10] < "'$CUTOFF_DATE'")] | .[] | "#\(.number) - \(.title) (Updated: \(.updatedAt[:10]))"' \
  | head -10

echo ""
echo "🎉 Recent Activity (last 7 days):"
RECENT_DATE=$(date -d "7 days ago" +%Y-%m-%d 2>/dev/null || date -v-7d +%Y-%m-%d 2>/dev/null)
gh issue list --repo $ORG/$REPO --label initiative --state all --limit 20 --json number,title,updatedAt,state \
  --jq '[.[] | select(.updatedAt[:10] >= "'$RECENT_DATE'")] | .[] | "#\(.number) - \(.title) (\(.state | ascii_upcase))"' \
  | head -10

echo ""
echo "🚀 Currently Executing:"
gh issue list --repo $ORG/$REPO --label initiative,stage:Executing --state open --limit 50 --json number,title,labels \
  --jq '.[] | "#\(.number) - \(.title) [Priority: \([.labels[] | select(.name | startswith("priority:")) | .name] | join(", "))]"'

echo ""
echo "✅ Health Check Complete!"
