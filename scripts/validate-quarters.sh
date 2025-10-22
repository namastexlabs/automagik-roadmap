#!/bin/bash
# Validate quarter/ETA consistency and check for overdue initiatives
# Usage: ./validate-quarters.sh

set -e

ORG="namastexlabs"
REPO="automagik-roadmap"

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_YEAR=$(date +%Y)
CURRENT_MONTH=$(date +%m)

# Determine current quarter
if [ "$CURRENT_MONTH" -le 3 ]; then
  CURRENT_QUARTER="q1"
elif [ "$CURRENT_MONTH" -le 6 ]; then
  CURRENT_QUARTER="q2"
elif [ "$CURRENT_MONTH" -le 9 ]; then
  CURRENT_QUARTER="q3"
else
  CURRENT_QUARTER="q4"
fi

echo "=== 📅 Quarter/ETA Validator ==="
echo "=== Current Date: $CURRENT_DATE ==="
echo "=== Current Quarter: $CURRENT_YEAR-$CURRENT_QUARTER ==="
echo ""

# 1. Check for initiatives missing quarter/ETA
echo "⚠️  Initiatives Missing Quarter/ETA Label:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,labels \
  --jq '[.[] | select([.labels[].name | startswith("quarter:")] | any | not)] | .[] | "  #\(.number) - \(.title)"' \
  | head -10

echo ""
echo "📊 Quarter Distribution (Open Initiatives):"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json labels \
  --jq '[.[] | .labels[] | select(.name | startswith("quarter:")) | .name] | group_by(.) | map({quarter: .[0], count: length}) | sort_by(.quarter) | .[] | "  \(.quarter): \(.count) initiatives"'

echo ""
echo "🔴 Potentially Overdue Initiatives:"
echo "Checking for initiatives in past quarters that are still open..."

# Check past quarters (this is approximate based on quarter labels)
for year in 2024 2025; do
  for q in q1 q2 q3 q4; do
    quarter_label="quarter:$year-$q"

    # Skip future quarters
    if [ "$year" -gt "$CURRENT_YEAR" ]; then
      continue
    fi
    if [ "$year" -eq "$CURRENT_YEAR" ]; then
      case $CURRENT_QUARTER in
        "q1") [[ "$q" =~ ^(q2|q3|q4)$ ]] && continue ;;
        "q2") [[ "$q" =~ ^(q3|q4)$ ]] && continue ;;
        "q3") [[ "$q" == "q4" ]] && continue ;;
      esac
    fi

    # Find initiatives in past quarters still in Executing or Prioritization
    OVERDUE=$(gh issue list --repo $ORG/$REPO --label "$quarter_label" --state open --limit 1000 --json number,title,labels \
      --jq '[.[] | select([.labels[].name] | index("Executing") or index("Prioritization"))] | .[] | "  #\(.number) - \(.title) ['$quarter_label']"' 2>/dev/null || true)

    if [ -n "$OVERDUE" ]; then
      echo ""
      echo "Quarter: $quarter_label"
      echo "$OVERDUE"
    fi
  done
done

echo ""
echo "🎯 Current Quarter Focus ($CURRENT_YEAR-$CURRENT_QUARTER):"
gh issue list --repo $ORG/$REPO --label "quarter:$CURRENT_YEAR-$CURRENT_QUARTER" --state open --limit 1000 --json number,title,labels \
  --jq '.[] | "  #\(.number) - \(.title) [Stage: \([.labels[].name | select(test("^(Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped)$"))] | join(", ")), Priority: \([.labels[].name | select(startswith("priority:"))] | join(", "))]"' \
  | head -15

echo ""
echo "🔮 Next Quarter Preview ($CURRENT_YEAR-q$((${CURRENT_QUARTER:1}+1))):"
NEXT_Q=$((${CURRENT_QUARTER:1}+1))
NEXT_YEAR=$CURRENT_YEAR
if [ "$NEXT_Q" -gt 4 ]; then
  NEXT_Q=1
  NEXT_YEAR=$((CURRENT_YEAR+1))
fi
NEXT_QUARTER="$NEXT_YEAR-q$NEXT_Q"

gh issue list --repo $ORG/$REPO --label "quarter:$NEXT_QUARTER" --state open --limit 1000 --json number,title,labels \
  --jq '.[] | "  #\(.number) - \(.title) [Priority: \([.labels[].name | select(startswith("priority:"))] | join(", "))]"' \
  | head -10

echo ""
echo "📈 Quarter Velocity Analysis:"
echo "Shipped per Quarter (last 4 quarters):"

for offset in 3 2 1 0; do
  # Calculate quarter
  q_num=$((${CURRENT_QUARTER:1}-offset))
  q_year=$CURRENT_YEAR

  while [ "$q_num" -lt 1 ]; do
    q_num=$((q_num+4))
    q_year=$((q_year-1))
  done

  quarter_label="quarter:$q_year-q$q_num"

  SHIPPED_COUNT=$(gh issue list --repo $ORG/$REPO --label "$quarter_label,Shipped" --state all --limit 1000 --json number --jq 'length' 2>/dev/null || echo "0")
  TOTAL_COUNT=$(gh issue list --repo $ORG/$REPO --label "$quarter_label" --state all --limit 1000 --json number --jq 'length' 2>/dev/null || echo "0")

  if [ "$TOTAL_COUNT" -gt 0 ]; then
    COMPLETION_RATE=$(awk "BEGIN {printf \"%.0f\", ($SHIPPED_COUNT/$TOTAL_COUNT)*100}")
    echo "  $quarter_label: $SHIPPED_COUNT/$TOTAL_COUNT shipped ($COMPLETION_RATE%)"
  fi
done

echo ""
echo "🎒 Backlog Items (no specific quarter):"
BACKLOG_COUNT=$(gh issue list --repo $ORG/$REPO --label "quarter:backlog" --state open --limit 1000 --json number --jq 'length' 2>/dev/null || echo "0")
echo "  Total backlog items: $BACKLOG_COUNT"

echo ""
echo "💡 Recommendations:"
echo "  - Review overdue initiatives and update quarters or close as Archived"
echo "  - Ensure current quarter initiatives have clear priorities"
echo "  - Plan next quarter by moving backlog items to concrete quarters"

echo ""
echo "✅ Quarter/ETA Validation Complete!"
