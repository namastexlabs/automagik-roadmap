#!/bin/bash
# Check initiative field completeness and quality
# Validates body content, expected results, RASCI assignments, etc.
# Usage: ./check-initiative-completeness.sh [--detailed]

set -e

ORG="namastexlabs"
REPO="automagik-roadmap"
DETAILED=${1:-""}

echo "=== 📋 Initiative Completeness Checker ==="
echo "=== Checking initiative quality and field completeness ==="
echo ""

# 1. Check for empty or minimal body content
echo "📝 Body Content Quality:"
echo ""
echo "⚠️  Initiatives with Short/Empty Body (<200 chars):"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,body \
  --jq '[.[] | select(.body | length < 200)] | .[:10][] | "  #\(.number) - \(.title) (Body length: \(.body | length) chars)"'

echo ""
echo "✅ Well-Documented Initiatives (>1000 chars):"
WELL_DOCUMENTED=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,body \
  --jq '[.[] | select(.body | length > 1000)] | length')
echo "  Count: $WELL_DOCUMENTED initiatives"

# 2. Check for expected results section
echo ""
echo "🎯 Expected Results/Goals Section:"
echo ""
echo "⚠️  Missing Expected Results Section:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,body \
  --jq '[.[] | select(.body | test("(Expected Results|Goals|Objectives)"; "i") | not)] | .[:10][] | "  #\(.number) - \(.title)"'

# 3. Check for RASCI assignments
echo ""
echo "👥 RASCI Assignment Check:"
echo ""
echo "⚠️  Missing Accountable (A) Assignment:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,body \
  --jq '[.[] | select(.body | test("Accountable.*:"; "i") | not)] | .[:10][] | "  #\(.number) - \(.title)"'

echo ""
echo "⚠️  Missing Responsible (R) Assignment:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,body \
  --jq '[.[] | select(.body | test("Responsible.*:"; "i") | not)] | .[:10][] | "  #\(.number) - \(.title)"'

# 4. Check assignees
echo ""
echo "👤 Assignee Status:"
echo ""
echo "⚠️  Initiatives Without Assignees:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,assignees \
  --jq '[.[] | select(.assignees | length == 0)] | .[:10][] | "  #\(.number) - \(.title)"'

ASSIGNED_COUNT=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json assignees \
  --jq '[.[] | select(.assignees | length > 0)] | length')
TOTAL_OPEN=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number --jq 'length')
ASSIGNMENT_RATE=$(awk "BEGIN {printf \"%.0f\", ($ASSIGNED_COUNT/$TOTAL_OPEN)*100}")

echo ""
echo "📊 Assignment Rate: $ASSIGNED_COUNT/$TOTAL_OPEN initiatives assigned ($ASSIGNMENT_RATE%)"

# 5. Check for linked wish folders
echo ""
echo "🔗 Wish Folder Links:"
echo ""
echo "💡 Initiatives Referencing Wish Folders:"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,body \
  --jq '[.[] | select(.body | test("projects/.*/wishes"; "i"))] | length' | \
  xargs -I {} echo "  Count: {} initiatives with wish folder links"

echo ""
echo "⚠️  Complex Initiatives Without Wish Folder (body >500 chars, no wish link):"
gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,body \
  --jq '[.[] | select((.body | length > 500) and (.body | test("projects/.*/wishes"; "i") | not))] | .[:5][] | "  #\(.number) - \(.title)"'

# 6. Template compliance check
echo ""
echo "📋 Template Compliance:"
echo ""
echo "Checking for standard template sections..."

# Count initiatives with key sections
WITH_CONTEXT=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json body \
  --jq '[.[] | select(.body | test("(## Context|### Context|Background)"; "i"))] | length')

WITH_GOALS=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json body \
  --jq '[.[] | select(.body | test("(## Goals|### Goals|## Expected Results)"; "i"))] | length')

WITH_SCOPE=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json body \
  --jq '[.[] | select(.body | test("(## Scope|### Scope|## Requirements)"; "i"))] | length')

WITH_RASCI=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json body \
  --jq '[.[] | select(.body | test("## RASCI"; "i"))] | length')

echo "  Initiatives with Context section: $WITH_CONTEXT/$TOTAL_OPEN"
echo "  Initiatives with Goals section: $WITH_GOALS/$TOTAL_OPEN"
echo "  Initiatives with Scope section: $WITH_SCOPE/$TOTAL_OPEN"
echo "  Initiatives with RASCI section: $WITH_RASCI/$TOTAL_OPEN"

# 7. Stage-specific validation
echo ""
echo "🎭 Stage-Specific Validation:"
echo ""

# Executing stage should have high completeness
echo "Executing Stage Quality Check:"
EXECUTING_COMPLETE=$(gh issue list --repo $ORG/$REPO --label initiative,stage:Executing --state open --limit 1000 --json number,title,body,assignees \
  --jq '[.[] | select((.body | length > 500) and (.assignees | length > 0))] | length')
EXECUTING_TOTAL=$(gh issue list --repo $ORG/$REPO --label initiative,stage:Executing --state open --limit 1000 --json number --jq 'length')

if [ "$EXECUTING_TOTAL" -gt 0 ]; then
  EXECUTING_QUALITY=$(awk "BEGIN {printf \"%.0f\", ($EXECUTING_COMPLETE/$EXECUTING_TOTAL)*100}")
  echo "  Well-documented with assignees: $EXECUTING_COMPLETE/$EXECUTING_TOTAL ($EXECUTING_QUALITY%)"
fi

# Wishlist can be minimal
WISHLIST_TOTAL=$(gh issue list --repo $ORG/$REPO --label initiative,stage:Wishlist --state open --limit 1000 --json number --jq 'length')
echo ""
echo "Wishlist Stage: $WISHLIST_TOTAL initiatives (minimal docs expected)"

# 8. Detailed analysis (optional)
if [ "$DETAILED" == "--detailed" ]; then
  echo ""
  echo "=== 🔍 DETAILED ANALYSIS ==="
  echo ""

  # Sample high-quality initiative
  echo "✨ Example High-Quality Initiative:"
  gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,body,assignees,labels \
    --jq '[.[] | select((.body | length > 1000) and (.assignees | length > 0))] | .[0] | "  #\(.number) - \(.title)\n  Body length: \(.body | length) chars\n  Assignees: \([.assignees[].login] | join(", "))\n  Labels: \([.labels[].name] | join(", "))"'

  # Sample low-quality initiative
  echo ""
  echo "⚠️  Example Low-Quality Initiative:"
  gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json number,title,body,assignees \
    --jq '[.[] | select((.body | length < 300) and (.assignees | length == 0))] | .[0] | "  #\(.number) - \(.title)\n  Body length: \(.body | length) chars\n  Assignees: none"'
fi

# 9. Quality score summary
echo ""
echo "=== 📊 Overall Quality Score ==="

# Calculate composite quality score
QUALITY_FACTORS=0
QUALITY_SCORE=0

# Factor 1: Assignment rate
QUALITY_FACTORS=$((QUALITY_FACTORS + 1))
QUALITY_SCORE=$((QUALITY_SCORE + ASSIGNMENT_RATE))

# Factor 2: Documentation rate (>500 chars)
WELL_DOC_COUNT=$(gh issue list --repo $ORG/$REPO --label initiative --state open --limit 1000 --json body \
  --jq '[.[] | select(.body | length > 500)] | length')
DOC_RATE=$(awk "BEGIN {printf \"%.0f\", ($WELL_DOC_COUNT/$TOTAL_OPEN)*100}")
QUALITY_FACTORS=$((QUALITY_FACTORS + 1))
QUALITY_SCORE=$((QUALITY_SCORE + DOC_RATE))

# Factor 3: Template compliance (goals section)
GOALS_RATE=$(awk "BEGIN {printf \"%.0f\", ($WITH_GOALS/$TOTAL_OPEN)*100}")
QUALITY_FACTORS=$((QUALITY_FACTORS + 1))
QUALITY_SCORE=$((QUALITY_SCORE + GOALS_RATE))

# Calculate average
OVERALL_QUALITY=$(awk "BEGIN {printf \"%.0f\", $QUALITY_SCORE/$QUALITY_FACTORS}")

echo ""
echo "📈 Completeness Metrics:"
echo "  - Assignment Rate: $ASSIGNMENT_RATE%"
echo "  - Documentation Rate: $DOC_RATE%"
echo "  - Goals Defined: $GOALS_RATE%"
echo ""
echo "🎯 Overall Quality Score: $OVERALL_QUALITY/100"

if [ "$OVERALL_QUALITY" -ge 80 ]; then
  echo "   Status: 🟢 Excellent - Roadmap is well-maintained!"
elif [ "$OVERALL_QUALITY" -ge 60 ]; then
  echo "   Status: 🟡 Good - Some improvements needed"
else
  echo "   Status: 🔴 Needs Attention - Many initiatives need updating"
fi

echo ""
echo "💡 Improvement Suggestions:"
echo "  1. Assign owners to unassigned initiatives"
echo "  2. Add expected results sections to initiatives missing them"
echo "  3. Expand body content for initiatives with <200 chars"
echo "  4. Link complex initiatives to wish folders for detailed specs"
echo "  5. Use LEAN templates from docs/templates/ for new initiatives"

echo ""
echo "✅ Completeness Check Complete!"
echo ""
echo "💬 Run with --detailed flag for sample high/low quality initiatives"
