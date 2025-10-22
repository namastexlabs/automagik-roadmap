# Scripts

Utility scripts for managing the Automagik Roadmap and monitoring ecosystem activity.

---

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Initiative Management](#initiative-management)
- [Live Activity Monitoring](#live-activity-monitoring)
- [Roadmap Health & Validation](#roadmap-health--validation)
- [Common Workflows](#common-workflows)
- [Requirements](#requirements)

---

## Quick Start

**Most commonly used scripts:**

```bash
# Daily standup - see what happened today
./scripts/quick-activity-status.sh 1

# Create new initiative from JSON
cat initiative.json | ./scripts/create-initiative-from-json.sh

# Run all health checks
./scripts/check-all.sh

# Check roadmap quality
./scripts/check-initiative-completeness.sh
```

---

## Initiative Management

### create-initiative-from-json.sh

Creates roadmap initiatives from JSON input with **full automation** - sets all labels, project fields, dates, and assignees.

**When to use:**
- Creating new roadmap initiatives
- Batch-creating multiple initiatives
- Programmatic initiative creation

**Usage:**
```bash
cat initiative.json | ./scripts/create-initiative-from-json.sh
```

**Quick example:**
```bash
echo '{
  "title": "Add WebSocket support to Omni",
  "project": "omni",
  "stage": "Exploring",
  "priority": "high",
  "quarter": "2026-q1",
  "type": "feature",
  "areas": ["api", "performance"],
  "description": "Enable real-time bidirectional communication",
  "goals": [
    "Implement WebSocket server",
    "Add client library",
    "Write documentation"
  ]
}' | ./scripts/create-initiative-from-json.sh
```

**JSON Fields:**
- `title` (required): Initiative name
- `project` (required): omni|hive|spark|forge|genie|tools|cross-project
- `stage` (required): Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped
- `priority` (required): critical|high|medium|low
- `quarter` (required): 2026-q1, 2025-10, backlog (auto-calculates dates)
- `type` (optional): feature|enhancement|research|infrastructure|documentation
- `areas` (optional): Array of area labels (api, cli, mcp, etc.)
- `owner` (optional): GitHub username (auto-selects if not provided)
- `start_date` (optional): YYYY-MM-DD (overrides quarter auto-calculation)
- `target_date` (optional): YYYY-MM-DD (overrides quarter auto-calculation)
- `description` (required): One-line problem/solution/impact
- `goals` (required): Array of expected results

**Auto-selection rules:**
- Owner: genie/forge → namastex888, others → vasconceloscezar
- Dates: Quarter-based (q1→Mar 31, q2→Jun 30, q3→Sep 30, q4→Dec 31)

**See also:** `example-initiative.json` for complete template

---

### export-to-csv.py

Exports all roadmap initiatives to CSV format for reporting and analysis.

**When to use:**
- Quarterly stakeholder reports
- Data analysis in Excel/Google Sheets
- Backup/archival purposes

**Usage:**
```bash
export GITHUB_TOKEN=ghp_xxx
python3 scripts/export-to-csv.py
```

**Output:** CSV file in `exports/` directory with all initiative metadata

**Note:** Auto-runs weekly via GitHub Actions workflow

---

## Live Activity Monitoring

### quick-activity-status.sh ⚡ **RECOMMENDED**

Fast snapshot (10-15 seconds) of latest commits across **all 7 Automagik repos**.

**When to use:**
- Daily standup meetings
- Quick "what's happening now" check
- Finding who's working on what
- Identifying stale projects

**Usage:**
```bash
./scripts/quick-activity-status.sh [days]

# Today's activity
./scripts/quick-activity-status.sh 1

# This week
./scripts/quick-activity-status.sh 7

# Last 2 weeks
./scripts/quick-activity-status.sh 14
```

**What it shows:**
- Latest commit per repo (date, author, message)
- Open PRs and issues count
- Active feature branches (non-main/dev)
- Commit messages from last N days

**Example output:**
```
Repo      | Last Commit | Author           | Branch  | Open PRs | Open Issues
----------|-------------|------------------|---------|----------|-------------
omni      | 2025-10-22  | Automagik Genie  | default | 1        | 30
genie     | 2025-10-22  | github-actions   | default | 0        | 18
forge     | 2025-10-22  | Felipe Rosa      | default | 0        | 4
...

🔥 Latest Commit Per Repo (Last 7 Days)

📦 omni
   [5b1e02f] 2025-10-20T15:20 by Automagik Genie 🧞
   Merge pull request #105 from namastexlabs/dev
```

**Why use this instead of check-repo-activity.sh:**
- Much faster (10-15s vs 60s+)
- Covers all repos at once
- Clean tabular output
- Perfect for daily use

---

### live-activity-dashboard.sh

Comprehensive ecosystem-wide activity dashboard with detailed statistics.

**When to use:**
- Weekly team sync meetings
- Monthly activity reports
- Identifying bottlenecks
- Contributor recognition
- Detailed analysis needed

**Usage:**
```bash
./scripts/live-activity-dashboard.sh [days] [--detailed]

# Last week
./scripts/live-activity-dashboard.sh 7

# Last quarter with full details
./scripts/live-activity-dashboard.sh 90 --detailed
```

**What it shows:**
- Ecosystem-wide commit statistics (total commits, PRs, issues)
- Latest commits across all repos (sorted by date)
- Active branches with recent activity
- Open pull requests per repo
- Contributor activity summary (who committed how many times)
- With `--detailed`: Stars, forks, releases, branch counts

**Example output:**
```
╔═══════════════════════════════════════════════════════════════╗
║     🔴 LIVE: AUTOMAGIK ECOSYSTEM ACTIVITY DASHBOARD           ║
╚═══════════════════════════════════════════════════════════════╝

📊 QUICK STATS - Last 7 Days
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📈 Total commits (last 7 days): 42
🔀 Total open PRs: 3
🐛 Total new issues: 8
✅ Active repositories: 6/7

👥 CONTRIBUTOR ACTIVITY (Last 7 Days)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  👤 Cezar Vasconcelos: 15 commits across (omni hive spark)
  👤 Automagik Genie: 12 commits across (omni genie)
  👤 github-actions: 10 commits across (genie)
```

**Performance note:** Takes 30-60 seconds due to comprehensive API calls. Use `quick-activity-status.sh` for faster results.

---

### check-repo-activity.sh

Analyzes **single repository** activity across all branches (main, dev, feature branches).

**When to use:**
- Deep-dive into specific repo
- Finding hidden feature branch work
- Debugging "quiet" repos
- Investigating branch activity

**Usage:**
```bash
./scripts/check-repo-activity.sh owner/repo [days]

# Check genie repo (last 7 days)
./scripts/check-repo-activity.sh namastexlabs/automagik-genie 7

# Check forge repo (last 14 days)
./scripts/check-repo-activity.sh namastexlabs/automagik-forge 14
```

**What it shows:**
- Recent push events across all branches
- List of all branches
- Most active branches with commit counts
- Latest commit date per branch

**Why this exists:**
- Standard `gh` commands only check default branch
- Feature branches often have active work not visible in main
- This finds ALL branch activity

---

## Roadmap Health & Validation

### check-all.sh

Runs all 5 health checks in sequence without interruption.

**When to use:**
- Weekly roadmap review
- Before quarterly planning
- After major roadmap updates
- Comprehensive health assessment

**Usage:**
```bash
./scripts/check-all.sh [--detailed]

# Standard run
./scripts/check-all.sh

# With detailed completeness analysis
./scripts/check-all.sh --detailed

# Save to file
./scripts/check-all.sh > health-report-$(date +%Y%m%d).txt
```

**Runs these checks in order:**
1. Board Health (distribution, missing labels, stale items)
2. Label Consistency (validation, invalid combinations)
3. Quarter/ETA Validation (overdue, velocity)
4. Initiative Completeness (quality score, RASCI)
5. Cross-Repo Sync (roadmap ↔ repo alignment)

**Output:** Comprehensive report with all health metrics

---

### check-board-health.sh

Analyzes initiative distribution and identifies issues.

**When to use:**
- Quick health check before meetings
- Finding initiatives missing labels
- Identifying stale work
- Distribution analysis

**Usage:**
```bash
./scripts/check-board-health.sh [--stale-days 30]

# Default (30 day stale threshold)
./scripts/check-board-health.sh

# Custom stale threshold
./scripts/check-board-health.sh --stale-days 60
```

**What it checks:**
- Initiative distribution by stage (Wishlist, Executing, etc.)
- Priority distribution (critical, high, medium, low)
- Project distribution (omni, hive, spark, etc.)
- Missing critical labels (priority, stage, project, quarter)
- Stale initiatives (no activity in N days)
- Recent activity (last 7 days)
- Currently executing initiatives

**Example output:**
```
📊 Initiative Distribution by Stage:
  Executing: 5
  Exploring: 8
  Wishlist: 10

⚠️  Issues Missing Critical Labels:
  - Missing priority: 0 issues
  - Missing stage: 2 issues
  - Missing quarter/ETA: 5 issues
```

---

### check-cross-repo-sync.sh

Validates alignment between roadmap initiatives and actual repositories.

**When to use:**
- Quarterly roadmap sync reviews
- Finding repos with roadmap items but no activity
- Identifying abandoned projects
- Cross-project coordination planning

**Usage:**
```bash
./scripts/check-cross-repo-sync.sh
```

**What it checks:**
- Repository accessibility for all 6 projects
- Last commit dates per repo
- Open issues and PRs count
- Roadmap initiatives count per project
- Cross-project dependencies
- Orphaned initiatives (roadmap entries for non-existent repos)

**Example output:**
```
📦 Repository Status Check:

--- Project: omni (Repo: automagik-omni) ---
  ✅ Repository accessible
  📅 Last commit: 2025-10-20T15:20:24Z
  🐛 Open issues: 30
  🔀 Open PRs: 1
  🎯 Roadmap initiatives: 10

📊 Activity Summary by Project
Project | Roadmap Initiatives | Repo Issues | Repo PRs | Last Commit
--------|---------------------|-------------|----------|-------------
omni    | 10                  | 30          | 1        | 2025-10-20
genie   | 5                   | 18          | 0        | 2025-10-22
```

---

### validate-labels.sh

Validates label consistency and identifies invalid combinations.

**When to use:**
- Label hygiene maintenance
- Finding mislabeled initiatives
- After updating label taxonomy
- Before board presentations

**Usage:**
```bash
./scripts/validate-labels.sh
```

**What it checks:**
- Issues missing 'initiative' label
- Missing required labels (project, stage, priority, type)
- Multiple stage labels (should only have one)
- Multiple priority labels (should only have one)
- Unknown/invalid area labels (not in .github/labels.yml)
- Label usage statistics

**Example output:**
```
⚠️  Multiple Stage Labels (Should Only Have One):
  #73 - Omni: Email Channel Integration: Exploring, Wishlist

⚠️  Potentially Invalid Area Labels:
  - area:observability (Consider adding to .github/labels.yml)
  - area:dx (Consider adding to .github/labels.yml)

📊 Most Common Area Labels:
  area:api: 8 issues
  area:cli: 6 issues
```

---

### validate-quarters.sh

Validates quarter/ETA consistency and identifies overdue initiatives.

**When to use:**
- Quarterly planning sessions
- Identifying stuck initiatives
- Capacity planning
- Historical velocity analysis

**Usage:**
```bash
./scripts/validate-quarters.sh
```

**What it checks:**
- Initiatives missing quarter/ETA labels
- Quarter distribution (how many per quarter)
- Overdue initiatives (past quarters still in Executing/Prioritization)
- Current quarter focus
- Next quarter preview
- Quarter velocity (shipped vs total per quarter)
- Backlog items

**Example output:**
```
=== Current Quarter: 2025-q4 ===

⚠️  Initiatives Missing Quarter/ETA Label:
  #72 - Forge: One-Click Auto-Update System

🔴 Potentially Overdue Initiatives:
Quarter: 2025-q3
  #45 - Omni: Human-Like Agent Interactions [Executing]

📈 Quarter Velocity Analysis:
  quarter:2025-q3: 5/8 shipped (62%)
  quarter:2025-q2: 8/10 shipped (80%)

🎯 Current Quarter Focus (2025-q4):
  #44 - Omni: Enhanced Observability [Priority: high]
  #43 - Omni: Get Started in Under 5 Minutes [Priority: low]
```

---

### check-initiative-completeness.sh

Validates initiative quality and calculates completeness score.

**When to use:**
- New initiative review
- Pre-execution quality gates
- Roadmap audit
- Finding initiatives needing documentation

**Usage:**
```bash
./scripts/check-initiative-completeness.sh [--detailed]

# Standard run
./scripts/check-initiative-completeness.sh

# With sample high/low quality examples
./scripts/check-initiative-completeness.sh --detailed
```

**What it checks:**
- Body content length and quality
- Expected Results/Goals section presence
- RASCI assignments (Accountable and Responsible)
- Assignee status
- Wish folder links for complex initiatives
- Template compliance (Context, Goals, Scope, RASCI sections)
- Stage-specific validation (Executing should be well-documented)
- Overall quality score calculation (0-100)

**Quality scoring factors:**
- Assignment rate (initiatives with owners)
- Documentation rate (body length >500 chars)
- Goals defined (has expected results section)

**Example output:**
```
⚠️  Initiatives with Short/Empty Body (<200 chars):
  #72 - Forge: One-Click Auto-Update System (150 chars)

⚠️  Missing Accountable (A) Assignment:
  #73 - Omni: Email Channel Integration

📊 Assignment Rate: 19/27 initiatives assigned (70%)

📋 Template Compliance:
  Initiatives with Context section: 15/27
  Initiatives with Goals section: 20/27
  Initiatives with RASCI section: 12/27

🎯 Overall Quality Score: 75/100
   Status: 🟡 Good - Some improvements needed

💡 Improvement Suggestions:
  1. Assign owners to 8 unassigned initiatives
  2. Add expected results to 7 initiatives
  3. Use LEAN templates for new initiatives
```

**Quality score interpretation:**
- 🟢 80-100: Excellent - Roadmap is well-maintained
- 🟡 60-79: Good - Some improvements needed
- 🔴 0-59: Needs Attention - Many initiatives need updating

---

## Common Workflows

### Daily Standup
```bash
# Quick activity snapshot (10-15 seconds)
./scripts/quick-activity-status.sh 1

# See what happened yesterday
./scripts/quick-activity-status.sh 2
```

### Weekly Health Check
```bash
# 1. Check recent activity
./scripts/quick-activity-status.sh 7

# 2. Run all health checks
./scripts/check-all.sh
```

### Quarterly Planning
```bash
# 1. Review ecosystem activity (last 90 days)
./scripts/live-activity-dashboard.sh 90 --detailed

# 2. Check quarter velocity
./scripts/validate-quarters.sh

# 3. Validate current initiatives
./scripts/check-initiative-completeness.sh --detailed

# 4. Cross-repo sync
./scripts/check-cross-repo-sync.sh

# 5. Export for stakeholders
export GITHUB_TOKEN=$(gh auth token)
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

### Monthly Report Generation
```bash
# Generate comprehensive monthly report
{
  echo "# Automagik Ecosystem - Monthly Report $(date +%Y-%m)"
  echo ""
  ./scripts/live-activity-dashboard.sh 30
  echo ""
  ./scripts/check-all.sh
} > monthly-report-$(date +%Y%m).txt
```

---

## Requirements

All scripts require:

- **GitHub CLI (`gh`)** installed and authenticated
  ```bash
  # Install (macOS)
  brew install gh

  # Install (Ubuntu/Debian)
  sudo apt install gh

  # Authenticate
  gh auth login
  ```

- **jq** for JSON processing
  ```bash
  # macOS
  brew install jq

  # Ubuntu/Debian
  sudo apt install jq
  ```

- **GITHUB_TOKEN** environment variable (some scripts)
  ```bash
  export GITHUB_TOKEN=$(gh auth token)
  ```

- **Permissions:** Read access to namastexlabs organization and repositories

**Optional:**
- Python 3.x (for export-to-csv.py)
- `date` command (built-in on Linux/macOS)

---

## Tips & Best Practices

### Performance
- Use `quick-activity-status.sh` for daily checks (fast)
- Use `live-activity-dashboard.sh` for weekly/monthly reports (thorough)
- Combine scripts for comprehensive analysis
- Save output to files for historical tracking

### Automation
- Schedule weekly via cron: `0 9 * * 1 cd ~/roadmap && ./scripts/check-all.sh > weekly-$(date +%Y%m%d).txt`
- Add to CI/CD for automated quality checks
- Use in pre-commit hooks for initiative validation

### Organization
- Create reports directory: `mkdir -p reports/`
- Save weekly reports: `./scripts/check-all.sh > reports/week-$(date +%Y-W%V).txt`
- Export CSV monthly: `python3 scripts/export-to-csv.py`

### Troubleshooting
- If scripts hang: Check GitHub API rate limits with `gh api rate_limit`
- If auth fails: Re-authenticate with `gh auth login`
- If jq errors: Update jq to latest version
- If date errors: Script auto-detects Linux/macOS date formats

---

## Script Summary Table

| Script | Speed | Purpose | Use Case |
|--------|-------|---------|----------|
| `quick-activity-status.sh` | ⚡ Fast (10-15s) | Latest commits all repos | Daily standup |
| `live-activity-dashboard.sh` | 🐢 Slow (30-60s) | Comprehensive ecosystem stats | Weekly/monthly reports |
| `check-repo-activity.sh` | ⚡ Fast (10-20s) | Single repo all branches | Deep-dive investigation |
| `check-all.sh` | 🐢 Slow (60-90s) | All health checks | Weekly review |
| `check-board-health.sh` | ⚡ Fast (15-20s) | Distribution & missing labels | Quick health check |
| `check-cross-repo-sync.sh` | ⚡ Fast (20-30s) | Roadmap ↔ repo alignment | Quarterly sync |
| `validate-labels.sh` | ⚡ Fast (10-15s) | Label consistency | Label hygiene |
| `validate-quarters.sh` | ⚡ Fast (15-20s) | Overdue & velocity | Quarterly planning |
| `check-initiative-completeness.sh` | ⚡ Fast (15-25s) | Quality score & compliance | Quality gates |
| `create-initiative-from-json.sh` | ⚡ Fast (30-45s) | Create initiatives | New initiative |
| `export-to-csv.py` | ⚡ Fast (10-20s) | Export to CSV | Reporting |

---

## Contributing

When adding new scripts:
1. Add executable permission: `chmod +x script-name.sh`
2. Update this README with usage examples
3. Add to appropriate workflow section
4. Test on both Linux and macOS (date command compatibility)
5. Follow naming convention: `verb-noun.sh` (e.g., `check-board-health.sh`)

---

## Support

- Issues: https://github.com/namastexlabs/automagik-roadmap/issues
- Discord: https://discord.gg/xcW8c7fF3R
- Documentation: See `docs/` folder in repository root
