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

**Core Concept:** Initiatives progress through lifecycle stages (Wishlist → Exploring → RFC → Priorization → Executing → Preview → Shipped) with RASCI ownership and expected results tracking.

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
│   ├── create-initiative.sh             # CLI for creating detailed initiatives
│   ├── create-initiative-from-json.sh   # JSON-based initiative creation
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

#### 1. Dual Initiative Creation Methods

**Method A: GitHub Issue Form** (Quick proposals)
- Uses `.github/ISSUE_TEMPLATE/initiative.yml`
- Structured form with dropdowns
- Workflow parses body headers (`### Field Name`)
- Auto-syncs to project board via `sync-to-project.yml`

**Method B: CLI Script** (Detailed initiatives)
- Uses `scripts/create-initiative.sh`
- Accepts piped markdown from templates
- Sets project board fields directly via GraphQL
- Bypasses workflow parsing (already complete)

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

**Option IDs** (see `scripts/create-initiative.sh:63-99` for complete mapping)

#### 3. Label System (6 Dimensions)

From `.github/labels.yml` - 56 labels total:

1. **Project** (7): `project:omni`, `project:hive`, etc.
2. **Stage** (8): `Wishlist`, `Exploring`, `RFC`, `Priorization`, `Executing`, `Preview`, `Shipped`, `Archived`
3. **Type** (6): `type:feature`, `type:enhancement`, `type:research`, `type:infrastructure`, `type:documentation`, `type:bug-initiative`
4. **Priority** (4): `priority:critical`, `priority:high`, `priority:medium`, `priority:low`
5. **Quarter** (7): `quarter:2025-q4`, `quarter:2026-q1`, ..., `quarter:backlog`
6. **Area** (15+): `area:api`, `area:cli`, `area:mcp`, `area:agents`, `area:performance`, `area:security`, etc.

**Important Label Behavior:**
- **CLI Script:** Does NOT apply quarter labels. The `--quarter` parameter sets the **ETA project field** directly via GraphQL.
- **GitHub Form:** DOES apply quarter labels via workflow (`.github/workflows/sync-to-project.yml:142`) AND sets ETA field.
- Both methods ultimately set the same ETA project field, but form submissions also get visual quarter labels for filtering.

## Creating Initiatives

### Using CLI Script (Recommended for Detailed Work)

```bash
# Basic usage with template
cat docs/templates/STANDARD_INITIATIVE.md | ./scripts/create-initiative.sh \
  --title "Initiative Title" \
  --project (omni|hive|spark|forge|genie|tools|cross-project) \
  --stage (Wishlist|Exploring|RFC|Priorization|Executing|Preview|Shipped) \
  --priority (critical|high|medium|low) \
  --quarter (2025-Q4|2026-Q1|backlog) \
  --owner github-username \
  --type (feature|enhancement|research|infrastructure|documentation) \
  --areas "area1,area2"
```

**Critical Points:**
1. **Area labels must exist** in `.github/labels.yml` or script fails
   - Valid areas: `api`, `ui`, `cli`, `mcp`, `knowledge`, `auth`, `agents`, `teams`, `workflows`, `storage`, `testing`, `docs`, `messaging`, `performance`, `security`
   - To add new areas: Edit `.github/labels.yml` first

2. **Quarter vs Target Date:**
   - `--quarter` sets ETA field AND calculates target date (end of quarter)
   - Script auto-calculates: Q1→Mar 31, Q2→Jun 30, Q3→Sep 30, Q4→Dec 31
   - To override, manually update Target Date field via GraphQL after creation

3. **Expected Results Extraction:**
   - Script parses `### Goals (Expected Results)` or `### Expected Results` section
   - Limited to 300 chars, sets Project Board field
   - Ensure template has this header for auto-population

4. **Retry Logic:**
   - Script retries 10x to find project item ID (GraphQL can lag)
   - If item not found after 20s, script fails
   - Re-run script if this happens (idempotent)

### Using GitHub Form (Quick Proposals)

1. Go to Issues → New Issue → "🎯 Roadmap Initiative"
2. Fill form (all fields auto-sync to project board)
3. Submit → Workflow handles everything

**Form vs CLI Detection:**
- Workflow checks if `project` field parsed from body
- If empty → assumes CLI-created, skips label/comment actions
- If present → applies labels and adds sync comment

### Templates

Three levels based on complexity:

1. **Minimal** (`docs/templates/MINIMAL_INITIATIVE.md`) - 8 sections, 15-30 min
   - For: Small features, quick wins, straightforward enhancements
   - Sections: Overview (5W2H), Goals, Scope, Timeline, Dependencies, Risks

2. **Standard** (`docs/templates/STANDARD_INITIATIVE.md`) - 12 sections, 1-2 hours
   - For: Most initiatives (default choice)
   - Adds: Options analysis, detailed phases, success metrics, open questions

3. **Comprehensive** (`docs/templates/COMPREHENSIVE_INITIATIVE.md`) - 20+ sections, 4-8 hours
   - For: Major launches, full PRDs, complex cross-project work
   - Adds: User personas, BDD scenarios, rollout plans, stakeholder matrix

**Template Selection Guide:** See `docs/templates/README.md:40-80`

## Common Commands

### Initiative Management

```bash
# Create initiative from Standard template
cat docs/templates/STANDARD_INITIATIVE.md | ./scripts/create-initiative.sh \
  --title "My Feature" --project omni --priority high --quarter 2026-Q1

# Create cross-project initiative
cat my-initiative.md | ./scripts/create-initiative.sh \
  --title "Cross-repo Work" --project cross-project --areas "performance,security"

# Create from JSON (alternative method)
echo '{"title":"Feature","project":"hive","quarter":"2026-q1"}' | ./scripts/create-initiative-from-json.sh

# Update Target Date manually (if needed)
gh api graphql -f query='
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwDOBvG2684BE-4E"
    itemId: "ITEM_ID_HERE"
    fieldId: "PVTF_lADOBvG2684BE-4Ezg2c8aM"
    value: {date: "2026-03-15"}
  }) { projectV2Item { id } }
}'
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
- `scripts/create-initiative.sh:52-60` (FIELD_IDS map)
- `scripts/create-initiative.sh:63-99` (Option IDs)
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
Wishlist (Ideation, 1-2 weeks)
    ↓
Exploring (Validation, 1-4 weeks)
    ↓
RFC (Community feedback, 2-6 weeks)
    ↓
Priorization (Planning, 2-8 weeks)
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
