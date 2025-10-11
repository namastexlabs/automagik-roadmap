# 🔄 Stage Definitions

This document defines the lifecycle stages for initiatives in the Automagik roadmap.

---

## Overview

Every initiative progresses through a series of stages from initial exploration to final delivery. These stages help communicate the current state of work and set expectations for stakeholders.

**Stage Flow:**
```
Wishlist → Exploring → RFC → Priorization → Executing → Preview → Shipped
                                                                         ↓
                                                                     Archived
```

---

## 💡 Wishlist

**Definition:** Initial ideation and brainstorming phase. Early concept formation.

**Activities:**
- Initial idea capture
- High-level brainstorming
- Preliminary problem definition
- Opportunity identification

**Exit Criteria:**
- Idea is clearly articulated
- Initial stakeholder interest
- Worth exploring further

**Typical Duration:** 1-2 weeks

**Labels:** `Wishlist`

---

## 🔍 Exploring

**Definition:** Early investigation and validation phase. We're validating whether this initiative is worth pursuing.

**Activities:**
- Problem research and validation
- User interviews and feedback gathering
- Technical feasibility assessment
- Competitive analysis
- Cost/benefit estimation

**Exit Criteria:**
- Problem is clearly defined
- Proposed solution has broad support
- Technical approach is feasible
- RASCI ownership assigned

**Typical Duration:** 1-4 weeks

**Labels:** `Exploring`

---

## 💬 RFC (Request for Comments)

**Definition:** Gathering community and stakeholder feedback on the proposal.

**Activities:**
- Publishing detailed proposal
- Community discussion and feedback
- Addressing concerns and questions
- Iterating on the approach
- Building consensus

**Exit Criteria:**
- Proposal has been publicly shared
- Major concerns addressed
- Community feedback incorporated
- Go/no-go decision made

**Typical Duration:** 2-6 weeks

**Labels:** `RFC`

**Note:** RFC can happen in parallel with "Exploring" or "Priorization" for community-driven projects.

---

## 📋 Priorization

**Definition:** Priorization and planning phase. Determining implementation approach and timeline.

**Activities:**
- Creating technical specifications
- Designing system architecture
- Planning API contracts
- Designing user flows (if applicable)
- Identifying dependencies
- Writing wish document (if using wish structure)
- Prioritizing features and requirements
- Resource planning

**Exit Criteria:**
- Technical spec completed
- Architecture reviewed and approved
- Dependencies identified and planned
- Success criteria defined
- Wish document created (optional)
- Implementation priority established

**Typical Duration:** 2-8 weeks

**Labels:** `Priorization`

---

## 🔨 Executing

**Definition:** Active execution and implementation of the initiative.

**Activities:**
- Writing code
- Implementing features
- Writing tests
- Code reviews
- Documentation updates
- Regular progress updates

**Exit Criteria:**
- Core functionality implemented
- Tests passing
- Code reviewed
- Documentation complete
- Ready for preview/beta release

**Typical Duration:** 4-16 weeks (varies widely)

**Labels:** `Executing`

**Progress Indicators:**
- Update issue with weekly progress
- Link to active PRs
- Update wish document with execution reports

---

## 🧪 Preview

**Definition:** Beta or preview release for testing.

**Activities:**
- Beta testing with select users
- Gathering feedback
- Bug fixes and refinements
- Performance testing
- Documentation polishing
- Migration planning (if needed)

**Exit Criteria:**
- Feature is stable
- Critical bugs resolved
- Performance acceptable
- Migration path validated
- Documentation ready for GA

**Typical Duration:** 2-8 weeks

**Labels:** `Preview`

**Note:** Not all initiatives require a preview stage. Small features may go straight to shipped.

---

## ✅ Shipped

**Definition:** Generally available in production.

**Activities:**
- Production deployment
- Announcement and communication
- Monitoring and support
- Gathering usage metrics
- Post-launch iteration

**Exit Criteria:**
- Feature live in production
- Announcement published
- Monitoring in place
- Expected results being tracked

**Duration:** Ongoing

**Labels:** `Shipped`

**Follow-up:**
- Track expected results
- Monitor for issues
- Plan future enhancements
- Eventually archive when superseded

---

## 📦 Archived

**Definition:** No longer active or deprioritized.

**Reasons for Archiving:**
- Initiative completed and stable (no further work planned)
- Deprioritized or cancelled
- Superseded by another initiative
- No longer relevant

**Activities:**
- Document final state
- Link to replacement (if applicable)
- Close issue with summary

**Labels:** `Archived`

---

## Stage Transition Guidelines

### How to Move Between Stages

1. **Update the issue:**
   - Add a comment explaining the transition
   - Update the stage label
   - Update project board fields

2. **Notify stakeholders:**
   - Tag RASCI informed parties
   - Update relevant channels (Discord, etc.)

3. **Update documentation:**
   - Update wish document status (if applicable)
   - Add execution report (if applicable)

### Who Can Change Stages?

- **Responsible:** Proposes stage changes
- **Accountable:** Approves stage changes
- **Community:** Can request clarification or raise concerns

---

## Stage vs. Priority

**Stages** describe *where* an initiative is in its lifecycle.
**Priority** describes *how important* it is relative to other work.

An initiative can be:
- High priority but still in "Exploring" (urgent problem, needs design)
- Low priority but in "Executing" (nice-to-have, already in progress)

Both dimensions are tracked independently.

---

## FAQ

**Q: Can initiatives skip stages?**
A: Yes. Small bug fixes or simple features may skip RFC, Preview, etc. Use judgment based on complexity and risk.

**Q: How long should initiatives stay in one stage?**
A: No hard rules. The durations above are guidelines. If an initiative is stuck, discuss in issue comments.

**Q: What if we're unsure which stage to use?**
A: Default to the earlier stage. It's better to be conservative. You can always move forward.

**Q: Can we go backwards?**
A: Yes. If design needs rework or more community feedback is needed, move back to the appropriate stage.

---

## Examples

### Example 1: Small Feature
```
Exploring (1 week) → Priorization (1 week) → Executing (2 weeks) → Shipped
```

### Example 2: Major Initiative
```
Exploring (4 weeks) → RFC (6 weeks) → Priorization (8 weeks) →
Executing (12 weeks) → Preview (4 weeks) → Shipped
```

### Example 3: Research Project
```
Exploring (8 weeks) → RFC (4 weeks) → Archived
(Decision: not pursuing at this time)
```

---

## Related Documentation

- [Label Guide](label-guide.md) - Complete label taxonomy
- [RASCI Guide](rasci-guide.md) - Ownership model
- [Wish Template](wish-template.md) - Detailed initiative structure

---

*Last updated: 2025-10-07*
