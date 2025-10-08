# Wish Sync Strategy - Cross-Repo Workflow

**Purpose:** Design system for managing wish files across project repos and roadmap repo
**Date:** 2025-10-07
**Status:** 🧠 Strategic Planning

---

## The Problem

### Current Reality
- **Wishes live in project repos** during development (e.g., `automagik-hive/genie/wishes/`)
- **Roadmap has wish folders** but they're empty (`projects/hive/wishes/`)
- **Completed wishes accumulate** in project repos → pollution
- **No clear workflow** for archiving completed work
- **Missing links** between roadmap initiatives and implementation PRs

### Example: PR #30 in automagik-hive
- **Title:** Agno v2 Migration & AgentOS Integration
- **Author:** @rodriguess-caio (caio)
- **Owner:** @vasconceloscezar (you)
- **Status:** Merged (Oct 7, 2025)
- **Size:** +16,190 / -4,588 lines
- **Contains:** 4 wish files + 88 report files in `genie/` folder
- **This SHOULD be tracked** as macro task in roadmap

---

## The Vision

### Wish Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│ PHASE 1: ACTIVE DEVELOPMENT (Project Repo)                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  automagik-hive/genie/wishes/agno-v2-migration-wish.md     │
│  Status: 🚧 In Progress                                     │
│                                                             │
│  - Agents work on implementation                            │
│  - Reports accumulate in genie/reports/                     │
│  - QA back and forth                                        │
│  - PR is open and evolving                                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    (PR Merged, Status → ✅ Complete)
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 2: ARCHIVE & LINK (Roadmap Repo)                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  automagik-roadmap/projects/hive/wishes/agno-v2-migration/ │
│                                                             │
│  Files moved from project repo:                             │
│  - agno-v2-migration-wish.md (historical record)            │
│  - reports/ (all execution reports)                         │
│  - qa/ (evidence and test results)                          │
│  - ARCHIVE-INFO.md (metadata)                               │
│                                                             │
│  Roadmap Issue created/updated:                             │
│  - Links to PR #30                                          │
│  - Links to archived wish folder                            │
│  - RASCI assigned (Owner: vasconceloscezar, Assignee: caio) │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 3: CLEANUP (Project Repo)                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Option A: Delete wish files (they're in roadmap now)       │
│  Option B: Mark as archived with stub:                      │
│                                                             │
│    Status: ✅ Complete - Archived                           │
│    Archive: automagik-roadmap/projects/hive/wishes/...      │
│    Roadmap: automagik-roadmap#XX                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Architecture Options

### Option 1: Manual Process with Helper Script (RECOMMENDED START)

**Tool:** `scripts/archive-wish.sh`

**Usage:**
```bash
cd automagik-roadmap
./scripts/archive-wish.sh hive agno-v2-migration \
  --source-repo namastexlabs/automagik-hive \
  --pr 30 \
  --owner vasconceloscezar \
  --assignee rodriguess-caio
```

**What it does:**
1. Clones source repo (or uses local path)
2. Finds wish file: `genie/wishes/agno-v2-migration-wish.md`
3. Finds related reports: `genie/reports/*agno-v2*`
4. Creates: `projects/hive/wishes/agno-v2-migration/`
5. Copies all files with structure preservation
6. Generates `ARCHIVE-INFO.md` with metadata
7. Commits to roadmap repo
8. Outputs template for roadmap issue
9. **Optional:** Creates PR in source repo to mark as archived

**Pros:**
- ✅ Simple, transparent, debuggable
- ✅ Manual control and verification
- ✅ No infrastructure complexity
- ✅ Can be run by any maintainer
- ✅ Works immediately

**Cons:**
- ❌ Manual process (not automated)
- ❌ Requires maintainer discipline
- ❌ Potential for human error

**Verdict:** START HERE. Build automation later.

---

### Option 2: Semi-Automated with GitHub Actions

**Trigger:** Manual workflow dispatch in roadmap repo

```yaml
# .github/workflows/archive-wish.yml
name: Archive Completed Wish

on:
  workflow_dispatch:
    inputs:
      project:
        description: 'Project (omni/hive/spark/forge/tools/genie)'
        required: true
      wish_slug:
        description: 'Wish slug (e.g., agno-v2-migration)'
        required: true
      source_repo:
        description: 'Source repo (e.g., namastexlabs/automagik-hive)'
        required: true
      pr_number:
        description: 'PR number'
        required: false

jobs:
  archive:
    runs-on: ubuntu-latest
    steps:
      - name: Run archive script
        run: ./scripts/archive-wish.sh ...

      - name: Create archive PR
        uses: peter-evans/create-pull-request@v5
```

**Usage:**
1. Go to Actions tab in roadmap repo
2. Click "Archive Completed Wish"
3. Fill in form (project, wish slug, PR number)
4. Action runs, creates PR in roadmap
5. Review and merge

**Pros:**
- ✅ UI-driven (no command line needed)
- ✅ Still manual approval
- ✅ Creates PR for review
- ✅ Logs and audit trail

**Cons:**
- ❌ Still manual trigger
- ❌ Requires GitHub UI access

**Verdict:** Good next step after manual script proven.

---

### Option 3: Fully Automated with Repository Dispatch

**Flow:**
```
Project Repo PR Merged
    ↓
GitHub Action in project repo detects completed wishes
    ↓
Sends repository_dispatch event to roadmap repo
    ↓
Roadmap action automatically archives
    ↓
Creates PR in roadmap (auto-merge or review)
```

**Project Repo Action:**
```yaml
# automagik-hive/.github/workflows/notify-roadmap.yml
name: Notify Roadmap of Completed Wishes

on:
  pull_request:
    types: [closed]
    branches: [main, dev]

jobs:
  check-wishes:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Find completed wishes
        run: |
          # Parse genie/wishes/*.md for Status: ✅ Complete
          # Extract wish slugs

      - name: Dispatch to roadmap
        uses: peter-evans/repository-dispatch@v2
        with:
          token: ${{ secrets.ROADMAP_REPO_TOKEN }}
          repository: namastexlabs/automagik-roadmap
          event-type: archive-wish
          client-payload: {...}
```

**Roadmap Repo Action:**
```yaml
# automagik-roadmap/.github/workflows/receive-wish.yml
on:
  repository_dispatch:
    types: [archive-wish]

jobs:
  archive:
    runs-on: ubuntu-latest
    steps:
      - name: Archive wish files
        run: ./scripts/archive-wish.sh ${{ github.event.client_payload.project }} ...
```

**Pros:**
- ✅ Fully automated
- ✅ Immediate archival on merge
- ✅ No manual intervention
- ✅ Consistent process

**Cons:**
- ❌ Complex setup (2 repos, tokens)
- ❌ Needs `ROADMAP_REPO_TOKEN` with write access
- ❌ Debugging harder
- ❌ Risk of automatic errors

**Verdict:** Future optimization, not MVP.

---

## Detection Strategies: How to Know What to Archive?

### Method 1: Parse Wish File Status (RECOMMENDED)

**Check wish markdown:**
```markdown
**Status:** ✅ Complete | 🚧 In Progress | 🔍 Exploring
```

**Script logic:**
```bash
grep -l "Status.*✅ Complete" genie/wishes/*.md
```

**Pros:** Simple, explicit, already in template
**Cons:** Relies on maintainer updating status

---

### Method 2: Commit Message Convention

**Format:**
```
feat: complete agno v2 migration

WISH-COMPLETE: agno-v2-migration
```

**Action parses commit message to detect completion**

**Pros:** Event-driven
**Cons:** Requires discipline, easy to forget

---

### Method 3: PR Labels

**Label:** `wish:complete`

Applied to PR when all wishes are done.

**Pros:** Visual in GitHub UI
**Cons:** Manual labeling step

---

### Method 4: Git Tags

**Tag format:** `wish-<slug>-complete`

```bash
git tag wish-agno-v2-migration-complete
git push --tags
```

**Pros:** Git-native, immutable
**Cons:** Extra step, not intuitive

---

## The Archive Structure

### Folder Layout in Roadmap Repo

```
projects/hive/wishes/agno-v2-migration/
├── agno-v2-migration-wish.md          # Main wish (copied from project repo)
├── ARCHIVE-INFO.md                    # Metadata about archival
├── qa/                                # Evidence (if exists in source)
│   └── test-results-YYYYMMDD.json
└── reports/                           # All execution reports
    ├── forge-plan-agno-v2-migration-202509232210.md
    ├── hive-coder-agno-v2-foundation-202509232259.md
    ├── hive-reviewer-agno-v2-audit-202509251548.md
    ├── hive-tests-agno-v2-migration-202510070001.md
    └── ... (all 88 report files from PR #30)
```

### ARCHIVE-INFO.md Template

```markdown
# Archive Information

**Archived From:** namastexlabs/automagik-hive
**Original Path:** genie/wishes/agno-v2-migration-wish.md
**Archived On:** 2025-10-07
**Archived By:** @vasconceloscezar

## Source PR
- **PR:** namastexlabs/automagik-hive#30
- **Title:** Agno v2 Migration & AgentOS Integration
- **Author:** @rodriguess-caio
- **Owner:** @vasconceloscezar
- **Merged:** 2025-10-07T15:34:03Z
- **Status:** MERGED

## Roadmap Tracking
- **Roadmap Issue:** automagik-roadmap#XX
- **Initiative:** Hive: Agno v2 Migration & Platform Modernization
- **Quarter:** Q4 2025
- **Priority:** Critical

## Files Archived
- Main Wish: agno-v2-migration-wish.md
- Reports: 88 files (see reports/ folder)
- QA: (none in source)

## Related Wishes (Same PR)
- agentos-api-configuration-wish.md
- agno-agentos-unification-wish.md
- knowledge-agno-pgvector-alignment-wish.md

## Links
- [Source PR](https://github.com/namastexlabs/automagik-hive/pull/30)
- [Roadmap Initiative](https://github.com/namastexlabs/automagik-roadmap/issues/XX)
- [Wish Folder](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/hive/wishes/agno-v2-migration)
```

---

## The Roadmap Issue Structure

### For PR #30 Example

```markdown
---
name: Initiative
about: Strategic roadmap initiative
title: '[Initiative] Hive: Agno v2 Migration & Platform Modernization'
labels: initiative, project:hive, Shipped, priority:critical, quarter:2025-q4, type:infrastructure
---

## Project
project:hive

## Description

Complete migration from Agno v1 to v2 with comprehensive AgentOS integration, modernizing the entire Automagik Hive platform architecture. Includes storage abstraction updates, model configuration improvements, and full Control Plane readiness.

This macro initiative encompasses multiple sub-wishes executed by agents through iterative review and QA cycles.

## Expected Results

- [x] Agno v1 → v2 migration complete across all agents, teams, workflows
- [x] AgentOS integration functional with YAML-based runtime config
- [x] Storage abstractions modernized (PostgreSQL + SQLite)
- [x] All tests passing with Agno v2
- [x] Control Plane integration ready
- [x] Production deployment successful

## RASCI Ownership

| Role | Assigned To |
|------|-------------|
| **Responsible** | @rodriguess-caio (caio - implementation) |
| **Accountable** | @vasconceloscezar (owner - final approval) |
| **Support** | Hive team, Agno maintainers |
| **Consulted** | Architecture team |
| **Informed** | All Automagik users, community |

## Implementation

**Primary PR:** namastexlabs/automagik-hive#30 (Merged 2025-10-07)
- +16,190 additions / -4,588 deletions
- 88 execution reports (agent iterations)
- 4 wish files (sub-initiatives)

**Wish Folder:** [projects/hive/wishes/agno-v2-migration/](../../projects/hive/wishes/agno-v2-migration/)

**Sub-Wishes:**
1. Agno v2 Core Migration
2. AgentOS API Configuration
3. Agno-AgentOS Unification
4. Knowledge System Alignment (pgvector)

## Timeline

- **Started:** September 23, 2025
- **Completed:** October 7, 2025
- **Duration:** ~2 weeks
- **Quarter:** Q4 2025

## Metrics

- **Code Changes:** 16,190 additions, 4,588 deletions
- **Files Changed:** 150+ files
- **Agent Iterations:** 88 reports
- **Test Coverage:** Maintained (all tests updated)
- **Breaking Changes:** Documented with migration guides

## Links

- **PR:** https://github.com/namastexlabs/automagik-hive/pull/30
- **Wish Archive:** [projects/hive/wishes/agno-v2-migration/](../../projects/hive/wishes/agno-v2-migration/)
- **Agno v2 Docs:** [Agno Documentation](https://docs.agno.com)

## Status

✅ **Shipped** - Merged and deployed to production

---

**Note:** This is a completed initiative archived for reference. The wish files have been moved from the project repository to this roadmap for historical tracking.
```

---

## Cleanup Strategy in Project Repos

### Option A: Delete Completed Wishes

**After archiving to roadmap:**
```bash
# In automagik-hive
rm genie/wishes/agno-v2-migration-wish.md
rm genie/wishes/agentos-api-configuration-wish.md
rm genie/wishes/agno-agentos-unification-wish.md
rm genie/wishes/knowledge-agno-pgvector-alignment-wish.md

# Keep only ARCHIVED.md stub
```

**Create stub:**
```markdown
# genie/wishes/ARCHIVED.md

The following wishes have been completed and archived to the roadmap repository:

## 2025-10-07
- [Agno v2 Migration](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/hive/wishes/agno-v2-migration) - PR #30
- [AgentOS API Configuration](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/hive/wishes/agentos-api-configuration) - PR #30
- [Agno-AgentOS Unification](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/hive/wishes/agno-agentos-unification) - PR #30
- [Knowledge pgvector Alignment](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/hive/wishes/knowledge-pgvector-alignment) - PR #30
```

**Pros:**
- Clean project repo
- Single source of truth (roadmap)
- Forces proper archival

**Cons:**
- Loses local history
- Requires roadmap to always be accessible

---

### Option B: Mark as Archived (Keep Files)

**Update each wish file:**
```markdown
# Agno v2 Migration Wish

**Status:** ✅ Complete - Archived to Roadmap
**Archive Location:** [automagik-roadmap](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/hive/wishes/agno-v2-migration)
**Roadmap Issue:** automagik-roadmap#XX
**Archived:** 2025-10-07

---

_This wish has been completed and archived to the roadmap repository._
_For the full historical record, see the [archive](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/hive/wishes/agno-v2-migration)._

---

[Original wish content below - kept for local reference]

...
```

**Pros:**
- Keeps local history
- Dual reference (project + roadmap)
- Easier rollback if needed

**Cons:**
- Duplication
- File "pollution" remains
- Can get out of sync

---

**RECOMMENDATION:** Start with Option B (mark as archived), evaluate Option A later if pollution becomes an issue.

---

## The Archive Script (MVP)

```bash
#!/bin/bash
# scripts/archive-wish.sh
# Archives completed wish from project repo to roadmap

set -e

# Usage
USAGE="Usage: $0 <project> <wish-slug> --source-repo <repo> --pr <number> [--owner <user>] [--assignee <user>]"

# Parse arguments
PROJECT=$1
WISH_SLUG=$2
shift 2

while [[ $# -gt 0 ]]; do
  case $1 in
    --source-repo) SOURCE_REPO=$2; shift 2 ;;
    --pr) PR_NUMBER=$2; shift 2 ;;
    --owner) OWNER=$2; shift 2 ;;
    --assignee) ASSIGNEE=$2; shift 2 ;;
    *) echo "Unknown option: $1"; echo "$USAGE"; exit 1 ;;
  esac
done

# Validate
[[ -z "$PROJECT" ]] && { echo "Error: project required"; echo "$USAGE"; exit 1; }
[[ -z "$WISH_SLUG" ]] && { echo "Error: wish-slug required"; echo "$USAGE"; exit 1; }
[[ -z "$SOURCE_REPO" ]] && { echo "Error: --source-repo required"; echo "$USAGE"; exit 1; }

# Set defaults
OWNER=${OWNER:-"unknown"}
ASSIGNEE=${ASSIGNEE:-"unknown"}
PR_NUMBER=${PR_NUMBER:-"N/A"}

# Paths
ROADMAP_ROOT=$(git rev-parse --show-toplevel)
TARGET_DIR="$ROADMAP_ROOT/projects/$PROJECT/wishes/$WISH_SLUG"
TMP_DIR=$(mktemp -d)

echo "=== Archiving Wish ==="
echo "Project: $PROJECT"
echo "Wish: $WISH_SLUG"
echo "Source: $SOURCE_REPO"
echo "PR: #$PR_NUMBER"
echo "Owner: $OWNER"
echo "Assignee: $ASSIGNEE"
echo ""

# Clone source repo
echo "Cloning source repository..."
git clone "https://github.com/$SOURCE_REPO" "$TMP_DIR/source" --depth 1

# Find wish file
WISH_FILE=$(find "$TMP_DIR/source" -name "*$WISH_SLUG*.md" -path "*/genie/wishes/*" | head -1)
[[ -z "$WISH_FILE" ]] && { echo "Error: Wish file not found"; exit 1; }

echo "Found wish file: $WISH_FILE"

# Create target directory
mkdir -p "$TARGET_DIR/reports"
mkdir -p "$TARGET_DIR/qa"

# Copy wish file
cp "$WISH_FILE" "$TARGET_DIR/${WISH_SLUG}-wish.md"
echo "Copied wish file"

# Copy related reports
echo "Copying reports..."
find "$TMP_DIR/source" -path "*/genie/reports/*$WISH_SLUG*.md" -exec cp {} "$TARGET_DIR/reports/" \;
find "$TMP_DIR/source" -path "*/genie/reports/*${WISH_SLUG}*.md" -exec cp {} "$TARGET_DIR/reports/" \;

REPORT_COUNT=$(ls -1 "$TARGET_DIR/reports/" 2>/dev/null | wc -l)
echo "Copied $REPORT_COUNT reports"

# Copy QA if exists
if [ -d "$TMP_DIR/source/genie/wishes/$WISH_SLUG/qa" ]; then
  cp -r "$TMP_DIR/source/genie/wishes/$WISH_SLUG/qa/"* "$TARGET_DIR/qa/"
  echo "Copied QA files"
fi

# Generate ARCHIVE-INFO.md
cat > "$TARGET_DIR/ARCHIVE-INFO.md" <<EOF
# Archive Information

**Archived From:** $SOURCE_REPO
**Original Path:** genie/wishes/${WISH_SLUG}-wish.md
**Archived On:** $(date -u +"%Y-%m-%d")
**Archived By:** @$OWNER

## Source PR
- **PR:** $SOURCE_REPO#$PR_NUMBER
- **Owner:** @$OWNER
- **Assignee:** @$ASSIGNEE

## Roadmap Tracking
- **Roadmap Issue:** (TODO: Add issue number)
- **Initiative:** $PROJECT: $(echo $WISH_SLUG | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
- **Quarter:** $(date +%Y-q$(($(date +%-m-1)/3+1)))

## Files Archived
- Main Wish: ${WISH_SLUG}-wish.md
- Reports: $REPORT_COUNT files
- QA: $(ls -1 "$TARGET_DIR/qa/" 2>/dev/null | wc -l) items

## Links
- [Source PR](https://github.com/$SOURCE_REPO/pull/$PR_NUMBER)
- [Roadmap Initiative](TODO)
- [Wish Folder](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/$PROJECT/wishes/$WISH_SLUG)
EOF

echo "Generated ARCHIVE-INFO.md"

# Commit
git add "$TARGET_DIR"
git commit -m "archive: $PROJECT wish - $WISH_SLUG

Archived completed wish from $SOURCE_REPO#$PR_NUMBER

- Project: $PROJECT
- Wish: $WISH_SLUG
- Reports: $REPORT_COUNT
- Owner: @$OWNER
- Assignee: @$ASSIGNEE

Co-authored-by: Automagik Genie 🧞 <genie@namastex.ai>"

echo ""
echo "=== Archive Complete ==="
echo "Location: projects/$PROJECT/wishes/$WISH_SLUG/"
echo ""
echo "Next steps:"
echo "1. Review the archived files"
echo "2. Create roadmap issue linking to this wish"
echo "3. Update ARCHIVE-INFO.md with issue number"
echo "4. (Optional) Mark wish as archived in source repo"

# Cleanup
rm -rf "$TMP_DIR"
```

---

## Phased Rollout Plan

### Phase 1: Manual MVP (Week 1)
**Goal:** Prove the concept with one example

1. Create `scripts/archive-wish.sh`
2. Test with PR #30 (Hive Agno v2)
3. Create roadmap issue manually
4. Document the process
5. Archive 1-2 more wishes to validate

**Success Criteria:**
- Script works reliably
- Archived wishes are well-structured
- Team understands the workflow

---

### Phase 2: Documentation & Process (Week 2-3)
**Goal:** Establish clear workflow

1. Document in `docs/wish-sync-guide.md`
2. Update wish-template.md with archive instructions
3. Train team on archival process
4. Create checklist for PR completion

**Success Criteria:**
- Any maintainer can archive a wish
- Process is documented
- No questions about "what to do with completed wishes"

---

### Phase 3: Semi-Automation (Month 2)
**Goal:** Add GitHub Actions for easier archiving

1. Create workflow_dispatch action in roadmap
2. Add UI form for archiving
3. Test with 3-5 wishes
4. Gather feedback

**Success Criteria:**
- Can archive from GitHub UI
- No command line needed
- Still manual trigger (controlled)

---

### Phase 4: Full Automation (Month 3+)
**Goal:** Automatic archival on PR merge

1. Add repository_dispatch from project repos
2. Detect completed wishes automatically
3. Auto-create archive PRs in roadmap
4. Monitor and refine

**Success Criteria:**
- Zero manual steps
- Reliable automation
- Clear audit trail

---

## Token & Permission Requirements

### For Manual Script (Phase 1)
- Local git access to both repos
- Write access to roadmap repo
- **No special tokens needed**

### For Semi-Automation (Phase 3)
- GitHub Personal Access Token with `repo` scope
- Store as `GITHUB_TOKEN` secret in roadmap repo
- **Used for:** Cloning source repos

### For Full Automation (Phase 4)
- `ROADMAP_REPO_TOKEN` in each project repo
  - Scope: `repo` (full access to roadmap repo)
  - Created as fine-grained PAT or classic PAT
  - Stored in project repo secrets
- **Used for:** Triggering repository_dispatch

### Security Considerations
- Use fine-grained PATs with minimal scope
- Rotate tokens quarterly
- Limit to specific repositories
- Consider GitHub App for better security

---

## Handling Multiple Wishes in One PR

**Problem:** PR #30 has 4 wishes. How to handle?

**Option 1: Archive All Together**
Create mega-folder:
```
projects/hive/wishes/agno-v2-migration-suite/
  ├── agno-v2-migration-wish.md
  ├── agentos-api-configuration-wish.md
  ├── agno-agentos-unification-wish.md
  ├── knowledge-pgvector-alignment-wish.md
  └── reports/ (all 88 reports)
```

**Option 2: Archive Separately**
```
projects/hive/wishes/agno-v2-migration/
projects/hive/wishes/agentos-api-configuration/
projects/hive/wishes/agno-agentos-unification/
projects/hive/wishes/knowledge-pgvector-alignment/
```

Each references the same PR #30.

**Option 3: Main + Sub-wishes**
```
projects/hive/wishes/agno-v2-migration/  (main)
  ├── agno-v2-migration-wish.md
  ├── sub-wishes/
  │   ├── agentos-api-configuration-wish.md
  │   ├── agno-agentos-unification-wish.md
  │   └── knowledge-pgvector-alignment-wish.md
  └── reports/
```

**RECOMMENDATION:** Option 3 (Main + Sub-wishes) for large PRs. Shows hierarchy.

---

## Summary: What We Need

### Immediate (This Week)
1. ✅ Create `scripts/archive-wish.sh`
2. ✅ Test with PR #30 example
3. ✅ Create roadmap issue for Hive Agno v2
4. ✅ Document the workflow

### Short-term (Next 2 Weeks)
5. Create `docs/wish-sync-guide.md`
6. Archive 3-5 more completed wishes
7. Refine script based on learnings

### Medium-term (Month 2)
8. GitHub Action for UI-based archiving
9. Team training on process

### Long-term (Month 3+)
10. Full automation with repository_dispatch
11. Automatic cleanup in source repos

---

## Next Actions

**For PR #30 Specifically:**
1. Run: `./scripts/archive-wish.sh hive agno-v2-migration --source-repo namastexlabs/automagik-hive --pr 30 --owner vasconceloscezar --assignee rodriguess-caio`
2. Create roadmap issue using template above
3. Link issue to wish folder
4. Update ARCHIVE-INFO.md with issue number
5. Use as reference example

---

**Status:** Ready to implement Phase 1 (manual script)
