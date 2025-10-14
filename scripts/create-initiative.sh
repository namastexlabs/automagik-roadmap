#!/bin/bash
# scripts/create-initiative.sh
# Creates a roadmap initiative with all fields properly set
# Version 2.0 - Fixed node_id lookup and proper error handling

set -e

# Configuration
PROJECT_NUMBER=9
PROJECT_ID="PVT_kwDOBvG2684BE-4E"
ORG="namastexlabs"
REPO="automagik-roadmap"

# Parse arguments
TITLE=""
PROJECT_NAME=""
STAGE=""
PRIORITY=""
QUARTER=""
OWNER=""
TYPE=""
AREAS=""

show_usage() {
  cat << EOF
Usage: $0 --title "Initiative Title" [options]

Required:
  --title        Initiative title (clean title, no prefix needed)
  --project      Project name (omni|hive|spark|forge|genie|tools|cross-project)

Optional:
  --stage        Stage (Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped|Archived) [default: Exploring]
  --priority     Priority (critical|high|medium|low) [default: medium]
  --quarter      Quarter (2025-Q4|2026-Q1|2026-Q2|etc|backlog) [default: backlog]
  --owner        GitHub username for assignment [default: current user]
  --type         Type label (feature|enhancement|research|infrastructure|documentation)
  --areas        Area labels comma-separated (api,mcp,cli,etc)

Example:
  $0 --title "Slack Integration" \\
     --project omni \\
     --stage Exploring \\
     --priority high \\
     --quarter 2026-Q1 \\
     --owner vasconceloscezar \\
     --type feature \\
     --areas "mcp,messaging"
EOF
}

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
  ["2026-Q1"]="a0cccfe6"
  ["2026-Q2"]="cf1026cb"
  ["2026-Q3"]="3c402b09"
  ["2026-Q4"]="ec810765"
  ["2027-Q1"]="4ac5ad3f"
)

declare -A STATUS_OPTIONS=(
  ["Todo"]="f75ad846"
  ["In Progress"]="47fc9ee4"
  ["Done"]="98236657"
)

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --title) TITLE="$2"; shift 2 ;;
    --project) PROJECT_NAME="$2"; shift 2 ;;
    --stage) STAGE="$2"; shift 2 ;;
    --priority) PRIORITY="$2"; shift 2 ;;
    --quarter) QUARTER="$2"; shift 2 ;;
    --owner) OWNER="$2"; shift 2 ;;
    --type) TYPE="$2"; shift 2 ;;
    --areas) AREAS="$2"; shift 2 ;;
    -h|--help) show_usage; exit 0 ;;
    *) echo "Unknown option: $1"; show_usage; exit 1 ;;
  esac
done

# Validate required fields
if [[ -z "$TITLE" ]]; then
  echo "Error: --title is required"
  show_usage
  exit 1
fi

if [[ -z "$PROJECT_NAME" ]]; then
  echo "Error: --project is required"
  show_usage
  exit 1
fi

# Set defaults
STAGE="${STAGE:-Exploring}"
PRIORITY="${PRIORITY:-medium}"
QUARTER="${QUARTER:-backlog}"
OWNER="${OWNER:-$(gh api user --jq .login)}"

# Validate project
if [[ ! -v PROJECT_OPTIONS[$PROJECT_NAME] ]]; then
  echo "Error: Invalid project. Must be one of: ${!PROJECT_OPTIONS[@]}"
  exit 1
fi

# Build labels (quarter is NOT a label, only a project field)
LABELS="initiative,project:${PROJECT_NAME},${STAGE},priority:${PRIORITY}"

if [[ -n "$TYPE" ]]; then
  LABELS="${LABELS},type:${TYPE}"
fi

if [[ -n "$AREAS" ]]; then
  IFS=',' read -ra AREA_ARRAY <<< "$AREAS"
  for area in "${AREA_ARRAY[@]}"; do
    LABELS="${LABELS},area:${area}"
  done
fi

echo "=== Creating Initiative ==="
echo "Title: $TITLE"
echo "Project: $PROJECT_NAME"
echo "Stage: $STAGE"
echo "Priority: $PRIORITY"
echo "Quarter: $QUARTER"
echo "Owner: $OWNER"
echo "Labels: $LABELS"
echo ""

# Read issue body from stdin or use template
if [[ -t 0 ]]; then
  echo "Paste issue body (Ctrl+D when done):"
  BODY=$(cat)
else
  BODY=$(cat)
fi

# Create the issue and capture JSON response with node_id
echo "Creating issue..."
ISSUE_RESPONSE=$(echo "$BODY" | gh issue create \
  --repo "$ORG/$REPO" \
  --title "$TITLE" \
  --label "$LABELS" \
  --assignee "$OWNER" \
  --body-file - \
  --json number,id,url)

ISSUE_NUMBER=$(echo "$ISSUE_RESPONSE" | jq -r '.number')
ISSUE_NODE_ID=$(echo "$ISSUE_RESPONSE" | jq -r '.id')
ISSUE_URL=$(echo "$ISSUE_RESPONSE" | jq -r '.url')

echo "Created issue #$ISSUE_NUMBER: $ISSUE_URL"
echo "Issue node ID: $ISSUE_NODE_ID"
echo ""

# NOTE: We do NOT manually add to project board here!
# The .github/workflows/sync-to-project.yml workflow automatically adds issues
# with the 'initiative' label to the project board.

# Wait for workflow to add the issue to the project board
echo "Waiting for workflow to add issue to project board..."
echo "  This usually takes 5-15 seconds depending on GitHub Actions load..."
sleep 12

# Get project item ID using node_id (most reliable method)
echo "Looking up project item by issue node ID..."
ITEM_ID=""
MAX_RETRIES=25
RETRY_DELAY=3

for i in $(seq 1 $MAX_RETRIES); do
  # Query by node_id to get the exact item we created
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
                number
                title
              }
            }
          }
        }
      }
    }
  }" --jq ".data.organization.projectV2.items.nodes[] | select(.content.id == \"$ISSUE_NODE_ID\") | .id" 2>/dev/null)

  if [[ -n "$ITEM_ID" ]]; then
    # Verify this is the correct item by checking title
    FOUND_TITLE=$(gh api graphql -f query="
    query {
      organization(login: \"$ORG\") {
        projectV2(number: $PROJECT_NUMBER) {
          items(first: 100) {
            nodes {
              id
              content {
                ... on Issue {
                  id
                  title
                }
              }
            }
          }
        }
      }
    }" --jq ".data.organization.projectV2.items.nodes[] | select(.id == \"$ITEM_ID\") | .content.title" 2>/dev/null)

    if [[ "$FOUND_TITLE" == "$TITLE" ]]; then
      echo "✓ Found correct project item on attempt $i"
      echo "  Item ID: $ITEM_ID"
      echo "  Verified title: $FOUND_TITLE"
      break
    else
      echo "⚠ Found item but title mismatch (attempt $i)"
      echo "  Expected: $TITLE"
      echo "  Found: $FOUND_TITLE"
      ITEM_ID=""
    fi
  fi

  if [[ $i -lt $MAX_RETRIES ]]; then
    echo "  Attempt $i/$MAX_RETRIES: Item not found yet, retrying in ${RETRY_DELAY}s..."
    sleep $RETRY_DELAY
  fi
done

if [[ -z "$ITEM_ID" ]]; then
  echo ""
  echo "❌ ERROR: Could not find project item for issue #$ISSUE_NUMBER"
  echo ""
  echo "This usually means the GitHub Actions workflow is delayed or failed."
  echo "The issue was created successfully at: $ISSUE_URL"
  echo ""
  echo "Troubleshooting steps:"
  echo "  1. Check workflow status: https://github.com/$ORG/$REPO/actions"
  echo "  2. Wait 1-2 minutes and verify issue appears on project board"
  echo "  3. If issue is on board, manually set fields in UI"
  echo "  4. Project board: https://github.com/orgs/$ORG/projects/$PROJECT_NUMBER"
  echo ""
  exit 1
fi

echo ""
echo "Project item found and verified!"
echo ""

# Set custom fields - temporarily disable exit on error for granular tracking
set +e
FAILED_FIELDS=()

echo "Setting custom fields..."

# Set Project field
echo -n "  Setting Project field... "
if gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[Project]}\"
    value: {singleSelectOptionId: \"${PROJECT_OPTIONS[$PROJECT_NAME]}\"}
  }) { projectV2Item { id } }
}" > /dev/null 2>&1; then
  echo "✓"
else
  echo "✗"
  FAILED_FIELDS+=("Project")
fi

# Set Stage field
echo -n "  Setting Stage field... "
if gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[Stage]}\"
    value: {singleSelectOptionId: \"${STAGE_OPTIONS[$STAGE]}\"}
  }) { projectV2Item { id } }
}" > /dev/null 2>&1; then
  echo "✓"
else
  echo "✗"
  FAILED_FIELDS+=("Stage")
fi

# Set Priority field
echo -n "  Setting Priority field... "
if gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[Priority]}\"
    value: {singleSelectOptionId: \"${PRIORITY_OPTIONS[$PRIORITY]}\"}
  }) { projectV2Item { id } }
}" > /dev/null 2>&1; then
  echo "✓"
else
  echo "✗"
  FAILED_FIELDS+=("Priority")
fi

# Set ETA/Quarter field
echo -n "  Setting ETA field... "
if gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[ETA]}\"
    value: {singleSelectOptionId: \"${QUARTER_OPTIONS[$QUARTER]}\"}
  }) { projectV2Item { id } }
}" > /dev/null 2>&1; then
  echo "✓"
else
  echo "✗"
  FAILED_FIELDS+=("ETA")
fi

# Map Stage to Status
case "$STAGE" in
  Wishlist|Exploring|RFC|Prioritization)
    STATUS="Todo"
    ;;
  Executing|Preview)
    STATUS="In Progress"
    ;;
  Shipped|Archived)
    STATUS="Done"
    ;;
  *)
    STATUS="Todo"
    ;;
esac

# Set Status field
echo -n "  Setting Status field... "
if gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[Status]}\"
    value: {singleSelectOptionId: \"${STATUS_OPTIONS[$STATUS]}\"}
  }) { projectV2Item { id } }
}" > /dev/null 2>&1; then
  echo "✓"
else
  echo "✗"
  FAILED_FIELDS+=("Status")
fi

# Extract Expected Results from body - try multiple patterns for robustness
EXPECTED_RESULTS=""
# Try "### Goals (Expected Results)" first (MINIMAL template format)
EXPECTED_RESULTS=$(echo "$BODY" | sed -n '/### Goals (Expected Results)/,/^##/p' | sed '1d;$d' | head -15 | sed 's/"/\\"/g' | tr '\n' ' ')
# If empty, try "### Expected Results"
if [[ -z "$EXPECTED_RESULTS" || "$EXPECTED_RESULTS" =~ ^[[:space:]]*$ ]]; then
  EXPECTED_RESULTS=$(echo "$BODY" | sed -n '/### Expected Results/,/^##/p' | sed '1d;$d' | head -15 | sed 's/"/\\"/g' | tr '\n' ' ')
fi
# Trim to 300 chars for field limit
EXPECTED_RESULTS="${EXPECTED_RESULTS:0:300}"

# Set Expected Results field (text field)
if [[ -n "$EXPECTED_RESULTS" && ! "$EXPECTED_RESULTS" =~ ^[[:space:]]*$ ]]; then
  echo -n "  Setting Expected Results field... "
  if gh api graphql -f query="
  mutation {
    updateProjectV2ItemFieldValue(input: {
      projectId: \"$PROJECT_ID\"
      itemId: \"$ITEM_ID\"
      fieldId: \"${FIELD_IDS[ExpectedResults]}\"
      value: {text: \"$EXPECTED_RESULTS\"}
    }) { projectV2Item { id } }
  }" > /dev/null 2>&1; then
    echo "✓"
  else
    echo "⚠"
    FAILED_FIELDS+=("Expected Results")
  fi
else
  echo "  Expected Results field... (skipped - not found in body)"
fi

# Set Owner field (text field with @username)
echo -n "  Setting Owner field... "
if gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[Owner]}\"
    value: {text: \"@$OWNER\"}
  }) { projectV2Item { id } }
}" > /dev/null 2>&1; then
  echo "✓"
else
  echo "⚠"
  FAILED_FIELDS+=("Owner")
fi

# Calculate Target Date from quarter (end of quarter)
TARGET_DATE=""
if [[ "$QUARTER" != "backlog" ]]; then
  YEAR=$(echo "$QUARTER" | cut -d'-' -f1)
  Q=$(echo "$QUARTER" | cut -d'-' -f2 | tr -d 'Qq')
  case $Q in
    1) TARGET_DATE="${YEAR}-03-31" ;;
    2) TARGET_DATE="${YEAR}-06-30" ;;
    3) TARGET_DATE="${YEAR}-09-30" ;;
    4) TARGET_DATE="${YEAR}-12-31" ;;
  esac
fi

# Set Target Date field (date field)
if [[ -n "$TARGET_DATE" ]]; then
  echo -n "  Setting Target Date field... "
  if gh api graphql -f query="
  mutation {
    updateProjectV2ItemFieldValue(input: {
      projectId: \"$PROJECT_ID\"
      itemId: \"$ITEM_ID\"
      fieldId: \"${FIELD_IDS[TargetDate]}\"
      value: {date: \"$TARGET_DATE\"}
    }) { projectV2Item { id } }
  }" > /dev/null 2>&1; then
    echo "✓"
  else
    echo "⚠"
    FAILED_FIELDS+=("Target Date")
  fi
fi

# Re-enable exit on error
set -e

echo ""
echo "=== Initiative Created ==="
echo "URL: $ISSUE_URL"
echo "Number: #$ISSUE_NUMBER"
echo "Node ID: $ISSUE_NODE_ID"
echo "Project Item ID: $ITEM_ID"
echo ""

# Show summary based on success/failure
if [[ ${#FAILED_FIELDS[@]} -eq 0 ]]; then
  echo "✅ All fields set successfully:"
  echo "  ✓ Project: $PROJECT_NAME"
  echo "  ✓ Stage: $STAGE"
  echo "  ✓ Status: $STATUS"
  echo "  ✓ Priority: $PRIORITY"
  echo "  ✓ Quarter: $QUARTER"
  echo "  ✓ Owner: @$OWNER"
  echo "  ✓ Target Date: ${TARGET_DATE:-Not set (backlog)}"
  if [[ -n "$EXPECTED_RESULTS" ]]; then
    echo "  ✓ Expected Results: ${EXPECTED_RESULTS:0:50}..."
  fi
  echo "  ✓ Labels: $LABELS"
else
  echo "⚠️  Initiative created but some fields failed to set:"
  echo ""
  echo "Successfully set:"
  [[ ! " ${FAILED_FIELDS[@]} " =~ " Project " ]] && echo "  ✓ Project: $PROJECT_NAME"
  [[ ! " ${FAILED_FIELDS[@]} " =~ " Stage " ]] && echo "  ✓ Stage: $STAGE"
  [[ ! " ${FAILED_FIELDS[@]} " =~ " Status " ]] && echo "  ✓ Status: $STATUS"
  [[ ! " ${FAILED_FIELDS[@]} " =~ " Priority " ]] && echo "  ✓ Priority: $PRIORITY"
  [[ ! " ${FAILED_FIELDS[@]} " =~ " ETA " ]] && echo "  ✓ Quarter: $QUARTER"
  [[ ! " ${FAILED_FIELDS[@]} " =~ " Owner " ]] && echo "  ✓ Owner: @$OWNER"
  if [[ -n "$TARGET_DATE" && ! " ${FAILED_FIELDS[@]} " =~ " Target Date " ]]; then
    echo "  ✓ Target Date: $TARGET_DATE"
  fi
  echo ""
  echo "Failed to set:"
  for field in "${FAILED_FIELDS[@]}"; do
    echo "  ✗ $field"
  done
  echo ""
  echo "Please manually set these fields in the project board."
fi

echo ""
echo "View on project board: https://github.com/orgs/$ORG/projects/$PROJECT_NUMBER"
echo ""
echo "Verify all fields: gh api graphql -f query='query { organization(login: \"$ORG\") { projectV2(number: $PROJECT_NUMBER) { items(first: 100) { nodes { id content { ... on Issue { number } } fieldValues(first: 20) { nodes { ... on ProjectV2ItemFieldSingleSelectValue { name field { ... on ProjectV2SingleSelectField { name } } } } } } } } } }' | jq '.data.organization.projectV2.items.nodes[] | select(.content.number == $ISSUE_NUMBER)'"
