# 🚩 RASCI Guide

Understanding ownership and accountability in the Automagik roadmap.

---

## What is RASCI?

**RASCI** is a responsibility assignment matrix that clarifies who does what in a project or initiative. It's especially valuable in open-source projects where contributors are distributed and roles may be fluid.

**RASCI Stands For:**
- **R**esponsible - Who will do the work
- **A**ccountable - Who has final approval
- **S**upport - Who provides resources/help
- **C**onsulted - Who gives input/feedback
- **I**nformed - Who should know about progress

---

## Why RASCI for Open Source?

Open-source projects often struggle with:
- ❌ Unclear ownership ("someone should do this")
- ❌ Stalled initiatives (no one feels accountable)
- ❌ Duplicated effort (multiple people working on same thing)
- ❌ Missed stakeholders (important people not informed)

**RASCI solves this by:**
- ✅ Making ownership explicit and public
- ✅ Ensuring exactly one person is accountable
- ✅ Identifying who can help (support)
- ✅ Looping in right people at right time

---

## RASCI Roles Explained

### R - Responsible (1 person)

**The doer.** This person leads the execution and does the work.

**Key Questions:**
- Who will drive this forward day-to-day?
- Who is coding/designing/writing?
- Who will coordinate with others?

**Characteristics:**
- Exactly **1 person** should be Responsible
- Owns the day-to-day execution
- Reports progress to Accountable
- Can delegate tasks but remains responsible

**Examples:**
- Lead developer implementing feature
- Designer creating mockups
- Technical writer authoring docs

**In Open Source:**
- Often a core maintainer or active contributor
- May be assigned when initiative moves to "In Development"
- Can change if person becomes unavailable

---

### A - Accountable (1 person)

**The decider.** This person has final approval and veto power.

**Key Questions:**
- Who makes the final call?
- Who approves the work before it ships?
- Who is ultimately answerable for success/failure?

**Characteristics:**
- Exactly **1 person** should be Accountable
- Has authority to approve or reject
- Signs off on completion
- Often a project maintainer or lead

**Examples:**
- Project maintainer approving design
- Tech lead reviewing architecture
- Product owner accepting feature

**In Open Source:**
- Usually a core maintainer
- May be same as Responsible for small initiatives
- Has merge rights and final say

---

### S - Support (0+ people)

**The helpers.** These people provide resources, expertise, or assistance.

**Key Questions:**
- Who can provide technical help?
- Who has relevant expertise to share?
- Who can unblock if needed?

**Characteristics:**
- Can be **multiple people**
- Provides help when asked
- Not doing the work directly
- May have specialized knowledge

**Examples:**
- Senior engineer available for architecture questions
- DevOps engineer helping with CI/CD
- Designer providing UX feedback

**In Open Source:**
- Subject matter experts
- Cross-functional helpers
- Community members offering assistance

---

### C - Consulted (0+ people)

**The advisors.** These people should be asked for input before decisions.

**Key Questions:**
- Who should we get feedback from?
- Who might have concerns or dependencies?
- Who has valuable context?

**Characteristics:**
- Can be **multiple people or teams**
- Two-way communication (ask and respond)
- Input should be considered (not binding)
- Consulted **before** decisions made

**Examples:**
- Security team reviewing auth changes
- Community members providing feedback on API design
- Adjacent project maintainers reviewing integration

**In Open Source:**
- Community members during RFC stage
- Stakeholders with dependencies
- Domain experts

---

### I - Informed (0+ people)

**The audience.** These people should be kept in the loop about progress.

**Key Questions:**
- Who cares about this but doesn't need to give input?
- Who should know when this ships?
- Who might be impacted?

**Characteristics:**
- Can be **multiple people or groups**
- One-way communication (broadcast to them)
- No input required
- Updated at key milestones

**Examples:**
- Users interested in the feature
- Community Discord channel
- Partner projects using the API

**In Open Source:**
- Community at large
- Users of affected features
- Contributors watching the repo

---

## RASCI in Practice

### Example 1: New API Endpoint for Omni

```yaml
Initiative: Add Slack integration to Omni
Responsible: @developer-alice
Accountable: @maintainer-cezar
Support: @devops-bob, @mcp-expert-charlie
Consulted: @community, @hive-team
Informed: @discord-community, @users-channel
```

**Breakdown:**
- **Alice** does the coding and drives execution
- **Cezar** reviews and approves before merge
- **Bob** helps with deployment, **Charlie** advises on MCP
- **Community** gives feedback during RFC stage
- **Discord** users are notified when it ships

---

### Example 2: Cross-Project Infrastructure

```yaml
Initiative: Shared auth system for all projects
Responsible: @infra-lead-dan
Accountable: @vasconceloscezar
Support: @project-omni-lead, @project-hive-lead, @project-spark-lead
Consulted: All project maintainers
Informed: All contributors, community
```

**Breakdown:**
- **Dan** builds the shared auth library
- **Cezar** approves architecture and rollout plan
- **Project leads** help integrate into their projects
- **All maintainers** consulted on design decisions
- **Everyone** informed about migration timeline

---

### Example 3: Documentation Initiative

```yaml
Initiative: Write comprehensive MCP integration guide
Responsible: @tech-writer-eve
Accountable: @docs-lead-frank
Support: @mcp-expert-charlie
Consulted: @new-contributors
Informed: @community
```

**Breakdown:**
- **Eve** writes the documentation
- **Frank** reviews and approves
- **Charlie** provides technical expertise
- **New contributors** give feedback on clarity
- **Community** notified when published

---

## Common Patterns

### Solo Contributor Project
```yaml
Responsible: @alice
Accountable: @alice
Support: -
Consulted: @community
Informed: @users
```
Small initiative where one person does everything.

### Team Effort
```yaml
Responsible: @alice (frontend), @bob (backend)
Accountable: @team-lead
Support: @designer, @devops
Consulted: @security-team
Informed: @company
```
Multiple people responsible for different parts.

### Community-Driven
```yaml
Responsible: @community-champion
Accountable: @maintainer
Support: @core-team
Consulted: @users via RFC
Informed: @everyone
```
Community member drives, maintainer approves.

---

## RASCI Anti-Patterns

### ❌ No Responsible Person
```yaml
Responsible: "TBD" or "Anyone" or "Community"
```
**Problem:** No one feels ownership, initiative stalls.
**Fix:** Assign a specific person, even if tentative.

---

### ❌ Too Many Responsible People
```yaml
Responsible: @alice, @bob, @charlie, @dan
```
**Problem:** Diffused responsibility, confusion about who leads.
**Fix:** Pick ONE lead (Responsible), others become Support.

---

### ❌ No Accountable Person
```yaml
Accountable: "Team" or "Maintainers"
```
**Problem:** No clear decision maker, approvals delayed.
**Fix:** Name one specific Accountable person.

---

### ❌ Responsible = Accountable = Support = Consulted
```yaml
Responsible: @alice
Accountable: @alice
Support: @alice
Consulted: @alice
```
**Problem:** One person doing everything alone, no collaboration.
**Fix:** Identify at least who should be Informed, preferably Support.

---

## RASCI FAQs

**Q: Can Responsible and Accountable be the same person?**
A: Yes, especially for small initiatives. As initiatives grow, separate roles clarify accountability.

**Q: What if the Responsible person becomes unavailable?**
A: Update the RASCI in the issue. Either find a new Responsible or mark as `help-wanted`.

**Q: Who updates the RASCI?**
A: The Accountable person approves changes. Anyone can propose changes in comments.

**Q: How do I know who to consult?**
A: Think about dependencies, related projects, and expertise areas. When in doubt, over-communicate.

**Q: Can I add people to Informed later?**
A: Yes! RASCI is living. Update as needed.

**Q: Is RASCI required for every issue?**
A: For **roadmap initiatives**, yes. For small bugs/tasks, it's optional.

---

## How to Fill Out RASCI

### When Creating an Initiative Issue

Use the initiative template, which prompts for:

```markdown
## 🚩 RASCI Ownership

**Responsible:** @username (Who will lead execution?)
**Accountable:** @username (Who has final approval?)
**Support:** @user1, @user2 (Who provides help?)
**Consulted:** @team, @community (Who gives feedback?)
**Informed:** @discord-community (Who should know?)
```

### Best Practices

1. **Start with Accountable** - Who can approve?
2. **Identify Responsible** - Who will do the work?
3. **Think Support** - Who can help if blocked?
4. **Consider Consulted** - Who has a stake?
5. **Don't forget Informed** - Who cares about updates?

### Templates by Initiative Size

**Small Initiative:**
```
Responsible: @dev
Accountable: @maintainer
Support: -
Consulted: @community (via RFC)
Informed: @users
```

**Medium Initiative:**
```
Responsible: @lead-dev
Accountable: @project-owner
Support: @architect, @designer
Consulted: @security, @adjacent-project
Informed: @community, @stakeholders
```

**Large Initiative:**
```
Responsible: @initiative-lead
Accountable: @exec-sponsor
Support: @frontend-team, @backend-team, @devops-team
Consulted: @all-maintainers, @community (via RFC)
Informed: @all-contributors, @users, @partners
```

---

## Updating RASCI

RASCI should evolve as the initiative progresses.

**When to Update:**
- Responsible person changes
- New dependencies discovered (add to Support)
- Scope changes (update Consulted)
- Stakeholder identified (add to Informed)

**How to Update:**
1. Comment on issue with proposed change
2. Tag Accountable person for approval
3. Update issue body once approved
4. Notify affected parties

---

## RASCI and Stages

RASCI may change as initiatives move through stages:

| Stage | Typical RASCI Changes |
|-------|---------------------|
| **Exploring** | R may be "TBD", A is product/project lead |
| **RFC** | C expands to community, I grows |
| **In Design** | R assigned (architect/designer), S identified |
| **In Dev** | R is developer, S is technical helpers |
| **Preview** | S may include testers, I expands to beta users |
| **Shipped** | R may shift to maintainer for ongoing support |

---

## RASCI in Open Source vs. Corporate

| Aspect | Corporate | Open Source (Automagik) |
|--------|-----------|------------------------|
| **Assignment** | Manager assigns | Self-selection + approval |
| **Authority** | Hierarchical | Meritocratic (maintainer trust) |
| **Flexibility** | Rigid | Fluid (people come/go) |
| **Informed** | Specific stakeholders | Often "community" or "users" |
| **Accountability** | Performance reviews | Reputation + trust |

**Adaptation for Open Source:**
- Responsible can be a volunteer
- Support is often "best effort"
- Consulted includes open community feedback
- Informed uses public channels (Discord, GitHub)

---

## Related Documentation

- [Stage Definitions](stage-definitions.md) - Initiative lifecycle
- [Label Guide](label-guide.md) - Label taxonomy
- [Contributing Guide](../CONTRIBUTING.md) - How to participate

---

## Summary

**RASCI makes open source collaboration clearer:**
- ✅ One **Responsible** person drives execution
- ✅ One **Accountable** person approves
- ✅ **Support** provides help when needed
- ✅ **Consulted** gives input before decisions
- ✅ **Informed** stays in the loop

**Use RASCI to:**
- Prevent initiatives from stalling
- Clarify who does what
- Ensure stakeholders are engaged
- Make collaboration transparent

---

*Last updated: 2025-10-07*
