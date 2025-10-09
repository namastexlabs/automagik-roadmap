# Issue Templates

Template files for creating consistent GitHub issues across Automagik project repositories.

---

## Templates

### 1. 🐛 Bug Report (`bug-report.yml`)

**Purpose:** Community bugs and standalone issues

**Auto-Applied Labels:**
- `type:bug`
- `status:needs-triage`
- `priority:medium` (default, adjust during triage)

**Key Fields:**
- Bug description (required)
- Steps to reproduce (required)
- Expected vs actual behavior (required)
- Environment (required)
- Impact level (informational)
- Affected areas (optional, helps routing)

**Title Format:** `[Bug] User's title`

---

### 2. ✨ Feature Request (`feature-request.yml`)

**Purpose:** Community suggestions and enhancement ideas

**Auto-Applied Labels:**
- `type:enhancement`
- `status:needs-review`
- `priority:medium` (default, adjust during review)

**Key Fields:**
- Feature summary (required)
- Problem statement (required)
- Proposed solution (required)
- Use cases (required)
- Alternatives considered (optional)
- Willingness to contribute (optional)

**Title Format:** `[Feature] User's title`

---

### 3. 🎯 Planned Feature (`planned-feature.yml`)

**Purpose:** Team/agent work linked to roadmap initiatives

**Auto-Applied Labels:**
- `planned-feature` (triggers linking workflow)
- `priority:medium` (default, can override)

**Workflow-Added Labels:**
- `roadmap-linked` (after successful link)
- `initiative-{number}` (dynamic, based on initiative)

**Key Fields:**
- Initiative number (required, triggers workflow)
- Work type (required: bug/feature/debt/etc.)
- Title (required, clean format)
- Description (required)
- Acceptance criteria (required)
- Context/evidence (optional)
- Dependencies (optional)
- Complexity estimate (optional)
- Priority override (optional)
- Areas (optional, informational)
- Related wish (optional)

**Title Format:** User provides clean title (no prefix)

**Workflow Behavior:**
1. Validates initiative exists in automagik-roadmap
2. Creates sub-issue relationship via GraphQL
3. Adds `roadmap-linked` + `initiative-{number}` labels
4. Comments with confirmation

---

### 4. Configuration (`config.yml`)

**Settings:**
- `blank_issues_enabled: true` - Allows quick notes
- Contact links to Discord, docs, roadmap

---

## Installation

### Copy to Repository

```bash
# Navigate to target repo
cd /path/to/automagik-{repo}

# Create directory
mkdir -p .github/ISSUE_TEMPLATE

# Copy templates
cp /path/to/automagik-roadmap/docs/templates/issue-templates/*.yml .github/ISSUE_TEMPLATE/

# Verify
ls -la .github/ISSUE_TEMPLATE/
```

### Customize for Repo

**Edit `bug-report.yml` and `feature-request.yml`:**

Update the "Affected Areas" checkboxes to match repo-specific components:

```yaml
# Example for genie repo
options:
  - label: CLI
  - label: MCP Server
  - label: Agents
  - label: Wishes
  - label: Forge
  - label: Templates
  - label: Docs
  - label: Build/Testing

# Example for omni repo
options:
  - label: API
  - label: Channels (Slack, WhatsApp, etc.)
  - label: Evolution API
  - label: MCP Server
  - label: Docs
  - label: Build/Testing
```

**Edit `planned-feature.yml`:**

Same customization for Component/Area checkboxes.

**Edit `config.yml`:**

Update Discord/docs URLs if repo has specific documentation.

---

## Testing Templates

### 1. Test Bug Report
```bash
# Create test issue via GitHub UI
# Or via CLI:
gh issue create --template bug-report.yml --web
```

**Verify:**
- Title has `[Bug]` prefix
- Labels: `type:bug`, `status:needs-triage`, `priority:medium`
- All required fields present

### 2. Test Feature Request
```bash
gh issue create --template feature-request.yml --web
```

**Verify:**
- Title has `[Feature]` prefix
- Labels: `type:enhancement`, `status:needs-review`, `priority:medium`
- All required fields present

### 3. Test Planned Feature
```bash
gh issue create --template planned-feature.yml --web
```

**Verify:**
- Labels: `planned-feature`, `priority:medium`
- Initiative field triggers workflow
- After workflow: `roadmap-linked` and `initiative-{number}` added
- Sub-issue relationship created

---

## Label Behavior

### Auto-Applied (On Issue Creation)

| Template | Labels |
|----------|--------|
| Bug Report | `type:bug`, `status:needs-triage`, `priority:medium` |
| Feature Request | `type:enhancement`, `status:needs-review`, `priority:medium` |
| Planned Feature | `planned-feature`, `priority:medium` |

### Workflow-Applied (After Creation)

| Template | Labels | Trigger |
|----------|--------|---------|
| Planned Feature | `roadmap-linked`, `initiative-{number}` | Linking workflow success |

### Manual (Triager Adds)

- `area:*` labels - Based on checkboxes, manually applied
- `priority:*` overrides - If default medium isn't appropriate
- `status:*` updates - As work progresses

---

## Design Decisions

### Priority Strategy
- **Default:** All issues start with `priority:medium`
- **Rationale:** Prevents over-escalation, triager adjusts based on actual impact
- **Impact field:** Informational only, doesn't auto-label

### Area Labels
- **Checkboxes:** Help users categorize, but informational only
- **Rationale:** Users might select too many, triager refines
- **Application:** Manually added during triage based on checkboxes

### Blank Issues
- **Enabled:** Allows quick notes and discussions
- **Rationale:** Templates are comprehensive, sometimes quick issue needed
- **Alternative:** Users can use templates for structured issues

---

## Next Steps

After installing templates:

1. **Deploy linking workflow** - See `roadmap-linking-workflow.md` (pending)
2. **Test with real issues** - Create 2-3 test issues per template
3. **Gather feedback** - Iterate on field structure based on usage
4. **Document in README** - Link to templates from repo README

---

## Related Documentation

- [Project Label Guide](../../project-label-guide.md) - Label taxonomy
- [Label Rollout Guide](../../label-rollout-guide.md) - Deployment steps
- [Cross-Repo References](../../cross-repo-references.md) - Linking patterns

---

*Last updated: 2025-10-09*
