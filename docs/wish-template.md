# 🌟 Wish Template

How to structure detailed technical initiatives using the Automagik wish pattern.

---

## What is a Wish?

A **wish** is a detailed technical specification for an initiative that lives in a folder structure alongside your roadmap. It's inspired by the [automagik-genie](https://github.com/namastexlabs/automagik-genie) pattern.

**Think of it as:**
- 📋 Living blueprint that evolves during implementation
- 📦 Self-contained folder with all context and evidence
- 🔄 Append-only execution log (reports never change)
- ✅ Verification plan with clear success criteria

---

## When to Use Wishes

### ✅ Use Wishes For:
- Complex features requiring detailed specs
- Initiatives with multiple execution phases
- Work needing structured verification
- Long-running efforts (4+ weeks)
- Cross-team coordination

### ❌ Don't Use Wishes For:
- Simple bug fixes
- Straightforward features (<1 week)
- Documentation-only updates
- Quick experiments

**Rule of thumb:** If the GitHub issue description is sufficient, you don't need a wish.

---

## Wish Folder Structure

```
projects/<project>/wishes/<slug>/
├── <slug>-wish.md           # Main living document (evolves in-place)
├── qa/                       # Evidence & validation artifacts
│   ├── group-a/             # Optional: per-group evidence
│   ├── group-b/
│   └── review-YYYYMMDD.md   # Timestamped reviews
└── reports/                  # Timestamped execution reports (append-only)
    ├── forge-plan-YYYYMMDD.md
    ├── done-YYYYMMDD.md
    └── commit-advice-YYYYMMDD.md
```

**Key Principles:**
- 📝 **Wish document evolves** - Update in-place as understanding grows
- 📸 **Reports are snapshots** - Timestamped, never modified
- 🧪 **QA holds evidence** - Test results, screenshots, data
- 📂 **One folder = One initiative** - Self-contained and portable

---

## Wish Document Template

### File: `<slug>-wish.md`

```markdown
# [Initiative Name]

**Status:** 🚧 In Progress | ✅ Complete | 🔍 Exploring | 📦 Archived
**Completion:** 60% (or score out of 100)
**Roadmap Item:** [Link to GitHub Issue](#)
**Last Updated:** YYYY-MM-DD

---

## 🎯 Overview

### What
Brief description of what we're building (1-2 sentences).

### Why
Problem being solved and expected impact.

### Expected Results
- Measurable outcome 1
- Measurable outcome 2
- Measurable outcome 3

---

## 🚩 RASCI

| Role | Assigned To |
|------|-------------|
| **Responsible** | @username |
| **Accountable** | @username |
| **Support** | @user1, @user2 |
| **Consulted** | @team, @community |
| **Informed** | @discord-community |

---

## 📊 Context Ledger

Running log of important decisions, learnings, and context.

### YYYY-MM-DD - Initial Planning
- Decision: Chose approach X over Y because...
- Learning: Discovered that Z is a blocker
- Context: User feedback indicated...

### YYYY-MM-DD - Design Review
- Decision: Updated architecture to...
- Learning: Performance tests showed...
- Context: Dependency on project X requires...

---

## 🏗️ Execution Groups

Break initiative into logical groups/phases.

### Group A: Core Implementation
**Status:** ✅ Complete | 🚧 In Progress | ⏳ Pending
**Estimated Effort:** 2 weeks
**Dependencies:** None

**Tasks:**
- [x] Task 1
- [x] Task 2
- [ ] Task 3

**Spec Contract:**
```
GIVEN initial state
WHEN action is performed
THEN expected outcome
```

**Verification:**
- Unit tests passing
- Manual test: [describe test]
- Evidence: See `qa/group-a/`

---

### Group B: Integration & Testing
**Status:** 🚧 In Progress
**Estimated Effort:** 1 week
**Dependencies:** Group A complete

**Tasks:**
- [ ] Task 1
- [ ] Task 2

**Spec Contract:**
```
GIVEN Group A complete
WHEN integration is tested
THEN all systems work together
```

**Verification:**
- Integration tests passing
- Performance benchmarks met
- Evidence: See `qa/group-b/`

---

## ✅ Overall Verification Plan

How we'll know the entire initiative is complete.

### Success Criteria
- [ ] All execution groups complete
- [ ] All tests passing (unit, integration, E2E)
- [ ] Documentation updated
- [ ] Performance benchmarks met
- [ ] Stakeholder approval received

### Acceptance Tests
1. **Test 1:** Description
   - Steps: 1, 2, 3
   - Expected: X happens
   - Evidence: Link to QA

2. **Test 2:** Description
   - Steps: 1, 2, 3
   - Expected: Y happens
   - Evidence: Link to QA

### Metrics to Track
- Metric 1: Baseline X → Target Y
- Metric 2: Baseline A → Target B

---

## 🔗 Related Work

- **Implementation PRs:** owner/repo#123, owner/repo#124
- **Dependencies:** owner/other-repo#45
- **Documentation:** Link to docs
- **Related Wishes:** Link to other wishes

---

## 📝 Notes

Additional context, open questions, future enhancements.

### Open Questions
- Question 1?
- Question 2?

### Future Enhancements (Out of Scope)
- Enhancement 1
- Enhancement 2

---

## 📂 Folder Contents

- `qa/` - Test evidence, screenshots, validation data
- `reports/` - Timestamped execution logs (forge-plan, done, commit-advice)

```

---

## QA Folder (`qa/`)

Store evidence and validation artifacts:

### Structure
```
qa/
├── group-a/
│   ├── test-results-YYYYMMDD.json
│   ├── screenshot-feature-working.png
│   └── benchmark-data.csv
├── group-b/
│   └── integration-test-results.md
└── review-YYYYMMDD.md
```

### What Goes in QA
- ✅ Test outputs and results
- ✅ Screenshots demonstrating functionality
- ✅ Performance benchmark data
- ✅ User feedback or survey results
- ✅ Code review summaries
- ❌ Source code (that goes in the repo)
- ❌ Execution reports (those go in `reports/`)

---

## Reports Folder (`reports/`)

Timestamped execution logs that are **append-only** (never modified).

### Types of Reports

#### 1. Forge Plan (`forge-plan-YYYYMMDD.md`)
Generated when planning an execution group.

```markdown
# Forge Plan - YYYY-MM-DD

## Group: Group A

### Tasks Identified
1. Task 1 - Estimated 4h
2. Task 2 - Estimated 2h
3. Task 3 - Estimated 6h

### Approach
[Description of how we'll approach this]

### Risks
- Risk 1: Mitigation plan
- Risk 2: Mitigation plan
```

#### 2. Done Report (`done-YYYYMMDD.md`)
Snapshot after completing a group or phase.

```markdown
# Done Report - YYYY-MM-DD

## Completed: Group A

### What Was Done
- Implemented Task 1
- Implemented Task 2
- Implemented Task 3

### Results
- All tests passing
- Performance targets met
- Documentation updated

### Evidence
- See qa/group-a/test-results.json
- See PR: owner/repo#123

### Blockers Resolved
- Blocker 1: How we resolved it
- Blocker 2: Workaround applied

### Next Steps
- Begin Group B
- Address feedback from review
```

#### 3. Commit Advice (`commit-advice-YYYYMMDD.md`)
Recommendations for commits and PRs.

```markdown
# Commit Advice - YYYY-MM-DD

## Group: Group A

### Suggested Commit Structure
1. Commit 1: "feat: add core implementation"
   - Files: src/core.ts, src/utils.ts
   - Message: [detailed description]

2. Commit 2: "test: add unit tests for core"
   - Files: tests/core.test.ts
   - Message: [detailed description]

### PR Strategy
- Create draft PR early for feedback
- Split into 2 PRs if >500 lines
- Tag @reviewers for review

### Testing Checklist
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing complete
```

---

## Workflow: Using Wishes

### 1. Creating a Wish

```bash
# Create the folder structure
cd projects/<project>/wishes
mkdir <slug>
cd <slug>
mkdir qa reports

# Copy template
# Create <slug>-wish.md from template above

# Initial commit
git add .
git commit -m "feat: add wish for <initiative>"
```

### 2. During Execution

**Update the Wish Document:**
- Update status and completion %
- Add context to ledger
- Mark tasks complete
- Update verification status

**Add Reports:**
- Generate forge-plan before starting a group
- Generate done report after completing work
- Generate commit-advice before creating PRs

**Collect Evidence:**
- Save test results to qa/
- Add screenshots to qa/
- Store benchmark data in qa/

### 3. Completion

**Final checklist:**
- [ ] All execution groups complete
- [ ] All verification criteria met
- [ ] Final done report generated
- [ ] Wish document updated to ✅ Complete
- [ ] Roadmap issue closed
- [ ] Evidence archived in qa/

---

## Integration with Roadmap

### Link Wish to Issue
In your roadmap issue:
```markdown
## Wish Folder
[View detailed specification](../projects/omni/wishes/slack-integration/)
```

### Link Issue to Wish
In your wish document:
```markdown
**Roadmap Item:** namastexlabs/automagik-roadmap#42
```

### Status Sync
- Wish "Exploring" → Issue `stage:exploring`
- Wish "In Progress" → Issue `stage:in-dev`
- Wish "Complete" → Issue `stage:shipped`

---

## Examples

### Example Wish: WhatsApp MCP Integration

```
projects/omni/wishes/whatsapp-mcp/
├── whatsapp-mcp-wish.md
├── qa/
│   ├── group-a/
│   │   ├── unit-test-results.json
│   │   └── manual-test-evidence.md
│   └── group-b/
│       └── integration-test-results.json
└── reports/
    ├── forge-plan-20250115.md
    ├── done-20250127.md
    ├── forge-plan-20250128.md
    └── done-20250205.md
```

### Example Wish: Multi-Agent Swarm Coordination

```
projects/hive/wishes/multi-agent-swarm/
├── multi-agent-swarm-wish.md
├── qa/
│   ├── group-a-core-protocol/
│   ├── group-b-message-passing/
│   ├── group-c-coordination-logic/
│   └── review-20250220.md
└── reports/
    ├── forge-plan-20250201.md
    ├── done-20250210.md
    ├── forge-plan-20250211.md
    ├── done-20250218.md
    ├── forge-plan-20250219.md
    └── done-20250228.md
```

---

## Tips & Best Practices

### ✅ Do:
- Update wish document regularly as understanding evolves
- Use context ledger to capture decisions and learnings
- Generate reports at key milestones
- Collect evidence in qa/ as you go
- Link wish to roadmap issue and vice versa

### ❌ Don't:
- Modify historical reports (they're snapshots)
- Create wishes for trivial tasks
- Let wish document get stale
- Forget to update status and completion %
- Skip verification planning

### Naming Conventions
- **Slug:** `kebab-case` (e.g., `whatsapp-mcp`, `multi-agent-swarm`)
- **File:** `<slug>-wish.md`
- **Reports:** `forge-plan-YYYYMMDD.md`, `done-YYYYMMDD.md`
- **QA reviews:** `review-YYYYMMDD.md`

---

## Wish Template Checklist

When creating a new wish, ensure:
- [ ] Slug is clear and kebab-case
- [ ] Folder structure created (qa/, reports/)
- [ ] Wish document created from template
- [ ] Roadmap issue linked
- [ ] RASCI assigned
- [ ] Execution groups defined
- [ ] Verification plan specified
- [ ] Initial commit made

---

## Related Documentation

- [Stage Definitions](stage-definitions.md) - Initiative lifecycle
- [RASCI Guide](rasci-guide.md) - Ownership model
- [Label Guide](label-guide.md) - Label taxonomy
- [automagik-genie wishes](https://github.com/namastexlabs/automagik-genie) - Original pattern

---

*Last updated: 2025-10-07*
