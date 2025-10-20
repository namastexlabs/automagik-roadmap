# Initiative Template

## 📋 Lean Initiative Template (v2.0)

**Use for:** All initiatives - small to large

We've consolidated our templates into a single **Lean Initiative** format that:
- ✅ Reduces clutter (80 lines visible vs 300+ in old templates)
- ✅ Uses advanced GitHub markdown (alerts, collapsible sections, diagrams)
- ✅ Maintains depth through `<details>` tags
- ✅ Provides clear visual scanning with emoji headers
- ✅ Scales from small to large initiatives

---

## 🎯 What's Included

### Core Sections (Always Visible - ~80 lines)
1. **TL;DR** - Problem → Solution → Impact with owner/stage/timeline
2. **🎯 Goals & Scope** - What we're building (numbered goals) + out of scope
3. **🚨 Problem & Why Now** - Current pain, why it matters, user examples
4. **📅 Timeline & Phases** - High-level roadmap with phase summaries
5. **⚠️ Risks & Mitigation** - Table format with probability/impact/strategies
6. **📊 Success Metrics** - Clear targets with baseline → goal
7. **🔗 Related** - Team, ownership, related work

### Detailed Sections (Collapsible via `<details>`)
- **Detailed Scope Breakdown** - Per-component/feature specs
- **Detailed Phase Breakdown** - Full checklists with interactive tasks
- **Risk Details** - Deep dive on each risk with contingency plans
- **Metrics Breakdown** - Launch, growth, long-term metrics by phase
- **Full RASCI Matrix** - Extended ownership when needed

### Advanced Features
- ✅ **Colored Alerts** - `[!IMPORTANT]` `[!WARNING]` `[!NOTE]` `[!TIP]`
- ✅ **Mermaid Diagrams** - Visualize architecture and workflows
- ✅ **Interactive Task Lists** - Clickable checkboxes for phase tracking
- ✅ **Tables** - Structured data for risks and metrics
- ✅ **Emoji Headers** - Visual scanning (🎯 🚨 📅 ⚠️ 📊 🔗)

---

## 🚀 Creating an Initiative

### Option 1: CLI Script (Recommended)

```bash
# Use the create-initiative.sh script with LEAN template
cat docs/templates/LEAN_INITIATIVE.md | ./scripts/create-initiative.sh \
  --title "Your Initiative Title" \
  --project (omni|hive|spark|forge|genie|tools|cross-project) \
  --stage (Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped) \
  --priority (critical|high|medium|low) \
  --quarter (2025-Q4|2026-Q1|2026-Q2|...|backlog) \
  --type (feature|enhancement|research|infrastructure|documentation) \
  --areas "area1,area2,area3"
```

**Title Format:** `Product: Clear Action/Outcome`
- Example: `Omni: Quick Start Guide (5-min Setup)`
- Example: `Cross-Project: Automagik Suite Deep Integration`
- Example: `Hive: Workflow Execution Debugging`

### Option 2: GitHub Issue Form

Use the web UI to create an issue with the `initiative` label. The workflow will auto-sync to the project board.

### Option 3: Manual

1. Copy [`LEAN_INITIATIVE.md`](./LEAN_INITIATIVE.md)
2. Fill in all `{placeholders}`
3. Remove sections that don't apply
4. Add Mermaid diagrams where helpful
5. Create GitHub issue with `initiative` label
6. Issue will auto-sync to project board

---

## 💡 Tips for Success

### Writing Quality Content
- **Be specific:** "Increase API throughput by 50%" not "Make API faster"
- **Add context:** Explain *why* decisions were made, not just *what*
- **Link everything:** PRs, docs, dashboards, related initiatives
- **Use collapsible sections:** Keep body scannable, details accessible
- **Add diagrams:** Mermaid for architecture/workflows helps clarity

### Making It Scalable
**For Small Initiatives (1-2 weeks):**
- Keep collapsed sections minimal
- 3-5 goals maximum
- Simple risk table (2-3 rows)
- Basic metrics (2-3 KPIs)

**For Medium Initiatives (2-8 weeks):**
- Expand detailed scope breakdown
- Full phase checklists in collapsed sections
- 5-7 risks with detailed mitigation
- Metrics by phase (launch/growth/long-term)

**For Large Initiatives (2+ months):**
- Add Mermaid diagrams for architecture
- Detailed contingency plans for each risk
- User personas and examples in problem section
- Comprehensive RASCI in collapsed section

### Common Pitfalls to Avoid
- ❌ Writing too much in visible sections (use `<details>`)
- ❌ Skipping ownership (always add owner in TL;DR)
- ❌ No metrics (can't measure success)
- ❌ No scope boundaries (feature creep)
- ❌ Ignoring risks (surprises hurt)
- ❌ Not using alerts (`[!WARNING]` for critical items)

---

## 🔧 Using Comments for Updates

The issue body should be the **reference document** (stable). Use comments for **temporal information**:

1. **Pinned Status Comment** - Current phase, progress %, blockers
2. **Decision Comments** - Document key architectural/scope decisions
3. **Implementation Links** - Link PRs as they're merged
4. **Discussion Threads** - Questions about specific sections

This keeps the body clean while capturing evolution over time.

---

## 📊 Real Example

See **[Initiative #61](https://github.com/namastexlabs/automagik-roadmap/issues/61)** for a live example of the lean format in action.

**What changed from old format:**
- Title: `Automagik Suite Integration` → `Cross-Project: Automagik Suite Deep Integration`
- Body: 210 lines → 80 visible (120 in collapsed sections)
- Added: Colored alerts, Mermaid diagram, interactive task lists, table-formatted risks

---

## 📚 Old Templates (Archived)

Previous templates have been moved to [`archive/`](./archive/) for reference:
- `MINIMAL_INITIATIVE.md` (deprecated)
- `STANDARD_INITIATIVE.md` (deprecated)
- `COMPREHENSIVE_INITIATIVE.md` (deprecated)

**Why we consolidated:**
- Too much redundancy between templates
- Hard to choose which template to use
- Old formats were too verbose
- Missed opportunity to use GitHub markdown features

The new LEAN template replaces all three by scaling through collapsed sections.

---

## 🔗 Related Documentation

- [LEAN Initiative Template](./LEAN_INITIATIVE.md) - The template
- [Initiative #61](https://github.com/namastexlabs/automagik-roadmap/issues/61) - Live example
- [Create Initiative Script](../../scripts/create-initiative.sh)
- [Project Board](https://github.com/orgs/namastexlabs/projects/9)
- [Label Guide](../../docs/label-guide.md)

---

## ❓ FAQ

**Q: Do I need to fill out every section?**
A: No! Skip sections that don't apply. The template is a guide, not a requirement.

**Q: When should I use `<details>` tags?**
A: For any content that's important but not needed for quick scanning. Phase checklists, detailed scope, risk contingencies, etc.

**Q: Should I add Mermaid diagrams?**
A: If it helps! Architecture flows, cross-product integrations, and workflow visualizations benefit from diagrams.

**Q: What if I don't know all the details yet?**
A: Use placeholders like `{TBD}` or add to collapsed sections later. Start with the essentials.

**Q: Can I customize the format?**
A: Yes! The template is a starting point. Add sections, change structure, use what works for your initiative.

**Q: What about emojis - are they required?**
A: No, but they help with visual scanning. If your team prefers plain text, use: `## Goals & Scope` instead of `## 🎯 Goals & Scope`

---

**Template Version:** 2.0 (Lean + Advanced Markdown)
**Last Updated:** 2025-10-20

**Need help?** Check the template file or see the live example in issue #61.
