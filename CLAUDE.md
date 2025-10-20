# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

The **Automagik Roadmap** is a centralized strategic planning repository for the entire Automagik ecosystem. It serves as the single source of truth for tracking initiatives across 6 projects:

- **Omni** - Omnichannel messaging with MCP
- **Hive** - Multi-agent orchestration
- **Spark** - Cron system that sparks repos
- **Forge** - AI-powered development orchestrator
- **Genie** - Autonomous agent framework
- **Tools** - MCP tools builder & marketplace

**Core Concept:** Initiatives progress through lifecycle stages (Wishlist → Exploring → RFC → Prioritization → Executing → Preview → Shipped) with RASCI ownership and expected results tracking.

## Architecture

### Repository Structure

```
.
├── .github/
│   ├── ISSUE_TEMPLATE/initiative.yml    # GitHub issue form for quick proposals
│   ├── workflows/
│   │   ├── sync-to-project.yml          # Auto-syncs issues to project board
│   │   ├── export-roadmap.yml           # Weekly CSV exports
│   │   └── label-sync.yml               # Label management
│   └── labels.yml                       # Label definitions (6 dimensions)
├── scripts/
│   ├── create-initiative-from-json.sh   # JSON-based initiative creation (primary)
│   └── export-to-csv.py                 # Export roadmap to CSV
├── docs/
│   ├── templates/                       # Initiative templates (Minimal/Standard/Comprehensive)
│   ├── label-guide.md                   # Complete label taxonomy
│   ├── stage-definitions.md             # Lifecycle stage criteria
│   └── rasci-guide.md                   # Ownership model
├── projects/                            # Per-project folders
│   ├── omni/
│   │   ├── 5w2h.md                     # Strategic analysis
│   │   └── wishes/                     # Detailed initiative specs
│   └── [hive|spark|forge|genie|tools]/ # Same structure
└── exports/                             # Weekly CSV exports
```

### Key Systems

#### 1. Initiative Creation Methods

**Method A: GitHub Issue Form** (Quick proposals)
- Uses `.github/ISSUE_TEMPLATE/initiative.yml`
- Structured form with dropdowns
- Workflow parses body headers (`### Field Name`)
- Auto-syncs to project board via `sync-to-project.yml`

**Method B: JSON Script** (Recommended - Automated & Fast)
- Uses `scripts/create-initiative-from-json.sh`
- Accepts JSON input with all fields
- Auto-selects owners (genie/forge → namastex888, others → vasconceloscezar)
- Sets all project board fields via parallel GraphQL mutations
- Supports start_date and target_date overrides
- ~40s creation time with full automation

#### 2. Project Board Sync Workflow

**Flow:** Issue created → Workflow detects `initiative` label → Adds to project #9 → Parses fields → Sets custom fields

**Field Mappings** (from `sync-to-project.yml`):
- Project field ID: `PVTSSF_lADOBvG2684BE-4Ezg2c_ec`
- Stage field ID: `PVTSSF_lADOBvG2684BE-4Ezg2c_hc`
- Priority field ID: `PVTSSF_lADOBvG2684BE-4Ezg2c_kA`
- ETA/Quarter field ID: `PVTSSF_lADOBvG2684BE-4Ezg2dPxc`
- Expected Results field ID: `PVTF_lADOBvG2684BE-4Ezg2c8aE`
- Owner field ID: `PVTF_lADOBvG2684BE-4Ezg2c8aI`
- Target Date field ID: `PVTF_lADOBvG2684BE-4Ezg2c8aM`

**Option IDs** (see `scripts/create-initiative-from-json.sh:56-70` for complete mapping)

#### 3. Label System (6 Dimensions)

From `.github/labels.yml` - 59 labels total:

1. **Project** (7): `project:omni`, `project:hive`, etc.
2. **Stage** (8): `Wishlist`, `Exploring`, `RFC`, `Prioritization`, `Executing`, `Preview`, `Shipped`, `Archived`
3. **Type** (6): `type:feature`, `type:enhancement`, `type:research`, `type:infrastructure`, `type:documentation`, `type:bug-initiative`
4. **Priority** (4): `priority:critical`, `priority:high`, `priority:medium`, `priority:low`
5. **Quarter** (10): `quarter:2025-q4`, `quarter:2026-q1` through `quarter:2027-q4`, `quarter:backlog`
6. **Area** (15+): `area:api`, `area:cli`, `area:mcp`, `area:agents`, `area:performance`, `area:security`, etc.

**Important Label Behavior:**
- **CLI Script:** Does NOT apply quarter labels. The `--quarter` parameter sets the **ETA project field** directly via GraphQL.
- **GitHub Form:** DOES apply quarter labels via workflow (`.github/workflows/sync-to-project.yml:142`) AND sets ETA field.
- Both methods ultimately set the same ETA project field, but form submissions also get visual quarter labels for filtering.

## Creating Initiatives

### Using JSON Script (Recommended - Fast & Automated)

```bash
# Create initiative from JSON
cat initiative.json | ./scripts/create-initiative-from-json.sh

# Example JSON
{
  "title": "Feature Name",
  "project": "genie",
  "stage": "Executing",
  "priority": "high",
  "quarter": "2025-q4",
  "start_date": "2025-10-20",
  "target_date": "2025-12-15",
  "type": "feature",
  "areas": ["cli", "testing"],
  "description": "One-line summary",
  "goals": ["Goal 1", "Goal 2", "Goal 3"]
}
```

**Key Features:**
1. **Auto-selects owners:**
   - genie/forge → `namastex888`
   - omni/hive/spark/tools/cross-project → `vasconceloscezar`
   - Override with `"owner": "username"` in JSON

2. **Smart date handling:**
   - Provide `start_date` and `target_date` for custom timeline
   - Or use `quarter` and dates auto-calculate (Q1→Mar 31, Q2→Jun 30, etc.)
   - Quarter is case-insensitive: `2025-q4` = `2025-Q4`

3. **Fast parallel mutations:**
   - All project board fields set simultaneously
   - ~40s creation time (vs 60s+ before)
   - 10 retries with 3s delay (30s max timeout)

4. **Full automation:**
   - No manual field updates needed
   - All labels, assignees, and project fields set automatically
   - Simplified body template for speed

### Using GitHub Form (Alternative - Quick Proposals)

1. Go to Issues → New Issue → "🎯 Roadmap Initiative"
2. Fill form (all fields auto-sync to project board)
3. Submit → Workflow handles everything

**Note:** JSON script is preferred for better control and automation.

## Common Commands

### Initiative Management

```bash
# Create initiative from JSON (recommended)
cat initiative.json | ./scripts/create-initiative-from-json.sh

# Quick one-liner
echo '{"title":"Feature","project":"hive","quarter":"2026-q1","priority":"high","goals":["Goal 1"]}' | ./scripts/create-initiative-from-json.sh

# With custom dates
cat << EOF | ./scripts/create-initiative-from-json.sh
{
  "title": "My Feature",
  "project": "omni",
  "stage": "Executing",
  "priority": "high",
  "start_date": "2025-11-01",
  "target_date": "2025-12-31",
  "type": "feature",
  "areas": ["api", "performance"],
  "goals": ["Improve API speed", "Add caching layer"]
}
EOF

# See script help for all options
./scripts/create-initiative-from-json.sh --help
```

### Exports & Reporting

```bash
# Generate CSV export (requires GITHUB_TOKEN)
export GITHUB_TOKEN=ghp_xxx
python3 scripts/export-to-csv.py

# Weekly auto-export runs via .github/workflows/export-roadmap.yml
```

### Label Management

```bash
# Sync labels to repo (after editing .github/labels.yml)
gh workflow run label-sync.yml

# View project board
open https://github.com/orgs/namastexlabs/projects/9
```

## Development Workflow

### Adding New Area Labels

1. Edit `.github/labels.yml`:
```yaml
- name: area:telemetry
  color: '006B75'
  description: 'Telemetry and observability'
```

2. Sync labels: `gh workflow run label-sync.yml`

3. Now available in CLI: `--areas "telemetry,performance"`

### Updating Project Board Field IDs

If project board schema changes, update field IDs in:
- `scripts/create-initiative-from-json.sh:15-24` (FIELD_IDS map)
- `scripts/create-initiative-from-json.sh:27-70` (Option IDs)
- `.github/workflows/sync-to-project.yml:170-366` (all field update mutations)

**To find new IDs:**
```bash
# Get project schema
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

### Debugging Initiative Creation Issues

**Problem: "Label not found" error**
- Check `.github/labels.yml` for valid area labels
- Remove invalid areas from `--areas` parameter
- Available areas listed in label-guide.md:141-154

**Problem: "Item ID not found"**
- GraphQL sync can lag up to 20s
- Script retries 10x with 2s delay
- If fails, re-run script (safe to retry)

**Problem: Expected Results not populating**
- Ensure template has `### Goals (Expected Results)` or `### Expected Results` header
- Script extracts first 300 chars from that section
- Verify markdown formatting (script removes bold/bullets)

**Problem: Quarter label applied but ETA field empty**
- This should never happen - both methods set ETA field
- If it does: Manually set ETA field via GraphQL (see commands above)
- **Label vs Field:**
  - CLI: Sets ETA field only (no quarter label)
  - Form: Sets both ETA field AND quarter label
  - Both are valid - label is cosmetic for GitHub filtering

## Project Context

### RASCI Model

From `docs/rasci-guide.md`:
- **R**esponsible: Executes the work (can be TBD)
- **A**ccountable: Owns success/failure (1 person, required)
- **S**upport: Provides resources
- **C**onsulted: Provides input
- **I**nformed: Kept updated

### Stage Lifecycle

From `docs/stage-definitions.md`:

```
Wishlist (Initial ideation, 1-2 weeks)
    ↓
Exploring (Validation, 1-4 weeks)
    ↓
RFC (Community feedback, 2-6 weeks)
    ↓
Prioritization (Planning, 2-8 weeks)
    ↓
Executing (Implementation, 4-16 weeks)
    ↓
Preview (Beta testing, 2-8 weeks)
    ↓
Shipped (Production)
    ↓
Archived (Deprioritized)
```

### Wish Folders

For detailed specs, create in `projects/<project>/wishes/<slug>/`:
- Follow template from `docs/wish-template.md`
- Link in roadmap issue
- Used by automagik-genie for implementation context

## Important Notes

1. **Initiative titles:** Clean format, no `[Initiative]` prefix (script handles this)
2. **Quarter ≠ Commitment:** Targets only, per repo disclaimer
3. **Cross-project coordination:** Use `project:cross-project` + multiple area labels
4. **CSV exports:** Auto-generated weekly in `exports/` for stakeholder reporting
5. **Project board:** #9 in namastexlabs org, synced automatically
6. **Authentication:** CLI script requires `gh` CLI authenticated with org access

## Resources

- Project Board: https://github.com/orgs/namastexlabs/projects/9
- All Initiatives: https://github.com/namastexlabs/automagik-roadmap/issues?q=label%3Ainitiative
- Discord: https://discord.gg/xcW8c7fF3R
- Complete docs in `docs/` folder
