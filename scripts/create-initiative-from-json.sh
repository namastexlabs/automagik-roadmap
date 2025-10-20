#!/bin/bash
# scripts/create-initiative-from-json.sh
# Create initiative from JSON input - supports both simple and rich formats
# Version 2.0 - Fixed to work with gh CLI limitations

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

# Show usage if --help or -h
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  cat << 'EOF'
Usage: cat initiative.json | ./scripts/create-initiative-from-json.sh

Simple JSON format:
{
  "title": "Initiative Title",
  "project": "omni|hive|spark|forge|genie|tools|cross-project",
  "stage": "Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped",
  "priority": "critical|high|medium|low",
  "quarter": "2025-Q4|2026-Q1|backlog",
  "owner": "github-username",
  "type": "feature|enhancement|research|infrastructure|documentation",
  "areas": ["api", "mcp"],
  "description": "Problem, solution, impact",
  "goals": ["Goal 1", "Goal 2"]
}

Example:
{
  "title": "Test Initiative",
  "project": "hive",
  "stage": "Wishlist",
  "priority": "low",
  "quarter": "backlog",
  "owner": "vasconceloscezar",
  "type": "feature",
  "areas": ["testing"],
  "description": "Testing the JSON initiative creation script",
  "goals": [
    "Verify script works correctly",
    "Test all field population",
    "Validate node_id lookup"
  ]
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
QUARTER=$(echo "$JSON" | jq -r '.quarter // "backlog"')
OWNER=$(echo "$JSON" | jq -r '.owner // "vasconceloscezar"')
TYPE=$(echo "$JSON" | jq -r '.type // "feature"')
AREAS=$(echo "$JSON" | jq -r '.areas // [] | join(",")')

# Validate required fields
if [[ -z "$RAW_TITLE" || "$RAW_TITLE" == "null" ]]; then
  echo "Error: title is required in JSON"
  exit 1
fi

if [[ -z "$PROJECT" || "$PROJECT" == "null" ]]; then
  echo "Error: project is required in JSON"
  exit 1
fi

# Format title with project prefix: "Product: Clear Title"
# Capitalize project name properly
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

# Only add prefix if title doesn't already have it
if [[ "$RAW_TITLE" =~ ^[A-Za-z-]+:  ]]; then
  TITLE="$RAW_TITLE"
else
  TITLE="${PROJECT_PREFIX}: ${RAW_TITLE}"
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

# Build LEAN markdown body
DESCRIPTION=$(echo "$JSON" | jq -r '.description // "TBD"')
TIMELINE=$(echo "$JSON" | jq -r '.timeline // "TBD"')

# Format goals as numbered list
GOALS_ARRAY=$(echo "$JSON" | jq -r '.goals // []')
GOALS=""
if [[ "$GOALS_ARRAY" != "[]" ]]; then
  i=1
  while IFS= read -r goal; do
    if [[ -n "$goal" ]]; then
      GOALS="${GOALS}${i}. **${goal}** - Description and success metric\n"
      ((i++))
    fi
  done < <(echo "$GOALS_ARRAY" | jq -r '.[]')
else
  GOALS="1. **Goal 1** - Description with success metric\n2. **Goal 2** - Description with success metric\n3. **Goal 3** - Description with success metric"
fi

BODY=$(cat <<EOF
# $TITLE

> **TL;DR:** $DESCRIPTION
> **Owner:** @$OWNER | **Stage:** $STAGE | **Timeline:** $TIMELINE

> [!IMPORTANT]
> **Key Context:** Add any critical context, dependencies, or why this matters NOW.

---

## 🎯 Goals & Scope

**What we're building:**
$(echo -e "$GOALS")

**Out of scope:**
- Thing we're explicitly NOT doing
- Thing we're deferring to future
- Thing that's out of bounds

<details>
<summary><b>📋 Detailed Scope Breakdown</b></summary>

### Component/Feature Area 1
- Specific feature A
- Specific feature B
- **Example:** Concrete use case

### Component/Feature Area 2
- Specific feature C
- Specific feature D
- **Example:** Concrete use case

</details>

---

## 🚨 Problem & Why Now

**Current pain:**
Describe the problem in 2-4 sentences. What's broken? What's frustrating users? What's holding back growth?

**Why this matters:**
Explain business/user impact in 1-2 sentences. Why is this important? What happens if we don't do this?

**Example workflow** users want but can't build today:
\`\`\`
Step 1 → Step 2 → Step 3 → Step 4
\`\`\`
**Currently:** What users have to do now (painful)
**After this:** What users will be able to do (easy)

**Users affected:**
- User persona 1 - Why they care
- User persona 2 - Why they care

> [!NOTE]
> **Evidence:** Link to user research, support tickets, or metrics showing the problem.

---

## 📅 Timeline & Phases

**High-level roadmap:**
- **Phase 1:** Name (Dates) - 1-line summary
- **Phase 2:** Name (Dates) - 1-line summary
- **Phase 3:** Name (Dates) - 1-line summary

<details>
<summary><b>🗓️ Detailed Phase Breakdown</b></summary>

### Phase 1: Name (Start Date - End Date)

**Goals:** What we're trying to achieve in this phase

**Tasks:**
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

**Success Criteria:** How we know this phase is done

---

### Phase 2: Name (Start Date - End Date)

**Goals:** What we're trying to achieve in this phase

**Tasks:**
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

**Success Criteria:** How we know this phase is done

> [!TIP]
> Use comments to update phase progress. Pin a status comment showing current phase, % complete, blockers.

</details>

---

## ⚠️ Risks & Mitigation

| Risk | Probability | Impact | Mitigation Strategy |
|:-----|:-----------:|:------:|:--------------------|
| Risk 1 | High/Med/Low | High/Med/Low | How we'll address this |
| Risk 2 | High/Med/Low | High/Med/Low | How we'll address this |
| Risk 3 | High/Med/Low | High/Med/Low | How we'll address this |

> [!WARNING]
> **Critical Dependencies:** Highlight any major blockers or dependencies that could derail the initiative.

<details>
<summary><b>🔍 Risk Details & Contingency Plans</b></summary>

### Risk 1 Name
**Description:** Deeper explanation of the risk
**Probability:** Why we think this might happen
**Impact:** What happens if this risk materializes
**Mitigation:** Detailed strategy for prevention
**Contingency:** What we do if mitigation fails

</details>

---

## 📊 Success Metrics

**Targets by {End Date/Quarter}:**

| Metric | Baseline | Target | Tracking |
|:-------|:--------:|:------:|:---------|
| Metric 1 | Current value | Goal value | Dashboard/tool |
| Metric 2 | Current value | Goal value | Dashboard/tool |
| Metric 3 | Current value | Goal value | Dashboard/tool |

<details>
<summary><b>📈 Metrics Breakdown by Phase</b></summary>

### Launch Metrics (Week 1-4)
- **Metric A:** Baseline → Week 4 target
- **Metric B:** Baseline → Week 4 target

### Growth Metrics (Month 2-3)
- **Metric C:** Month 1 → Month 3 target
- **Metric D:** Month 1 → Month 3 target

### Long-term Metrics (Month 6+)
- **Metric E:** Month 3 → Month 6+ target

</details>

---

## 🔗 Related

**Team & Ownership:**
- **Accountable:** @$OWNER (owns success/failure)
- **Responsible:** Team or people executing the work
- **Consulted:** Stakeholders who provide input
- **Informed:** People who need updates

**Related Work:**
- **Initiatives:** #XX, #YY
- **PRs/Implementation:** TBD
- **Design Docs:** TBD

<details>
<summary><b>📚 Full RASCI Matrix</b></summary>

| Role | Person/Team | Responsibilities |
|:-----|:------------|:-----------------|
| **R**esponsible | Team/users | What they execute |
| **A**ccountable | @$OWNER | Owns final outcomes |
| **S**upport | Team | Resources they provide |
| **C**onsulted | Stakeholders | Input they provide |
| **I**nformed | Leadership | Updates they receive |

</details>

---

## 💬 Using Comments for Updates

> [!TIP]
> Use comments on this issue for:
> - **Status updates** - Pin a comment with current phase, progress %, blockers
> - **Decisions** - Document key architectural or scope decisions
> - **Questions** - Thread discussions about specific sections
> - **Implementation links** - Link PRs as they're merged
>
> Keep the issue body as the **reference document** (stable), comments for **temporal info** (changes over time).
EOF
)

echo "=== Creating Initiative from JSON ==="
echo "Title: $TITLE"
echo "Project: $PROJECT"
echo "Stage: $STAGE"
echo "Priority: $PRIORITY"
echo "Quarter: $QUARTER"
echo "Owner: $OWNER"
echo "Labels: $LABELS"
echo ""

# Create the issue - gh CLI only returns URL
echo "Creating issue..."
TEMP_BODY_FILE=$(mktemp)
echo "$BODY" > "$TEMP_BODY_FILE"

ISSUE_URL=$(gh issue create \
  --repo "$ORG/$REPO" \
  --title "$TITLE" \
  --label "$LABELS" \
  --assignee "$OWNER" \
  --body-file "$TEMP_BODY_FILE")

rm "$TEMP_BODY_FILE"

# Extract issue number from URL
ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -oP '/issues/\K\d+')

echo "Created issue #$ISSUE_NUMBER: $ISSUE_URL"
echo ""

# Wait a moment, then get issue metadata including node_id
echo "Getting issue metadata..."
sleep 2

# Use gh issue view to get node_id
ISSUE_METADATA=$(gh issue view "$ISSUE_NUMBER" --repo "$ORG/$REPO" --json id,number,title,url)
ISSUE_NODE_ID=$(echo "$ISSUE_METADATA" | jq -r '.id')

echo "Issue node ID: $ISSUE_NODE_ID"
echo ""

# Wait for workflow to add the issue to the project board
echo "Waiting for workflow to add issue to project board..."
echo "  This usually takes 10-15 seconds..."
sleep 12

# Get project item ID using node_id
echo "Looking up project item by issue node ID..."
ITEM_ID=""
MAX_RETRIES=25
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
    # Verify title matches
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
      break
    else
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
  echo "Issue created successfully, but project board sync failed."
  echo "URL: $ISSUE_URL"
  echo "Please check workflow: https://github.com/$ORG/$REPO/actions"
  echo ""
  exit 1
fi

echo ""
echo "Project item found!"
echo ""

# Set custom fields
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
    value: {singleSelectOptionId: \"${PROJECT_OPTIONS[$PROJECT]}\"}
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

# Set Expected Results from goals
if [[ -n "$GOALS" && "$GOALS" != "null" ]]; then
  EXPECTED_RESULTS=$(echo "$GOALS" | head -c 300)
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
fi

# Set Owner field
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

# Calculate Target Date from quarter
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

# Set Target Date field
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

set -e

echo ""
echo "=== Initiative Created ==="
echo "URL: $ISSUE_URL"
echo "Number: #$ISSUE_NUMBER"
echo "Node ID: $ISSUE_NODE_ID"
echo "Project Item ID: $ITEM_ID"
echo ""

# Show summary
if [[ ${#FAILED_FIELDS[@]} -eq 0 ]]; then
  echo "✅ All fields set successfully:"
  echo "  ✓ Project: $PROJECT"
  echo "  ✓ Stage: $STAGE"
  echo "  ✓ Status: $STATUS"
  echo "  ✓ Priority: $PRIORITY"
  echo "  ✓ Quarter: $QUARTER"
  echo "  ✓ Owner: @$OWNER"
  echo "  ✓ Target Date: ${TARGET_DATE:-Not set (backlog)}"
  echo "  ✓ Labels: $LABELS"
else
  echo "⚠️  Initiative created but some fields failed:"
  echo ""
  echo "Failed fields:"
  for field in "${FAILED_FIELDS[@]}"; do
    echo "  ✗ $field"
  done
  echo ""
  echo "Please manually set these in project board."
fi

echo ""
echo "View on project board: https://github.com/orgs/$ORG/projects/$PROJECT_NUMBER"
