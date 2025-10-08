# Automated Initiative Creation

This document explains how to create initiatives that are automatically added to the project board with all fields populated.

## Quick Start

1. **Go to GitHub Issues**: https://github.com/namastexlabs/automagik-roadmap/issues/new/choose
2. **Select "🎯 Roadmap Initiative"** template
3. **Fill out the form** with all required fields
4. **Submit** - automation handles the rest!

## What Gets Automated

When you create an initiative via the issue template, the GitHub Action automatically:

✅ **Adds to Project Board**: Issue is added to Project #9
✅ **Sets All Fields**: Project, Stage, Priority, ETA, Status, Owner, Target Date, Expected Results
✅ **Applies Labels**: All dimensional labels (project, stage, priority, quarter, type, area)
✅ **Posts Confirmation**: Comment with summary of fields set

## Template Fields

### Required Fields

| Field | Description | Example |
|-------|-------------|---------|
| **Project** | Which Automagik project | omni, hive, spark, forge, genie, tools, cross-project |
| **Description** | Problem, solution, impact | See template placeholder |
| **Expected Results** | Measurable outcomes | Bullet list of deliverables |
| **Responsible** | Lead executor (1 person) | @vasconceloscezar |
| **Accountable** | Final approver (1 person) | @vasconceloscezar |
| **Stage** | Current lifecycle stage | Wishlist, Exploring, RFC, etc. |
| **Priority** | Business priority | critical, high, medium, low |
| **Quarter** | Target delivery quarter | 2025-q4, 2026-q1, backlog |

### Optional Fields

| Field | Description | Example |
|-------|-------------|---------|
| **Success Criteria** | How we know it's complete | Checklist items |
| **Support** | Technical/ops support team | @user1, @user2 |
| **Consulted** | Who to consult | @team, @expert |
| **Informed** | Who to keep informed | @community |
| **Target Date** | Specific target date | 2026-03-31 |
| **Type** | Initiative type | feature, enhancement, research, infrastructure, documentation |
| **Areas** | Functional areas | api, mcp, workflows, agents |
| **Wish Folder** | Link to wish folder | projects/omni/wishes/my-feature/ |
| **Related Repos** | Links to repos/issues | namastexlabs/automagik-omni#123 |

## How It Works

### 1. Issue Template (.github/ISSUE_TEMPLATE/initiative.yml)

GitHub's issue form feature provides:
- Dropdowns for controlled values (project, stage, priority, quarter, type)
- Text inputs for free-form content
- Validation for required fields
- Structured YAML output in issue body

### 2. GitHub Action (.github/workflows/sync-to-project.yml)

The workflow automatically:

1. **Triggers** on issue creation/edit with `initiative` label
2. **Parses** the issue body to extract all field values
3. **Adds** issue to project board (Project #9)
4. **Waits** 5 seconds for project item to be created
5. **Gets** project item ID via GraphQL
6. **Sets** all custom fields via GraphQL mutations:
   - Project (single select)
   - Stage (single select)
   - Priority (single select)
   - ETA/Quarter (single select)
   - Status (single select, derived from Stage)
   - Owner (text, from Responsible field)
   - Target Date (date, calculated from quarter if not provided)
   - Expected Results (text)
7. **Applies** all dimensional labels
8. **Comments** on issue with confirmation

### 3. Auto-Calculated Fields

Some fields are automatically calculated:

**Status** (derived from Stage):
- Wishlist, Ideation, Exploring, RFC, Prioritization → **Todo**
- Executing, Preview → **In Progress**
- Shipped, Archived → **Done**

**Target Date** (if not provided):
- Uses quarter end date
- 2025-q4 → 2025-12-31
- 2026-q1 → 2026-03-31
- 2026-q2 → 2026-06-30
- 2026-q3 → 2026-09-30

**Labels** (auto-applied):
- `initiative` (always)
- `project:{project}` (e.g., project:omni)
- `{stage}` (e.g., Wishlist)
- `priority:{priority}` (e.g., priority:critical)
- `quarter:{quarter}` (e.g., quarter:2025-q4)
- `type:{type}` (if provided)
- `area:{area}` for each area (if provided)

## Requirements

### GitHub Secrets

The workflow requires:
- `ADD_TO_PROJECT_PAT`: Fine-grained PAT with permissions:
  - `repo` scope for reading issues
  - `project` write access to organization projects
  - `read:org` for organization access

### Label Setup

All labels must exist before using the template:
- Project labels: `project:omni`, `project:hive`, etc.
- Stage labels: `Wishlist`, `Ideation`, `Exploring`, etc.
- Priority labels: `priority:critical`, `priority:high`, etc.
- Quarter labels: `quarter:backlog`, `quarter:2025-q4`, etc.
- Type labels: `type:feature`, `type:enhancement`, etc.
- Area labels: `area:api`, `area:cli`, `area:mcp`, etc.

See [label-config.yml](../.github/label-config.yml) for full list.

## Examples

### Example 1: New Feature Initiative

```yaml
Project: omni
Stage: Exploring
Priority: high
Quarter: 2026-q1
Type: feature
Areas: mcp, messaging
Responsible: @vasconceloscezar
Accountable: @vasconceloscezar
```

**Result**:
- Added to project board
- Status set to "Todo" (from Exploring stage)
- Target Date set to "2026-03-31" (Q1 end)
- Labels: `initiative`, `project:omni`, `Exploring`, `priority:high`, `quarter:2026-q1`, `type:feature`, `area:mcp`, `area:messaging`

### Example 2: Critical Infrastructure Work

```yaml
Project: cross-project
Stage: Wishlist
Priority: critical
Quarter: 2025-q4
Type: infrastructure
Areas: workflows
Responsible: @vasconceloscezar
Accountable: @vasconceloscezar
Target Date: 2025-11-15
```

**Result**:
- Status set to "Todo"
- Target Date uses provided date (2025-11-15)
- Labels: `initiative`, `project:cross-project`, `Wishlist`, `priority:critical`, `quarter:2025-q4`, `type:infrastructure`, `area:workflows`

## Troubleshooting

### Issue not added to board

**Cause**: Missing `initiative` label
**Fix**: Add label manually, workflow will re-trigger on `labeled` event

### Fields not populated

**Cause**: Missing `ADD_TO_PROJECT_PAT` secret or insufficient permissions
**Fix**: Check secret exists and has correct permissions

### Wrong target date

**Cause**: Quarter format incorrect (should be lowercase: `2025-q4`)
**Fix**: Edit issue, change quarter format, workflow re-runs on `edited` event

### Labels not applied

**Cause**: Labels don't exist in repository
**Fix**: Run `./scripts/sync-labels.sh` to create all required labels

### GraphQL errors

**Cause**: Field IDs or option IDs changed (rare)
**Fix**: Update field/option IDs in workflow file by running:
```bash
gh api graphql -f query='
query {
  organization(login: "namastexlabs") {
    projectV2(number: 9) {
      fields(first: 20) {
        nodes {
          ... on ProjectV2SingleSelectField {
            id
            name
            options { id name }
          }
          ... on ProjectV2Field {
            id
            name
          }
        }
      }
    }
  }
}'
```

## Manual Fallback

If automation fails, you can still use the script:

```bash
./scripts/create-initiative.sh \
  --title "Your Initiative Title" \
  --project omni \
  --stage Exploring \
  --priority high \
  --quarter 2026-q1 \
  --owner vasconceloscezar \
  --type feature \
  --areas "api,mcp" \
  < /path/to/body.md
```

## Comparison: Template vs Script

| Aspect | GitHub Template | Shell Script |
|--------|----------------|--------------|
| **Ease of Use** | ✅ Web UI, no CLI needed | ⚠️ Requires terminal |
| **Validation** | ✅ Form validation | ⚠️ Manual checks |
| **Automation** | ✅ Fully automated | ⚠️ Some manual steps |
| **Speed** | ✅ Fast (< 30 seconds) | ⚠️ Slower (2-3 minutes) |
| **Flexibility** | ⚠️ Limited to form fields | ✅ Full control |
| **Recommended For** | Most users | Power users, automation |

## Future Enhancements

Planned improvements:
- [ ] Support for editing initiatives (update project fields)
- [ ] Validation of field values before setting
- [ ] Retry logic for failed GraphQL mutations
- [ ] Slack/Discord notifications on creation
- [ ] Auto-assignment based on project
- [ ] Template for other issue types (bugs, tasks)

## Related Documentation

- **Issue Template Guide**: [GitHub Docs](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms)
- **Project GraphQL API**: [GitHub Docs](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/using-the-api-to-manage-projects)
- **Stage Definitions**: [docs/stage-definitions.md](./stage-definitions.md)
- **RASCI Ownership**: [docs/rasci-guide.md](./rasci-guide.md)
- **Label System**: [docs/label-system.md](./label-system.md)
