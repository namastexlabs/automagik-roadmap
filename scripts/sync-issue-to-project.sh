#!/bin/bash
# scripts/sync-issue-to-project.sh
# Manually sync an initiative issue to the project board
# Use this if GitHub App automation isn't set up

set -e

# Configuration
ORG="namastexlabs"
REPO="automagik-roadmap"
PROJECT_NUMBER=9
PROJECT_ID="PVT_kwDOBvG2684BE-4E"

# Field IDs
declare -A FIELD_IDS=(
  ["Project"]="PVTSSF_lADOBvG2684BE-4Ezg2c_ec"
  ["Stage"]="PVTSSF_lADOBvG2684BE-4Ezg2c_hc"
  ["Priority"]="PVTSSF_lADOBvG2684BE-4Ezg2c_kA"
  ["ETA"]="PVTSSF_lADOBvG2684BE-4Ezg2dPxc"
  ["Status"]="PVTSSF_lADOBvG2684BE-4Ezg2c5dY"
  ["Owner"]="PVTF_lADOBvG2684BE-4Ezg2c8aI"
  ["TargetDate"]="PVTF_lADOBvG2684BE-4Ezg2c8aM"
  ["ExpectedResults"]="PVTF_lADOBvG2684BE-4Ezg2c8aE"
)

# Option IDs
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
  ["Ideation"]="d4964f90"
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
  ["2025-q4"]="a35fa4f5"
  ["2026-q1"]="a0cccfe6"
  ["2026-q2"]="cf1026cb"
  ["2026-q3"]="3c402b09"
  ["2026-q4"]="ec810765"
  ["2027-q1"]="4ac5ad3f"
)

declare -A STATUS_OPTIONS=(
  ["Todo"]="f75ad846"
  ["In Progress"]="47fc9ee4"
  ["Done"]="98236657"
)

show_usage() {
  cat << EOF
Usage: $0 <issue-number>

Syncs an initiative issue to the project board by:
- Adding issue to project
- Parsing issue body for metadata
- Setting all custom fields
- Applying labels

Example:
  $0 8      # Sync issue #8

Note: This script requires 'gh' CLI and appropriate permissions.
EOF
}

if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  show_usage
  exit 0
fi

ISSUE_NUMBER=$1

echo "=== Syncing Issue #$ISSUE_NUMBER to Project Board ==="
echo ""

# Get issue details
echo "Fetching issue details..."
ISSUE_DATA=$(gh issue view $ISSUE_NUMBER --repo "$ORG/$REPO" --json body,labels)
BODY=$(echo "$ISSUE_DATA" | jq -r '.body')

# Parse fields from body
parse_field() {
  local field_name="$1"
  echo "$BODY" | grep -A 1 "^### $field_name" | tail -1 | sed 's/^[[:space:]]*//'
}

PROJECT=$(parse_field "Project")
STAGE=$(parse_field "Stage")
PRIORITY=$(parse_field "Priority")
QUARTER=$(parse_field "Quarter (ETA)")
OWNER=$(parse_field "Responsible")
EXPECTED_RESULTS=$(parse_field "Expected Results (RESULTADO_ESPERADO)" | head -c 300)

echo "Parsed fields:"
echo "  Project: $PROJECT"
echo "  Stage: $STAGE"
echo "  Priority: $PRIORITY"
echo "  Quarter: $QUARTER"
echo "  Owner: $OWNER"
echo ""

# Map stage to status
case "$STAGE" in
  "Wishlist"|"Ideation"|"Exploring"|"RFC"|"Prioritization") STATUS="Todo" ;;
  "Executing"|"Preview") STATUS="In Progress" ;;
  "Shipped"|"Archived") STATUS="Done" ;;
  *) STATUS="Todo" ;;
esac

# Calculate target date from quarter
TARGET_DATE=""
if [[ "$QUARTER" != "backlog" ]] && [[ -n "$QUARTER" ]]; then
  YEAR=$(echo "$QUARTER" | cut -d- -f1)
  Q=$(echo "$QUARTER" | cut -d- -f2 | tr -d 'q')
  case "$Q" in
    1) TARGET_DATE="$YEAR-03-31" ;;
    2) TARGET_DATE="$YEAR-06-30" ;;
    3) TARGET_DATE="$YEAR-09-30" ;;
    4) TARGET_DATE="$YEAR-12-31" ;;
  esac
fi

# Add to project
echo "Adding to project board..."
ISSUE_URL="https://github.com/$ORG/$REPO/issues/$ISSUE_NUMBER"
gh project item-add "$PROJECT_NUMBER" --owner "$ORG" --url "$ISSUE_URL" 2>/dev/null || echo "  (Already on board)"

# Wait for item to be created
echo "Waiting for project item..."
sleep 3

# Get project item ID
ITEM_ID=$(gh api graphql -f query="
query {
  organization(login: \"$ORG\") {
    projectV2(number: $PROJECT_NUMBER) {
      items(first: 50) {
        nodes {
          id
          content {
            ... on Issue {
              number
            }
          }
        }
      }
    }
  }
}" --jq ".data.organization.projectV2.items.nodes[] | select(.content.number == $ISSUE_NUMBER) | .id")

if [[ -z "$ITEM_ID" ]]; then
  echo "Error: Could not find project item"
  exit 1
fi

echo "Project item ID: $ITEM_ID"
echo ""

# Function to set field
set_field() {
  local field_name=$1
  local field_id=$2
  local value=$3
  local value_type=$4  # singleSelectOptionId, text, or date

  if [[ -z "$value" ]]; then
    return
  fi

  echo "Setting $field_name..."

  local mutation
  if [[ "$value_type" == "singleSelectOptionId" ]]; then
    mutation="mutation {
      updateProjectV2ItemFieldValue(input: {
        projectId: \"$PROJECT_ID\"
        itemId: \"$ITEM_ID\"
        fieldId: \"$field_id\"
        value: {singleSelectOptionId: \"$value\"}
      }) { projectV2Item { id } }
    }"
  elif [[ "$value_type" == "text" ]]; then
    mutation="mutation {
      updateProjectV2ItemFieldValue(input: {
        projectId: \"$PROJECT_ID\"
        itemId: \"$ITEM_ID\"
        fieldId: \"$field_id\"
        value: {text: \"$value\"}
      }) { projectV2Item { id } }
    }"
  elif [[ "$value_type" == "date" ]]; then
    mutation="mutation {
      updateProjectV2ItemFieldValue(input: {
        projectId: \"$PROJECT_ID\"
        itemId: \"$ITEM_ID\"
        fieldId: \"$field_id\"
        value: {date: \"$value\"}
      }) { projectV2Item { id } }
    }"
  fi

  gh api graphql -f query="$mutation" > /dev/null
}

# Set all fields
[[ -n "$PROJECT" ]] && set_field "Project" "${FIELD_IDS[Project]}" "${PROJECT_OPTIONS[$PROJECT]}" "singleSelectOptionId"
[[ -n "$STAGE" ]] && set_field "Stage" "${FIELD_IDS[Stage]}" "${STAGE_OPTIONS[$STAGE]}" "singleSelectOptionId"
[[ -n "$PRIORITY" ]] && set_field "Priority" "${FIELD_IDS[Priority]}" "${PRIORITY_OPTIONS[$PRIORITY]}" "singleSelectOptionId"
[[ -n "$QUARTER" ]] && set_field "ETA" "${FIELD_IDS[ETA]}" "${QUARTER_OPTIONS[$QUARTER]}" "singleSelectOptionId"
[[ -n "$STATUS" ]] && set_field "Status" "${FIELD_IDS[Status]}" "${STATUS_OPTIONS[$STATUS]}" "singleSelectOptionId"
[[ -n "$OWNER" ]] && set_field "Owner" "${FIELD_IDS[Owner]}" "$OWNER" "text"
[[ -n "$TARGET_DATE" ]] && set_field "Target Date" "${FIELD_IDS[TargetDate]}" "$TARGET_DATE" "date"
[[ -n "$EXPECTED_RESULTS" ]] && set_field "Expected Results" "${FIELD_IDS[ExpectedResults]}" "$EXPECTED_RESULTS" "text"

echo ""
echo "=== ✅ Sync Complete ==="
echo "View on project board: https://github.com/orgs/$ORG/projects/$PROJECT_NUMBER"
