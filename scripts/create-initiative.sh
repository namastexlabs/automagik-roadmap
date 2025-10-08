#!/bin/bash
# scripts/create-initiative.sh
# Creates a roadmap initiative with all fields properly set

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
  --title        Initiative title (without [Initiative] prefix)
  --project      Project name (omni|hive|spark|forge|genie|tools|cross-project)

Optional:
  --stage        Stage (Wishlist|Exploring|RFC|Priorization|Executing|Preview|Shipped|Archived) [default: Exploring]
  --priority     Priority (critical|high|medium|low) [default: medium]
  --quarter      Quarter (2025-Q4|2026-Q1|2026-Q2|etc|backlog) [default: backlog]
  --owner        GitHub username for assignment [default: current user]
  --type         Type label (feature|enhancement|research|infrastructure|documentation)
  --areas        Area labels comma-separated (api,mcp,cli,etc)

Example:
  $0 --title "Omni: Slack Integration" \\
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
  ["Priorization"]="a3c2913b"
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

# Build labels
LABELS="initiative,project:${PROJECT_NAME},${STAGE},priority:${PRIORITY},quarter:${QUARTER}"

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
echo "Title: [Initiative] ${PROJECT_NAME^}: $TITLE"
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

# Create the issue
echo "Creating issue..."
ISSUE_URL=$(gh issue create \
  --repo "$ORG/$REPO" \
  --title "[Initiative] ${PROJECT_NAME^}: $TITLE" \
  --label "$LABELS" \
  --assignee "$OWNER" \
  --body "$BODY")

ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -oP '#\K\d+')
echo "Created issue #$ISSUE_NUMBER: $ISSUE_URL"

# Add to project board
echo "Adding to project board..."
gh project item-add "$PROJECT_NUMBER" --owner "$ORG" --url "$ISSUE_URL"

# Get project item ID
echo "Getting project item ID..."
ITEM_ID=$(gh api graphql -f query="
query {
  organization(login: \"$ORG\") {
    projectV2(number: $PROJECT_NUMBER) {
      items(first: 20) {
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

echo "Project item ID: $ITEM_ID"

# Set custom fields
echo "Setting custom fields..."

# Set Project field
gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[Project]}\"
    value: {singleSelectOptionId: \"${PROJECT_OPTIONS[$PROJECT_NAME]}\"}
  }) { projectV2Item { id } }
}" > /dev/null

# Set Stage field
gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[Stage]}\"
    value: {singleSelectOptionId: \"${STAGE_OPTIONS[$STAGE]}\"}
  }) { projectV2Item { id } }
}" > /dev/null

# Set Priority field
gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[Priority]}\"
    value: {singleSelectOptionId: \"${PRIORITY_OPTIONS[$PRIORITY]}\"}
  }) { projectV2Item { id } }
}" > /dev/null

# Set ETA/Quarter field
gh api graphql -f query="
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: \"$PROJECT_ID\"
    itemId: \"$ITEM_ID\"
    fieldId: \"${FIELD_IDS[ETA]}\"
    value: {singleSelectOptionId: \"${QUARTER_OPTIONS[$QUARTER]}\"}
  }) { projectV2Item { id } }
}" > /dev/null

echo ""
echo "=== Initiative Created Successfully ==="
echo "URL: $ISSUE_URL"
echo "Number: #$ISSUE_NUMBER"
echo ""
echo "All fields set:"
echo "  ✓ Project: $PROJECT_NAME"
echo "  ✓ Stage: $STAGE"
echo "  ✓ Priority: $PRIORITY"
echo "  ✓ Quarter: $QUARTER"
echo "  ✓ Owner: $OWNER"
echo "  ✓ Labels: $LABELS"
echo ""
echo "View on project board: https://github.com/orgs/$ORG/projects/$PROJECT_NUMBER"
