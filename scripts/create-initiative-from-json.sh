#!/bin/bash
# scripts/create-initiative-from-json.sh
# Create initiative from JSON input - single command for LLMs

set -e

# Show usage if --help or -h
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  cat << 'EOF'
Usage: cat initiative.json | ./scripts/create-initiative-from-json.sh

Input JSON format:
{
  "title": "Initiative Title",
  "project": "omni|hive|spark|forge|genie|tools|cross-project",
  "stage": "Wishlist|Ideation|Exploring|RFC|Priorization|Executing|Preview|Shipped",
  "priority": "critical|high|medium|low",
  "quarter": "2025-q4|2026-q1|2026-q2|backlog|etc",
  "owner": "github-username",
  "type": "feature|enhancement|research|infrastructure|documentation",
  "areas": ["api", "mcp", "workflows"],
  "description": "Problem, solution, impact",
  "expected_results": ["Result 1", "Result 2"],
  "success_criteria": ["Criterion 1", "Criterion 2"]
}

Example:
  echo '{"title":"Slack Integration","project":"omni","stage":"Exploring","priority":"high","quarter":"2026-q1","owner":"vasconceloscezar","type":"feature","areas":["mcp","messaging"],"description":"Add Slack support","expected_results":["Slack working"]}' | ./scripts/create-initiative-from-json.sh
EOF
  exit 0
fi

# Read JSON from stdin
JSON=$(cat)

# Parse JSON fields
TITLE=$(echo "$JSON" | jq -r '.title')
PROJECT=$(echo "$JSON" | jq -r '.project')
STAGE=$(echo "$JSON" | jq -r '.stage // "Exploring"')
PRIORITY=$(echo "$JSON" | jq -r '.priority // "medium"')
QUARTER=$(echo "$JSON" | jq -r '.quarter // "backlog"')
OWNER=$(echo "$JSON" | jq -r '.owner // "vasconceloscezar"')
TYPE=$(echo "$JSON" | jq -r '.type // "feature"')
AREAS=$(echo "$JSON" | jq -r '.areas // [] | join(",")')
DESCRIPTION=$(echo "$JSON" | jq -r '.description')
EXPECTED_RESULTS=$(echo "$JSON" | jq -r '.expected_results // [] | map("- [ ] " + .) | join("\n")')
SUCCESS_CRITERIA=$(echo "$JSON" | jq -r '.success_criteria // [] | map("- [ ] " + .) | join("\n")')
RESPONSIBLE=$(echo "$JSON" | jq -r '.responsible // .owner // "vasconceloscezar"')
ACCOUNTABLE=$(echo "$JSON" | jq -r '.accountable // .owner // "vasconceloscezar"')

# Build issue body in template format
BODY=$(cat <<EOF
### Project

$PROJECT

### Description

$DESCRIPTION

### Expected Results (RESULTADO_ESPERADO)

$EXPECTED_RESULTS

### Success Criteria

$SUCCESS_CRITERIA

### Responsible

@$RESPONSIBLE

### Accountable

@$ACCOUNTABLE

### Support

_No response_

### Consulted

_No response_

### Informed

_No response_

### Stage

$STAGE

### Priority

$PRIORITY

### Quarter (ETA)

$QUARTER

### Target Date (Optional)

_No response_

### Type

$TYPE

### Areas (Optional)

$AREAS

### Wish Folder (Optional)

_No response_

### Related Repositories

_No response_
EOF
)

# Create issue
echo "Creating initiative: $TITLE"
ISSUE_URL=$(gh issue create \
  --repo namastexlabs/automagik-roadmap \
  --title "[Initiative] ${PROJECT^}: $TITLE" \
  --label "initiative" \
  --body "$BODY")

ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -oP '\d+$')

echo ""
echo "✅ Initiative created: $ISSUE_URL"
echo ""
echo "The GitHub Actions workflow will automatically:"
echo "  - Add to project board"
echo "  - Set all custom fields"
echo "  - Apply labels"
echo ""
echo "Check status: gh run list --workflow=sync-to-project.yml --limit 1"
echo "View on board: https://github.com/orgs/namastexlabs/projects/9"
