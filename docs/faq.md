# ❓ Frequently Asked Questions

Common questions about the Automagik roadmap.

---

## General Questions

### What is the Automagik roadmap?

The Automagik roadmap is a **public repository** that provides transparency into strategic initiatives across the entire Automagik ecosystem (Omni, Hive, Spark, Forge, Genie, Tools).

It uses GitHub Issues, Projects, and Labels to track what we're building, why we're building it, and who's building it.

---

### Why is the roadmap public?

**Transparency builds trust.** By making our roadmap public, we:
- Give the community visibility into what's coming
- Enable stakeholders to provide early feedback
- Clarify priorities and timelines
- Prevent duplicate effort across teams
- Foster collaboration and contribution

---

### Is this a commitment to deliver on specific dates?

**No.** The roadmap represents our **current plans and priorities**, which may change based on:
- Community feedback and feature requests
- Technical constraints and dependencies
- Strategic shifts and market changes
- Resource availability and capacity

**Dates are targets, not guarantees.** See the [Disclaimer](../README.md#-disclaimer) in the main README.

---

## Using the Roadmap

### How do I view the roadmap?

**Multiple ways:**

1. **GitHub Issues:** [Browse all initiatives](https://github.com/namastexlabs/automagik-roadmap/issues)
2. **Project Board:** [View project board](https://github.com/orgs/namastexlabs/projects/9)
3. **Filtered Views:**
   - [By Project](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Aproject%3Aomni)
   - [This Quarter](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Aquarter%3A2025-q4)
   - [Executing](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3AExecuting)

---

### How do I filter initiatives for a specific project?

Use **label filters** in GitHub Issues:

```
# All Omni initiatives
label:project:omni

# Hive initiatives in development
label:project:hive label:Executing

# Critical priorities this quarter
label:priority:critical label:quarter:2025-q4
```

See [Label Guide](label-guide.md) for all available labels.

---

### What do the different stages mean?

Initiatives progress through stages from exploration to delivery:

- 💡 **Wishlist** - Initial ideation and brainstorming
- 🔍 **Exploring** - Early investigation
- 💬 **RFC** - Request for Change (formal proposal)
- 📋 **Prioritization** - Prioritization and planning phase
- 🔨 **Executing** - Active execution and implementation
- 🧪 **Preview** - Beta/preview release
- ✅ **Shipped** - Generally available
- 📦 **Archived** - No longer active

See [Stage Definitions](stage-definitions.md) for detailed criteria.

---

### How often is the roadmap updated?

**Continuously.**
- Issues are updated as work progresses
- Labels are updated when stages change
- New initiatives are added as they're prioritized
- Quarterly reviews happen at the start of each quarter

**Automated exports:**
- CSV exports run weekly (every Monday)
- Stale initiatives flagged automatically after 90 days

---

## Contributing

### Can I propose a new initiative?

**Yes!** We welcome community proposals.

**How to propose:**
1. [Create a new issue](https://github.com/namastexlabs/automagik-roadmap/issues/new/choose) using the **Initiative template**
2. Fill in:
   - Which project it affects
   - What problem it solves
   - Expected results and success criteria
   - RASCI ownership (or "TBD" if unsure)
3. Tag relevant stakeholders
4. Community can discuss and provide feedback

See [Contributing Guide](../CONTRIBUTING.md) for details.

---

### Can I comment on existing initiatives?

**Absolutely!** Community feedback is encouraged.

**Be:**
- Constructive and respectful
- Specific (provide use cases and examples)
- Solution-oriented (suggest alternatives if you have concerns)

**Maintainers will:**
- Read and consider all feedback
- Respond to questions and concerns
- Update initiatives based on valuable input

---

### Can I work on an initiative?

**Yes!** If you want to contribute:

1. **Comment on the issue** expressing interest
2. **Tag the Responsible/Accountable person** to coordinate
3. **Check for existing PRs** to avoid duplicate work
4. **Review the wish document** if one exists (detailed spec)
5. **Follow contribution guidelines** for the specific project repository

See individual project repositories for contribution guides:
- [automagik-omni](https://github.com/namastexlabs/automagik-omni)
- [automagik-hive](https://github.com/namastexlabs/automagik-hive)
- [automagik-spark](https://github.com/namastexlabs/automagik-spark)
- [automagik-forge](https://github.com/namastexlabs/automagik-forge)
- [automagik-genie](https://github.com/namastexlabs/automagik-genie)
- [automagik-tools](https://github.com/namastexlabs/automagik-tools)

---

### How do I create a detailed wish document?

**Wishes** are detailed specifications for complex initiatives.

**When to create a wish:**
- Complex features requiring detailed specs
- Multi-phase implementations
- Long-running efforts (4+ weeks)

**How to create:**
1. Navigate to `projects/<project>/wishes/`
2. Create folder: `<slug>/`
3. Follow the [Wish Template](wish-template.md)
4. Link wish in roadmap issue

---

## Understanding RASCI

### What is RASCI?

**RASCI** is a responsibility assignment matrix:
- **R**esponsible - Who will do the work
- **A**ccountable - Who has final approval
- **S**upport - Who provides help
- **C**onsulted - Who gives input
- **I**nformed - Who should know

See [RASCI Guide](rasci-guide.md) for detailed explanations.

---

### Why is RASCI used in an open-source project?

Open-source projects often struggle with unclear ownership. **RASCI clarifies:**
- Who leads execution (Responsible)
- Who makes final decisions (Accountable)
- Who can help if blocked (Support)
- Who should be consulted (Consulted)
- Who should stay informed (Informed)

This prevents initiatives from stalling and ensures stakeholders are engaged.

---

### Can I be added to RASCI for an initiative?

**Yes!** If you want to:
- **Lead execution** → Volunteer as Responsible
- **Provide approval** → Discuss with current Accountable
- **Offer help** → Add yourself as Support (comment on issue)
- **Give feedback** → You're automatically part of Consulted (community)
- **Stay informed** → Watch the issue or join Discord

Update RASCI by **commenting on the issue** with your request.

---

## Roadmap vs. Project Repositories

### What's the difference between the roadmap and project repos?

**Roadmap (this repo):**
- **Strategic planning** and high-level initiatives
- **Cross-project** coordination and dependencies
- **5w2h context** and expected results
- **Wishes** (detailed specifications)

**Project Repositories:**
- **Implementation** code and features
- **Issues/PRs** for bugs and tasks
- **Documentation** specific to that project
- **Releases** and changelogs

**Relationship:**
- Roadmap initiatives **link to** implementation repos
- Implementation PRs **reference** roadmap initiatives
- Wishes in roadmap **specify** what gets built in repos

See [Cross-Repo References](cross-repo-references.md) for linking patterns.

---

### Do I create issues in the roadmap or project repo?

**It depends:**

| Type | Where to Create |
|------|----------------|
| **Strategic initiative** | Roadmap repo (this repo) |
| **Feature request** | Roadmap repo (using feature template) |
| **Bug report** | Project repository |
| **Implementation task** | Project repository |
| **Technical question** | Project repository or Discord |

**Rule of thumb:**
- If it's **strategic/planning** → Roadmap
- If it's **implementation/bug** → Project repo

---

## Timelines and Priorities

### How are priorities decided?

Priorities are set based on:
- **User impact** - How many users benefit?
- **Strategic alignment** - Does it align with vision?
- **Dependencies** - Is it blocking other work?
- **Effort vs. value** - What's the ROI?
- **Community feedback** - What do users want?

**Maintainers** make final priority decisions, but **community input** is valued.

---

### What does "quarter:backlog" mean?

`quarter:backlog` means the initiative is **not yet scheduled** for a specific quarter.

**Reasons for backlog:**
- Lower priority than current work
- Needs more exploration/design
- Waiting on dependencies
- Resource constraints

**Backlog doesn't mean "never."** Items can be pulled from backlog when priorities shift.

---

### Can initiative timelines change?

**Yes.** Timelines are **targets, not commitments.**

**Common reasons for timeline changes:**
- Scope increased during implementation
- Unexpected technical complexity
- Dependencies not ready
- Resource reallocation
- Higher priority work emerged

When timelines change, we:
- Update quarter labels
- Add comment explaining why
- Notify stakeholders (Informed)

---

## Labels and Organization

### Why so many labels?

**Multi-dimensional labels** enable powerful filtering and organization.

**6 label dimensions:**
1. **Project** - Which project (omni, hive, etc.)
2. **Stage** - Current phase (exploring, in-dev, shipped, etc.)
3. **Type** - Kind of work (feature, enhancement, research, etc.)
4. **Priority** - Urgency (critical, high, medium, low)
5. **Quarter** - Target timeframe (2025-q4, 2026-q1, etc.)
6. **Area** - Technical domain (api, mcp, agents, etc.)

This allows filtering like:
- "Show me all critical Omni features in development this quarter"
- "What MCP-related work is shipped?"

See [Label Guide](label-guide.md) for complete taxonomy.

---

### How do I know which labels to use?

**When creating an initiative**, the **issue template** prompts for key fields:
- Project (required)
- Stage (auto-applied as "exploring" or "rfc")
- Priority (you choose)
- Quarter (you choose)

**Optional labels** like Area can be added based on technical domain.

**Maintainers** can adjust labels as needed.

---

## Technical Questions

### How do I export the roadmap data?

**CSV exports** are generated automatically every Monday and saved to [`exports/`](../exports/).

**Manual export:**
```bash
# Clone the repo
git clone https://github.com/namastexlabs/automagik-roadmap
cd automagik-roadmap

# Run export script
python scripts/export-to-csv.py

# Output in exports/roadmap-YYYY-MM-DD.csv
```

**Export includes:**
- Project, Initiative, Description
- Stage, Quarter, Priority
- Expected Results
- Owner, Created/Updated dates
- Links to issues and wishes

---

### Can I integrate the roadmap into my own tools?

**Yes!** The roadmap is accessible via:

**GitHub API:**
```bash
# List all roadmap initiatives
curl https://api.github.com/repos/namastexlabs/automagik-roadmap/issues?labels=initiative

# Filter by project
curl https://api.github.com/repos/namastexlabs/automagik-roadmap/issues?labels=initiative,project:omni
```

**GitHub GraphQL:**
```graphql
{
  repository(owner: "namastexlabs", name: "automagik-roadmap") {
    issues(first: 100, labels: ["initiative"]) {
      nodes {
        title
        labels(first: 10) { nodes { name } }
        assignees(first: 5) { nodes { login } }
      }
    }
  }
}
```

**CSV Exports:**
- Download from [`exports/`](../exports/) folder
- Updated weekly

---

### How is the roadmap different from a changelog?

**Roadmap** = **Future plans** (what we're building)
**Changelog** = **Past releases** (what we shipped)

**Roadmap:**
- Forward-looking
- Initiatives in planning and development
- May change based on feedback

**Changelog:**
- Historical record
- Features already shipped
- Immutable (doesn't change)

**Each project repository** maintains its own changelog (e.g., `CHANGELOG.md`).

---

## Community and Support

### Where can I ask questions?

**Options:**

1. **Discord:** [Join the community](https://discord.gg/xcW8c7fF3R) - Best for quick questions
2. **GitHub Issues:** Comment on specific initiatives - Best for initiative-specific questions
3. **Discussions:** GitHub Discussions *(coming soon)* - Best for open-ended discussion

---

### How do I stay updated on roadmap changes?

**To follow all updates:**
- **Watch this repository** on GitHub (click "Watch" → "All Activity")
- **Join Discord** for announcements
- **Subscribe to specific issues** you care about

**To follow specific projects:**
- Use **GitHub's custom notification filters**
- Subscribe to issues with labels like `project:omni`

---

### Who maintains the roadmap?

**Maintained by:**
- **Core Team:** @vasconceloscezar and Namastex Labs maintainers
- **Project Leads:** Leads for each Automagik project
- **Community:** Contributors proposing and discussing initiatives

**Final decisions:** Core team and project leads, informed by community feedback.

---

## Misc

### What license is the roadmap under?

**MIT License** - Same as most Automagik projects.

See [LICENSE](../LICENSE) for details.

---

### Can I fork or copy this roadmap structure?

**Absolutely!** The roadmap structure is **open source** and can be adapted for other projects.

**If you use it:**
- Attribution appreciated (but not required)
- Share your learnings with the community!
- Consider contributing improvements back

---

### Why "wishes" instead of "specs"?

**"Wish"** terminology comes from [automagik-genie](https://github.com/namastexlabs/automagik-genie), which uses:
- **Wishes** - What you want built
- **Genie** - AI that helps build it

It's a more human and approachable term than "specification" or "requirement document."

---

### Where did the roadmap structure come from?

**Inspired by:**
- **GitHub's public roadmap:** Multi-dimensional labels, quarterly views, stages
- **SmartFit PM practices:** RASCI, expected results (RESULTADO_ESPERADO), CSV exports
- **automagik-genie:** Wish folder structure, execution groups

We combined **best practices** from corporate PM (SmartFit) with **open-source transparency** (GitHub) and **structured execution** (Genie).

---

## Still Have Questions?

- 💬 **Ask on Discord:** [Join here](https://discord.gg/xcW8c7fF3R)
- 📝 **Open an issue:** [Ask here](https://github.com/namastexlabs/automagik-roadmap/issues/new)
- 📧 **Email the team:** [Contact info](https://namastex.ai)

---

*Last updated: 2025-10-07*
