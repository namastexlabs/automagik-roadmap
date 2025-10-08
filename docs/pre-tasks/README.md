# Pre-Tasks - Strategic Task Aggregation

**Purpose:** Extracted tasks from 5w2h documentation, organized with strategic aggregation for roadmap planning.

**Date:** 2025-10-07
**Status:** 🧠 Team Review Required

---

## What's in This Folder?

This folder contains **208 extracted tasks** from the repos-5w2h documentation, organized by project and **grouped into strategic themes** for roadmap initiative planning.

### Files Structure

```
docs/pre-tasks/
├── README.md (this file)
├── omni.md          # 60 tasks → ~12 strategic initiatives
├── hive.md          # 45 tasks → ~10 strategic initiatives
├── spark.md         # 35 tasks → ~8 strategic initiatives
├── forge.md         # 4 tasks → ~3 strategic initiatives
├── tools.md         # 42 tasks → ~10 strategic initiatives
├── genie.md         # 22 tasks → ~6 strategic initiatives (preliminary)
└── cross-project.md # Cross-cutting initiatives
```

---

## How to Use These Files

### Step 1: Team Review (Before Creating Issues)
Each file contains:
- **Strategic Themes** - Aggregated groups of related tasks
- **Initiative Proposals** - Suggested roadmap initiatives
- **Implementation Tasks** - What goes in project repos
- **Priority & Quarter** - Recommended timeline

**Action:** Review with your team, validate aggregation, adjust priorities

### Step 2: Create Roadmap Initiatives
For each **approved strategic initiative**:
1. Create issue in `automagik-roadmap` using initiative template
2. Populate all fields (project, stage, priority, quarter, RASCI)
3. Link to wish if complex (needs detailed spec)

### Step 3: Create Project Issues (As Needed)
For each **implementation task**:
1. Create issue in project repository (e.g., `automagik-omni`)
2. Link back to roadmap initiative
3. Assign to developers when ready to execute

---

## The Aggregation Strategy

**Key Principle:** Roadmap = Strategic initiatives, not task list

### What Goes in Roadmap?
✅ **Strategic Initiatives** (2-3 months work)
- Multi-platform messaging expansion
- Agent swarm orchestration
- MCP marketplace platform

### What Goes in Project Repos?
✅ **Implementation Tasks** (days/weeks work)
- Slack API client implementation
- Add webhook handler
- Create MCP tool interface

### Decision Framework
Ask these questions:
1. **Duration:** > 4 weeks? → Roadmap
2. **Impact:** Affects 2+ projects? → Roadmap
3. **Visibility:** Stakeholders care? → Roadmap
4. **Abstraction:** Epic/theme level? → Roadmap

---

## File Format

Each project file follows this structure:

```markdown
# {Project} - Strategic Task Aggregation

## Summary
- Total Tasks Extracted: X
- Strategic Initiatives: Y
- Recommended for Q4 2025: Z

---

## Strategic Initiative 1: {Theme Name}

**Aggregates Tasks:** #1, #5, #8, #12
**Roadmap Initiative:** {Project}: {Initiative Name}

### Proposed Roadmap Issue
- **Description:** Clear value proposition
- **Expected Results:** Measurable outcomes
- **Priority:** Critical/High/Medium/Low
- **Quarter:** 2025-Q4 / 2026-Q1 / etc.
- **Stage:** Wishlist/Exploring/etc.
- **Type:** feature/infrastructure/etc.
- **Areas:** [area labels]
- **Wish Needed:** Yes/No

### Implementation Tasks (Project Repo)
- [ ] Task 1 description
- [ ] Task 2 description
- [ ] Task 3 description

### Notes
Additional context, dependencies, considerations

---

(Repeat for each strategic initiative)
```

---

## Current Status by Project

| Project | Tasks | Strategic Initiatives | Q4 2025 Priority | Status |
|---------|-------|----------------------|------------------|--------|
| Omni | 60 | ~12 | 3 initiatives | ✅ Aggregated |
| Hive | 45 | ~10 | 2 initiatives | ✅ Aggregated |
| Spark | 35 | ~8 | 2 initiatives | ✅ Aggregated |
| Forge | 4 | ~3 | 2 initiatives | ✅ Aggregated |
| Tools | 42 | ~10 | 2 initiatives | ✅ Aggregated |
| Genie | 22 | ~6 | 2 initiatives | ⚠️ Preliminary |

**Total:** 208 tasks → ~50 strategic initiatives → ~15 for Q4 2025

---

## Next Steps

### This Week: Team Review
- [ ] Review each project's strategic aggregation
- [ ] Validate initiative groupings
- [ ] Adjust priorities and quarters
- [ ] Assign preliminary RASCI

### Next Week: Create Initiatives
- [ ] Create Q4 2025 roadmap issues (8-10 initiatives)
- [ ] Create wishes for complex initiatives (3-5 wishes)
- [ ] Populate Q1-Q2 2026 backlog (lighter detail)

### Ongoing: Refinement
- [ ] Move tasks between themes as needed
- [ ] Add new tasks from discussions
- [ ] Remove/merge duplicate initiatives
- [ ] Update as 5w2h docs evolve

---

## Important Notes

### ⚠️ Genie Status
Genie tasks are **preliminary** - based on repo description only.
- **Action Required:** Complete Genie 5w2h documentation
- **Timeline:** Within 2 weeks
- **Then:** Re-aggregate Genie tasks with full context

### 📊 Forge Review Needed
Only 4 tasks extracted for Forge despite substantial source content.
- **Action Required:** Validate with Forge lead
- **Question:** Are these truly high-level epics, or did we miss tasks?

### 🔗 Cross-Project Opportunities
Several initiatives span multiple projects:
- Unified Authentication (all projects)
- MCP Tool Sharing Protocol (Omni, Hive, Genie, Tools)
- Agent Deployment Pipeline (Genie → Hive)

See `cross-project.md` for details.

---

## Related Documentation

- [Task Hierarchy Strategy](../TASK-HIERARCHY-STRATEGY.md) - Strategic thinking behind aggregation
- [Integration Plan](../INTEGRATION-PLAN.md) - Original detailed integration plan
- [Review Findings](../REVIEW-FINDINGS.md) - Comprehensive review results
- [Wish Template](wish-template.md) - How to create detailed specs

---

**Remember:** This is a living document. Update as you review with your team and refine the strategy.

---

*Last updated: 2025-10-07*
