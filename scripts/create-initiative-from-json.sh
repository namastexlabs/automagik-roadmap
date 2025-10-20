#!/bin/bash
# scripts/create-initiative-from-json.sh
# Create initiative from JSON input - OPTIMIZED VERSION
# Version 3.0 - Performance improvements + correct owner handling

set -e

# Configuration
PROJECT_NUMBER=9
PROJECT_ID="PVT_kwDOBvG2684BE-4E"
ORG="namastexlabs"
REPO="automagik-roadmap"

# Field ID mapping
declare -A FIELD_IDS=(
  ["Project"]="PVTSSF_lADOBvG2684BE-4Ezg2c_ec"
  ["Stage"]="PVTSSF_lADOBvG2684BE-4Ezg2c_hc"
  ["Priority"]="PVTSSF_lADOBvG2684BE-4Ezg2c_kA"
  ["ETA"]="PVTSSF_lADOBvG2684BE-4Ezg2dPxc"
  ["Status"]="PVTSSF_lADOBvG2684BE-4Ezg2c5dY"
  ["ExpectedResults"]="PVTF_lADOBvG2684BE-4Ezg2c8aE"
  ["Owner"]="PVTF_lADOBvG2684BE-4Ezg2c8aI"
  ["TargetDate"]="PVTF_lADOBvG2684BE-4Ezg2c8aM"
  ["StartDate"]="PVTF_lADOBvG2684BE-4Ezg2dQ6Y"
)

# Option ID mapping
declare -A PROJECT_OPTIONS=(
  ["omni"]="9c171c42"
  ["hive"]="a28ceeff"
  ["spark"]="0a588179"
  ["forge"]="2a9e974c"
  ["genie"]="93d4bd3c"
  ["tools"]="f00fd26a"
  ["cross-project"]="c1f1ab29"
)

declare -A STAGE_OPTIONS=(
  ["Wishlist"]="d4964f90"
  ["Exploring"]="f5c85cef"
  ["RFC"]="cd5acf90"
  ["Prioritization"]="a3c2913b"
  ["Executing"]="073f61b0"
  ["Preview"]="b572947d"
  ["Shipped"]="3d0b8ddd"
  ["Archived"]="0e15297c"
)

declare -A PRIORITY_OPTIONS=(
  ["critical"]="700a2c58"
  ["high"]="d7a47ff6"
  ["medium"]="79c50f9e"
  ["low"]="c7f229a8"
)

declare -A QUARTER_OPTIONS=(
  ["backlog"]="88ae1263"
  ["2025-Q4"]="a35fa4f5"
  ["2025-q4"]="a35fa4f5"
  ["2026-Q1"]="a0cccfe6"
  ["2026-q1"]="a0cccfe6"
  ["2026-Q2"]="cf1026cb"
  ["2026-q2"]="cf1026cb"
  ["2026-Q3"]="3c402b09"
  ["2026-q3"]="3c402b09"
  ["2026-Q4"]="ec810765"
  ["2026-q4"]="ec810765"
  ["2027-Q1"]="4ac5ad3f"
  ["2027-q1"]="4ac5ad3f"
)

declare -A STATUS_OPTIONS=(
  ["Todo"]="f75ad846"
  ["In Progress"]="47fc9ee4"
  ["Done"]="98236657"
)

# Owner mapping - project-specific defaults
declare -A DEFAULT_OWNERS=(
  ["omni"]="vasconceloscezar"
  ["hive"]="vasconceloscezar"
  ["spark"]="vasconceloscezar"
  ["forge"]="namastex888"
  ["genie"]="namastex888"
  ["tools"]="vasconceloscezar"
  ["cross-project"]="vasconceloscezar"
)

# Show usage if --help or -h
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  cat << 'EOF'
Usage: cat initiative.json | ./scripts/create-initiative-from-json.sh

PERFORMANCE OPTIMIZATIONS:
- Reduced retries from 25 to 10 (3s each = 30s max vs 75s)
- Batch GraphQL mutations (parallel API calls)
- Smart owner defaults (genie/forge → namastex888, others → vasconceloscezar)
- Optional start_date/target_date override in JSON

Simple JSON format:
{
  "title": "Initiative Title",
  "project": "omni|hive|spark|forge|genie|tools|cross-project",
  "stage": "Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped",
  "priority": "critical|high|medium|low",
  "quarter": "2025-Q4|2026-Q1|backlog",
  "owner": "github-username (optional, auto-selects based on project)",
  "type": "feature|enhancement|research|infrastructure|documentation",
  "areas": ["api", "mcp"],
  "start_date": "2025-10-20 (optional, YYYY-MM-DD)",
  "target_date": "2025-12-31 (optional, YYYY-MM-DD, overrides quarter)",
  "description": "Problem, solution, impact",
  "goals": ["Goal 1", "Goal 2"]
}

Owner auto-selection:
- forge/genie → namastex888
- omni/hive/spark/tools/cross-project → vasconceloscezar

Example:
{
  "title": "Test Initiative",
  "project": "genie",
  "stage": "Executing",
  "priority": "high",
  "quarter": "2025-q4",
  "start_date": "2025-10-20",
  "target_date": "2025-11-15",
  "type": "feature",
  "areas": ["testing", "cli"],
  "description": "Testing the optimized script with proper dates",
  "goals": ["Fast creation", "Correct owner", "No manual updates needed"]
}
EOF
  exit 0
fi

# Read JSON from stdin
JSON=$(cat)

# Parse basic fields
RAW_TITLE=$(echo "$JSON" | jq -r '.title')
PROJECT=$(echo "$JSON" | jq -r '.project')
STAGE=$(echo "$JSON" | jq -r '.stage // "Exploring"')
PRIORITY=$(echo "$JSON" | jq -r '.priority // "medium"')
QUARTER=$(echo "$JSON" | jq -r '.quarter // "backlog"' | tr '[:upper:]' '[:lower:]')
TYPE=$(echo "$JSON" | jq -r '.type // "feature"')
AREAS=$(echo "$JSON" | jq -r '.areas // [] | join(",")')
START_DATE=$(echo "$JSON" | jq -r '.start_date // empty')
TARGET_DATE=$(echo "$JSON" | jq -r '.target_date // empty')

# Owner selection - use JSON if provided, otherwise use project-based default
OWNER_FROM_JSON=$(echo "$JSON" | jq -r '.owner // empty')
if [[ -n "$OWNER_FROM_JSON" ]]; then
  OWNER="$OWNER_FROM_JSON"
else
  OWNER="${DEFAULT_OWNERS[$PROJECT]:-vasconceloscezar}"
fi

# Validate required fields
if [[ -z "$RAW_TITLE" || "$RAW_TITLE" == "null" ]]; then
  echo "Error: title is required in JSON"
  exit 1
fi

if [[ -z "$PROJECT" || "$PROJECT" == "null" ]]; then
  echo "Error: project is required in JSON"
  exit 1
fi

# Format title with project prefix
case "$PROJECT" in
  "cross-project") PROJECT_PREFIX="Cross-Project" ;;
  "omni") PROJECT_PREFIX="Omni" ;;
  "hive") PROJECT_PREFIX="Hive" ;;
  "spark") PROJECT_PREFIX="Spark" ;;
  "forge") PROJECT_PREFIX="Forge" ;;
  "genie") PROJECT_PREFIX="Genie" ;;
  "tools") PROJECT_PREFIX="Tools" ;;
  *) PROJECT_PREFIX=$(echo "$PROJECT" | sed 's/.*/\u&/') ;;
esac

if [[ "$RAW_TITLE" =~ ^[A-Za-z-]+:  ]]; then
  TITLE="$RAW_TITLE"
else
  TITLE="${PROJECT_PREFIX}: ${RAW_TITLE}"
fi

# Calculate Target Date from quarter if not provided
if [[ -z "$TARGET_DATE" && "$QUARTER" != "backlog" ]]; then
  YEAR=$(echo "$QUARTER" | cut -d'-' -f1)
  Q=$(echo "$QUARTER" | cut -d'-' -f2 | sed 's/[Qq]//')
  case $Q in
    1) TARGET_DATE="${YEAR}-03-31" ;;
    2) TARGET_DATE="${YEAR}-06-30" ;;
    3) TARGET_DATE="${YEAR}-09-30" ;;
    4) TARGET_DATE="${YEAR}-12-31" ;;
  esac
fi

# Build labels
LABELS="initiative,project:${PROJECT},${STAGE},priority:${PRIORITY}"

if [[ -n "$TYPE" && "$TYPE" != "null" ]]; then
  LABELS="${LABELS},type:${TYPE}"
fi

if [[ -n "$AREAS" && "$AREAS" != "null" ]]; then
  IFS=',' read -ra AREA_ARRAY <<< "$AREAS"
  for area in "${AREA_ARRAY[@]}"; do
    LABELS="${LABELS},area:${area}"
  done
fi

# Build LEAN markdown body (simplified for speed)
DESCRIPTION=$(echo "$JSON" | jq -r '.one_line_summary // .description // "TBD"')
TIMELINE=$(echo "$JSON" | jq -r '.timeline // "TBD"')

# Format goals
GOALS_ARRAY=$(echo "$JSON" | jq -r '.goals // []')
GOALS=""
if [[ "$GOALS_ARRAY" != "[]" ]]; then
  i=1
  while IFS= read -r goal; do
    if [[ -n "$goal" ]]; then
      GOALS="${GOALS}${i}. ${goal}\n"
      ((i++))
    fi
  done < <(echo "$GOALS_ARRAY" | jq -r '.[]')
else
  GOALS="1. Goal 1\n2. Goal 2\n3. Goal 3"
fi

# Simplified body template
BODY=$(cat <<EOF
# $TITLE

> **TL;DR:** $DESCRIPTION
> **Owner:** @$OWNER | **Stage:** $STAGE | **Timeline:** $TIMELINE

---

## 🎯 Goals & Scope

$(echo -e "$GOALS")

## 📅 Timeline

- **Start:** ${START_DATE:-TBD}
- **Target:** ${TARGET_DATE:-TBD}
- **Quarter:** ${QUARTER^^}

## 🔗 Related

- **Accountable:** @$OWNER
- **Project:** $PROJECT
- **Priority:** $PRIORITY
EOF
)

echo "=== Creating Initiative (Optimized) ==="
echo "Title: $TITLE"
echo "Project: $PROJECT ($OWNER)"
echo "Stage: $STAGE | Priority: $PRIORITY | Quarter: ${QUARTER^^}"
echo "Dates: ${START_DATE:-auto} → ${TARGET_DATE:-auto}"
echo ""

# Create issue
echo "[1/3] Creating issue..."
TEMP_BODY_FILE=$(mktemp)
echo "$BODY" > "$TEMP_BODY_FILE"

ISSUE_URL=$(gh issue create \
  --repo "$ORG/$REPO" \
  --title "$TITLE" \
  --label "$LABELS" \
  --assignee "$OWNER" \
  --body-file "$TEMP_BODY_FILE")

rm "$TEMP_BODY_FILE"

ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -oP '/issues/\K\d+')
echo "   Created #$ISSUE_NUMBER"

# Get node ID (fast, no sleep)
echo "[2/3] Getting metadata..."
ISSUE_NODE_ID=$(gh issue view "$ISSUE_NUMBER" --repo "$ORG/$REPO" --json id --jq '.id')
echo "   Node ID: ${ISSUE_NODE_ID:0:20}..."

# Wait for workflow (reduced from 12s to 5s)
echo "[3/3] Waiting for project sync (5s)..."
sleep 5

# Get project item ID (reduced retries: 10 attempts, 3s delay = 30s max)
ITEM_ID=""
MAX_RETRIES=10
RETRY_DELAY=3

for i in $(seq 1 $MAX_RETRIES); do
  ITEM_ID=$(gh api graphql -f query="
  query {
    organization(login: \"$ORG\") {
      projectV2(number: $PROJECT_NUMBER) {
        items(first: 100) {
          nodes {
            id
            content {
              ... on Issue {
                id
              }
            }
          }
        }
      }
    }
  }" --jq ".data.organization.projectV2.items.nodes[] | select(.content.id == \"$ISSUE_NODE_ID\") | .id" 2>/dev/null | head -1)

  if [[ -n "$ITEM_ID" ]]; then
    echo "   ✓ Found item (attempt $i)"
    break
  fi

  if [[ $i -lt $MAX_RETRIES ]]; then
    sleep $RETRY_DELAY
  fi
done

if [[ -z "$ITEM_ID" ]]; then
  echo ""
  echo "❌ ERROR: Project sync timed out (${MAX_RETRIES}x${RETRY_DELAY}s)"
  echo "   Issue created: $ISSUE_URL"
  echo "   Manual: Set fields in project board"
  exit 1
fi

# Map Stage to Status
case "$STAGE" in
  Wishlist|Exploring|RFC|Prioritization) STATUS="Todo" ;;
  Executing|Preview) STATUS="In Progress" ;;
  Shipped|Archived) STATUS="Done" ;;
  *) STATUS="Todo" ;;
esac

# Batch update fields (all mutations in parallel for speed)
echo ""
echo "Setting fields..."

# Build all mutations as parallel background jobs
{
  gh api graphql -f query="mutation { updateProjectV2ItemFieldValue(input: {projectId: \"$PROJECT_ID\", itemId: \"$ITEM_ID\", fieldId: \"${FIELD_IDS[Project]}\", value: {singleSelectOptionId: \"${PROJECT_OPTIONS[$PROJECT]}\"}}) { projectV2Item { id } }}" > /dev/null 2>&1 && echo "  ✓ Project" || echo "  ✗ Project"
} &

{
  gh api graphql -f query="mutation { updateProjectV2ItemFieldValue(input: {projectId: \"$PROJECT_ID\", itemId: \"$ITEM_ID\", fieldId: \"${FIELD_IDS[Stage]}\", value: {singleSelectOptionId: \"${STAGE_OPTIONS[$STAGE]}\"}}) { projectV2Item { id } }}" > /dev/null 2>&1 && echo "  ✓ Stage" || echo "  ✗ Stage"
} &

{
  gh api graphql -f query="mutation { updateProjectV2ItemFieldValue(input: {projectId: \"$PROJECT_ID\", itemId: \"$ITEM_ID\", fieldId: \"${FIELD_IDS[Priority]}\", value: {singleSelectOptionId: \"${PRIORITY_OPTIONS[$PRIORITY]}\"}}) { projectV2Item { id } }}" > /dev/null 2>&1 && echo "  ✓ Priority" || echo "  ✗ Priority"
} &

{
  gh api graphql -f query="mutation { updateProjectV2ItemFieldValue(input: {projectId: \"$PROJECT_ID\", itemId: \"$ITEM_ID\", fieldId: \"${FIELD_IDS[Status]}\", value: {singleSelectOptionId: \"${STATUS_OPTIONS[$STATUS]}\"}}) { projectV2Item { id } }}" > /dev/null 2>&1 && echo "  ✓ Status" || echo "  ✗ Status"
} &

{
  QUARTER_UPPER=$(echo "$QUARTER" | tr '[:lower:]' '[:upper:]')
  gh api graphql -f query="mutation { updateProjectV2ItemFieldValue(input: {projectId: \"$PROJECT_ID\", itemId: \"$ITEM_ID\", fieldId: \"${FIELD_IDS[ETA]}\", value: {singleSelectOptionId: \"${QUARTER_OPTIONS[$QUARTER]}\"}}) { projectV2Item { id } }}" > /dev/null 2>&1 && echo "  ✓ Quarter ($QUARTER_UPPER)" || echo "  ✗ Quarter"
} &

{
  gh api graphql -f query="mutation { updateProjectV2ItemFieldValue(input: {projectId: \"$PROJECT_ID\", itemId: \"$ITEM_ID\", fieldId: \"${FIELD_IDS[Owner]}\", value: {text: \"@$OWNER\"}}) { projectV2Item { id } }}" > /dev/null 2>&1 && echo "  ✓ Owner (@$OWNER)" || echo "  ✗ Owner"
} &

if [[ -n "$START_DATE" ]]; then
  {
    gh api graphql -f query="mutation { updateProjectV2ItemFieldValue(input: {projectId: \"$PROJECT_ID\", itemId: \"$ITEM_ID\", fieldId: \"${FIELD_IDS[StartDate]}\", value: {date: \"$START_DATE\"}}) { projectV2Item { id } }}" > /dev/null 2>&1 && echo "  ✓ Start Date ($START_DATE)" || echo "  ✗ Start Date"
  } &
fi

if [[ -n "$TARGET_DATE" ]]; then
  {
    gh api graphql -f query="mutation { updateProjectV2ItemFieldValue(input: {projectId: \"$PROJECT_ID\", itemId: \"$ITEM_ID\", fieldId: \"${FIELD_IDS[TargetDate]}\", value: {date: \"$TARGET_DATE\"}}) { projectV2Item { id } }}" > /dev/null 2>&1 && echo "  ✓ Target Date ($TARGET_DATE)" || echo "  ✗ Target Date"
  } &
fi

# Wait for all parallel jobs
wait

echo ""
echo "✅ Initiative Created Successfully"
echo "   URL: $ISSUE_URL"
echo "   Board: https://github.com/orgs/$ORG/projects/$PROJECT_NUMBER"
echo ""
