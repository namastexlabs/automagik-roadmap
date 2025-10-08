# [Initiative] {Project}: {Title}

**One-line Summary:** {Problem definition} → {Solution/Deliverable} → {Expected impact with metrics} | Timeline: {Duration} | Key risks: {Top 1-2 risks}

**Version:** 1.0 | **Status:** Draft | **Last Updated:** {YYYY-MM-DD}

---

## RASCI

**Responsible:** {Who executes the work - typically @vasconceloscezar + team}

**Accountable:** {Who owns success/failure - typically initiative owner}

**Support:** {Who provides resources - CI/CD, infrastructure, design, etc.}

**Consulted:** {Who provides input - stakeholders, domain experts, affected teams}

**Informed:** {Who needs updates - leadership, other teams, customers}

---

## Links & Related Documents

- **Related Initiatives:** #{issue-number}, #{issue-number}
- **PRs/Implementation:** {org/repo}#{pr-number}
- **Design Docs:** {link}
- **Metrics Dashboard:** {link}
- **Slack Channel:** {#channel}

---

## Overview (5W2H)

### What
{Clear, concise description of what will be built/delivered}

### Why (Problem)
{The problem being solved, pain points, current limitations}

### Who
**For whom:** {End users, developers, customers - who benefits}
**By whom:** {Team/person building it}

### When
**Timeline:** {Start → End dates}
**Milestones:** {Key phases with dates}

### Where
**Touchpoints:** {Where users/systems interact - UI, API, CLI, webhook, etc.}
**Platforms:** {Web, mobile, server, edge, etc.}

### How
{High-level solution approach, architecture, methodology}

### How Much
**Cost:** {Engineering time, infrastructure, third-party services}
**Resources:** {Team size, tools, dependencies}

---

## Value Proposition

### Goals (Expected Results)
1. {Measurable outcome 1 - with specific metrics}
2. {Measurable outcome 2}
3. {Measurable outcome 3}
4. {etc.}

### Non-Goals
{What this initiative explicitly will NOT do - set boundaries}

### Expected Impact

**For the Organization:**
- {Business value, operational improvement, cost savings}
- {Strategic advantage, competitive edge}

**For Users/Customers:**
- {User benefit 1 - improved experience, new capability}
- {User benefit 2}

**Metrics:**
- {KPI 1}: Baseline → Target
- {KPI 2}: Baseline → Target
- {Success threshold}: {Definition of success}

---

## Problem & Context

{Detailed description of the problem, current state, and why this matters now. Include data, user feedback, or business drivers that make this urgent/important.}

---

## Options & Proposals

| Proposal | Description | Advantages | Disadvantages | Cost | Recommendation |
|----------|-------------|------------|---------------|------|----------------|
| **Option A** | {Approach} | • {Pro 1}<br>• {Pro 2} | • {Con 1}<br>• {Con 2} | {Estimate} | ⭐ Recommended |
| **Option B** | {Alternative} | • {Pro 1} | • {Con 1} | {Estimate} | Not recommended |
| **Do Nothing** | Maintain status quo | • Zero cost | • Problem persists<br>• Tech debt grows | $0 | ❌ |

**Selected Approach:** {Option A} - {Brief rationale}

---

## Scope

### In Scope
- {Feature/capability 1}
- {Feature/capability 2}
- {Integration/system 1}
- {Deliverable 1}

### Out of Scope (for now)
- {Explicitly excluded feature}
- {Future consideration}
- {Adjacent problem not being solved}

---

## Users, Personas & Use Cases

### Personas

#### Persona 1: {Name} ({Role})
**Needs:** {What they need to accomplish}
**Context:** {Their environment, constraints, motivations}
**Pain Points:** {Current frustrations}

#### Persona 2: {Name} ({Role})
{Same structure}

### Key Use Cases

**Use Case 1: {Name}**
- **Actor:** {Persona}
- **Goal:** {What they want to achieve}
- **Flow:**
  1. {Step 1}
  2. {Step 2}
  3. {Step 3}
- **Success:** {End state}

---

## Requirements

### Functional Requirements (User Stories)

#### Story 1: {Feature name}

**Persona:** {Who}
**Journey:** {At what moment in their workflow}

**User Story:**
As a {persona},
I want to {action/capability},
So that {benefit/outcome}.

**Acceptance Criteria (BDD):**
```gherkin
Given [Initial condition/context]
When [Action performed]
Then [Expected result]

Given [Another scenario]
And [Additional context]
When [Action]
Then [Result]
And [Additional verification]
```

#### Story 2: {Feature name}
{Same structure}

### Non-Functional Requirements

| Category | Requirement | Target | Measurement |
|----------|-------------|--------|-------------|
| **Performance** | {Metric} | {Target value} | {How measured} |
| **Scalability** | {Capability} | {Scale target} | {Load test} |
| **Reliability** | {Uptime} | {SLA %} | {Monitoring} |
| **Security** | {Control} | {Standard} | {Audit} |
| **Usability** | {UX metric} | {Target} | {User testing} |
| **Accessibility** | {Standard} | {WCAG level} | {Compliance} |

---

## Technical Architecture

### System Design
{High-level architecture diagram or description}

### Components
1. **{Component 1}:** {Purpose, tech stack}
2. **{Component 2}:** {Purpose, tech stack}

### Data Flow
```
{Source} → {Processing} → {Storage} → {Output}
```

### Technology Stack
- **Frontend:** {Framework, libraries}
- **Backend:** {Language, framework}
- **Database:** {Type, provider}
- **Infrastructure:** {Cloud, services}
- **APIs/Integrations:** {Third-party services}

### Key Design Decisions
- **Decision 1:** {What + Why + Trade-offs}
- **Decision 2:** {What + Why + Trade-offs}

---

## Timeline & Phases

### Phase 1: {Name} ({Dates})
- [ ] {Milestone 1}
- [ ] {Milestone 2}
- [ ] {Deliverable}

**Success Criteria:** {What defines phase completion}

### Phase 2: {Name} ({Dates})
- [ ] {Milestone 1}
- [ ] {Deliverable}

**Success Criteria:** {Phase exit criteria}

### Phase 3: {Name} ({Dates})
{etc.}

---

## Dependencies & Risks

### Dependencies

| Dependency | Type | Owner | Status | Impact if Blocked |
|------------|------|-------|--------|-------------------|
| {Item 1} | External | {Team} | {Status} | {Impact} |
| {Item 2} | Internal | {Person} | {Status} | {Impact} |

### Risks & Mitigation

| Risk | Probability | Impact | Mitigation Strategy | Contingency Plan |
|------|-------------|--------|---------------------|------------------|
| {Risk 1} | High/Med/Low | High/Med/Low | {Preventive action} | {If it happens} |
| {Risk 2} | {Level} | {Level} | {Prevention} | {Response} |

---

## Success Metrics & Tracking

### Launch Metrics (Week 1-4)
- {Metric 1}: {Target}
- {Metric 2}: {Target}

### Growth Metrics (Month 2-3)
- {Metric 1}: {Target}
- {Metric 2}: {Target}

### Long-term Metrics (Month 6+)
- {Metric 1}: {Target}
- {Health metric}: {Threshold}

### Monitoring & Dashboards
- {Dashboard 1}: {Link}
- {Alert condition}: {When to escalate}

---

## Rollout & Communication

### Rollout Strategy
- **Alpha:** {Scope, audience, dates}
- **Beta:** {Scope, audience, dates}
- **GA:** {General availability plan}

### Communication Plan
- **Stakeholders:** {When, what, channel}
- **Users:** {Announcement, docs, training}
- **Team:** {Sync frequency, updates}

---

## Appendix

### Open Questions
- [ ] {Question 1}
- [ ] {Question 2}

### Future Considerations
- {Enhancement 1}
- {Related opportunity}

### References
- {Doc/article 1}
- {Research 2}
