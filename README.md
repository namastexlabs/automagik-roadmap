<p align="center">
  <img alt="Automagik Roadmap Logo" src=".github/assets/automagik-roadmap-light-png.png" width="400">
</p>
<h2 align="center">Public Roadmap for the Automagik Ecosystem</h2>

<p align="center">
  <strong>🗺️ Transparency, Ownership, Results-Driven</strong><br>
  Strategic initiatives across Omni, Hive, Spark, Forge, Genie, and Tools<br>
  Track what we're building, why we're building it, and who's building it
</p>

<p align="center">
  <a href="https://github.com/namastexlabs/automagik-roadmap/blob/main/LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-00D9FF?style=flat-square" /></a>
  <a href="https://discord.gg/xcW8c7fF3R"><img alt="Discord" src="https://img.shields.io/discord/1095114867012292758?style=flat-square&color=00D9FF&label=discord" /></a>
  <a href="https://github.com/namastexlabs/automagik-roadmap/issues?q=label%3Ainitiative"><img alt="Initiatives" src="https://img.shields.io/badge/initiatives-5-00D9FF?style=flat-square" /></a>
</p>

<p align="center">
  <a href="#-projects">Projects</a> •
  <a href="#-how-to-propose">How to Propose</a> •
  <a href="#-labels--stages">Labels & Stages</a> •
  <a href="#-contributing">Contributing</a> •
  <a href="#-documentation">Documentation</a>
</p>

---

## 🗺️ What is the Automagik Roadmap?

This repository is the **single source of truth** for strategic initiatives across the entire Automagik ecosystem. Think of it as:

- 📊 **The Command Center**: Where all projects align on priorities and timelines
- 🎯 **The Context Repository**: Strategic analysis (5w2h) and detailed wishes for each project
- 🤝 **The Community Hub**: Where stakeholders provide feedback and track progress
- 📈 **The Progress Tracker**: From Wishlist → Exploring → RFC → Prioritization → Executing → Preview → Shipped

### 💡 Why a Public Roadmap?

**Transparency** builds trust. **Ownership** drives results. **Structure** enables scale.

**Before:**
- ❌ Roadmap scattered across Slack, Notion, and individual heads
- ❌ Community asks "when will X be ready?" without visibility
- ❌ Cross-project dependencies create surprise blockers
- ❌ No clear ownership = things fall through the cracks

**After (with this repo):**
- ✅ Single place to see what's being built across all projects
- ✅ Clear RASCI ownership (Responsible, Accountable, Support, Consulted, Informed)
- ✅ Expected results tracked for every initiative
- ✅ Community can comment, vote, and contribute ideas
- ✅ Quarterly planning and review cadence

---

## 🚀 Projects

| Project | Description | Repository | Context |
|---------|-------------|------------|---------|
| **[Omni](projects/omni/)** | Omnichannel messaging with MCP | [automagik-omni](https://github.com/namastexlabs/automagik-omni) | [5w2h](projects/omni/5w2h.md) |
| **[Hive](projects/hive/)** | Multi-agent orchestration | [automagik-hive](https://github.com/namastexlabs/automagik-hive) | [5w2h](projects/hive/5w2h.md) |
| **[Spark](projects/spark/)** | Cron system that sparks repos | [automagik-spark](https://github.com/namastexlabs/automagik-spark) | [5w2h](projects/spark/5w2h.md) |
| **[Forge](projects/forge/)** | AI-powered development orchestrator | [automagik-forge](https://github.com/namastexlabs/automagik-forge) | [5w2h](projects/forge/5w2h.md) |
| **[Genie](projects/genie/)** | Autonomous agent framework | [automagik-genie](https://github.com/namastexlabs/automagik-genie) | [5w2h](projects/genie/5w2h.md) |
| **[Tools](projects/tools/)** | MCP tools builder & marketplace | [automagik-tools](https://github.com/namastexlabs/automagik-tools) | [5w2h](projects/tools/5w2h.md) |

Each project folder contains:
- **5w2h.md** - Strategic analysis (What, Why, Who, When, Where, How, How Much)
- **wishes/** - Detailed initiative plans following the [automagik-genie](https://github.com/namastexlabs/automagik-genie) pattern
- **README.md** - Project overview with repository links

---

## 📊 View the Roadmap

🔗 **[View Project Board](https://github.com/orgs/namastexlabs/projects/9)** - Live project board with all initiatives

**Quick Filters:**
- 📅 [All Initiatives](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Ainitiative)
- 🚧 [Executing](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3AExecuting)
- 📋 [Prioritization](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3APrioritization)
- ✅ [Shipped](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3AShipped)
- ⚡ [This Quarter (Q4 2025)](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Aquarter%3A2025-q4)
- 🔥 [High Priority](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Apriority%3Ahigh+label%3Ainitiative)

---

## 📋 How to Propose

**Want to suggest something?** We have different paths based on what you need:

### 🧞 Option 1: Make a Wish (Recommended for Feature Ideas)

**Got an idea but not sure how to structure it?** Use our simple wish form:

1. **[Make a Wish](../../issues/new/choose)** using the **🧞 Make a Wish** template
2. Tell us:
   - What's your wish?
   - Why would it be useful? (optional)
   - Any additional context? (optional)
3. Submit → Gets `wish:triage` label, team will review and guide it forward ✨

**Perfect for:**
- 💡 Feature ideas
- 🎯 Improvement suggestions
- 🤔 "Wouldn't it be cool if..." thoughts
- 🚀 Quick submissions without formal structure

---

### 📋 Option 2: GitHub Issue Form (For Structured Initiatives)

**Have a well-defined initiative ready?** Use the formal template:

1. **[Create a new issue](../../issues/new/choose)** using the **Initiative template**
2. Fill in the form fields (project, description, RASCI, expected results)
3. Submit → Automatically added to project board ✨

### 🛠️ Option 3: CLI Script (For Maximum Detail)

Use our CLI script with structured templates:

```bash
# Use one of three template levels:
# - Minimal (8 sections, 15-30min)
# - Standard (12 sections, 1-2hr) ← Most common
# - Comprehensive (20+ sections, 4-8hr) ← Full PRD

cat your-initiative.md | ./scripts/create-initiative.sh \
  --title "Your Initiative Title" \
  --project (omni|hive|spark|forge|genie|tools|cross-project) \
  --stage (Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped) \
  --priority (critical|high|medium|low) \
  --quarter (2025-Q4|2026-Q1|...|backlog) \
  --type (feature|enhancement|research|infrastructure|documentation) \
  --areas "area1,area2"
```

**Templates available:**
- 📄 [Minimal](docs/templates/MINIMAL_INITIATIVE.md) - Small features, quick wins
- 📄 [Standard](docs/templates/STANDARD_INITIATIVE.md) - Most initiatives (recommended default)
- 📄 [Comprehensive](docs/templates/COMPREHENSIVE_INITIATIVE.md) - Major launches (full PRD)
- 📖 [Template Guide](docs/templates/README.md) - Decision tree, comparison, tips

**Features:**
- ✅ PRD-style structure (5W2H, BDD stories, personas)
- ✅ Automatic label application
- ✅ Direct project board field setting
- ✅ Retry logic for reliability

**💬 Community feedback is welcome!** Share your thoughts on any initiative.

---

## 🏷️ Labels & Stages

### Development Stages

Our initiatives follow a structured lifecycle inspired by [GitHub's public roadmap](https://github.com/github/roadmap):

- 💡 **Wishlist** - Initial ideation and brainstorming
- 🔍 **Exploring** - Early investigation, validating the idea
- 💬 **RFC** - Request for comments, gathering community feedback
- 📋 **Prioritization** - Prioritization and planning phase
- 🔨 **Executing** - Active execution and implementation
- 🧪 **Preview** - Beta/preview release for testing
- ✅ **Shipped** - Generally available, live in production
- 📦 **Archived** - No longer active or deprioritized

### Multi-Dimensional Labels

We use a **6-dimensional label system** to organize initiatives:

| Dimension | Examples | Purpose |
|-----------|----------|---------|
| **Project** | `project:omni`, `project:hive` | Which project(s) are involved |
| **Stage** | `Exploring`, `Executing` | Current development phase |
| **Type** | `type:feature`, `type:research` | Kind of initiative |
| **Priority** | `priority:critical`, `priority:high` | Urgency level |
| **Quarter** | `quarter:2025-q4`, `quarter:2026-q1` | Target timeframe |
| **Area** | `area:api`, `area:mcp`, `area:agents` | Technical domain |

**Total:** ~40 labels across 6 dimensions for precise organization.

### Wish Workflow Labels

For community-submitted feature ideas:

| Label | Meaning | Usage |
|-------|---------|-------|
| `wish:triage` | User wish pending team review | Auto-applied by Make a Wish template |
| `wish:active` | Wish approved and being worked on | Set by team during triage |
| `wish:archived` | Wish completed and archived | Auto-applied when PR merges |

[View complete label guide →](docs/label-guide.md)

---

## 📚 Documentation

- **[Stage Definitions](docs/stage-definitions.md)** - Detailed criteria for each stage
- **[Label Guide](docs/label-guide.md)** - Complete label taxonomy and usage
- **[RASCI Guide](docs/rasci-guide.md)** - Ownership model for open source projects
- **[Wish Template](docs/wish-template.md)** - How to structure detailed initiatives
- **[Cross-Repo References](docs/cross-repo-references.md)** - Linking initiatives across repos

---

## 📊 CSV Export

Weekly CSV exports are available in [`exports/`](exports/) for stakeholder reporting and analysis.

**Export format includes:**
- Project, Initiative, Description
- Stage, Quarter, Priority
- Expected Results
- Owner, Created/Updated dates
- Links to issues and wish folders

Exports run **automatically every Monday** via GitHub Actions.

---

## 🤝 Contributing

We welcome community input on our roadmap!

**How to contribute:**
- 🧞 **Make a wish** for feature ideas (no technical knowledge needed!)
- 💬 **Comment on issues** to share feedback and ideas
- 🎯 **Propose initiatives** via structured templates
- 🔧 **Submit PRs** to project repos (link to issues for auto-labeling)
- 💡 **Join discussions** on our [Discord](https://discord.gg/xcW8c7fF3R)

**For Developers:**
- All project repos have PR templates with issue linking
- Link PRs to issues using `- Closes #X` for automatic metadata inheritance
- Wish documents in `.genie/wishes/` are auto-archived when PRs merge

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## ⚖️ Disclaimer

This roadmap represents our **current plans and priorities**. Items may change based on:
- Community feedback and feature requests
- Technical constraints and dependencies
- Strategic shifts and market changes
- Resource availability and capacity

**No dates or commitments are guaranteed.** This is a living document that evolves with the ecosystem.

---

## 🔗 Links

- **Discord**: [Join the community](https://discord.gg/xcW8c7fF3R)
- **GitHub Org**: [@namastexlabs](https://github.com/namastexlabs)
- **Documentation**: [docs.automagik.ai](https://docs.automagik.ai)

---

## 📜 License

MIT License - See [LICENSE](LICENSE)

---

<p align="center">
  <strong>Built with transparency by <a href="https://github.com/namastexlabs">Namastex Labs</a></strong><br>
  Questions? Check our <a href="docs/faq.md">FAQ</a> or reach out on <a href="https://discord.gg/xcW8c7fF3R">Discord</a>
</p>
