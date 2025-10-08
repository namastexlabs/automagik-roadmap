## Project
cross-project

## Description

**Problem:**

Currently, completed wish files accumulate in project repositories (e.g., `automagik-hive/genie/wishes/`) after PRs are merged, causing:
- **Repository pollution** - Old wish files and reports clutter active development repos
- **Lost context** - Completed work isn't tracked in the roadmap repository
- **Missing links** - No connection between strategic roadmap initiatives and actual implementation PRs
- **No archival process** - Team doesn't know what to do with completed wishes

**Example:** PR #30 in automagik-hive (Agno v2 Migration) has 4 wishes + 88 agent reports. This represents a major strategic initiative but isn't tracked in the roadmap.

**Solution:**

Implement a systematic workflow for archiving completed wishes from project repositories to the roadmap repository:

1. **Active Development (Project Repo)** - Wishes live in project repos during active work
2. **Archive & Link (Roadmap Repo)** - Upon PR merge, wish files are moved to roadmap with full metadata
3. **Cleanup (Project Repo)** - Archived wishes are marked/removed from project repos

**Phased Implementation:**
- **Phase 1 (Week 1):** Manual script (`scripts/archive-wish.sh`) with helper commands
- **Phase 2 (Month 1):** GitHub Actions with UI-based triggering
- **Phase 3 (Month 2+):** Full automation with repository_dispatch events

**Impact:**

- **Maintainers:** Clear process for handling completed work
- **Team:** Easy reference to historical implementation details
- **Community:** Transparent view of what's been built
- **Roadmap:** Becomes single source of truth for all initiatives

## Expected Results (RESULTADO_ESPERADO)

- [ ] Archive script (`scripts/archive-wish.sh`) created and tested with at least 3 wishes
- [ ] Wish lifecycle documented in `docs/wish-sync-guide.md` with step-by-step instructions
- [ ] First example archived: Hive Agno v2 Migration (PR #30) → roadmap issue created
- [ ] Archive structure standardized: wish files + reports + QA + ARCHIVE-INFO.md metadata
- [ ] Team trained on archival process - any maintainer can archive a wish
- [ ] GitHub Actions workflow for UI-based archiving (Phase 2)
- [ ] 10+ completed wishes archived from all projects within first month
- [ ] Zero confusion about "what to do with completed wishes"

## Success Criteria

**Phase 1 - Manual Process (Week 1):**
- [ ] `scripts/archive-wish.sh` working reliably
- [ ] Successfully archived 1 wish (PR #30 example) with:
  - Wish files copied to `projects/hive/wishes/agno-v2-migration/`
  - All reports (88 files) organized in archive
  - ARCHIVE-INFO.md generated with complete metadata
  - Roadmap issue created and linked
- [ ] Documentation complete in `docs/wish-sync-guide.md`
- [ ] Process validated with 2 more wishes from different projects

**Phase 2 - Semi-Automation (Month 1):**
- [ ] GitHub Actions workflow in `.github/workflows/archive-wish.yml`
- [ ] UI form working (workflow_dispatch with inputs)
- [ ] Creates PR in roadmap for review
- [ ] Team can archive without command line

**Phase 3 - Full Automation (Month 2+):**
- [ ] repository_dispatch integration from project repos
- [ ] Automatic detection of completed wishes (parse "Status: ✅ Complete")
- [ ] Auto-archival on PR merge (with review step)

**Quality Gates:**
- [ ] Archived wishes maintain full context and history
- [ ] Links work bidirectionally (roadmap ↔ PR ↔ archive)
- [ ] No data loss during archival
- [ ] Process takes < 5 minutes per wish

## RASCI Ownership

| Role | Assigned To |
|------|-------------|
| **Responsible** | @vasconceloscezar (implementation and rollout) |
| **Accountable** | @vasconceloscezar (decision maker and process owner) |
| **Support** | All project maintainers (testing and feedback) |
| **Consulted** | Hive, Omni, Spark, Forge, Tools, Genie leads (process design) |
| **Informed** | All developers, community (new archival workflow) |

## Implementation Plan

### Phase 1: Manual Script (Week 1) - IMMEDIATE

**Goal:** Prove the concept with working script

**Tasks:**
1. Create `scripts/archive-wish.sh` with features:
   - Clone source repo (or use local path)
   - Find wish file by slug in `genie/wishes/`
   - Find related reports in `genie/reports/` (pattern matching)
   - Create target folder: `projects/{project}/wishes/{slug}/`
   - Copy wish + reports + QA files
   - Generate `ARCHIVE-INFO.md` with metadata
   - Commit to roadmap repo
   - Output roadmap issue template

2. Create `docs/wish-sync-guide.md`:
   - Complete process documentation
   - Step-by-step instructions for any developer
   - Examples and troubleshooting
   - Lifecycle diagram
   - Cleanup options (delete vs mark as archived)

3. Test with PR #30 (Hive Agno v2):
   ```bash
   ./scripts/archive-wish.sh hive agno-v2-migration \
     --source-repo namastexlabs/automagik-hive \
     --pr 30 \
     --owner vasconceloscezar \
     --assignee rodriguess-caio
   ```

4. Create roadmap issue for archived wish:
   - Use existing `scripts/create-initiative.sh`
   - Link to archived wish folder
   - Link to source PR
   - Mark as Shipped (already completed)

5. Validate with 2 more archives from different projects

**Deliverables:**
- ✅ `scripts/archive-wish.sh` (tested and working)
- ✅ `docs/wish-sync-guide.md` (complete documentation)
- ✅ 3 archived wishes in roadmap
- ✅ 3 corresponding roadmap issues

### Phase 2: Semi-Automation (Month 1)

**Goal:** GitHub Actions for easier access

**Tasks:**
1. Create `.github/workflows/archive-wish.yml`:
   - workflow_dispatch trigger with form inputs
   - Run archive script with parameters
   - Create PR in roadmap for review
   - Auto-add labels and metadata

2. Form inputs:
   - Project (dropdown)
   - Wish slug (text)
   - Source repo (text)
   - PR number (number)
   - Owner (text, default: current user)
   - Assignee (text, optional)

3. Test with team (3-5 wishes)
4. Gather feedback and iterate

**Deliverables:**
- ✅ `.github/workflows/archive-wish.yml`
- ✅ Tested by 3+ team members
- ✅ Documentation updated with UI process

### Phase 3: Full Automation (Month 2+)

**Goal:** Automatic archival on PR merge

**Tasks:**
1. Add action to each project repo:
   - `.github/workflows/notify-roadmap.yml`
   - Triggers on PR merge to main/dev
   - Scans for completed wishes (Status: ✅ Complete)
   - Sends repository_dispatch to roadmap

2. Update roadmap action to receive events:
   - Listen for archive-wish event type
   - Extract payload (project, slug, PR, etc.)
   - Run archive script automatically
   - Create PR for manual review (or auto-merge)

3. Create `ROADMAP_REPO_TOKEN` in each project:
   - Fine-grained PAT with repo write access
   - Scoped to automagik-roadmap only
   - Rotated quarterly

4. Monitor and refine automation

**Deliverables:**
- ✅ Automation in 6 project repos
- ✅ Tested with 5+ automatic archives
- ✅ Security review of tokens
- ✅ Monitoring and error handling

## Technical Details

### Archive Structure

```
projects/{project}/wishes/{slug}/
├── {slug}-wish.md              # Main wish (copied from project)
├── ARCHIVE-INFO.md             # Metadata and links
├── qa/                         # Evidence files (if exists)
│   ├── test-results.json
│   └── screenshots/
└── reports/                    # All execution reports
    ├── forge-plan-*.md
    ├── hive-coder-*.md
    ├── hive-reviewer-*.md
    └── hive-tests-*.md
```

### ARCHIVE-INFO.md Template

Contains:
- Source repository and original path
- Archive date and archived by
- Source PR details (number, title, author, owner, assignee)
- Roadmap tracking (issue number, quarter, priority)
- Files archived (count and list)
- Related wishes (if multiple in one PR)
- All links (PR, roadmap issue, archive folder)

### Detection Strategies

**Method 1:** Parse wish file status (RECOMMENDED)
```markdown
**Status:** ✅ Complete
```
Script: `grep -l "Status.*✅ Complete" genie/wishes/*.md`

**Method 2:** Commit message convention
```
feat: complete feature X

WISH-COMPLETE: feature-x-slug
```

**Method 3:** PR labels (`wish:complete`)

**Method 4:** Git tags (`wish-{slug}-complete`)

### Script Usage

```bash
# Basic usage
./scripts/archive-wish.sh <project> <wish-slug> \
  --source-repo <org/repo> \
  --pr <number> \
  [--owner <user>] \
  [--assignee <user>]

# Example
./scripts/archive-wish.sh hive agno-v2-migration \
  --source-repo namastexlabs/automagik-hive \
  --pr 30 \
  --owner vasconceloscezar \
  --assignee rodriguess-caio

# From local repo (skip cloning)
./scripts/archive-wish.sh hive my-feature \
  --source-path ../automagik-hive \
  --pr 45
```

## Handling Edge Cases

### Multiple Wishes in One PR

**Example:** PR #30 has 4 wishes

**Solution:** Parent/child structure
```
projects/hive/wishes/agno-v2-migration/  (main)
├── agno-v2-migration-wish.md
├── sub-wishes/
│   ├── agentos-api-configuration-wish.md
│   ├── agno-agentos-unification-wish.md
│   └── knowledge-pgvector-alignment-wish.md
└── reports/ (all 88 reports shared)
```

### Large Report Counts

**Example:** 88 reports in PR #30

**Solution:**
- Organize by agent: `reports/hive-coder/`, `reports/hive-reviewer/`, `reports/hive-tests/`
- Keep naming pattern: `{agent}-{slug}-{timestamp}.md`
- Create `reports/README.md` with summary

### Wish Without Reports

Some wishes may not use agent execution.

**Solution:**
- Archive just the wish file
- Note in ARCHIVE-INFO.md: "No reports (manual implementation)"

### Cleanup in Source Repo

**Option A:** Delete archived wishes (recommended for active repos)
**Option B:** Mark as archived with stub pointing to roadmap

Documented in guide, team chooses per project.

## Metrics & Success Tracking

### KPIs

- **Adoption:** % of completed PRs with wishes properly archived
- **Speed:** Average time from PR merge to archive (target: < 1 day)
- **Quality:** % of archives with complete metadata (target: 100%)
- **Usage:** Number of archived wishes referenced in discussions
- **Automation:** % of archives using Actions vs manual (Phase 2+)

### Milestone Goals

- **Week 1:** 3 wishes archived (manual)
- **Week 2:** 10 wishes archived, guide complete
- **Month 1:** 20 wishes archived, Actions deployed
- **Month 2:** 30 wishes archived, automation live
- **Quarter 1:** 50+ wishes archived, process fully adopted

## Related Documentation

- **Strategy Doc:** [WISH-SYNC-STRATEGY.md](../WISH-SYNC-STRATEGY.md) - Full strategic analysis
- **Wish Template:** [docs/wish-template.md](../docs/wish-template.md) - How wishes are structured
- **Stage Definitions:** [docs/stage-definitions.md](../docs/stage-definitions.md) - Lifecycle stages
- **RASCI Guide:** [docs/rasci-guide.md](../docs/rasci-guide.md) - Ownership model

## References

### Example PR to Archive First
- **PR:** namastexlabs/automagik-hive#30
- **Title:** Agno v2 Migration & AgentOS Integration
- **Author:** @rodriguess-caio
- **Owner:** @vasconceloscezar
- **Status:** Merged (2025-10-07)
- **Size:** +16,190 / -4,588 lines
- **Wishes:** 4 wish files
- **Reports:** 88 agent execution reports

### Wish Locations in Project Repos
- **Hive:** `automagik-hive/genie/wishes/`
- **Omni:** `automagik-omni/genie/wishes/` (to be created)
- **Spark:** `automagik-spark/genie/wishes/` (to be created)
- **Forge:** `automagik-forge/genie/wishes/` (to be created)
- **Tools:** `automagik-tools/genie/wishes/` (to be created)
- **Genie:** `automagik-genie/genie/wishes/` (to be created)

### Cross-Repo Integration Points
- Each project repo needs `.github/workflows/notify-roadmap.yml` (Phase 3)
- Roadmap repo needs `ROADMAP_REPO_TOKEN` access granted
- Fine-grained PAT scoped to roadmap only

## Security Considerations

### Token Management
- Use fine-grained PATs (not classic)
- Scope: `repo` write access to automagik-roadmap only
- Rotate quarterly
- Store in project secrets (not hardcoded)
- Audit token usage monthly

### Access Control
- Only maintainers should run archive script
- Automated archives create PRs (require approval)
- Roadmap repo remains single source of truth

## Questions & Decisions Needed

**Before Starting Phase 1:**
- [ ] Should we delete or mark archived wishes in source repos? (Decision: Document both, let teams choose)
- [ ] What file naming pattern for multi-wish PRs? (Decision: Parent/child structure)
- [ ] Who can trigger archives? (Decision: Any maintainer, document in guide)

**Before Phase 2:**
- [ ] Auto-merge archive PRs or always require review? (Decision: TBD with team)
- [ ] Which repos adopt automation first? (Decision: Hive first as pilot)

**Before Phase 3:**
- [ ] Token rotation schedule? (Decision: Quarterly)
- [ ] Error handling for failed archives? (Decision: Notify in Discord + issue)

## Rollout Checklist

### Week 1 (Immediate)
- [ ] Create `scripts/archive-wish.sh`
- [ ] Archive PR #30 (Hive Agno v2) as test case
- [ ] Create roadmap issue for archived wish
- [ ] Document full process in `docs/wish-sync-guide.md`
- [ ] Archive 2 more wishes (different projects)
- [ ] Team demo/training

### Month 1
- [ ] Create GitHub Actions workflow
- [ ] Test with 5+ team members
- [ ] Refine based on feedback
- [ ] Archive 20 total wishes
- [ ] Update documentation

### Month 2
- [ ] Design automation flow
- [ ] Implement repository_dispatch
- [ ] Test with 3 projects
- [ ] Security review
- [ ] Full rollout

### Ongoing
- [ ] Monitor adoption metrics
- [ ] Collect feedback
- [ ] Iterate on process
- [ ] Quarterly token rotation
- [ ] Monthly archive audit

---

**Note:** This is a meta-initiative about managing initiatives. It establishes the critical workflow for connecting strategic roadmap planning with actual implementation work.
