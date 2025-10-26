# 🏷️ Label Guide

Complete taxonomy and usage guide for Automagik roadmap labels.

---

## Overview

The Automagik roadmap uses a **multi-dimensional label system** to organize and filter initiatives. Labels are grouped into **6 dimensions**, allowing precise categorization and powerful filtering.

**Total Labels:** 59 labels across 6 dimensions

**Inspiration:** GitHub's public roadmap label system

---

## Label Dimensions

### 1. 📦 Project Dimension (7 labels)

Identifies which Automagik project(s) the initiative belongs to.

| Label | Color | Description | Repository |
|-------|-------|-------------|------------|
| `project:omni` | `#0052CC` | Omnichannel messaging with MCP | [automagik-omni](https://github.com/namastexlabs/automagik-omni) |
| `project:hive` | `#0052CC` | Multi-agent orchestration | [automagik-hive](https://github.com/namastexlabs/automagik-hive) |
| `project:spark` | `#0052CC` | Cron system that sparks repos | [automagik-spark](https://github.com/namastexlabs/automagik-spark) |
| `project:forge` | `#0052CC` | AI-powered development orchestrator | [automagik-forge](https://github.com/namastexlabs/automagik-forge) |
| `project:genie` | `#0052CC` | Autonomous agent framework | [automagik-genie](https://github.com/namastexlabs/automagik-genie) |
| `project:tools` | `#0052CC` | MCP tools builder & marketplace | [automagik-tools](https://github.com/namastexlabs/automagik-tools) |
| `project:cross-project` | `#0052CC` | Spans multiple projects | Multiple repos |

**Usage:**
- Every initiative MUST have at least one project label
- Can have multiple project labels if the initiative affects multiple projects
- Use `project:cross-project` for ecosystem-wide initiatives

---

### 2. 🔄 Stage Dimension (8 labels)

Indicates the current development phase. See [Stage Definitions](stage-definitions.md) for detailed criteria.

| Label | Color | Description | Typical Duration |
|-------|-------|-------------|------------------|
| `Wishlist` | `#E1BEE7` | Initial ideation and brainstorming | 1-2 weeks |
| `Exploring` | `#FBCA04` | Early investigation and validation | 1-4 weeks |
| `RFC` | `#FFA500` | Request for Change, formal proposal and Go/No-Go | 2-6 weeks |
| `Prioritization` | `#D876E3` | Prioritization and planning | 2-8 weeks |
| `Executing` | `#1D76DB` | Active execution and implementation | 4-16 weeks |
| `Preview` | `#9C27B0` | Beta or preview release for testing | 2-8 weeks |
| `Shipped` | `#0E8A16` | Generally available in production | Ongoing |
| `Archived` | `#6C757D` | No longer active or deprioritized | - |

**Usage:**
- Every initiative MUST have exactly one stage label
- Update stage label as initiative progresses
- Add comment to issue when changing stages

**Flow:**
```
Wishlist → Exploring → RFC (Proposal/Go-No-Go) → Prioritization → Executing → Preview → Shipped
                                                                                             ↓
                                                                                         Archived
```

---

### 3. 🎯 Type Dimension (6 labels)

Categorizes the kind of work being done.

| Label | Color | Description | Examples |
|-------|-------|-------------|----------|
| `type:feature` | `#7057FF` | New capability | WhatsApp integration, Multi-agent swarms |
| `type:enhancement` | `#A2EEEF` | Improvement to existing | Performance optimization, UX polish |
| `type:research` | `#FFEB3B` | Investigation/analysis | Architecture exploration, User research |
| `type:infrastructure` | `#795548` | DevOps, tooling, build | CI/CD pipeline, Docker setup |
| `type:documentation` | `#0075CA` | Docs-only initiative | API docs, tutorials |
| `type:bug-initiative` | `#D73A4A` | Major bug fix initiative | Critical security fix, data integrity |

**Usage:**
- Every initiative SHOULD have exactly one type label
- Choose the primary type if multiple apply
- `type:bug-initiative` is for major bug-fixing efforts, not individual bugs

---

### 4. ⚡ Priority Dimension (4 labels)

Indicates urgency and importance.

| Label | Color | Description | When to Use |
|-------|-------|-------------|-------------|
| `priority:critical` | `#D93F0B` | Blocker, urgent | Breaks production, security issue, customer blocker |
| `priority:high` | `#FF9800` | Important, soon | Key feature, significant user impact |
| `priority:medium` | `#FFC107` | Normal priority | Standard roadmap item |
| `priority:low` | `#CDDC39` | Nice to have | Future enhancement, minor improvement |

**Usage:**
- Every initiative SHOULD have a priority label
- Priority can change as context evolves
- Critical priorities should be rare and addressed immediately

**Priority ≠ Stage:**
- An initiative can be high priority but still in "exploring"
- An initiative can be low priority but in "in-dev"

---

### 5. 📅 Quarter Dimension (10 labels)

Target timeframe for completion.

| Label | Color | Description |
|-------|-------|-------------|
| `quarter:2025-q4` | `#5319E7` | Oct-Dec 2025 |
| `quarter:2026-q1` | `#5319E7` | Jan-Mar 2026 |
| `quarter:2026-q2` | `#5319E7` | Apr-Jun 2026 |
| `quarter:2026-q3` | `#5319E7` | Jul-Sep 2026 |
| `quarter:2026-q4` | `#5319E7` | Oct-Dec 2026 |
| `quarter:2027-q1` | `#5319E7` | Jan-Mar 2027 |
| `quarter:2027-q2` | `#5319E7` | Apr-Jun 2027 |
| `quarter:2027-q3` | `#5319E7` | Jul-Sep 2027 |
| `quarter:2027-q4` | `#5319E7` | Oct-Dec 2027 |
| `quarter:backlog` | `#6C757D` | Not yet scheduled |

**Usage:**
- Every initiative SHOULD have a quarter label
- Use `quarter:backlog` for future ideas
- Quarter labels are targets, not commitments (see disclaimer)
- Update quarterly during planning cycles

**Quarterly Review:**
- Review all items for each quarter
- Move completed items to shipped
- Reprioritize backlog

---

### 6. 🔧 Area Dimension (15 labels)

Technical domain or functional area.

| Label | Color | Description | Examples |
|-------|-------|-------------|----------|
| `area:api` | `#006B75` | REST/GraphQL API | API endpoints, webhooks |
| `area:ui` | `#006B75` | User interface | Web UI, dashboards |
| `area:cli` | `#006B75` | Command-line tools | CLI commands, scripts |
| `area:mcp` | `#006B75` | MCP integration | MCP servers, tools, resources |
| `area:knowledge` | `#006B75` | Knowledge/RAG systems | Vector DB, embeddings, search |
| `area:auth` | `#006B75` | Authentication | Login, tokens, permissions |
| `area:agents` | `#006B75` | Agent implementation | Agent logic, coordination |
| `area:teams` | `#006B75` | Team coordination | Multi-user, collaboration |
| `area:workflows` | `#006B75` | Workflow orchestration | Pipelines, automation |
| `area:storage` | `#006B75` | Database/persistence | SQL, Redis, file storage |
| `area:testing` | `#006B75` | Test infrastructure | Unit tests, E2E, CI |
| `area:docs` | `#006B75` | Documentation | Guides, API docs, READMEs |

**Usage:**
- Initiatives MAY have one or more area labels
- Use multiple area labels if initiative spans domains
- Add new area labels as needed for new domains

---

## Special Labels

### Meta Labels

| Label | Color | Description |
|-------|-------|-------------|
| `initiative` | `#B60205` | Marks roadmap initiative (auto-added by template) |
| `help-wanted` | `#008672` | Community contributions welcome |
| `good-first-issue` | `#7057FF` | Good for newcomers |
| `breaking-change` | `#D93F0B` | Introduces breaking changes |
| `security` | `#D93F0B` | Security-related |

---

## Label Usage Patterns

### Example 1: New Feature
```yaml
Labels:
  - project:omni
  - Prioritization
  - type:feature
  - priority:high
  - quarter:2026-q1
  - area:api
  - area:mcp
```

### Example 2: Infrastructure Work
```yaml
Labels:
  - project:cross-project
  - Executing
  - type:infrastructure
  - priority:medium
  - quarter:2025-q4
  - area:testing
  - area:workflows
```

### Example 3: Research Initiative
```yaml
Labels:
  - project:hive
  - RFC
  - type:research
  - priority:low
  - quarter:backlog
  - area:agents
  - area:workflows
```

---

## Filtering Examples

### View All Omni Initiatives in Development
```
label:project:omni label:Executing
```

### View Critical Priorities This Quarter
```
label:priority:critical label:quarter:2025-q4
```

### View All MCP-Related Work
```
label:area:mcp
```

### View Cross-Project Infrastructure
```
label:project:cross-project label:type:infrastructure
```

---

## Label Management

### Creating Labels

Labels are defined in `.github/labels.yml` and synced automatically via workflow.

### Updating Labels

1. Edit `.github/labels.yml`
2. Workflow will sync on next push
3. Or run manually: `Actions → Sync Labels → Run workflow`

### Requesting New Labels

1. Open an issue in this repo
2. Explain the use case
3. Suggest name, color, description
4. Maintainers will review

---

## Best Practices

### ✅ Do:
- Apply all relevant labels to new initiatives
- Update stage labels as work progresses
- Use quarter labels for planning
- Add area labels to improve discoverability

### ❌ Don't:
- Use stage labels inconsistently
- Create duplicate or overlapping labels
- Skip priority labels on critical work
- Use quarter labels as commitments

---

## Label Colors

Labels follow a color coding system:

- **Blue (`#0052CC`)**: Project dimension
- **Yellow/Orange (`#FBCA04`, `#FFA500`)**: Early stages
- **Purple (`#D876E3`)**: Design stage
- **Blue (`#1D76DB`)**: Development stage
- **Green (`#0E8A16`)**: Shipped/Preview
- **Gray (`#6C757D`)**: Archived/Backlog
- **Red (`#D93F0B`)**: Critical priority
- **Purple (`#5319E7`)**: Quarter dimension
- **Teal (`#006B75`)**: Area dimension

This color coding helps visually identify label types at a glance.

---

## Related Documentation

- [Stage Definitions](stage-definitions.md) - Detailed stage criteria
- [RASCI Guide](rasci-guide.md) - Ownership model
- [Contributing](../CONTRIBUTING.md) - How to propose initiatives

---

*Last updated: 2025-10-07*
