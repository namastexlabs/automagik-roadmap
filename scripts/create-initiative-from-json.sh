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
  "stage": "Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped",
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

# Build issue body in RICH MARKDOWN format (NOT template format)
BODY=$(cat <<EOF
# $TITLE

**One-line Summary:** $DESCRIPTION | Timeline: TBD | Key risks: TBD

**Version:** 1.0 | **Status:** $STAGE | **Last Updated:** $(date +%Y-%m-%d)

---

## RASCI

**Responsible:** Development team (implementation execution)

**Accountable:** @$ACCOUNTABLE (owns success/failure and strategic decisions)

**Support:** TBD

**Consulted:** TBD

**Informed:** Automagik ecosystem teams

---

## Links & Related Documents

- **Related Initiatives:** TBD
- **Wish Documents:** TBD

---

## Overview (5W2H)

### What
$DESCRIPTION

### Why (Problem)
**Current Limitations:**
TBD - Document the problem this initiative solves

**Business Impact:**
TBD - Explain why this matters now

### Who
**For whom:** End users, developers, operators

**By whom:** Automagik $PROJECT team

### When
**Timeline:** $QUARTER

**Milestones:** TBD

### Where
**Touchpoints:** TBD - Systems/services affected

**Platforms:** TBD - Technical stack

### How
**Approach:** TBD - High-level implementation strategy

---

## Value Proposition

### Goals (Expected Results)
$EXPECTED_RESULTS

### Success Criteria
$SUCCESS_CRITERIA

### Non-Goals
TBD - What's explicitly out of scope

### Expected Impact

**For the Organization:**
TBD - Strategic benefits

**For Users/Customers:**
TBD - End-user benefits

**Metrics:**
TBD - Success metrics and targets

---

## Problem & Context

### Current State
TBD - Describe existing system/situation

### Why This Matters Now
TBD - Why prioritize this initiative

---

## Options & Proposals

| Proposal | Description | Advantages | Disadvantages | Cost | Recommendation |
|----------|-------------|------------|---------------|------|----------------|
| **Recommended Approach** | $DESCRIPTION | TBD | TBD | TBD | ⭐ Recommended |

---

## Scope

### In Scope
TBD - What will be delivered

### Out of Scope
TBD - What won't be delivered in this initiative

---

## Timeline & Phases

### Phase 1: Foundation (Weeks 1-2)
- [ ] TBD

**Success Criteria:** TBD

### Phase 2: Implementation (Weeks 3-4)
- [ ] TBD

**Success Criteria:** TBD

### Phase 3: Validation (Weeks 5-6)
- [ ] TBD

**Success Criteria:** TBD

---

## Dependencies & Risks

### Dependencies

| Dependency | Type | Owner | Status | Impact if Blocked |
|------------|------|-------|--------|-------------------|
| TBD | Internal | TBD | TBD | TBD |

### Risks & Mitigation

| Risk | Probability | Impact | Mitigation Strategy | Contingency Plan |
|------|-------------|--------|---------------------|------------------|
| TBD | Medium | High | TBD | TBD |

---

## Success Metrics & Tracking

### Launch Metrics
TBD - Metrics to track at launch

### Growth Metrics
TBD - Metrics to track over time

### Long-term Metrics
TBD - Strategic success indicators

### Monitoring & Dashboards
TBD - How we'll monitor success

---

## Open Questions & Future Considerations

### Open Questions
- [ ] TBD

### Future Considerations
TBD - Ideas for future phases
EOF
)

# Create issue with clean title (script will be piped to standard create-initiative.sh)
# Generate the markdown body and pipe to the standard script for proper handling
echo "Creating initiative: $TITLE"

# Build the command for the standard script
TEMP_BODY_FILE=$(mktemp)
echo "$BODY" > "$TEMP_BODY_FILE"

# Call the standard script with proper parameters
cat "$TEMP_BODY_FILE" | ./scripts/create-initiative.sh \
  --title "$TITLE" \
  --project "$PROJECT" \
  --stage "$STAGE" \
  --priority "$PRIORITY" \
  --quarter "$QUARTER" \
  --owner "$OWNER" \
  --type "$TYPE" \
  --areas "$AREAS"

rm "$TEMP_BODY_FILE"

# Note: The standard script handles all the rest (labels, project board, fields)
# and will output success messages
