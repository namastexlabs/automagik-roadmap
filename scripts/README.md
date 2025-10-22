# Scripts

Utility scripts for managing the Automagik Roadmap.

## Initiative Management

### create-initiative-from-json.sh
Creates roadmap initiatives from JSON input with full automation.

**Usage:**
```bash
cat initiative.json | ./scripts/create-initiative-from-json.sh
```

**Example:**
```bash
echo '{"title":"Feature","project":"hive","quarter":"2026-q1","priority":"high","goals":["Goal 1"]}' | ./scripts/create-initiative-from-json.sh
```

See `example-initiative.json` for complete JSON template.

### export-to-csv.py
Exports roadmap initiatives to CSV format.

**Usage:**
```bash
export GITHUB_TOKEN=ghp_xxx
python3 scripts/export-to-csv.py
```

## Repository Analysis

### check-repo-activity.sh
Analyzes repository activity across **all branches** (not just main/dev).

**Usage:**
```bash
./scripts/check-repo-activity.sh owner/repo [days]
```

**Examples:**
```bash
# Check public repos
./scripts/check-repo-activity.sh namastexlabs/automagik-genie 7
./scripts/check-repo-activity.sh namastexlabs/automagik-forge 14

# Check private repos (requires gh auth with access)
./scripts/check-repo-activity.sh namastexlabs/private-repo 7
```

**Output:**
- Recent push events across all branches
- List of all branches
- Most active branches with latest commit dates

**Why use this?**
- Standard `gh` commands only check default branch (main/dev)
- Feature branches often contain active work not visible in main
- This script checks ALL branches to find actual activity

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated
- Access to the repository (public or private with appropriate permissions)

## Roadmap Health & Validation

### check-board-health.sh
Comprehensive health check for the roadmap project board.

**Usage:**
```bash
./scripts/check-board-health.sh [--stale-days 30]
```

**What it checks:**
- Initiative distribution by stage, priority, and project
- Missing critical labels (priority, stage, project, quarter)
- Stale initiatives (no activity in N days)
- Recent activity (last 7 days)
- Currently executing initiatives

**Output:**
- Distribution statistics by stage/priority/project
- Count of issues missing required labels
- List of stale initiatives
- Recent activity summary
- Active executing initiatives

**Use cases:**
- Weekly roadmap review meetings
- Quick health check before stakeholder presentations
- Identifying initiatives needing attention

---

### check-cross-repo-sync.sh
Validates alignment between roadmap initiatives and actual repositories.

**Usage:**
```bash
./scripts/check-cross-repo-sync.sh
```

**What it checks:**
- Repository accessibility for all 6 projects (omni, hive, spark, forge, genie, tools)
- Last commit dates per repo
- Open issues and PRs count
- Roadmap initiatives count per project
- Cross-project dependencies
- Orphaned initiatives (roadmap entries for non-existent repos)

**Output:**
- Per-project repository status
- Activity summary table (roadmap vs repo metrics)
- Cross-project initiative identification
- Warnings for misaligned projects

**Use cases:**
- Quarterly roadmap sync reviews
- Finding repos with roadmap items but no activity
- Identifying abandoned or stale projects
- Cross-project coordination planning

---

### validate-labels.sh
Validates label consistency and identifies invalid combinations.

**Usage:**
```bash
./scripts/validate-labels.sh
```

**What it checks:**
- Issues missing 'initiative' label
- Missing required labels (project, stage, priority, type)
- Multiple stage labels (should only have one)
- Multiple priority labels (should only have one)
- Unknown/invalid area labels
- Label usage statistics

**Output:**
- Lists of initiatives missing critical labels
- Invalid label combinations
- Unknown area labels not in .github/labels.yml
- Most common area and type labels

**Use cases:**
- Label hygiene maintenance
- Finding mislabeled initiatives
- Identifying deprecated labels
- Planning label taxonomy updates

---

### validate-quarters.sh
Validates quarter/ETA consistency and identifies overdue initiatives.

**Usage:**
```bash
./scripts/validate-quarters.sh
```

**What it checks:**
- Initiatives missing quarter/ETA labels
- Quarter distribution (open initiatives)
- Overdue initiatives (past quarters still in Executing/Prioritization)
- Current quarter focus
- Next quarter preview
- Quarter velocity (shipped vs total per quarter)
- Backlog items

**Output:**
- Missing quarter/ETA warnings
- Quarter distribution stats
- Overdue initiative lists by past quarter
- Current and next quarter focus areas
- Historical completion rates per quarter
- Backlog count

**Use cases:**
- Quarterly planning sessions
- Identifying overdue/stuck initiatives
- Capacity planning
- Historical velocity analysis
- Prioritization decisions

---

### check-initiative-completeness.sh
Validates initiative quality and field completeness.

**Usage:**
```bash
./scripts/check-initiative-completeness.sh [--detailed]
```

**What it checks:**
- Body content length and quality
- Expected Results/Goals section presence
- RASCI assignments (Accountable and Responsible)
- Assignee status
- Wish folder links for complex initiatives
- Template compliance (Context, Goals, Scope, RASCI sections)
- Stage-specific validation (Executing should be well-documented)
- Overall quality score calculation

**Output:**
- Short/empty body warnings
- Missing expected results
- Missing RASCI assignments
- Unassigned initiatives
- Template compliance metrics
- Quality score (0-100)
- Improvement suggestions

**Detailed mode:**
- Sample high-quality initiative
- Sample low-quality initiative

**Quality scoring:**
- 🟢 80-100: Excellent - Roadmap is well-maintained
- 🟡 60-79: Good - Some improvements needed
- 🔴 0-59: Needs Attention - Many initiatives need updating

**Use cases:**
- New initiative review
- Pre-execution quality gates
- Roadmap audit
- Finding initiatives needing documentation
- Quality trend tracking

---

## Common Workflows

### Weekly Health Check
```bash
# Run all health checks
./scripts/check-board-health.sh
./scripts/validate-labels.sh
./scripts/validate-quarters.sh
./scripts/check-initiative-completeness.sh
```

### Quarterly Planning
```bash
# 1. Check quarter velocity
./scripts/validate-quarters.sh

# 2. Validate current initiatives
./scripts/check-initiative-completeness.sh --detailed

# 3. Cross-repo sync
./scripts/check-cross-repo-sync.sh

# 4. Export for stakeholders
python3 scripts/export-to-csv.py
```

### Pre-Execution Quality Gate
```bash
# Ensure initiative is ready for execution
./scripts/check-initiative-completeness.sh --detailed
./scripts/validate-labels.sh
```

### Repository Activity Scan
```bash
# Check all 6 projects for activity
for repo in automagik-{omni,hive,spark,forge,genie,tools}; do
  echo "=== $repo ==="
  ./scripts/check-repo-activity.sh namastexlabs/$repo 7
  echo ""
done
```

## Requirements

All scripts require:
- **GitHub CLI** (`gh`) installed and authenticated
- **jq** for JSON processing: `sudo apt install jq` (Linux) or `brew install jq` (macOS)
- **GITHUB_TOKEN** environment variable for API access (some scripts)
- Read access to namastexlabs organization and repositories

**Authentication:**
```bash
# Authenticate GitHub CLI
gh auth login

# Set token for Python scripts
export GITHUB_TOKEN=$(gh auth token)
```

## Tips

- **Combine scripts** for comprehensive analysis
- **Schedule weekly** via cron for proactive monitoring
- **Export results** to share with team
- **Use in CI/CD** for automated quality checks
- **Add to pre-commit** hooks for initiative validation
