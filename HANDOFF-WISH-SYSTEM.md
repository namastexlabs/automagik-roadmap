# 🔄 Handoff: Wish System Initiative

**Date:** 2025-10-10
**Initiative:** #29 - Wish Sync & Genie Update - Unified Workflow System
**Status:** Executing
**Current Sub-Issues:** 4 created (genie#27-30)

---

## 🎯 What This Initiative Does

**Goal:** Automate the lifecycle of "wishes" (AI-assisted development artifacts) across all 6 Automagik repos, eliminating manual archival and ensuring unified Genie tooling.

**Two Main Parts:**
1. **Wish Archival System:** Automatically move completed wishes from project repos to roadmap archive on PR merge
2. **Genie Updates:** Update all 6 repos to latest Genie version for consistent AI-assisted workflows

**Why It Matters:**
- 90+ wishes currently polluting project repos (88 in hive alone)
- Fragmented Genie versions create cross-project friction
- No automated link between roadmap initiatives and implementation PRs
- Historical context lost when wishes accumulate

---

## 📋 Issue Template Pattern

All sub-issues for initiative #29 follow this standardized template:

```markdown
### 🔗 Roadmap Initiative: [#29](https://github.com/namastexlabs/automagik-roadmap/issues/29)

### 📋 Work Type: `Feature Implementation`

### 📄 Description
[Clear description of what needs to be done]

[Optional: Technical scope breakdown with bullet points or subsections]

### ✅ Acceptance Criteria

[Grouped checklist items with clear headers]

**Category 1:**
- [ ] Specific actionable item
- [ ] Another specific item

**Category 2:**
- [ ] More items grouped logically

### 🔍 Context / Evidence
[Background information, links to related work, references]

Related work:
- Previous issues
- Workflow files
- Documentation

### 🧩 Dependencies

**Depends On:**
- [issue reference] - Reason why

**Blocks:**
- [issue reference] - What can't proceed without this

### 📊 Estimated Complexity
[XS/S/M/L/XL with time estimate]

### ⚡ Priority Override (Optional)
[Critical/High/Medium/Low]

### 🏷️ Component / Area (Optional)
- Relevant areas checked

### 🔗 Related Wish (Optional)
[Path to wish document if applicable]

### 👤 Suggested Assignee (Optional)
[@username or N/A]
```

### Key Template Characteristics

1. **Initiative Link First:** Always starts with link to parent initiative (#29)
2. **Grouped Acceptance Criteria:** Multiple categories with descriptive headers, not flat list
3. **Epic-Style Scope:** Issues group related work (not atomic tasks)
4. **Clear Dependencies:** Explicit "Depends On" and "Blocks" sections
5. **Context Rich:** Links to related issues, workflows, and documentation
6. **Component Areas:** Optional but helps with filtering in project board

---

## 🏗️ Current Structure

### Existing Sub-Issues (in genie repo)

**genie#27 - Repository infrastructure for wish system**
- **Scope:** Labels, templates, repo settings, GitHub Actions
- **Covers:** All repository-level setup needed for automation
- **Status:** Open, Executing
- **Acceptance Criteria Groups:** Labels, Templates, Repository Settings, Workflows

**genie#28 - Genie core updates for automated issue/PR workflows**
- **Scope:** Update Genie CLI/agents to use templates, integrate with automation
- **Covers:** Core code changes to Genie itself
- **Status:** Open, Executing
- **Acceptance Criteria Groups:** Core Updates, Issue Generation, Validation & Testing, Documentation

**genie#29 - Wish management and archival pipeline**
- **Scope:** Normalize wishes, build pipeline, deploy to all repos, cleanup
- **Covers:** End-to-end wish lifecycle management
- **Status:** Open, Executing
- **Acceptance Criteria Groups:** Wish Review & Normalization, Archival Pipeline, Cleanup System, Cross-Repo Deployment, Success Metrics

**genie#30 - TEST: Workflow parsing validation**
- **Scope:** Testing issue to validate workflows work correctly
- **Status:** Open, Executing

### Roadmap Initiative

**roadmap#29 - Wish Sync & Genie Update - Unified Workflow System**
- **Type:** Cross-Project Initiative
- **Stage:** Executing (just updated from Prioritization)
- **Timeline:** 8 weeks
- **Sub-Issues:** 4 (all in genie repo for now)
- **Labels:** `project:cross-project`, `type:infrastructure`, `area:workflows`, `priority:high`, `initiative`, `Prioritization`, `area:automation`

---

## 🔗 Integration with Cross-Repo Linking

This initiative builds on the recently completed cross-repo linking system:

**What We Have:**
- GitHub App authentication (PROJECT_APP_ID, PROJECT_APP_PRIVATE_KEY in all repos)
- Workflow: `.github/workflows/link-to-roadmap.yml` in omni and genie
- Templates: `planned-feature.yml`, `bug-report.yml`, `feature-request.yml`
- Labels: Unified 53-label taxonomy
- Project Board: Auto-adds issues and populates fields (Stage, Status, Project)

**What Wish System Adds:**
- Wish-specific labels (`wish:archived`, `wish:active`, `wish:implementation`)
- Wish metadata in templates (document path, implementation status)
- Automated archival workflow triggered on PR merge
- Wish cleanup workflow for removing archived wishes
- Cross-repo wish sync to roadmap `wishes/{project}/{quarter}/` structure

**Integration Points:**
- Wishes link to initiatives (same as current planned-feature flow)
- Wishes auto-archive on PR merge (new workflow)
- Archived wishes maintain full metadata (PR URL, completion date, initiative link)
- Genie generates issues using templates (extends current manual flow)

---

## 📝 Next Steps

### Immediate Tasks

1. **Review Existing Issues (#27-29)**
   - Ensure acceptance criteria comprehensive
   - Prioritize within each epic
   - Assign owners if needed

2. **Create Additional Sub-Issues if Needed**
   - Follow template pattern above
   - Keep scope epic-sized (not atomic)
   - Always link to initiative #29
   - Use consistent grouping for acceptance criteria

3. **Start Implementation**
   - Begin with #27 (infrastructure) as foundation
   - Then #28 (Genie core) for tooling
   - Finally #29 (pipeline) for automation

### Epic Breakdown Approach

**When to create new issues:**
- Group of related work requiring >3 days
- Clear dependencies on other epics
- Distinct component/area of codebase
- Natural team ownership boundary

**When to add to existing issue:**
- Small task related to existing epic
- Part of same workflow/component
- Depends on same prerequisites
- Same owner/team

---

## 🔄 Workflow Pattern

### For Each Wish System Issue

1. **Create issue in appropriate repo:**
   - Infrastructure/automation → genie repo
   - Deployment to specific project → that project's repo
   - Cross-project coordination → roadmap repo

2. **Use planned-feature template**
   - Initiative number: `29`
   - Work type: Usually "Feature Implementation"
   - Fill all sections per template above

3. **Workflow automatically:**
   - Links to initiative #29 as sub-issue
   - Adds labels: `roadmap-linked`, `initiative-29`
   - Adds to project board #9
   - Sets Stage: "Executing", Status: "Todo", Project: repo name

4. **Manual steps:**
   - Set milestone: "Event Fabric Foundation" (or create wish-specific milestone)
   - Assign owner if known
   - Add component/area labels manually if needed

---

## 📊 Success Criteria

### Initiative #29 Complete When:

**Wish Archival System:**
- ✅ All 6 repos have wish-archival workflow deployed
- ✅ Wishes automatically archive on PR merge (<2min latency)
- ✅ Metadata preserved (PR URL, completion date, initiative link)
- ✅ Roadmap `wishes/` folder organized by project and quarter
- ✅ Zero manual archival work for 20+ consecutive syncs

**Genie Updates:**
- ✅ All 6 repos running same Genie version
- ✅ Unified `.ai/` folder structure everywhere
- ✅ Genie generates issues using proper templates
- ✅ Genie integrates with roadmap linking workflows
- ✅ Team trained on unified Genie workflow

**Cross-Cutting:**
- ✅ 90+ historical wishes archived and organized
- ✅ Complete documentation and runbooks
- ✅ Dashboard showing completion metrics
- ✅ All tests passing across repos

---

## 🗂️ Repository Structure

### Where Wishes Go

**Before (scattered):**
```
automagik-hive/.ai/wishes/
  ├── old-wish-1.md (88+ files here)
  └── old-wish-2.md

automagik-omni/.ai/wishes/
  ├── some-wish.md
  └── another-wish.md

[... same for spark, forge, tools, genie]
```

**After (centralized):**
```
automagik-roadmap/wishes/
  ├── hive/
  │   ├── 2025-q4/
  │   │   ├── wish-1.md (with metadata)
  │   │   └── wish-2.md
  │   └── 2026-q1/
  ├── omni/
  │   └── 2025-q4/
  ├── spark/
  ├── forge/
  ├── tools/
  └── genie/
```

### Wish Metadata Format

Each archived wish enhanced with frontmatter:
```yaml
---
original_repo: automagik-hive
original_path: .ai/wishes/example-wish.md
initiative_number: 32
pr_url: https://github.com/namastexlabs/automagik-hive/pull/45
completed_at: 2025-10-15T10:30:00Z
archived_at: 2025-10-15T10:32:15Z
quarter: 2025-Q4
---

[Original wish content here]
```

---

## 🔧 Technical Details

### Workflows to Build

**1. wish-archive.yml** (runs on PR merge)
```yaml
trigger: pull_request (closed + merged)
steps:
  - Extract wishes from PR diff
  - Enrich with metadata
  - Transfer to roadmap repo
  - Update manifest
  - Trigger cleanup
```

**2. wish-cleanup.yml** (runs after archival)
```yaml
trigger: workflow_dispatch or webhook from roadmap
steps:
  - Verify wish archived in roadmap
  - Remove from source repo
  - Commit cleanup
  - Validate git history preserved
```

**3. wish-dashboard.yml** (runs nightly)
```yaml
trigger: schedule (cron: 0 2 * * *)
steps:
  - Scan all archived wishes
  - Calculate metrics (completion velocity, time-to-implement)
  - Update README with stats
  - Generate per-project dashboards
```

### GitHub App Permissions Needed

Already configured in all 6 repos:
- `contents: write` - For creating commits in roadmap
- `issues: write` - For linking issues
- `pull_requests: read` - For extracting wishes from PRs

### API Rate Limits

- GitHub GraphQL: 5000 points/hour
- Archival mutation: ~50 points per wish
- Safe limit: ~90 wishes/hour
- Batch processing: Group by project, process sequentially

---

## 📖 References

**Related Documentation:**
- Cross-repo linking: `/home/cezar/automagik/automagik-roadmap/HANDOFF.md` (completed system)
- Label taxonomy: `docs/project-label-guide.md`
- Template design: `docs/templates/issue-templates/README.md`
- Workflow foundation: `.github/workflows/link-to-roadmap.yml`

**Existing Issues:**
- Initiative: roadmap#29
- Infrastructure: genie#27
- Core updates: genie#28
- Pipeline: genie#29
- Test: genie#30

**Example Sub-Issues from Other Initiatives:**
- omni#29-32 (Event Fabric Foundation phases)
- genie#18 (Test roadmap linking)

---

## 🎨 Template Usage Examples

### Example 1: Adding Repo-Specific Infrastructure Issue

If you need to add wish system to omni repo specifically:

```markdown
### 🔗 Roadmap Initiative: [#29](https://github.com/namastexlabs/automagik-roadmap/issues/29)

### 📋 Work Type: `Feature Implementation`

### 📄 Description
Deploy wish system infrastructure to automagik-omni repository. Install workflows, configure labels, set up templates for omni-specific wish management.

[... rest of template]
```

### Example 2: Adding Documentation Task

If documentation is substantial enough to warrant its own issue:

```markdown
### 🔗 Roadmap Initiative: [#29](https://github.com/namastexlabs/automagik-roadmap/issues/29)

### 📋 Work Type: `Documentation`

### 📄 Description
Create comprehensive documentation for wish system including user guides, developer documentation, troubleshooting guides, and architectural decisions.

[... rest of template]
```

---

## 📈 Implementation Progress

### Completed (2025-10-10)

**genie#27 - Repository Infrastructure** 🔄 In Progress

**Labels:** ✅ Complete (commit 1e5236b)
- Added wish workflow labels: `wish:active`, `wish:archived`, `wish:implementation`
- Labels synced via `.github/labels.yml`
- Documented label usage in taxonomy

**Templates:** ✅ Complete (commit 1e5236b)
- Enhanced `planned-feature.yml` with wish status dropdown
- Added wish workflow state tracking (Active/Implementation/Ready for archive)
- Maintained existing wish path field for documentation linking

**Repository Settings:** ✅ Complete (commit 1e5236b)
- Set `blank_issues_enabled: false` in config.yml
- Forced use of structured templates
- Updated contact links for support

**Workflows:** 🔄 Design Phase (commit e404333 - removed premature implementation)
- Workflows need more design consideration before implementation
- Initial workflow specs documented in HANDOFF Technical Details section
- Key design questions to resolve:
  - Wish extraction logic (file detection, metadata parsing)
  - Quarter calculation and project structure
  - Verification strategy before cleanup
  - Error handling and rollback mechanisms
  - Testing approach for cross-repo operations

**Integration Status:**
- ✅ GitHub App authentication available (PROJECT_APP_ID/KEY)
- ✅ Cross-repo linking pattern established from HANDOFF.md
- ⏳ Workflow implementation pending design completion
- ⏳ Testing strategy to be defined

### Next Steps

**Immediate (Week 1):**
1. **Complete genie#27 - Workflow Design**
   - Resolve design questions for wish-archive workflow
   - Define wish extraction strategy (file detection, metadata)
   - Design verification logic for cleanup safety
   - Document error handling approach
   - Create testing plan for cross-repo operations

2. **Begin genie#28 - Genie Core Updates**
   - Update Genie to use GitHub issue form API
   - Implement template field population logic
   - Add automatic initiative linking support
   - Enable Genie to work with new wish workflow labels

3. **Prepare genie#29 - Pipeline Implementation**
   - Review current wish structure across all repos
   - Audit 90+ existing wishes for normalization needs
   - Plan historical archival strategy

**Week 2-3:**
- Implement wish-archive and wish-cleanup workflows (after design complete)
- Test workflows in genie repo first (dogfooding)
- Deploy to remaining repos (omni, hive, spark, forge, tools)
- Execute historical wish archival

---

## ✅ Handoff Complete

**What's Ready:**
- Initiative #29 status: Executing
- 4 sub-issues created and linked (genie#27-30)
- Template pattern documented
- Integration points clear
- **genie#27 foundation complete (labels, templates, repo settings)**

**What's In Progress:**
- Workflow design for wish-archive and wish-cleanup
- Need to resolve key design questions before implementation

**What's Needed:**
- Complete workflow design and implementation (genie#27)
- Begin implementation of genie#28 (Genie core updates)
- Prepare for genie#29 (pipeline and historical archival)

**Questions?**
- Template unclear? See examples in genie#27-29
- Need more issues? Follow pattern above
- Integration questions? Reference HANDOFF.md for cross-repo linking
- Implementation status? See Implementation Progress section above
