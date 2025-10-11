# 🏷️ Project Repository Label Guide

Complete taxonomy and usage guide for labels in Automagik project repositories (genie, omni, hive, spark, forge, tools).

---

## Overview

Automagik project repositories use a **unified label taxonomy** adapted from the roadmap repo, designed for implementation tracking and roadmap integration.

**Key Differences from Roadmap Labels:**
- ❌ No `project:*` labels (each repo is one project)
- ❌ No `quarter:*` labels (roadmap handles scheduling)
- ❌ No stage labels (initiatives have stages, not individual issues)
- ✅ Adds roadmap linking labels (`planned-feature`, `roadmap-linked`)
- ✅ Adds release versioning labels (`release:patch`, `release:minor`, `release:major`)
- ✅ Adds status tracking labels (`status:blocked`, `status:in-progress`)

**Total Labels:** ~56 base labels + 2-4 repo-specific (includes wish workflow labels)

---

## Label Dimensions

### 1. 🎯 Type Dimension (7 labels)

Categorizes the kind of work.

| Label | Color | Description | When to Use |
|-------|-------|-------------|-------------|
| `type:bug` | `#D73A4A` | Something isn't working | Defects, errors, broken functionality |
| `type:feature` | `#7057FF` | New capability | Wholly new functionality |
| `type:enhancement` | `#A2EEEF` | Improvement to existing | Enhancements to existing features |
| `type:debt` | `#795548` | Technical debt | Refactoring, cleanup, maintenance |
| `type:docs` | `#0075CA` | Documentation only | Docs changes without code |
| `type:testing` | `#FFEB3B` | Test infrastructure | Test additions, test tooling |
| `type:research` | `#FFC107` | Investigation/spike | Research, exploration, POCs |

**Usage:**
- Every issue SHOULD have exactly one type label
- Applied via issue template or manually
- Helps filter and categorize work

---

### 2. ⚡ Priority Dimension (4 labels)

Indicates urgency and importance.

| Label | Color | Description | When to Use |
|-------|-------|-------------|-------------|
| `priority:critical` | `#D93F0B` | Blocker, urgent | Production down, security issue, customer blocker |
| `priority:high` | `#FF9800` | Important, soon | Key feature, significant impact |
| `priority:medium` | `#FFC107` | Normal priority | Standard work item |
| `priority:low` | `#CDDC39` | Nice to have | Future enhancement, minor |

**Usage:**
- Every issue SHOULD have a priority label
- Priority can change based on context
- Critical priorities are rare and urgent

---

### 3. 🔧 Area Dimension (15 base + repo-specific)

Technical domain or functional area.

#### Base Areas (All Repos)

| Label | Color | Description |
|-------|-------|-------------|
| `area:api` | `#006B75` | Backend, REST/GraphQL APIs, webhooks |
| `area:cli` | `#006B75` | Command-line interface and tools |
| `area:mcp` | `#006B75` | Model Context Protocol integration |
| `area:agents` | `#006B75` | Agent prompts, logic, orchestration |
| `area:ui` | `#006B75` | User interface, dashboards, web views |
| `area:docs` | `#006B75` | Documentation, guides, tutorials |
| `area:testing` | `#006B75` | Test infrastructure, test suites |
| `area:build` | `#006B75` | Build system, CI/CD, deployment |
| `area:auth` | `#006B75` | Authentication, authorization |
| `area:storage` | `#006B75` | Database, persistence, caching |
| `area:performance` | `#006B75` | Optimization, scaling |
| `area:security` | `#006B75` | Security features, vulnerabilities |
| `area:workflows` | `#006B75` | Workflow orchestration, automation |
| `area:messaging` | `#006B75` | Messaging systems, integrations |
| `area:knowledge` | `#006B75` | RAG, embeddings, vector DB |

#### Repo-Specific Areas

**Genie:**
- `area:wishes` - Wish system and workflow
- `area:forge` - Forge agent and task breakdown
- `area:templates` - Template management and init

**Omni:**
- `area:channels` - Channel integrations (Slack, WhatsApp, etc.)
- `area:evolution` - Evolution API integration

**Hive:**
- `area:orchestration` - Multi-agent coordination
- `area:swarm` - Swarm intelligence features

**Usage:**
- Issues MAY have one or more area labels
- Use multiple if work spans domains
- Helps routing and filtering

---

### 4. 🔗 Roadmap Linking (3+ labels)

Links issues to strategic roadmap initiatives.

| Label | Color | Description | Applied By |
|-------|-------|-------------|------------|
| `planned-feature` | `#B60205` | Work linked to roadmap initiative | Issue template |
| `roadmap-linked` | `#0E8A16` | Successfully linked as sub-issue | Workflow (auto) |
| `closed-initiative-work` | `#FBCA04` | Parent initiative is closed | Workflow (auto) |
| `initiative-{number}` | Dynamic | Links to specific initiative (e.g., `initiative-42`) | Workflow (auto) |

**Usage:**
- `planned-feature` triggers auto-linking workflow
- Workflow validates initiative exists and creates sub-issue relationship
- `roadmap-linked` confirms successful linking
- `initiative-{number}` labels created dynamically per initiative

**Workflow:**
```
Developer creates issue with planned-feature label
  ↓
Workflow parses initiative number from issue body
  ↓
Validates initiative exists in automagik-roadmap
  ↓
Creates sub-issue link via GraphQL API
  ↓
Adds roadmap-linked + initiative-{number} labels
  ↓
Comments with confirmation
```

---

### 5. 📦 Release/Versioning (4 labels)

Semantic versioning for release management.

| Label | Color | Description | Version Bump |
|-------|-------|-------------|--------------|
| `release:patch` | `#FEF2C0` | Backwards-compatible bug fixes | 0.0.x |
| `release:minor` | `#0E8A16` | Backwards-compatible features | 0.x.0 |
| `release:major` | `#D73A4A` | Breaking changes | x.0.0 |
| `release:auto` | `#1D76DB` | Let CI determine version bump | Auto |

**Usage:**
- Applied to PRs to indicate version impact
- CI/CD uses labels to auto-bump version
- Follows semantic versioning spec
- Default to `release:auto` if unsure

---

### 6. 📊 Status (4 labels)

Workflow state tracking.

| Label | Color | Description | When to Use |
|-------|-------|-------------|-------------|
| `status:blocked` | `#D93F0B` | Cannot proceed due to dependencies | Waiting on other work, external blockers |
| `status:needs-triage` | `#FBCA04` | Awaiting initial review | New issues, community contributions |
| `status:in-progress` | `#1D76DB` | Actively being worked on | Assigned and in development |
| `status:needs-review` | `#9C27B0` | Ready for code review | PR open, awaiting review |

**Usage:**
- Indicates current state in workflow
- Helps identify bottlenecks
- Auto-applied by some templates
- Update as work progresses

---

### 7. 👥 Community (4 labels)

Community contribution signals.

| Label | Color | Description |
|-------|-------|-------------|
| `community` | `#7057FF` | From external contributors |
| `good-first-issue` | `#7057FF` | Good for newcomers |
| `help-wanted` | `#008672` | Looking for contributors |
| `question` | `#D876E3` | Needs clarification or discussion |

**Usage:**
- Helps identify contribution opportunities
- `good-first-issue` for onboarding
- `help-wanted` signals need for help
- `community` distinguishes external contributions

---

### 8. 🧞 Wish Workflow (3 labels)

Community feature request workflow tracking.

| Label | Color | Description | Applied By | When to Use |
|-------|-------|-------------|------------|-------------|
| `wish:triage` | `#E1BEE7` | User wish pending team review | Make a Wish template (auto) | New community feature ideas |
| `wish:active` | `#1D76DB` | Wish approved and being worked on | Team (manual) | After triage approval |
| `wish:archived` | `#6C757D` | Wish completed and archived | Workflow (auto on PR merge) | Implementation complete |

**Workflow:**
```
User submits wish via Make a Wish template
  ↓
Auto-labeled with wish:triage
  ↓
Team reviews and triages
  ↓
If approved: Change to wish:active, create initiative/issue
  ↓
Implementation PR merges
  ↓
Wish document auto-archived to roadmap repo
  ↓
Auto-labeled with wish:archived
```

**Usage:**
- `wish:triage` - Filter for community ideas awaiting review
- `wish:active` - Track approved wishes in development
- `wish:archived` - Historical record of completed wishes
- Separate from `planned-feature` (roadmap) workflow
- Users don't need technical knowledge to make wishes

---

### 9. 🔧 Administrative (4 labels)

Issue management.

| Label | Color | Description |
|-------|-------|-------------|
| `duplicate` | `#CFD3D7` | Already exists |
| `invalid` | `#E4E669` | Not a valid issue |
| `wontfix` | `#FFFFFF` | Won't be addressed |
| `breaking-change` | `#D93F0B` | Introduces breaking changes |

---

## Label Usage Patterns

### Example 1: Bug from Community
```yaml
Labels:
  - type:bug
  - priority:high
  - area:cli
  - status:needs-triage
  - community
```

### Example 2: Planned Feature (Roadmap-Linked)
```yaml
Labels:
  - type:feature
  - priority:medium
  - area:mcp
  - area:agents
  - planned-feature        # Triggers workflow
  - roadmap-linked         # Auto-added by workflow
  - initiative-42          # Auto-added by workflow
```

### Example 3: Technical Debt
```yaml
Labels:
  - type:debt
  - priority:low
  - area:testing
  - status:in-progress
```

### Example 4: Enhancement with Breaking Change
```yaml
Labels:
  - type:enhancement
  - priority:high
  - area:api
  - breaking-change
  - release:major
```

### Example 5: Community Wish
```yaml
Labels:
  - wish:triage           # Auto-applied by template
  - status:needs-triage   # Awaiting team review
```

---

## Issue Templates

### Template 1: Bug Report
For community bugs and standalone issues without roadmap context.

**Auto-Applied Labels:**
- `type:bug`
- `status:needs-triage`

**User Selects:**
- Priority (dropdown)
- Areas (checkboxes)

### Template 2: Feature Request
For community suggestions and enhancement ideas.

**Auto-Applied Labels:**
- `type:enhancement`
- `status:needs-triage`

**User Selects:**
- Priority (dropdown)
- Areas (checkboxes)

### Template 3: Make a Wish 🧞
For community feature ideas and suggestions (no technical knowledge needed).

**Auto-Applied Labels:**
- `wish:triage`

**User Provides:**
- What's your wish? (required)
- Why would this be useful? (optional)
- Any additional context? (optional)

**Team Process:**
- Reviews during triage
- Converts to initiative or issue if approved
- Adds `wish:active` label when work begins

### Template 4: Planned Feature
For team/agent-created work linked to roadmap initiatives.

**Auto-Applied Labels:**
- `planned-feature`

**User Provides:**
- Initiative number (required, triggers linking)
- Work type (bug/feature/debt/etc.)
- Priority
- Areas
- Complexity estimate

**Workflow Auto-Adds:**
- `roadmap-linked`
- `initiative-{number}`

---

## Roadmap Integration

### Sub-Issue Hierarchy

```
Roadmap Initiative #42 (automagik-roadmap)
  ├─ Sub-Issue: genie#123 (Populate templates)
  ├─ Sub-Issue: genie#124 (Update MCP resolution)
  └─ Sub-Issue: omni#234 (Integration work)
```

### Querying Sub-Issues

**From roadmap initiative:**
```graphql
query {
  repository(owner: "namastexlabs", name: "automagik-roadmap") {
    issue(number: 42) {
      subIssues(first: 20) {
        nodes {
          title
          number
          repository { name }
          state
        }
      }
    }
  }
}
```

**From project issue:**
```graphql
query {
  repository(owner: "namastexlabs", name: "automagik-genie") {
    issue(number: 123) {
      parent {
        title
        number
        repository { name }
      }
    }
  }
}
```

### Filtering Roadmap Work

**All roadmap-linked issues:**
```bash
gh issue list --label "roadmap-linked"
```

**Work for specific initiative:**
```bash
gh issue list --label "initiative-42"
```

**Blocked roadmap work:**
```bash
gh issue list --label "roadmap-linked,status:blocked"
```

---

## Label Management

### Syncing Labels

Labels are defined in `.github/labels.yml` and synced automatically.

**Automatic Sync:**
- Workflow runs on push to `main` when `.github/labels.yml` changes
- Can also trigger manually: `Actions → Sync Labels → Run workflow`

**Manual Sync:**
```bash
gh workflow run label-sync.yml
```

### Adding New Labels

1. Edit `.github/labels.yml`
2. Add label definition:
```yaml
- name: area:telemetry
  color: '006B75'
  description: 'Telemetry and observability'
```
3. Commit and push
4. Workflow syncs automatically

### Label Sync Workflow

```yaml
name: Sync Labels
on:
  push:
    branches: [main]
    paths: ['.github/labels.yml']
  workflow_dispatch:

jobs:
  label-sync:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      - uses: EndBug/label-sync@v2
        with:
          config-file: .github/labels.yml
          token: ${{ secrets.GITHUB_TOKEN }}
          delete-other-labels: false
```

---

## Best Practices

### ✅ Do:
- Apply type label to all issues
- Use `planned-feature` for roadmap work
- Update status labels as work progresses
- Add area labels for discoverability
- Use release labels on PRs
- Link to initiative when relevant

### ❌ Don't:
- Create issues without type labels
- Skip initiative number for `planned-feature` issues
- Use `roadmap-linked` manually (workflow applies it)
- Create `initiative-{number}` labels manually
- Mix project repo labels with roadmap labels

### 🤔 When Unsure:
- Bug or enhancement? → Consider if new functionality (enhancement) or broken existing (bug)
- Priority? → Start with medium, adjust based on impact
- Roadmap-linked? → Only use `planned-feature` if part of roadmap initiative
- Status? → Use `status:needs-triage` for new issues

---

## Comparison: Roadmap vs Project Labels

| Dimension | Roadmap Repo | Project Repos |
|-----------|--------------|---------------|
| **Project** | ✅ 7 labels (omni, hive, etc.) | ❌ Not needed (each repo = 1 project) |
| **Stage** | ✅ 8 labels (Wishlist → Shipped) | ❌ Not used (stages for initiatives only) |
| **Type** | ✅ 6 labels | ✅ 7 labels (adds `type:bug`) |
| **Priority** | ✅ 4 labels | ✅ 4 labels (same) |
| **Quarter** | ✅ 10+ labels | ❌ Not used (roadmap handles scheduling) |
| **Area** | ✅ 15 labels | ✅ 15 base + repo-specific |
| **Roadmap Linking** | ❌ Not applicable | ✅ 3+ labels (`planned-feature`, etc.) |
| **Release** | ❌ Not used | ✅ 4 labels (semantic versioning) |
| **Status** | ❌ Not used | ✅ 4 labels (workflow states) |
| **Community** | ✅ Some | ✅ 4 labels (contribution signals) |

---

## Rollout Status

| Repository | Status | Labels | Workflow | Templates |
|------------|--------|--------|----------|-----------|
| **genie** | ✅ Complete | 53 labels | ✅ Deployed | ⏳ Pending |
| **omni** | ⏳ Pending | - | - | - |
| **hive** | ⏳ Pending | - | - | - |
| **spark** | ⏳ Pending | - | - | - |
| **forge** | ⏳ Pending | - | - | - |
| **tools** | ⏳ Pending | - | - | - |

---

## Related Documentation

- [Roadmap Label Guide](label-guide.md) - Labels for roadmap initiatives
- [Cross-Repo References](cross-repo-references.md) - Linking patterns
- [Stage Definitions](stage-definitions.md) - Initiative lifecycle stages

---

*Last updated: 2025-10-09*
