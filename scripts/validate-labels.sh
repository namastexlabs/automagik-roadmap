#!/bin/bash
# Validate label consistency across roadmap initiatives
# Checks for invalid combinations, missing required labels, and deprecated labels
# Usage: ./validate-labels.sh

set -e

ORG="namastexlabs"
REPO="automagik-roadmap"

echo "=== 🏷️  Label Consistency Validator ==="
echo "=== Repository: $ORG/$REPO ==="
echo ""

# Define valid label prefixes (from .github/labels.yml)
VALID_PROJECTS=("omni" "hive" "spark" "forge" "genie" "tools" "cross-project")
VALID_STAGES=("Wishlist" "Exploring" "RFC" "Prioritization" "Executing" "Preview" "Shipped" "Archived")
VALID_PRIORITIES=("critical" "high" "medium" "low")
VALID_TYPES=("feature" "enhancement" "research" "infrastructure" "documentation" "bug-initiative")
VALID_AREAS=("api" "cli" "ui" "mcp" "agents" "orchestration" "database" "authentication" "performance" "security" "testing" "deployment" "documentation" "monitoring" "integration")

# 1. Check for initiatives missing required labels
echo "🔍 Checking Required Labels..."
echo ""

echo "❌ Issues Missing 'initiative' Label:"
gh issue list --repo $ORG/$REPO --state all --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name] | index("initiative") | not)] | .[] | "#\(.number) - \(.title)"' \
  | head -5

echo ""
echo "⚠️  Initiatives Missing Critical Labels:"

# Missing project label
echo ""
echo "📦 Missing Project Label:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | startswith("project:")] | any | not)] | .[] | "  #\(.number) - \(.title)"' \
  | head -5

# Missing stage label
echo ""
echo "🎭 Missing Stage Label:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | test("^(Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped|Archived)$")] | any | not)] | .[] | "  #\(.number) - \(.title)"' \
  | head -5

# Missing priority label
echo ""
echo "🎯 Missing Priority Label:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | startswith("priority:")] | any | not)] | .[] | "  #\(.number) - \(.title)"' \
  | head -5

# Missing type label
echo ""
echo "🔖 Missing Type Label:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | startswith("type:")] | any | not)] | .[] | "  #\(.number) - \(.title)"' \
  | head -5

echo ""
echo "🔄 Checking for Invalid Label Combinations..."

# Initiatives with multiple stage labels (should only have one)
echo ""
echo "⚠️  Multiple Stage Labels (Should Only Have One):"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | test("^(Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped|Archived)$")] | length > 1)] | .[] | "  #\(.number) - \(.title): \([.labels[].name | select(test("^(Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped|Archived)$"))] | join(", "))"' \
  | head -5

# Initiatives with multiple priority labels (should only have one)
echo ""
echo "⚠️  Multiple Priority Labels (Should Only Have One):"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | startswith("priority:")] | length > 1)] | .[] | "  #\(.number) - \(.title): \([.labels[].name | select(startswith("priority:"))] | join(", "))"' \
  | head -5

echo ""
echo "🔍 Checking for Unknown/Invalid Labels..."

# Get all labels used in initiatives
ALL_LABELS=$(gh issue list --repo $ORG/$REPO --label initiative --state all --limit 1000 --json labels \
  --jq '[.[].labels[].name] | unique | .[]')

echo ""
echo "⚠️  Potentially Invalid Area Labels (not in standard list):"
echo "$ALL_LABELS" | grep '^area:' | while read label; do
  area="${label#area:}"
  valid=false
  for valid_area in "${VALID_AREAS[@]}"; do
    if [ "$area" == "$valid_area" ]; then
      valid=true
      break
    fi
  done
  if [ "$valid" == "false" ]; then
    echo "  - $label (Consider adding to .github/labels.yml or removing)"
  fi
done

echo ""
echo "📊 Label Usage Statistics:"
echo ""
echo "Most Common Area Labels:"
gh issue list --repo $ORG/$REPO --label initiative --state all --limit 1000 --json labels \
  --jq '[.[].labels[] | select(.name | startswith("area:")) | .name] | group_by(.) | map({label: .[0], count: length}) | sort_by(.count) | reverse | .[:10][] | "  \(.label): \(.count) issues"'

echo ""
echo "Most Common Type Labels:"
gh issue list --repo $ORG/$REPO --label initiative --state all --limit 1000 --json labels \
  --jq '[.[].labels[] | select(.name | startswith("type:")) | .name] | group_by(.) | map({label: .[0], count: length}) | sort_by(.count) | reverse | .[] | "  \(.label): \(.count) issues"'

echo ""
echo "✅ Label Validation Complete!"
echo ""
echo "💡 Tip: Run './scripts/check-board-health.sh' for overall board health"
