#!/bin/bash
# scripts/create-initiative-from-json.sh
# Create initiative from JSON input - supports both simple and rich formats

set -e

# Show usage if --help or -h
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  cat << 'EOF'
Usage: cat initiative.json | ./scripts/create-initiative-from-json.sh

See docs/templates/SAMPLE_INITIATIVE.json for complete example.

Simple JSON format (backwards compatible):
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
  "expected_results": ["Result 1", "Result 2"],
  "success_criteria": ["Criterion 1", "Criterion 2"]
}

Rich JSON format (recommended - see SAMPLE_INITIATIVE.json):
{
  "title": "...",
  "project": "...",
  "one_line_summary": {
    "problem": "...",
    "solution": "...",
    "impact": "...",
    "timeline": "8 weeks",
    "key_risks": "..."
  },
  "rasci": { "responsible": "...", "accountable": "...", "support": "...", "consulted": "...", "informed": "..." },
  "overview": { "what": "...", "why": {...}, "who": {...}, "when": {...}, "where": {...}, "how": "..." },
  "value_proposition": { "goals": [...], "non_goals": [...], "expected_impact": {...} },
  "options": [{...}],
  "phases": [{...}],
  ...
}
EOF
  exit 0
fi

# Read JSON from stdin
JSON=$(cat)

# Parse basic fields
TITLE=$(echo "$JSON" | jq -r '.title')
PROJECT=$(echo "$JSON" | jq -r '.project')
STAGE=$(echo "$JSON" | jq -r '.stage // "Exploring"')
PRIORITY=$(echo "$JSON" | jq -r '.priority // "medium"')
QUARTER=$(echo "$JSON" | jq -r '.quarter // "backlog"')
OWNER=$(echo "$JSON" | jq -r '.owner // "vasconceloscezar"')
TYPE=$(echo "$JSON" | jq -r '.type // "feature"')
AREAS=$(echo "$JSON" | jq -r '.areas // [] | join(",")')

# Check if rich format (has one_line_summary) or simple format
HAS_RICH_FORMAT=$(echo "$JSON" | jq 'has("one_line_summary")')

if [[ "$HAS_RICH_FORMAT" == "true" ]]; then
  # Parse rich format
  ONE_LINE_PROBLEM=$(echo "$JSON" | jq -r '.one_line_summary.problem // "TBD"')
  ONE_LINE_SOLUTION=$(echo "$JSON" | jq -r '.one_line_summary.solution // "TBD"')
  ONE_LINE_IMPACT=$(echo "$JSON" | jq -r '.one_line_summary.impact // "TBD"')
  ONE_LINE_TIMELINE=$(echo "$JSON" | jq -r '.one_line_summary.timeline // "TBD"')
  ONE_LINE_RISKS=$(echo "$JSON" | jq -r '.one_line_summary.key_risks // "TBD"')

  RASCI_RESPONSIBLE=$(echo "$JSON" | jq -r '.rasci.responsible // "Development team (implementation execution)"')
  RASCI_ACCOUNTABLE=$(echo "$JSON" | jq -r '.rasci.accountable // .owner // "vasconceloscezar"')
  RASCI_SUPPORT=$(echo "$JSON" | jq -r '.rasci.support // "TBD"')
  RASCI_CONSULTED=$(echo "$JSON" | jq -r '.rasci.consulted // "TBD"')
  RASCI_INFORMED=$(echo "$JSON" | jq -r '.rasci.informed // "Automagik ecosystem teams"')

  OVERVIEW_WHAT=$(echo "$JSON" | jq -r '.overview.what // "TBD"')
  OVERVIEW_WHY_LIMITATIONS=$(echo "$JSON" | jq -r '.overview.why.current_limitations // [] | map("- " + .) | join("\n")' || echo "TBD")
  OVERVIEW_WHY_IMPACT=$(echo "$JSON" | jq -r '.overview.why.business_impact // "TBD"')
  OVERVIEW_WHO_FOR=$(echo "$JSON" | jq -r '.overview.who.for_whom // "End users, developers, operators"')
  OVERVIEW_WHO_BY=$(echo "$JSON" | jq -r '.overview.who.by_whom // "Automagik '"$PROJECT"' team"')
  OVERVIEW_WHEN_TIMELINE=$(echo "$JSON" | jq -r '.overview.when.timeline // "'"$QUARTER"'"')
  OVERVIEW_WHEN_MILESTONES=$(echo "$JSON" | jq -r '.overview.when.milestones // [] | map("- " + .) | join("\n")' || echo "TBD")
  OVERVIEW_WHERE_TOUCHPOINTS=$(echo "$JSON" | jq -r '.overview.where.touchpoints // "TBD"')
  OVERVIEW_WHERE_PLATFORMS=$(echo "$JSON" | jq -r '.overview.where.platforms // "TBD"')
  OVERVIEW_HOW=$(echo "$JSON" | jq -r '.overview.how // "TBD"')

  VALUE_GOALS=$(echo "$JSON" | jq -r '.value_proposition.goals // [] | to_entries | map("- [ ] " + (.value)) | join("\n")')
  VALUE_NON_GOALS=$(echo "$JSON" | jq -r '.value_proposition.non_goals // [] | map("- " + .) | join("\n")' || echo "TBD")
  VALUE_ORG_IMPACT=$(echo "$JSON" | jq -r '.value_proposition.expected_impact.organization // [] | map("- " + .) | join("\n")' || echo "TBD")
  VALUE_USER_IMPACT=$(echo "$JSON" | jq -r '.value_proposition.expected_impact.users // [] | map("- " + .) | join("\n")' || echo "TBD")
  VALUE_METRICS=$(echo "$JSON" | jq -r '.value_proposition.expected_impact.metrics // [] | map("- " + .) | join("\n")' || echo "TBD")

  PROBLEM_CONTEXT=$(echo "$JSON" | jq -r '.problem_context // "TBD - Document the problem this initiative solves"')

  # Build options table
  OPTIONS_TABLE=$(echo "$JSON" | jq -r '
    if .options then
      .options | to_entries | map(
        "| **" + .value.name + "** | " + .value.description + " | " +
        ((.value.advantages // []) | map("• " + .) | join("<br>")) + " | " +
        ((.value.disadvantages // []) | map("• " + .) | join("<br>")) + " | " +
        .value.cost + " | " +
        (if .value.recommendation == "recommended" then "⭐ Recommended" else "Not recommended" end) + " |"
      ) | join("\n")
    else
      "| **Recommended Approach** | TBD | TBD | TBD | TBD | ⭐ Recommended |"
    end
  ')

  SCOPE_IN=$(echo "$JSON" | jq -r '.scope.in_scope // [] | map("- " + .) | join("\n")' || echo "TBD")
  SCOPE_OUT=$(echo "$JSON" | jq -r '.scope.out_of_scope // [] | map("- " + .) | join("\n")' || echo "TBD")

  # Build phases sections
  PHASES_CONTENT=$(echo "$JSON" | jq -r '
    if .phases then
      .phases | to_entries | map(
        "### Phase " + (.key + 1 | tostring) + ": " + .value.name + " (Weeks " + .value.weeks + ")\n" +
        ((.value.tasks // []) | map("- [ ] " + .) | join("\n")) + "\n\n" +
        "**Success Criteria:** " + (.value.success_criteria // "TBD")
      ) | join("\n\n")
    else
      "### Phase 1: Foundation (Weeks 1-2)\n- [ ] TBD\n\n**Success Criteria:** TBD\n\n### Phase 2: Implementation (Weeks 3-4)\n- [ ] TBD\n\n**Success Criteria:** TBD"
    end
  ')

  # Build dependencies table
  DEPENDENCIES_TABLE=$(echo "$JSON" | jq -r '
    if .dependencies then
      .dependencies | map(
        "| " + .item + " | " + .type + " | " + .owner + " | " + .status + " | " + .impact_if_blocked + " |"
      ) | join("\n")
    else
      "| TBD | Internal | TBD | TBD | TBD |"
    end
  ')

  # Build risks table
  RISKS_TABLE=$(echo "$JSON" | jq -r '
    if .risks then
      .risks | map(
        "| " + .risk + " | " + .probability + " | " + .impact + " | " + .mitigation + " | " + .contingency + " |"
      ) | join("\n")
    else
      "| TBD | Medium | High | TBD | TBD |"
    end
  ')

  METRICS_LAUNCH=$(echo "$JSON" | jq -r '.success_metrics.launch // [] | map("- " + .) | join("\n")' || echo "TBD")
  METRICS_GROWTH=$(echo "$JSON" | jq -r '.success_metrics.growth // [] | map("- " + .) | join("\n")' || echo "TBD")
  METRICS_LONGTERM=$(echo "$JSON" | jq -r '.success_metrics.long_term // [] | map("- " + .) | join("\n")' || echo "TBD")

  OPEN_QUESTIONS=$(echo "$JSON" | jq -r '.open_questions // [] | map("- [ ] " + .) | join("\n")' || echo "- [ ] TBD")
  FUTURE_CONSIDERATIONS=$(echo "$JSON" | jq -r '.future_considerations // [] | map("- " + .) | join("\n")' || echo "TBD")

else
  # Simple format (backwards compatibility)
  DESCRIPTION=$(echo "$JSON" | jq -r '.description // "TBD"')
  ONE_LINE_PROBLEM="TBD"
  ONE_LINE_SOLUTION="$DESCRIPTION"
  ONE_LINE_IMPACT="TBD"
  ONE_LINE_TIMELINE="TBD"
  ONE_LINE_RISKS="TBD"

  RASCI_RESPONSIBLE="Development team (implementation execution)"
  RASCI_ACCOUNTABLE=$(echo "$JSON" | jq -r '.accountable // .owner // "vasconceloscezar"')
  RASCI_SUPPORT="TBD"
  RASCI_CONSULTED="TBD"
  RASCI_INFORMED="Automagik ecosystem teams"

  OVERVIEW_WHAT="$DESCRIPTION"
  OVERVIEW_WHY_LIMITATIONS="TBD"
  OVERVIEW_WHY_IMPACT="TBD"
  OVERVIEW_WHO_FOR="End users, developers, operators"
  OVERVIEW_WHO_BY="Automagik $PROJECT team"
  OVERVIEW_WHEN_TIMELINE="$QUARTER"
  OVERVIEW_WHEN_MILESTONES="TBD"
  OVERVIEW_WHERE_TOUCHPOINTS="TBD"
  OVERVIEW_WHERE_PLATFORMS="TBD"
  OVERVIEW_HOW="TBD"

  VALUE_GOALS=$(echo "$JSON" | jq -r '.expected_results // [] | map("- [ ] " + .) | join("\n")')
  VALUE_NON_GOALS="TBD"
  VALUE_ORG_IMPACT="TBD"
  VALUE_USER_IMPACT="TBD"
  VALUE_METRICS="TBD"

  PROBLEM_CONTEXT="TBD"
  OPTIONS_TABLE="| **Recommended Approach** | $DESCRIPTION | TBD | TBD | TBD | ⭐ Recommended |"
  SCOPE_IN="TBD"
  SCOPE_OUT="TBD"
  PHASES_CONTENT="### Phase 1: Foundation (Weeks 1-2)\n- [ ] TBD\n\n**Success Criteria:** TBD"
  DEPENDENCIES_TABLE="| TBD | Internal | TBD | TBD | TBD |"
  RISKS_TABLE="| TBD | Medium | High | TBD | TBD |"
  METRICS_LAUNCH="TBD"
  METRICS_GROWTH="TBD"
  METRICS_LONGTERM="TBD"
  OPEN_QUESTIONS="- [ ] TBD"
  FUTURE_CONSIDERATIONS="TBD"
fi

# Build issue body following STANDARD_INITIATIVE.md template
BODY=$(cat <<EOF
# $TITLE

**One-line Summary:** $ONE_LINE_PROBLEM → $ONE_LINE_SOLUTION → $ONE_LINE_IMPACT | Timeline: $ONE_LINE_TIMELINE | Key risks: $ONE_LINE_RISKS

**Version:** 1.0 | **Status:** $STAGE | **Last Updated:** $(date +%Y-%m-%d)

---

## RASCI

**Responsible:** $RASCI_RESPONSIBLE

**Accountable:** @$RASCI_ACCOUNTABLE (owns success/failure and strategic decisions)

**Support:** $RASCI_SUPPORT

**Consulted:** $RASCI_CONSULTED

**Informed:** $RASCI_INFORMED

---

## Links & Related Documents

- **Related Initiatives:** TBD
- **PRs/Implementation:** TBD
- **Design Docs:** TBD
- **Metrics Dashboard:** TBD

---

## Overview (5W2H)

### What
$OVERVIEW_WHAT

### Why (Problem)
**Current Limitations:**
$OVERVIEW_WHY_LIMITATIONS

**Business Impact:**
$OVERVIEW_WHY_IMPACT

### Who
**For whom:** $OVERVIEW_WHO_FOR

**By whom:** $OVERVIEW_WHO_BY

### When
**Timeline:** $OVERVIEW_WHEN_TIMELINE

**Milestones:**
$OVERVIEW_WHEN_MILESTONES

### Where
**Touchpoints:** $OVERVIEW_WHERE_TOUCHPOINTS

**Platforms:** $OVERVIEW_WHERE_PLATFORMS

### How
$OVERVIEW_HOW

---

## Value Proposition

### Goals (Expected Results)
$VALUE_GOALS

### Non-Goals
$VALUE_NON_GOALS

### Expected Impact

**For the Organization:**
$VALUE_ORG_IMPACT

**For Users/Customers:**
$VALUE_USER_IMPACT

**Metrics:**
$VALUE_METRICS

---

## Problem & Context

$PROBLEM_CONTEXT

---

## Options & Proposals

| Proposal | Description | Advantages | Disadvantages | Cost | Recommendation |
|----------|-------------|------------|---------------|------|----------------|
$OPTIONS_TABLE

**Selected Approach:** First option - Brief rationale

---

## Scope

### In Scope
$SCOPE_IN

### Out of Scope (for now)
$SCOPE_OUT

---

## Timeline & Phases

$PHASES_CONTENT

---

## Dependencies & Risks

### Dependencies

| Dependency | Type | Owner | Status | Impact if Blocked |
|------------|------|-------|--------|-------------------|
$DEPENDENCIES_TABLE

### Risks & Mitigation

| Risk | Probability | Impact | Mitigation Strategy | Contingency Plan |
|------|-------------|--------|---------------------|------------------|
$RISKS_TABLE

---

## Success Metrics & Tracking

### Launch Metrics (Week 1-4)
$METRICS_LAUNCH

### Growth Metrics (Month 2-3)
$METRICS_GROWTH

### Long-term Metrics (Month 6+)
$METRICS_LONGTERM

### Monitoring & Dashboards
- Dashboard 1: TBD
- Alert conditions: TBD

---

## Open Questions & Future Considerations

### Open Questions
$OPEN_QUESTIONS

### Future Considerations
$FUTURE_CONSIDERATIONS
EOF
)

# Create issue with clean title (pipe to standard create-initiative.sh)
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
