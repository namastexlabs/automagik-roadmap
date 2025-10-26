# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

**This is NOT a code repository** - it's a strategic roadmap management system serving as the single source of truth for initiatives across 6 Automagik projects: Omni, Hive, Spark, Forge, Genie, and Tools.

**Core Purpose:** Centralized planning, transparent communication, cross-project coordination, and RASCI-based ownership accountability for the Automagik ecosystem.

---

## Quick Commands

### Daily Operations
```bash
# Daily standup - see today's activity across all repos
./scripts/quick-activity-status.sh 1

# This week's activity
./scripts/quick-activity-status.sh 7

# Full health check (90 seconds)
./scripts/check-all.sh
```

### Initiative Management
```bash
# Create initiative from JSON (fastest, most automated)
cat initiative.json | ./scripts/create-initiative-from-json.sh

# Quick example
echo '{
  "title": "Feature Name",
  "project": "omni",
  "stage": "Exploring",
  "priority": "high",
  "quarter": "2026-q1",
  "description": "Problem/solution/impact",
  "goals": ["Goal 1", "Goal 2"]
}' | ./scripts/create-initiative-from-json.sh

# Export roadmap to CSV
export GITHUB_TOKEN=$(gh auth token)
python3 scripts/export-to-csv.py
```

### Health Validation
```bash
# Quick health check (15-20s)
./scripts/check-board-health.sh

# Quality scoring (20s)
./scripts/check-initiative-completeness.sh

# Label consistency
./scripts/validate-labels.sh

# Quarter/velocity analysis
./scripts/validate-quarters.sh

# Roadmap ↔ repo alignment
./scripts/check-cross-repo-sync.sh
```

### Activity Monitoring
```bash
# Fast snapshot (10-15s) - RECOMMENDED
./scripts/quick-activity-status.sh 7

# Comprehensive dashboard (30-60s)
./scripts/live-activity-dashboard.sh 7 --detailed

# Single repo deep-dive
./scripts/check-repo-activity.sh namastexlabs/automagik-genie 7
```

---

## Architecture

### The 6 Projects

All projects share this single roadmap repository:

| Project | Purpose | Owner | Repo |
|---------|---------|-------|------|
| **Omni** | Omnichannel messaging with MCP | vasconceloscezar | automagik-omni |
| **Hive** | Multi-agent orchestration | vasconceloscezar | automagik-hive |
| **Spark** | Cron task runner for repos | vasconceloscezar | automagik-spark |
| **Forge** | AI-powered dev orchestrator | namastex888 | automagik-forge |
| **Genie** | Autonomous agent framework | namastex888 | automagik-genie |
| **Tools** | MCP tools marketplace | vasconceloscezar | automagik-tools |

Each project has a folder: `projects/<name>/` with strategic context (`5w2h.md`) and detailed specs (`wishes/`).

### Initiative Lifecycle (8 Stages)

```
Wishlist (1-2w) → Exploring (1-4w) → RFC [Proposal/Go-No-Go] (2-6w) → Prioritization (2-8w)
    → Executing (4-16w) → Preview (2-8w) → Shipped → Archived
```

Each stage has clear exit criteria in `docs/stage-definitions.md`.

### Multi-Dimensional Label System (6 Dimensions, 59 Labels)

1. **Project** (7): `project:omni`, `project:hive`, etc.
2. **Stage** (8): `Wishlist`, `Exploring`, `RFC` (Request for Change/Proposal), `Prioritization`, `Executing`, `Preview`, `Shipped`, `Archived`
3. **Priority** (4): `priority:critical`, `priority:high`, `priority:medium`, `priority:low`
4. **Type** (6): `type:feature`, `type:enhancement`, `type:research`, `type:infrastructure`, `type:documentation`, `type:bug-initiative`
5. **Quarter** (10): `quarter:2025-q4` through `quarter:2027-q4`, `quarter:backlog`
6. **Area** (15+): `area:api`, `area:cli`, `area:mcp`, `area:agents`, etc.

**Important:** Exactly ONE stage label per initiative. Multiple project/area labels allowed.

Full taxonomy in `docs/label-guide.md`.

### RASCI Ownership Model

Every initiative defines:
- **R** (Responsible): Who does the work
- **A** (Accountable): Who has final approval (exactly 1 person, owns success/failure)
- **S** (Support): Who provides resources
- **C** (Consulted): Who gives input
- **I** (Informed): Who should be kept updated

Auto-owner selection:
- `forge`/`genie` → `namastex888`
- `omni`/`hive`/`spark`/`tools`/`cross-project` → `vasconceloscezar`
- Override with `"owner": "username"` in JSON

Details in `docs/rasci-guide.md`.

### Project Board Automation

**GitHub Projects #9** is the single source of truth with automated field syncing:

**Synced Fields:**
- Project (which of the 6)
- Stage (lifecycle stage)
- Priority (critical/high/medium/low)
- ETA (quarter target)
- Expected Results (goals summary)
- Owner (assignee from RASCI)
- Target Date (specific YYYY-MM-DD)
- Start Date (when initiative begins)

**Two sync mechanisms:**
1. `.github/workflows/sync-to-project.yml` - Parses GitHub issue form
2. `scripts/create-initiative-from-json.sh` - Direct GraphQL mutations

Field IDs stored in `scripts/create-initiative-from-json.sh:15-24`. See `docs/PROJECT-BOARD-FIELD-IDS.md` if schema changes.

---

## Initiative Creation (3 Paths)

### Path A: "Make a Wish" Form (Simplest)
- **For:** Community feature ideas with minimal structure
- **How:** Go to Issues → "Make a Wish" template
- **Result:** Labeled `wish:triage`, team converts to proper initiative

### Path B: GitHub Issue Form (Structured)
- **For:** Well-defined initiatives ready for planning
- **How:** Issues → "🎯 Roadmap Initiative" template
- **Result:** Automatically added to project board with all fields set
- **Time:** ~40-60 seconds for full sync

### Path C: CLI JSON Script (Fastest & Most Automated) ⚡ **RECOMMENDED**
- **For:** Programmatic creation, batch operations, automation
- **How:** `cat initiative.json | ./scripts/create-initiative-from-json.sh`
- **Time:** ~40-45 seconds
- **Features:**
  - Auto-selects owner based on project
  - Auto-calculates dates from quarter
  - Batch GraphQL mutations (parallel)
  - 10 retries with 3s delay
  - Full project board field syncing

**JSON Format:**
```json
{
  "title": "Feature Name",
  "project": "genie|forge|omni|hive|spark|tools|cross-project",
  "stage": "Wishlist|Exploring|RFC [Proposal]|Prioritization|Executing|Preview|Shipped",
  "priority": "critical|high|medium|low",
  "quarter": "2026-q1",
  "type": "feature|enhancement|research|infrastructure|documentation",
  "areas": ["api", "mcp"],
  "description": "One-line problem/solution/impact",
  "goals": ["Goal 1", "Goal 2", "Goal 3"],
  "owner": "username (optional)",
  "start_date": "2025-10-20 (optional)",
  "target_date": "2025-12-31 (optional)"
}
```

**Date handling:**
- `quarter: "2026-q1"` → auto-calculates: start_date=2026-01-01, target_date=2026-03-31
- `quarter: "2025-10"` → auto-calculates: start_date=2025-10-01, target_date=2025-10-31
- Explicit `start_date`/`target_date` override auto-calculation

See `scripts/example-initiative.json` for complete template.

---

## GitHub Workflows

### `sync-to-project.yml` (Primary Automation)
**Trigger:** Issue labeled with `initiative`

**What it does:**
1. Generates GitHub App token
2. Adds issue to Project #9
3. Parses form body for field values (### headers)
4. Sets all project board custom fields via GraphQL
5. Applies dimensional labels
6. Calculates target date from quarter if not provided

**Important:** CLI-created initiatives have free-form bodies (no structured headers), so workflow skips parsing if project field is empty.

### `export-roadmap.yml` (Weekly CSV Export)
**Trigger:** Every Monday at midnight (or manual)

**What it does:**
1. Runs `scripts/export-to-csv.py`
2. Commits CSV to `exports/` directory
3. Exports all initiatives with full metadata

### `label-sync.yml` (Label Management)
**Trigger:** Manual dispatch

**What it does:** Syncs label definitions from `.github/labels.yml` to repository

### `link-to-roadmap.yml` (Cross-Repo Integration)
**Trigger:** Issue created with `planned-feature` label in individual project repos

**What it does:**
1. Links issue to parent roadmap initiative
2. Adds to Project Board #9
3. Populates project board fields (stage, priority, ETA)
4. Enables cross-repo tracking

---

## Script Ecosystem

### Initiative Management
- **`create-initiative-from-json.sh`** - Create from JSON with full automation
- **`export-to-csv.py`** - Export all initiatives to CSV

### Live Activity Monitoring
- **`quick-activity-status.sh`** ⚡ RECOMMENDED (10-15s) - Fast snapshot across all 7 repos
  - Latest commits per repo
  - Open PRs/issues count
  - Active feature branches
  - Commit messages

- **`live-activity-dashboard.sh`** 🐢 (30-60s) - Comprehensive ecosystem stats
  - Commit statistics
  - Contributor activity
  - Active branches with details
  - Open PRs per repo

- **`check-repo-activity.sh`** (10-20s) - Deep-dive into single repo
  - Push events on all branches
  - Most active branches
  - Identifies hidden feature branch work

### Health Validation
- **`check-all.sh`** 🐢 (60-90s) - Runs all 5 health checks sequentially
- **`check-board-health.sh`** ⚡ (15-20s) - Distribution, missing labels, stale items
- **`validate-labels.sh`** ⚡ (10-15s) - Label consistency and validation
- **`validate-quarters.sh`** ⚡ (15-20s) - Quarter/ETA consistency, velocity analysis
- **`check-initiative-completeness.sh`** ⚡ (15-25s) - Quality scoring (0-100)
- **`check-cross-repo-sync.sh`** ⚡ (20-30s) - Roadmap ↔ repo alignment

**Quality Score Interpretation:**
- 🟢 80-100: Excellent - Well-maintained
- 🟡 60-79: Good - Some improvements needed
- 🔴 0-59: Needs Attention - Many initiatives need updating

**All scripts documented in:** `scripts/README.md`

---

## Common Workflows

### Daily Standup
```bash
./scripts/quick-activity-status.sh 1    # Today
./scripts/quick-activity-status.sh 2    # Yesterday
```

### Weekly Health Check
```bash
./scripts/quick-activity-status.sh 7    # Recent activity
./scripts/check-all.sh                  # Full health report
```

### Quarterly Planning
```bash
# 1. Review ecosystem activity (last 90 days)
./scripts/live-activity-dashboard.sh 90 --detailed

# 2. Check quarter velocity
./scripts/validate-quarters.sh

# 3. Validate initiative quality
./scripts/check-initiative-completeness.sh --detailed

# 4. Cross-repo alignment
./scripts/check-cross-repo-sync.sh

# 5. Export for stakeholders
export GITHUB_TOKEN=$(gh auth token)
python3 scripts/export-to-csv.py
```

### Pre-Execution Quality Gate
```bash
./scripts/check-initiative-completeness.sh --detailed
./scripts/validate-labels.sh
```

### Monthly Report Generation
```bash
{
  echo "# Automagik Ecosystem - Monthly Report $(date +%Y-%m)"
  echo ""
  ./scripts/live-activity-dashboard.sh 30
  echo ""
  ./scripts/check-all.sh
} > monthly-report-$(date +%Y%m).txt
```

---

## Documentation Structure

**Core:**
- `README.md` - Main entry point
- `CONTRIBUTING.md` - Community guidelines
- `CLAUDE.md` - This file

**Label System:**
- `docs/label-guide.md` - Complete taxonomy (6 dimensions, 59 labels)
- `docs/project-label-guide.md` - Project-specific labels
- `docs/label-rollout-guide.md` - New label rollout strategy

**Initiative Planning:**
- `docs/stage-definitions.md` - Lifecycle stage criteria
- `docs/rasci-guide.md` - RASCI ownership model
- `docs/wish-template.md` - Detailed initiative specs
- `docs/templates/LEAN_INITIATIVE.md` - Modern format (recommended)

**Technical:**
- `docs/PROJECT-BOARD-AUTOMATION.md` - Field automation details
- `docs/PROJECT-BOARD-FIELD-IDS.md` - Field ID reference
- `docs/cross-repo-references.md` - Linking across repositories
- `docs/wish-sync-strategy.md` - Syncing wish documents

**Per-Project Context:**
- `projects/<name>/README.md` - Project overview
- `projects/<name>/5w2h.md` - Strategic analysis (What, Why, Who, When, Where, How, How Much)
- `projects/<name>/wishes/` - Detailed initiative specifications

---

## Requirements

**All scripts require:**
- GitHub CLI (`gh`) installed and authenticated
  ```bash
  # macOS
  brew install gh

  # Ubuntu/Debian
  sudo apt install gh

  # Authenticate
  gh auth login
  ```

- `jq` for JSON processing
  ```bash
  # macOS
  brew install jq

  # Ubuntu/Debian
  sudo apt install jq
  ```

- Permissions: Read/Write on `namastexlabs/automagik-roadmap` and read access to all 6 project repos

**Optional:**
- Python 3.x (for `export-to-csv.py`)
- `GITHUB_TOKEN` environment variable: `export GITHUB_TOKEN=$(gh auth token)`

---

## Important Design Decisions

### CLI Script vs GitHub Form
- **CLI Script:** Does NOT apply quarter labels - only sets ETA field via GraphQL
- **GitHub Form:** DOES apply both quarter label AND ETA field
- **Result:** Both set same ETA field, label is cosmetic for filtering

### Single Project Board
- All 6 projects share Project #9
- Filter by `project:` labels for per-project views
- Enables cross-project visibility and dependency tracking

### Owner Auto-Selection
Two categories:
- `forge`, `genie` → `namastex888`
- `omni`, `hive`, `spark`, `tools`, `cross-project` → `vasconceloscezar`
- Override with `"owner": "username"` in JSON

### Stage Label Requirement
- Must have exactly ONE stage label
- Validation scripts check for violations
- Multiple stage labels indicate data quality issue

### Wish Folders Optional
- Complex initiatives can have detailed specs in `projects/<name>/wishes/`
- Simple initiatives use just issue body
- Wish links are optional metadata

---

## Critical Field IDs (Rarely Change)

**Project Board IDs:**
- Project ID: `PVT_kwDOBvG2684BE-4E`
- Project Number: `9`
- Organization: `namastexlabs`

**Custom Field IDs** (stored in `scripts/create-initiative-from-json.sh:15-24`):
- Project: `PVTSSF_lADOBvG2684BE-4Ezg2c_ec`
- Stage: `PVTSSF_lADOBvG2684BE-4Ezg2c_hc`
- Priority: `PVTSSF_lADOBvG2684BE-4Ezg2c_kA`
- ETA: `PVTSSF_lADOBvG2684BE-4Ezg2dPxc`
- Expected Results: `PVTF_lADOBvG2684BE-4Ezg2c8aE`
- Owner: `PVTF_lADOBvG2684BE-4Ezg2c8aI`
- Target Date: `PVTF_lADOBvG2684BE-4Ezg2c8aM`

**To find updated IDs if schema changes:**
```bash
gh api graphql -f query='
query {
  organization(login: "namastexlabs") {
    projectV2(number: 9) {
      fields(first: 20) {
        nodes {
          ... on ProjectV2SingleSelectField { id name options { id name } }
          ... on ProjectV2Field { id name }
        }
      }
    }
  }
}'
```

See `docs/PROJECT-BOARD-FIELD-IDS.md` for complete reference.

---

## Health Metrics

**Board Health Indicators:**
- Distribution across stages (should have initiatives in multiple stages)
- Priority distribution (balanced across spectrum)
- Label consistency (no missing required labels)
- Stale initiatives (no items untouched for 30+ days)

**Initiative Quality (0-100 Score):**
- Assignment rate (% with owners) - Target: 80%+
- Documentation rate (body length >500 chars) - Target: 75%+
- Goals defined (has expected results section) - Target: 90%+

**Velocity Indicators:**
- Shipped vs Total per quarter (% completed)
- Average duration per stage
- Overdue initiatives (stuck past target quarter)

**Cross-Repo Alignment:**
- Roadmap initiatives count per project
- Open issues/PRs count per repo
- Last commit date per repo
- Orphaned initiatives detection

---

## Troubleshooting

**Scripts hang:**
- Check GitHub API rate limits: `gh api rate_limit`
- Reduce query scope or add delays

**Authentication fails:**
- Re-authenticate: `gh auth login`
- Verify org access: `gh auth status`

**jq errors:**
- Update to latest: `brew upgrade jq` or `sudo apt upgrade jq`

**Date format errors:**
- Script auto-detects Linux/macOS date formats
- If fails, check script line using `date` command

**Field sync issues:**
- Verify field IDs haven't changed (see Critical Field IDs section)
- Check workflow logs in GitHub Actions
- Re-run sync manually: trigger `sync-to-project.yml`

---

## Philosophy

This roadmap system embodies:

1. **Transparency** - Public by default (GitHub public repo)
2. **Accountability** - RASCI makes ownership explicit
3. **Structure** - 8-stage lifecycle prevents chaos
4. **Flexibility** - 3 entry methods for ideas at any stage
5. **Automation** - Reduces manual work, minimizes errors
6. **Scalability** - Works for 1 project or 100 (6 currently)
7. **Community-Friendly** - Wishes allow non-developers to contribute
8. **Data-Driven** - Scripts provide quantitative health metrics
9. **Cross-Project Coordination** - Single board enables dependency tracking
10. **Results-Focused** - Expected results and success criteria baked in

---

## GitHub CLI (`gh`) Command Reference

### Common Pitfalls and Correct Usage

**IMPORTANT:** The GitHub CLI has specific syntax requirements. Here are common mistakes and their corrections:

#### Issue and PR Management

**❌ WRONG - Using `-L` for labels:**
```bash
# This will FAIL - -L is for limit, not labels
gh issue list -R org/repo -L hacktoberfest
```

**✅ CORRECT - Use lowercase `-l` for labels:**
```bash
# Filter by label (use -l not -L)
gh issue list -R org/repo -l hacktoberfest -s all

# Multiple filters
gh issue list -R org/repo -l "good-first-issue" -l "hacktoberfest" -s open

# Get counts
gh issue list -R org/repo -l hacktoberfest -s all --json number | jq 'length'
```

#### Issue/PR Field Queries

**❌ WRONG - Requesting unsupported fields:**
```bash
# This will FAIL - timelineItems not available via gh issue view
gh issue view 123 -R org/repo --json timelineItems
```

**✅ CORRECT - Use supported fields only:**
```bash
# Available fields for issues/PRs:
gh issue view 123 -R org/repo --json assignees,author,body,closed,closedAt,comments,createdAt,id,labels,milestone,number,projectCards,projectItems,reactionGroups,state,title,updatedAt,url

# Find linked PRs by searching PR bodies
gh pr list -R org/repo --json number,title,body,state,author | jq -r '.[] | select(.body | contains("#123"))'
```

#### PR Assignee Management

**⚠️ WARNING - Classic Projects deprecation errors are normal:**
```bash
# This command WORKS despite deprecation warnings
gh pr edit 15 -R org/repo --add-assignee username1 --add-assignee username2

# Error message you might see (can be ignored if assignees were added):
# GraphQL: Projects (classic) is being deprecated...
```

**✅ CORRECT - Verify assignees were added:**
```bash
# Always verify after editing
gh pr view 15 -R org/repo --json assignees | jq '.assignees[].login'
```

**✅ CORRECT - Use GitHub API directly (more reliable):**
```bash
# Add assignees via REST API (no deprecation warnings)
gh api repos/org/repo/issues/15/assignees -X POST -f assignees[]='username1' -f assignees[]='username2'

# Verify
gh api repos/org/repo/issues/15 --jq '.assignees[].login'
```

#### Repository Information

**✅ CORRECT - Get repo metadata:**
```bash
# Get topics (tags) on a repository
gh repo view org/repo --json repositoryTopics,isPrivate,name,url

# Check if repo has specific topic
gh repo view org/repo --json repositoryTopics --jq '.repositoryTopics[].name' | grep -q "hacktoberfest" && echo "Has hacktoberfest topic"

# Add topic to repo
gh repo edit org/repo --add-topic hacktoberfest
```

#### Searching Across Repositories

**✅ CORRECT - Batch operations across repos:**
```bash
# Loop through multiple repos (proper bash syntax)
for repo in repo1 repo2 repo3; do
  echo "=== $repo ==="
  gh issue list -R org/$repo -l hacktoberfest --json number | jq 'length'
done

# Single line version (for scripts)
for repo in repo1 repo2 repo3; do echo "=== $repo ==="; gh issue list -R org/$repo -l hacktoberfest --json number | jq 'length'; done
```

#### JSON Output and JQ Processing

**✅ CORRECT - Processing JSON responses:**
```bash
# Count items
gh issue list -R org/repo -l label-name --json number | jq 'length'

# Extract specific fields
gh issue list -R org/repo -s open --json number,title,assignees | jq '.[] | {num: .number, title: .title, assigned: ([.assignees[].login] | length > 0)}'

# Filter and format
gh pr list -R org/repo --json number,title,body,author | jq -r '.[] | select(.body | contains("#123")) | "PR #\(.number) by \(.author.login) - \(.title)"'
```

### Quick Reference Card

| Task | Command |
|------|---------|
| List open issues with label | `gh issue list -R org/repo -l label-name -s open` |
| Count issues by label | `gh issue list -R org/repo -l label-name --json number \| jq 'length'` |
| Add PR assignees | `gh api repos/org/repo/issues/PR_NUM/assignees -X POST -f assignees[]='user'` |
| Check repo topics | `gh repo view org/repo --json repositoryTopics` |
| Add repo topic | `gh repo edit org/repo --add-topic topic-name` |
| Search PR bodies | `gh pr list -R org/repo --json body \| jq '.[] \| select(.body \| contains("#123"))'` |
| View PR/issue fields | `gh issue view 123 -R org/repo --json assignees,labels,state,title` |

### Common Flags

- `-R, --repo <org/repo>` - Specify repository
- `-l, --label <name>` - Filter by label (can use multiple times)
- `-s, --state <open|closed|all>` - Filter by state (default: open)
- `-L, --limit <n>` - Maximum items to fetch (default: 30)
- `--json <fields>` - Output JSON with specified fields
- `-q, --jq <expr>` - Filter JSON with jq expression

---

## Resources

- **Project Board:** https://github.com/orgs/namastexlabs/projects/9
- **All Initiatives:** https://github.com/namastexlabs/automagik-roadmap/issues?q=label%3Ainitiative
- **Discord:** https://discord.gg/xcW8c7fF3R
- **Documentation:** `docs/` folder in this repository
